//
//  DiffConfigViewController.swift
//  ExampleDemo
//
//  Created by Woncan on 2023/10/17.
//

import UIKit

class DiffConfigViewController: UIViewController,HCSocketUtilDelegate {
    var socketUtil: HCSocketUtil?
    private var timer: Timer?
    var nmeaSourceText: String? // 差分原始数据
    var util: HCUtil?
    var mountPointList = [String]()
    
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var portTextField: UITextField!
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var mountPointTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.socketUtil = HCSocketUtil()
        self.socketUtil?.delegate = self
    }

    /// 发起差分连接
    @IBAction func toConnectDiffEvent(_ sender: Any) {
        let model = HCDiffModel()
        model.ip = self.addressTextField.text ?? ""
        model.port = Int(self.portTextField.text ?? "") ?? 0
        model.account = self.accountTextField.text ?? ""
        model.password = self.passwordTextField.text ?? ""
        model.mountPointList = self.mountPointList
        model.currentMountPoint = self.mountPointTextField.text ?? ""
        self.socketUtil?.replaceDiffModel(model)
        self.socketUtil?.toLogin()
    }
    /// 获取挂载点
    @IBAction func getMountPointEvent(_ sender: Any) {
        let model = HCDiffModel()
        model.ip = self.addressTextField.text ?? ""
        model.port = Int(self.portTextField.text ?? "") ?? 0
        model.account = self.accountTextField.text ?? ""
        model.password = self.passwordTextField.text ?? ""
        self.socketUtil?.replaceDiffModel(model)
        self.socketUtil?.getMountPoints()
    }
    
    

    
}
// MARK: HCSocketUtilDelegate
extension DiffConfigViewController {
    // MARK: 差分登录成功
    func loginSuccess(_ tcpUtil: HCSocketUtil) {
        if timer == nil {
            timer = Timer(timeInterval: 0.5, target: self, selector: #selector(getDiffData), userInfo: nil, repeats: true)
            RunLoop.current.add(timer!, forMode: .common)
        }
        timer?.fireDate = .distantPast
    }
    // MARK: 差分登录失败
    func loginFailure(_ tcpUtil: HCSocketUtil, error: Error?) {
        removeTimer()
        self.socketUtil?.disconnect()
    }
    // MARK: 获取挂载点成功
    func didGetMountPointsSuccess(_ socketUtil: HCSocketUtil) {
        mountPointList = socketUtil.diffModel.mountPointList
        if mountPointList.count>0 {
            self.mountPointTextField.text = mountPointList.first
        }
        self.socketUtil?.disconnect()
    }
    
    // MARK: 处理差分数据
    func didReadOriginDiffDataSuccess(_ data: Data, socketUtil: HCSocketUtil) {
        self.util?.toSend(data)
    }
}

extension DiffConfigViewController {
    // MARK: 获取差分数据
    @objc func getDiffData() {
        if let nmeaSourceText = nmeaSourceText, nmeaSourceText.count > 0 {
            self.socketUtil?.sendData("\(nmeaSourceText)\r\n\r\n")
        }
    }
    
    func removeTimer() {
        timer?.invalidate()
        timer = nil
    }
}
