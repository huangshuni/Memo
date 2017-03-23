//
//  MEDBManager.swift
//  Memo
//
//  Created by 君若见故 on 17/3/14.
//  Copyright © 2017年 huangshuni. All rights reserved.
//

import UIKit


/// 该类是对数据库操作的封装，提供更加快捷方便的操作
class MEDBManager {

    static let manager = MEDBManager()
    private init() {}
    
    private let db = MEDataBase.defaultDB
    
    //更新模型状态
    func updateItemState(identifier: String, state: ModelStates) -> Void {
        
        var model = db.selectModelArrayInDatabase("id", value: identifier, startSelectLine: 0).first as! MEItemModel
        model.state = state
        db.insertAndUpdateModelToDatabase(model: model)
    }
    
    //删除模型
    func delItem(identifier: String) -> Void {
    
        //删除沙盒图片
        let model = getItem(identifier: identifier)
        if (model?.imgList?.count)! > 0 {
            for imagePath in (model?.imgList!)! {
               let path = MEItemModel.getImagePath(imgName: imagePath)
                YHFileManager.deleteFile(path)
            }
        }
        db.deleteModelInDatabase("id", value: identifier)
        
    }
    
    //插入或更新模型
    func saveItem(model: MEItemModel) -> Void {
    
        db.insertAndUpdateModelToDatabase(model: model)
    }
    
    //查询指定模型
    func getItem(identifier: String) -> MEItemModel? {
        
        let list = db.selectModelArrayInDatabase("id", value: identifier, startSelectLine: 0)
        var model: MEItemModel?
        if list.count > 0 {
            model = list.first as? MEItemModel
        }
        return model
    }
    
}
