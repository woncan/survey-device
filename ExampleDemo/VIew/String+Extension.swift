//
//  String+Extension.swift
//  HCReaderDemo
//
//  Created by chen on 2022/9/22.
//  Copyright © 2022 武汉桓参工程科技有限公司. All rights reserved.
//

import UIKit

extension String {
    public func color() -> UIColor {
        let scanner = Scanner(string: self)

        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0

        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
    
    public func toImage() -> UIImage {
        return self.color().toImage()
    }
    
    /// 16进制字符串转成Bytes
    public func hexStringToBytes() -> [UInt8] {
        var bytes = [UInt8]()

        let regex = try? NSRegularExpression(pattern: "[0-9a-f]{1,2}", options: .caseInsensitive)
        regex?.enumerateMatches(in: self, range: NSMakeRange(0, utf16.count)) { match, flags, stop in
            let byteString = (self as NSString).substring(with: match!.range)
            let num = UInt8(byteString, radix: 16)!
            bytes.append(num)
        }
        return bytes
    }
}

extension String {
    func getSubStrFrom(postion: Int, num: Int) -> String {
        if self.count >= (postion + 1) {
            return "\(NSString(string: self).substring(with: NSMakeRange(postion, num)))"
        }
        return ""
    }
}

