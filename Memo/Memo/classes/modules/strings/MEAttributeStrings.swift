//
//  MEAttributeStrings.swift
//  Memo
//
//  Created by 君若见故 on 17/2/20.
//  Copyright © 2017年 huangshuni. All rights reserved.
//

import UIKit

class MEAttributeStrings {
    
    public static func getAttributeString(string: String) -> NSAttributedString {
    
        return NSAttributedString.init(string: string, attributes: MESettingsModel.settingsModel.getAttribute())
    }
}
