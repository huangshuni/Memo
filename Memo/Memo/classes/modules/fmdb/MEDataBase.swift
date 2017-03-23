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

let selectSize = 3 //每次搜索10行

public class MEDataBase {
    
    
    private let MEItemTableName = "MEItemModel"
    private let id = "id"
    private let title = "title"
    private let content = "content"
    private let imgList = "imgList"
    private let editDate = "editDate"
    private let notifyDate = "notifyDate"
    private let isTurnNotify = "isTurnNotify"
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
                    try dataBase?.executeUpdate("create table \(self.MEItemTableName)(\(self.id) text PRIMARY KEY, \(self.title) text, \(self.content) text, \(self.imgList) text, \(self.editDate) text, \(self.notifyDate) text, \(self.isTurnNotify) text, \(self.state) text);", values: nil)
                    
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
                    let updateStr = "update \(self.MEItemTableName) set \(self.title) = \"\(model.title!)\", \(self.content) = \"\(model.content ?? "")\", \(self.imgList) = \"\(model.imgList?.joined(separator: ",") ?? "")\", \(self.editDate) = \(model.editDate!), \(self.notifyDate) = \(model.notifyDate ?? ""), \(self.isTurnNotify) = \"\(model.isTurnNotify)\", \(self.state) = \"\(model.state.rawValue)\" where \(self.id) = \"\(model.id!)\" "
                    print(updateStr)
                    do{
                        try dataBase?.executeUpdate(updateStr, values: nil)
                    }catch{
                        log.error("update failed -- \(error)")
                    }
                    
                }else{                    
                    //插入操作
                    let insertStr = "insert into \(self.MEItemTableName) (\(self.id),\(self.title),\(self.content),\(self.imgList),\(self.editDate),\(self.notifyDate),\(self.isTurnNotify),\(self.state)) values (?,?,?,?,?,?,?,?)"
                    let values = [model.id,model.title,model.content ?? "",model.imgList?.joined(separator: ",") ?? "",model.editDate,model.notifyDate ?? "",model.isTurnNotify,model.state.rawValue] as [Any]
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
    private func selectModelArrayInDatabase() -> Array<Any>{
        
        var resultArr = Array<Any>()
        
        dbQueue?.inDatabase({ (dataBase) in
            guard (dataBase?.open())! else {
                log.error("unable to open memoDB")
                return
            }
            
            let selectStr =  self.getAllColumnSql() + " from \(self.MEItemTableName)"
            do{
                
                let resultSet = try dataBase?.executeQuery(selectStr, values: nil)
                resultArr = self.getModelFromeResult(resultSet)
                
            }catch{
                log.error("select item in memo dailed -- \(error)")
            }
            
            dataBase?.close()
        })
        
         return resultArr;
    }
    
    
    //获取表中指定属性的数据
    public func selectModelArrayInDatabase(_ key: String, value:String, startSelectLine: Int) -> Array<Any>{
        
        var resultArr = Array<Any>()
        
        dbQueue?.inDatabase({ (dataBase) in
            guard (dataBase?.open())! else {
                log.error("unable to open memoDB")
                return
            }
            
            var selectStr = self.getAllColumnSql() + " from \(self.MEItemTableName) where \(key) = \"\(value)\" order by \(self.notifyDate) DESC"
            if startSelectLine != Int.max{
                selectStr.append(" limit \(startSelectLine),\(selectSize)")
            }

            log.debug(selectStr)
            do{
                let resultSet = try dataBase?.executeQuery(selectStr, values: nil)
                resultArr = self.getModelFromeResult(resultSet)
                
            }catch{
                log.error("select item in memo dailed -- \(error)")
            }
            dataBase?.close()
        })
        return resultArr;
    }
    
    // MARK: - 从分类中搜索数据
    public func selectModelArrayInDatabase(_ type: MESearchType, startSelectLine: Int) -> Array<Any>{

        var stateValue = ""
        switch type {
        case .MESearchTypeAll:
            
            break
        case .MESearchTypeWait:
            stateValue = String(ModelStates.ModelStatesWait.rawValue)
            break
        case .MESearchTypeFinish:
            stateValue = String(ModelStates.ModelStatesFinsh.rawValue)
            break
        case .MESearchTypeOverdDate:
            stateValue = String(ModelStates.ModelStatesOverdDate.rawValue)
            break
        }
        
        var selectStr = ""
        if type == .MESearchTypeAll {
            selectStr = self.getAllColumnSql() + " from \(self.MEItemTableName) order by \(self.notifyDate) DESC"
        }else{
            selectStr = self.getAllColumnSql() + " from \(self.MEItemTableName) where \(self.state) = \"\(stateValue)\" order by \(self.notifyDate) DESC"
        }
        if startSelectLine != Int.max{
            selectStr.append(" limit \(startSelectLine),\(selectSize)")
        }
        
        var resultArr = Array<Any>()
        dbQueue?.inDatabase({ (dataBase) in
            guard (dataBase?.open())! else {
                log.error("unable to open memoDB")
                return
            }
            log.debug(selectStr)
            do{
                let resultSet = try dataBase?.executeQuery(selectStr, values: nil)
                resultArr = self.getModelFromeResult(resultSet)
                
            }catch{
                log.error("select item in memo dailed -- \(error)")
            }
            dataBase?.close()
        })
        return resultArr;
    }
    
      // MARK: - 分页返回搜索数据（从当前分类中)
    public func selectModelArrayInDatabase(_ type: MESearchType, keyword: String, startSelectLine: Int) -> Array<Any>{
        
        var stateValue = ""
        switch type {
        case .MESearchTypeAll:
            
            break
        case .MESearchTypeWait:
            stateValue = String(ModelStates.ModelStatesWait.rawValue)
            break
        case .MESearchTypeFinish:
            stateValue = String(ModelStates.ModelStatesFinsh.rawValue)
            break
        case .MESearchTypeOverdDate:
            stateValue = String(ModelStates.ModelStatesOverdDate.rawValue)
            break
        }
        
        //提醒和编辑时间匹配待考究？
        var selectStr = ""
        if type == .MESearchTypeAll {
            selectStr =  self.getAllColumnSql() + " from \(self.MEItemTableName) where \(self.title) like \'%\(keyword)%\' or \(self.editDate) like \'%\(keyword)%\' or \(self.notifyDate) like \'%\(keyword)%\' or \(self.content) like \'%\(keyword)%\' order by \(self.notifyDate) DESC"
        }else{
            selectStr = self.getAllColumnSql() + " from \(self.MEItemTableName) where \(self.state) = \"\(stateValue)\" and (\(self.title) like \'%\(keyword)%\' or \(self.editDate) like \'%\(keyword)%\' or \(self.notifyDate) like \'%\(keyword)%\' or \(self.content) like \'%\(keyword)%\') order by \(self.notifyDate) DESC"
        }
        
        if startSelectLine != Int.max{
            selectStr.append(" limit \(startSelectLine),\(selectSize)")
        }
        
        var resultArr = Array<Any>()
        dbQueue?.inDatabase({ (dataBase) in
            guard (dataBase?.open())! else {
                log.error("unable to open memoDB")
                return
            }
            log.debug(selectStr)
            do{
                let resultSet = try dataBase?.executeQuery(selectStr, values: nil)
                resultArr = self.getModelFromeResult(resultSet)
                
            }catch{
                log.error("select item in memo dailed -- \(error)")
            }
            dataBase?.close()
        })
        return resultArr;
    }
    
    //将结果转化为模型
    private func getModelFromeResult(_ result: FMResultSet?) -> Array<Any> {
        
        var resultArr = Array<Any>()
        while (result?.next())!{
            let id = result?.string(forColumn: self.id)
            let title = result?.string(forColumn: self.title)
            let content = result?.string(forColumn: self.content)
            let imgList = result?.string(forColumn: self.imgList)
            let editDate = result?.string(forColumn: self.editDate)
            let notifyDate = result?.string(forColumn: self.notifyDate)
            let isTurnNotify = result?.string(forColumn: self.isTurnNotify)
            let state:ModelStates = ModelStates(rawValue: Int((result?.string(forColumn: self.state))!)!)!
            
            let model = MEItemModel.init(id:id!, title:title!,content:content ,imgList: imgList?.components(separatedBy: ","),editDate:editDate!,notifyDate:notifyDate, isTurnNotify:(isTurnNotify != nil),state: state)
            resultArr.append(model)
        }
        return resultArr
    }
    //获取选择所有列sql语句
    private func getAllColumnSql() -> String {
    
        return "select \(self.id),\(self.title),\(self.content),\(self.imgList),\(self.editDate),\(self.notifyDate),\(self.isTurnNotify),\(self.state)"
    }
    
}
