//
//  BleListCell.swift
//  HCUwbDemo
//
//  Created by iband on 2023/1/4.
//  Copyright © 2023 武汉桓参工程科技有限公司. All rights reserved.
//

import UIKit
import SnapKit

class BleListCell: UITableViewCell {

    var label: UILabel!
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .white
        setUI()
    }
    
    func setName(name: String) {
        label.text = name
    }
    
    func setUI() {
        label = UILabel(text: "", textColor: "06A7FF".color(), fontSize: 15, textAlignment: .center)
        contentView.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
        
        let line = UIView()
        contentView.addSubview(line)
        line.backgroundColor = "eeeeee".color()
        line.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
