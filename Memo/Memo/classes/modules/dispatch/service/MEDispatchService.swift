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
        
        var dataList: [Any] = []
        
        switch index {
        case .MenuAll:
            dataList = MEDataBase.defaultDB.selectModelArrayInDatabase(.MESearchTypeAll, startSelectLine: 0)
        case .MenuWait:
            dataList = MEDataBase.defaultDB.selectModelArrayInDatabase(.MESearchTypeWait, startSelectLine: 0)
        case .MenuFinsh:
            dataList = MEDataBase.defaultDB.selectModelArrayInDatabase(.MESearchTypeFinish, startSelectLine: 0)
        case .MenuOverDate:
            dataList = MEDataBase.defaultDB.selectModelArrayInDatabase(.MESearchTypeOverdDate, startSelectLine: 0)
        default:
            dataList = []
        }
        return dataList
    }
    
}






