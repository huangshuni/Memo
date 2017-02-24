//
//  MEItemModel.swift
//  Memo
//
//  Created by 君若见故 on 17/2/22.
//  Copyright © 2017年 huangshuni. All rights reserved.
//

import UIKit

public enum ModelStates: Int {

    case ModelStatesWait = 0, ModelStatesFinsh, ModelStatesOverdDate
}
//时间格式化字符串
let dateFormatStr = "yyyy-MM-dd HH:mm"
let threeDaySeconds = Double(259200)

public struct MEItemModel {
    
    /*
        未开启提醒：1.待办；2.过期
        开启提醒：1.待办；2.完成；3.过期
     */
    //编号
    let id = NSDate.getCurrentDateStamp()
    //标题
    var title: String!
    //内容
    var content: String?
    //图片数组
    var imgList: [String]?
    //编辑日期
    var editDate: String!
    //提醒日期
    var notifyDate: String?
    //是否开启提醒
    var isTurnNotify: Bool
    //是否已经完成
    var isFinsh: Bool = false
    //是否过期
    var overDate: Bool = false
    //状态
    var state: ModelStates = ModelStates.ModelStatesWait
    
//    init(title: String, content: String?, imgList: [String]?, editDate: String, notifyDate: String?, isTurnNotify: Bool) {
//        
//        self.title = title
//        self.content = content
//        self.imgList = imgList
//        self.editDate = editDate
//        self.notifyDate = notifyDate
//        self.isTurnNotify = isTurnNotify
//    }
    
    //更新模型状态
    public mutating func updateModelStatus() -> Void {
        //完成或过期 则不再改变状态
        if state == .ModelStatesFinsh || state == .ModelStatesOverdDate {
            return;
        }
        //未设置提醒的默认最后一次编辑时间后三天过期
        let nowDate = NSDate()
        if let date = notifyDate {
            //存在提醒时间
            let notiDate = NSDate.getNSDateFromDateString(dateString: date)
            let timeInterval = nowDate.timeIntervalSince(notiDate as! Date)
            if timeInterval > 0, isFinsh == false {
                state = .ModelStatesOverdDate
            }
        } else {
            //不存在
            let editDate = NSDate.getNSDateFromDateString(dateString: self.editDate)
            let timeInterval = nowDate.timeIntervalSince(editDate as! Date)
            if timeInterval > threeDaySeconds {
                state = .ModelStatesOverdDate
            }
        }
    }
}







