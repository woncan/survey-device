//
//  ViewController.swift
//  ExampleDemo
//
//  Created by Woncan on 2023/10/12.
//

import UIKit

enum RTKConnectType: Int {
    case RTK         // RTK定位
    case EA         // MFI连接
    case GPS         // 系统定位
}

class ViewController: UIViewController ,HCUtilDelegate{
    
    var list: [String] = [String]()
    var util: HCUtil?
    var currentDeviceIndex: Int = -1
    var deviceModel: HCDeviceInfoBaseModel?
    var bleListView: BleListView?
    var searchButton:UIButton!
    var searchEAButton:UIButton!
    var DiffButton:UIButton!
    var diffConfigVC:DiffConfigViewController!
    var currentConnectType:RTKConnectType?
    
    @IBOutlet weak var deviceNameLabel: UILabel!
    @IBOutlet weak var electricLabel: UILabel!
    @IBOutlet weak var diffStatusLabel: UILabel!
    @IBOutlet weak var diffDelayLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var deviceDiffLabel: UILabel!
    @IBOutlet weak var deviceDiffStatusLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        diffConfigVC = DiffConfigViewController()
    }
    /// UI
    func setUI(){
        searchButton = UIButton(type: .custom)
        searchButton.setTitle("搜 索", for: .normal)
        searchButton.setTitleColor(.white, for: .normal)
        searchButton.backgroundColor = "06A7FF".color()
        searchButton.layer.cornerRadius = 5
        searchButton.layer.masksToBounds = true
        searchButton.addTarget(self, action: #selector(searchBle), for: .touchUpInside)
        view.addSubview(searchButton)
        
        searchEAButton = UIButton(type: .custom)
        searchEAButton.setTitle("搜索MFI", for: .normal)
        searchEAButton.setTitleColor(.white, for: .normal)
        searchEAButton.backgroundColor = "06A7FF".color()
        searchEAButton.layer.cornerRadius = 5
        searchEAButton.layer.masksToBounds = true
        searchEAButton.addTarget(self, action: #selector(searchEA), for: .touchUpInside)
        view.addSubview(searchEAButton)
        
        DiffButton = UIButton(type: .custom)
        DiffButton.setTitle("差分配置", for: .normal)
        DiffButton.setTitleColor(.white, for: .normal)
        DiffButton.backgroundColor = "06A7FF".color()
        DiffButton.layer.cornerRadius = 5
        DiffButton.layer.masksToBounds = true
        DiffButton.addTarget(self, action: #selector(pushToDiffConfig), for: .touchUpInside)
        view.addSubview(DiffButton)
        
        DiffButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-30)
            make.bottom.equalToSuperview().offset(-100)
            make.width.equalTo(150)
            make.height.equalTo(40)
        }
        
        searchButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(30)
            make.bottom.equalToSuperview().offset(-100)
            make.width.equalTo(150)
            make.height.equalTo(40)
        }
        
        searchEAButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(30)
            make.bottom.equalToSuperview().offset(-50)
            make.width.equalTo(150)
            make.height.equalTo(40)
        }
    }
    
    @objc func searchBle(){
        self.currentConnectType = .RTK
        startListening()
    }
    @objc func searchEA(){
        self.currentConnectType = .EA
        startListening()
    }
    
    @objc func pushToDiffConfig(){
        
        self.present(diffConfigVC, animated: true)
    }
    
    @IBAction func toConnectDeviceDiffEvent(_ sender: Any) {
        guard let hasDeviceDiff = self.util?.hasDeviceDiff else {
            return
        }
        guard let isConnectDeviceDiff = self.util?.isConnectDeviceDiff else {
            return
        }
        if !isConnectDeviceDiff {
            self.util?.toConnectDeviceDiff()

        }
    }
    
    @IBAction func toDisconnectDeviceDiffEvent(_ sender: Any) {
        self.util?.toDisconnectDeviceDiff()
    }
    
    func setData(){
        diffConfigVC.nmeaSourceText = deviceModel?.nmeaSourceText
        diffConfigVC.util = self.util
        deviceNameLabel.text = self.list[currentDeviceIndex]
        electricLabel.text = "\(self.deviceModel?.electricity ?? "")%"
        var stateDesc = "单点解"
        switch self.deviceModel?.gpsLevelValue ?? 0 {
        case 4:
            stateDesc = "固定解"
        case 2:
            stateDesc = "码差分"
        case 5:
            stateDesc = "浮点解"
        default:
            break
        }
        diffStatusLabel.text = stateDesc
        diffDelayLabel.text = "\(self.deviceModel?.diffDelayTime ?? "")"
        longitudeLabel.text = "\(self.deviceModel?.longitude ?? "")"
        latitudeLabel.text = "\(self.deviceModel?.latitude ?? "")"
        deviceDiffLabel.text = "\(self.util!.hasDeviceDiff ? "是":"否")"
        deviceDiffStatusLabel.text = "\(self.util!.isConnectDeviceDiff ? "已连接" : "未连接")"
    }

    // MARK: 开始监听
    public func startListening() {
        endListening()
        util = HCUtil(delegate: self)
        toSearch()
    }
    
    // MARK: 终止监听
    public func endListening() {
        toDisconnect(isAuto: true)
        currentDeviceIndex = -1
        util = nil
        list.removeAll()
    }
    
    // MARK: 搜索
    public func toSearch() {
        // 清空缓存
        list.removeAll()
        if self.currentConnectType == .RTK{
            util?.toSearchDevice(with: .BleRTK)
        }else if self.currentConnectType == .EA{
            util?.toSearchDevice(with: .EaRTK)
        }
    }
    
    // MARK: 断开连接
    public func toDisconnect(isAuto: Bool = false) {
        currentDeviceIndex = -1
        if !isAuto {
            util?.toDisconnect()
        }
        
    }
}

