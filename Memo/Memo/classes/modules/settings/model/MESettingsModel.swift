//
//  MESettingsModel.swift
//  Memo
//
//  Created by 君若见故 on 17/2/20.
//  Copyright © 2017年 huangshuni. All rights reserved.
//

import UIKit

enum MEFontSize: CGFloat {
    case small = 11.0
    case normal = 15.0
    case big = 21.0
}

class MESettingsModel {
    
    var font = "PingFang SC"
    var size = MEFontSize.normal.rawValue
    var soundsOpen = true
    var version = YHDeviceInfo.appVersion
    
    static let settingsModel = MESettingsModel()
    private init() { }
    
    public func getAttribute() -> [String: Any] {
    
        return [NSFontAttributeName: UIFont.init(name: font, size: size)!]
    }
}
