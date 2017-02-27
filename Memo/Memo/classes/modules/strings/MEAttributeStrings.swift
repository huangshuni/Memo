//
//  MEAttributeStrings.swift
//  Memo
//
//  Created by 君若见故 on 17/2/20.
//  Copyright © 2017年 huangshuni. All rights reserved.
//

import UIKit

class MEAttributeStrings {
    
    static let settingsModel = MESettingsModel.settingsModel
    //获取文本富文本
    public static func getTextAttributeString(string: String) -> NSAttributedString {
    
        var attribute = settingsModel.getAttribute()
        attribute.updateValue(UIColor.black, forKey: NSForegroundColorAttributeName)
        return NSAttributedString.init(string: string, attributes: attribute)
    }
    //获取标题富文本
    public static func getTitleAttributeString(string: String) -> NSAttributedString {
    
        return getMenuAttributeString(string: string, size: settingsModel.size + 3, color: UIColor.black)
    }
    //获取日期富文本
    public static func getDateAttributeString(string: String) -> NSAttributedString {
        
        return getMenuAttributeString(string: string, size: settingsModel.size - 3, color: UIColor.black)
    }
    
    //获取菜单富文本
    public static func getMenuAttributeString(string: String, size: CGFloat, color: UIColor) -> NSAttributedString {
    
        let attribute = [NSFontAttributeName: UIFont.init(name: settingsModel.font, size: size), NSForegroundColorAttributeName: color] as [String : Any]
        return NSAttributedString.init(string: string, attributes: attribute)
    }
    
}
