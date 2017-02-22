//
//  UIColor_EMemoColor.swift
//  Memo
//
//  Created by 君若见故 on 17/2/20.
//  Copyright © 2017年 huangshuni. All rights reserved.
//

import UIKit

public typealias RGBColor = (Int, Int, Int)
let textBGColor: RGBColor = (247, 247, 247)
let blueColor: RGBColor = (18, 183, 246)
let whiteColor: RGBColor = (255, 255, 255)
let greenColor: RGBColor = (30, 161, 20)
let waitColor: RGBColor = (18, 183, 246)
let finshColor: RGBColor = (30, 161, 20)
let overDateColor: RGBColor = (251, 31, 42)

extension UIColor {

    public static func getColor(rgb: RGBColor) -> UIColor {

        guard rgb.0 <= 255, rgb.1 <= 255, rgb.2 <= 255 else {
            return UIColor.black
        }
        return UIColor.RGBAColor(red: rgb.0, green: rgb.1, blue: rgb.2, alpha: 1.0)
    }
}
