//
//  MEDataBase.swift
//  Memo
//
//  Created by huangshuni on 2017/2/25.
//  Copyright © 2017年 huangshuni. All rights reserved.
//

/**
 * 方法的访问权限<=类的
 * open:完全公开
 * public:公开
 * internal:默认
 * filePrivate:文件内私有
 * private:私有
 */


import UIKit
import FMDB

public enum MESearchType: Int {
    
    case MESearchTypeAll = 0, MESearchTypeWait, MESearchTypeFinish, MESearchTypeOverdDate
}

public class MEDataBase {
    
    private let MEItemTableName = "MEItemModel"
    private let id = "id"
    private let title = "title"
    private let content = "content"
    private let imgList = "imgList"
    private let editDate = "editDate"
    private let notifyDate = "notifyDate"
    private let isTurnNotify = "isTurnNotify"
    private let isFinsh = "isFinsh"
    private let overDate = "overDate"
    private let state = "state"
    
    //数据库操作队列（创建数据库）
    var dbQueue: FMDatabaseQueue? = {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("memoDB.sqlite")
        log.debug(fileURL);
        guard let dbqueue = FMDatabaseQueue.init(path: fileURL.path) else{
            log.error("creat memoDB failed")
            return nil
        }
        return dbqueue
    }()
    
    
    static let defaultDB = MEDataBase()
    private init() {
        creatTable()
    }
    
    
    //创建表
    private func creatTable() {
        
        dbQueue?.inDatabase({ (dataBase) in
            guard (dataBase?.open())! else {
                log.error("unable to open memoDB")
                return
            }
            if !(dataBase?.tableExists(self.MEItemTableName))! {
                do{
                    try dataBase?.executeUpdate("create table \(self.MEItemTableName)(\(self.id) text PRIMARY KEY, \(self.title) text, \(self.content) text, \(self.imgList) text, \(self.editDate) text, \(self.notifyDate) text, \(self.isTurnNotify) text, \(self.isFinsh) text, \(self.overDate) text, \(self.state) text);", values: nil)
                    
                }catch{
                    log.error("creat memotable failed -- \(error)")
                }
            }
        })

    }
    
    //插入数据
    public func insertAndUpdateModelToDatabase(model:MEItemModel){
        
        dbQueue?.inDatabase({ (dataBase) in
            guard (dataBase?.open())! else {
                log.error("unable to open memoDB")
                return
            }
            
            let selectStr = "select * from \(self.MEItemTableName) where id =\(model.id!)"
            
            do{
                let resultSet = try dataBase?.executeQuery(selectStr, values: nil)
                if (resultSet?.next())! {
                    //更新操作
                    let updateStr = "update \(self.MEItemTableName) set \(self.title) = \"\(model.title!)\", \(self.content) = \"\(model.content ?? "")\", \(self.imgList) = \"\(model.imgList?.joined(separator: ",") ?? "")\", \(self.editDate) = \(model.editDate!), \(self.notifyDate) = \(model.notifyDate ?? ""), \(self.isTurnNotify) = \"\(model.isTurnNotify)\", \(self.isFinsh) = \"\(model.isFinsh)\", \(self.overDate) = \"\(model.overDate)\", \(self.state) = \"\(model.state.rawValue)\" where \(self.id) = \"\(model.id!)\" "
                    print(updateStr)
                    do{
                        try dataBase?.executeUpdate(updateStr, values: nil)
                    }catch{
                        log.error("update failed -- \(error)")
                    }
                    
                }else{                    
                    //插入操作
                    let insertStr = "insert into \(self.MEItemTableName) (\(self.id),\(self.title),\(self.content),\(self.imgList),\(self.editDate),\(self.notifyDate),\(self.isTurnNotify),\(self.self.isFinsh),\(self.overDate),\(self.state)) values (?,?,?,?,?,?,?,?,?,?)"
                    let values = [model.id,model.title,model.content ?? "",model.imgList?.joined(separator: ",") ?? "",model.editDate,model.notifyDate ?? "",model.isTurnNotify,model.isFinsh,model.overDate,model.state.rawValue] as [Any]
                    do {
                        try dataBase?.executeUpdate(insertStr, values: values)
                    }catch{
                        log.error("insert failed -- \(error)")
                    }
                }
            }catch{
                log.error("query item in memo failed -- \(error)")
            }
            
            dataBase?.close()
        })
        
    }
    
    
    //删除数据
    public func deleteModelInDatabase(model:MEItemModel){
        dbQueue?.inDatabase({ (dataBase) in
            guard (dataBase?.open())! else {
                log.error("unable to open memoDB")
                return
            }
            let deleteStr = "delete from \(self.MEItemTableName) where \(self.id) = \"\(model.id!)\""
            print(deleteStr)
            do{
               try dataBase?.executeUpdate(deleteStr, values: nil)
            }catch{
                log.error("delete item in memo dailed -- \(error)")
            }
            dataBase?.close()
        })
    }
    
    //删除指定属性的数据
    public func deleteModelInDatabase(_ key: String, value:String){
        dbQueue?.inDatabase({ (dataBase) in
            guard (dataBase?.open())! else {
                log.error("unable to open memoDB")
                return
            }
            
            let deleteStr = "delete from \(self.MEItemTableName) where \(key) = \"\(value)\" "
            print(deleteStr)
            do{
               try dataBase?.executeUpdate(deleteStr, values: nil)
            }catch{
                log.error("delete item in memo dailed -- \(error)")
            }
            dataBase?.close()
        })
    }
    
