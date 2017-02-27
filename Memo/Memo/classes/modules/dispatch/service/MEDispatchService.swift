//
//  MEDispatchService.swift
//  Memo
//
//  Created by 君若见故 on 17/2/23.
//  Copyright © 2017年 huangshuni. All rights reserved.
//

import UIKit

class MEDispatchService {
    
    static let service = MEDispatchService()
    private init() { }
    
    //返回所有项
    func getAllItem() -> [MEItemModel] {
        
        return getItem(index: .MenuAll) as! [MEItemModel]
    }
    //返回完成项
    func getWaitItem() -> [MEItemModel] {
        
        return getItem(index: .MenuWait) as! [MEItemModel]
    }
    //返回完成项
    func getFinshItem() -> [MEItemModel] {
        
        return getItem(index: .MenuFinsh) as! [MEItemModel]
    }
    //返回过期项
    func getOverDateItem() -> [MEItemModel] {
        
        return getItem(index: .MenuOverDate) as! [MEItemModel]
    }
    //查询指定数据集合
    func getItem(index: MEMenuItem) -> Array<Any> {
        
        let item1 = MEItemModel(title: "abc今晚要战斗", content: "今天是周五😁又到了每周一次的战斗了。。", imgList: ["Stars", "Stars"], editDate: "1487756989", notifyDate: nil, isTurnNotify: false, isFinsh: false, overDate: false, state: .ModelStatesWait)
        let item2 = MEItemModel(title: "666周末洗衣服整理内务😁", content: "累啊累啊😁不想做啊~不想做啊~不想做啊~不想做啊~不想做啊~不想做啊~不想做啊~不想做啊~不想做啊~不想做啊~不想做啊~不想做啊~不想做啊~不想做啊~不想做啊~不想做啊~", imgList: ["add", "back"], editDate: "1487756989", notifyDate: "1487756989", isTurnNotify: true, isFinsh: true, overDate: false, state: .ModelStatesFinsh)
        let item3 = MEItemModel(title: "12345上山打老虎", content: "快放假啊~快放假！快放假啊~快放假！快放假啊~快放假！快放假啊~快放假！快放假啊~快放假！快放假啊~快放假！快放假啊~快放假！快放假啊~快放假！快放假啊~快放假！快放假啊~快放假！", imgList: nil, editDate: "1487756989", notifyDate: nil, isTurnNotify: false, isFinsh: false, overDate: true, state: .ModelStatesOverdDate)
        var dataList: [Any] = []
        
        switch index {
        case .MenuAll:
            dataList = [item1, item2, item3]
        case .MenuWait:
            dataList = [item1]
        case .MenuFinsh:
            dataList = [item2]
        case .MenuOverDate:
            dataList = [item3]
        default:
            dataList = []
        }
        return dataList
    }
    
}






