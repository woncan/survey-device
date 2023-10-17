//
//  UITableView+Extension.swift
//
//
//  Created by iband on 2019/1/4.
//  Copyright © 2019. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    
    public convenience init(frame: CGRect, style: UITableView.Style, target: Any) {
        self.init(frame: frame, style: style)
        if #available(iOS 11.0, *) {
            self.contentInsetAdjustmentBehavior = .never
        }
        if #available(iOS 15.0, *) {
            sectionHeaderTopPadding = 0.0
        }
        self.delegate = target as? UITableViewDelegate
        self.dataSource = target as? UITableViewDataSource
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.separatorStyle = .none
        rowHeight = UITableView.automaticDimension
        estimatedRowHeight = 44.0
        self.tableFooterView = UIView()
    }
}
