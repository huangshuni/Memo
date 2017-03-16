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
    var id: String!
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
    //状态
    var state: ModelStates = ModelStates.ModelStatesWait
    
    init(id: String = NSDate.getCurrentDateStamp(), title: String, content: String?, imgList: [String]?, editDate: String, notifyDate: String?, isTurnNotify: Bool, state: ModelStates = .ModelStatesWait) {
        
        self.id = id
        self.title = title
        self.content = content
        self.imgList = imgList
        self.editDate = editDate
        self.notifyDate = notifyDate
        self.isTurnNotify = isTurnNotify
        self.state = state
    }
    //获取图片存储路径
    static func getImagePath(imgName: String) -> String {
    
        return YHFileManager.documentsPath.appending(photoDirectory).appending(imgName)
    }
    //自检状态
    func checkStatusIsOverDate() -> Bool {
        
        if state.rawValue == ModelStates.ModelStatesFinsh.rawValue || state.rawValue == ModelStates.ModelStatesOverdDate.rawValue {
            return false
        }
        if notifyDate != nil && notifyDate!.characters.count > 0 {
            //存在提醒但未做任何处理的
            let result = NSDate.compareDate(NSDate.getDateFromDateStamp(dateStamp: notifyDate!), NSDate())
            if result > 0 {
                return false
            }
        } else {
            //不存在提醒且超过编辑日期三天的
            let result = NSDate.compareDate(NSDate.getDateFromDateStamp(dateStamp: editDate), NSDate())
            if result < threeDaySeconds {
                return false
            }
        }
        return true
    }
}







