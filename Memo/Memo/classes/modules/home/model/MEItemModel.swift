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
    
    static func getImagePath(imgName: String) -> String {
    
        return YHFileManager.documentsPath.appending(photoDirectory).appending(imgName)
    }
}







