//
//  UIColor+Extension.swift
//  HCReaderDemo
//
//  Created by chen on 2022/9/22.
//  Copyright © 2022 武汉桓参工程科技有限公司. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    public func toImage() -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        guard let context = UIGraphicsGetCurrentContext() else { return UIImage() }
        context.setFillColor(self.cgColor)
        context.fill(rect)
        guard let theImage = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
        UIGraphicsEndImageContext()
        return theImage
    }
}
