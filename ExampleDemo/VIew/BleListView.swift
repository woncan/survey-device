//
//  BleListView.swift
//  HCUwbDemo
//
//  Created by iband on 2023/1/4.
//  Copyright © 2023 武汉桓参工程科技有限公司. All rights reserved.
//

import UIKit
import SnapKit

class BleListView: UIView, UITableViewDataSource, UITableViewDelegate {

    var tableView: UITableView!
    var list = [String]()
    var masHeight: Constraint?
    var cancelBlock: (() -> ())?
    var selectItemBlock: ((_ itemIndex: NSInteger) -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    func setList(list: [String]) {
        self.list = list
        let count = list.count
        masHeight?.deactivate()
        tableView.snp.makeConstraints { make in
            masHeight = make.height.equalTo(38 * min(8, count)).constraint
        }
        tableView.reloadData()
        tableView.isScrollEnabled = count >= 8
    }
    
    func setUI() {
        backgroundColor = UIColor.black.withAlphaComponent(0.4)
        let bg = UIView()
        addSubview(bg)
        bg.backgroundColor = .white
        bg.frame = self.bounds
        bg.layer.cornerRadius = 10.0
        bg.layer.masksToBounds = true
        bg.snp.remakeConstraints({ make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.75)
        })
        
        let titleLabel = UILabel(text: "蓝牙列表", textColor: .black, mediumFontSize: 15)
        bg.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(44)
            make.top.equalToSuperview()
        }
        
        tableView = UITableView(frame: .zero, style: .plain, target: self)
        bg.addSubview(tableView)
        tableView.backgroundColor = .clear
        tableView.bounces = false
        tableView.rowHeight = 38.0
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.left.right.equalToSuperview()
            masHeight = make.height.equalTo(70).constraint
        }
        tableView.register(BleListCell.self, forCellReuseIdentifier: NSStringFromClass(BleListCell.self))
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen().bounds.width, height: 0.01))
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen().bounds.width, height: 0.01))
        
        let cancelButton = UIButton(type: .custom)
        bg.addSubview(cancelButton)
        cancelButton.setTitle("取消", for: .normal)
        cancelButton.setTitleColor(
            "06A7FF".color(), for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        cancelButton.setBackgroundImage(UIColor.white.toImage(), for: .normal)
        cancelButton.setBackgroundImage("f2f2f2".toImage(), for: .highlighted)
        cancelButton.addTarget(self, action: #selector(toCancel(sender:)), for: .touchUpInside)
        cancelButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(tableView.snp.bottom)
            make.height.equalTo(38)
            make.bottom.equalToSuperview()
        }
        
        let line = UIView()
        bg.addSubview(line)
        line.backgroundColor = "eeeeee".color()
        line.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
            make.top.equalTo(cancelButton.snp.top)
        }
    }
    
    @objc func toCancel(sender: UIButton) {
        cancelBlock?()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(BleListCell.self)) as! BleListCell
        if indexPath.row < list.count {
            cell.setName(name: list[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectItemBlock?(indexPath.row)
        if list.count <= 1 {
            cancelBlock?()
            return
        }
        list.remove(at: indexPath.row)
        setList(list: list)
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.backgroundColor = "f2f2f2".color()
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