    //获取表中所有的数据
    public func selectModelArrayInDatabase() -> Array<Any>{
        
        var resultArr = Array<Any>()
        
        dbQueue?.inDatabase({ (dataBase) in
            guard (dataBase?.open())! else {
                log.error("unable to open memoDB")
                return
            }
            
            let selectStr = "select \(self.id),\(self.title),\(self.content),\(self.imgList),\(self.editDate),\(self.notifyDate),\(self.isTurnNotify),\(self.self.isFinsh),\(self.overDate),\(self.state) from \(self.MEItemTableName)"
            do{
                
                let resultSet = try dataBase?.executeQuery(selectStr, values: nil)
                while (resultSet?.next())!{
                   let id = resultSet?.string(forColumn: self.id)
                   let title = resultSet?.string(forColumn: self.title)
                   let content = resultSet?.string(forColumn: self.content)
                    let imgList = resultSet?.string(forColumn: self.imgList)
                    let editDate = resultSet?.string(forColumn: self.editDate)
                    let notifyDate = resultSet?.string(forColumn: self.notifyDate)
                    let isTurnNotify = resultSet?.string(forColumn: self.isTurnNotify)
                    let isFinsh = resultSet?.string(forColumn: self.isFinsh)
                    let overDate = resultSet?.string(forColumn: self.overDate)
                    let state:ModelStates = ModelStates(rawValue: Int((resultSet?.string(forColumn: self.state))!)!)!
            
                    let model = MEItemModel.init(id:id!, title:title!,content:content ,imgList: imgList?.components(separatedBy: ","),editDate:editDate!,notifyDate:notifyDate, isTurnNotify:(isTurnNotify != nil),isFinsh:(isFinsh != nil),overDate:(overDate != nil),state:state)
                    resultArr.append(model)
                }
                
                
            }catch{
                log.error("select item in memo dailed -- \(error)")
            }
            
            dataBase?.close()
        })
        
         return resultArr;
    }
    
    
    //获取表中指定属性的数据
    public func selectModelArrayInDatabase(_ key: String, value:String) -> Array<Any>{
        
        var resultArr = Array<Any>()
        
        dbQueue?.inDatabase({ (dataBase) in
            guard (dataBase?.open())! else {
                log.error("unable to open memoDB")
                return
            }
            let selectStr = "select \(self.id),\(self.title),\(self.content),\(self.imgList),\(self.editDate),\(self.notifyDate),\(self.isTurnNotify),\(self.self.isFinsh),\(self.overDate),\(self.state) from \(self.MEItemTableName) where \(key) = \"\(value)\""
            do{
                let resultSet = try dataBase?.executeQuery(selectStr, values: nil)
                while (resultSet?.next())!{
                    let id = resultSet?.string(forColumn: self.id)
                    let title = resultSet?.string(forColumn: self.title)
                    let content = resultSet?.string(forColumn: self.content)
                    let imgList = resultSet?.string(forColumn: self.imgList)
                    let editDate = resultSet?.string(forColumn: self.editDate)
                    let notifyDate = resultSet?.string(forColumn: self.notifyDate)
                    let isTurnNotify = resultSet?.string(forColumn: self.isTurnNotify)
                    let isFinsh = resultSet?.string(forColumn: self.isFinsh)
                    let overDate = resultSet?.string(forColumn: self.overDate)
                    let state:ModelStates = ModelStates(rawValue: Int((resultSet?.string(forColumn: self.state))!)!)!
                    
                    let model = MEItemModel.init(id:id!, title:title!,content:content ,imgList: imgList?.components(separatedBy: ","),editDate:editDate!,notifyDate:notifyDate, isTurnNotify:(isTurnNotify != nil),isFinsh:(isFinsh != nil),overDate:(overDate != nil),state:state)
                    resultArr.append(model)
                }
                
            }catch{
                log.error("delete item in memo dailed -- \(error)")
            }
            dataBase?.close()
        })
        return resultArr;
    }
    
    // MARK: - 从分类中搜索数据
    public func selectModelArrayInDatabase(_ type: MESearchType, keyword: String) -> Array<Any>{
    
        var arr = [Any]()
        switch type {
        case .MESearchTypeAll:
            arr = selectModelArrayInDatabase()
            break
        case .MESearchTypeWait:
            arr = selectModelArrayInDatabase("state", value: "0")
            break
        case .MESearchTypeFinish:
            arr = selectModelArrayInDatabase("isFinsh", value: "true")
            break
        case .MESearchTypeOverdDate:
            arr = selectModelArrayInDatabase("overDate", value: "true")
            break
        }
        
        var resultArr = [Any]()
        for model in arr {
            if  (model as!MEItemModel).title.contains(keyword) {
                resultArr.append(model)
                continue
            }
            if  (model as!MEItemModel).editDate.contains(keyword) {
                resultArr.append(model)
                continue
            }
            if  ((model as!MEItemModel).notifyDate?.contains(keyword))! {
                resultArr.append(model)
                continue
            }
            if  ((model as!MEItemModel).content?.contains(keyword))! {
                resultArr.append(model)
                continue
            }
        }
        return resultArr
    }
    
}