// MARK: HCUtilDelegate
extension ViewController {
    // MARK: 连接报错
    func hcDeviceDidFailWithError(_ error: HCStatusError) {
        switch error {
        case .BleUnauthorized:
            print("蓝牙未授权")
            break
        case .UnsupportedDeviceType:
            print("不支持该设备连接")
            break
        case .BlePoweredOff:
            self.list.removeAll()
            print("手机蓝牙未开启，请先开启后再连接设备")
            break
        case .Unknown:
            break
        default:
            break
        }
    }
    
    // MARK: 搜索结果
    func hcSearchResult(_ deviceNameList: [String]!, isDone: Bool) {
        NSLog("搜索到的设备：\(deviceNameList ?? [])")
        if deviceNameList.count > 0 {
            self.list = deviceNameList
            showPeripheralList(tempPeripheralList: deviceNameList!)
        }


    }
    
    // MARK: 连接成功
    func hcDeviceConnected(_ index: Int) {
        currentDeviceIndex = index
        print("连接成功：\(self.list[currentDeviceIndex])")
    }
    
    // MARK: 收到数据
    func hcReceive(_ deviceInfoBaseModel: HCDeviceInfoBaseModel!) {
        if currentDeviceIndex < 0 || currentDeviceIndex >= list.count {
            return
        }
        deviceModel = HCDeviceInfoBaseModel(model: deviceInfoBaseModel)
        self.setData()
    }
    
    // MARK: 连接断开
    func hcDeviceDisconnected() {
        // 未连接
        toDisconnect(isAuto: true)
        
    }
    
    // MARK: 收到RTCM
    func hcReceiveRTCMData(_ data: Data!) {
        
    }
    
    // MARK: 收到UBX数据
    func hcReceiveUBXData(_ data: Data!) {
        // 直接处理sfrbx data类型的数据
    }
    
}

extension ViewController {
    func showPeripheralList(tempPeripheralList: [String]) {
        
        if (bleListView == nil) {
            bleListView = BleListView(frame: .zero)
            ViewController.keyWindow().addSubview(bleListView!)
            bleListView?.cancelBlock = {
                [weak self] in
                self?.removeBleListView()
            }
            bleListView?.selectItemBlock = {
                [weak self] itemIndex in
                // 发起连接
                self?.util?.toConnectDevice(itemIndex)
                
            }
        }
        bleListView?.snp.remakeConstraints({ make in
            make.edges.equalToSuperview()
            
        })
        bleListView?.setList(list: tempPeripheralList)
    }
    
    func removeBleListView() {
        bleListView?.removeFromSuperview()
        bleListView = nil
    }
    
    class func keyWindow() -> UIWindow {
           if #available(iOS 15.0, *) {
               let keyWindow = UIApplication.shared.connectedScenes
                   .map({ $0 as? UIWindowScene })
                   .compactMap({ $0 })
                   .first?.windows.first ?? UIWindow()
               return keyWindow
           }else {
               let keyWindow = UIApplication.shared.windows.first ?? UIWindow()
               return keyWindow
           }
       }

}
