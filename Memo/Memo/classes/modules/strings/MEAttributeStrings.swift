//
//  MEAttributeStrings.swift
//  Memo
//
//  Created by 君若见故 on 17/2/20.
//  Copyright © 2017年 huangshuni. All rights reserved.
//

import UIKit

class MEAttributeStrings {
    
    //获取文本富文本
    public static func getTextAttributeString(string: String) -> NSAttributedString {
    
        var attribute = MESettingsModel.settingsModel.getAttribute()
        attribute.updateValue(UIColor.black, forKey: NSForegroundColorAttributeName)
        return NSAttributedString.init(string: string, attributes: attribute)
    }
    //获取菜单富文本
    public static func getMenuAttributeString(string: String, size: CGFloat, color: UIColor) -> NSAttributedString {
    
        let attribute = [NSFontAttributeName: UIFont.init(name: MESettingsModel.settingsModel.font, size: size), NSForegroundColorAttributeName: color]
        return NSAttributedString.init(string: string, attributes: attribute)
    }
    
}
