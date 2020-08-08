//
//  NSColorExtension.swift
//  Swiftlighter
//
//  Created by Ramil Salimov on 30/03/2019.
//  Copyright © 2019 Ramil Salimov. All rights reserved.
//

import Cocoa

extension NSColor{
    
    public convenience init?(hexString: String) {
        let r, g, b, a: CGFloat
        
        if hexString.hasPrefix("#") {
            let start = hexString.index(hexString.startIndex, offsetBy: 1)
            let hexColor = String(hexString[start...])
            
            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        
        return nil
    }
    
    func converToHex() -> String?{
        var hexString: String? = nil
        if let components = cgColor.components, components.count >= 3{
            if self.colorSpace.colorSpaceModel == .cmyk{
                let r = (1 - Float(components[0])) * (1 - Float(components[3]))
                let g = (1 - Float(components[1])) * (1 - Float(components[3]))
                let b = (1 - Float(components[2])) * (1 - Float(components[3]))
                
                hexString = String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
            }else if self.colorSpace.colorSpaceModel == .rgb{
                let r = Float(components[0])
                let g = Float(components[1])
                let b = Float(components[2])
                
                hexString = String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
            }
        }else if let components = cgColor.components, components.count >= 1{
            let r = Float(components[0])
            let g = Float(components[0])
            let b = Float(components[0])
            
            hexString = String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
        }
        if hexString != nil{
            hexString = hexString!.lowercased()
        }
        return hexString
    }
}
