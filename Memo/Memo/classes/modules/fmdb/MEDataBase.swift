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
            
            let selectStr = "select * from \(self.MEItemTableName) where id =\(model.id)"
            
            do{
                let resultSet = try dataBase?.executeQuery(selectStr, values: nil)
                if (resultSet?.next())! {
                    //更新操作
                    let updateStr = "update \(self.MEItemTableName) set \(self.title) = ?,\(self.content) = ?,\(self.imgList) = ?,\(self.editDate) = ?,\(self.notifyDate) = ?,\(self.isTurnNotify) = ?,\(self.isFinsh) = ?,\(self.overDate) = ?,\(self.state) = ? where \(self.id) =\(model.id)"
                    do{
                        try dataBase?.executeUpdate(updateStr, values: nil)
                    }catch{
                        log.error("inset or update failed -- \(error)")
                    }
                    
                }else{
                    //插入操作
                    let insertStr = "insert into \(self.MEItemTableName) (\(self.id),\(self.title),\(self.content),\(self.imgList),\(self.editDate),\(self.notifyDate),\(self.isTurnNotify),\(self.self.isFinsh),\(self.overDate),\(self.state)) values (?,?,?,?,?,?,?,?,?,?)"
                    let values = [model.id,model.title,model.content ?? "",model.imgList?.joined(separator: ",") ?? "",model.editDate,model.notifyDate ?? "",model.isTurnNotify,model.isFinsh,model.overDate,model.state] as [Any]
                    dataBase?.executeUpdate(insertStr, withArgumentsIn: values)
                }
            }catch{
                log.error("query item in memo failed -- \(error)")
            }
            
            dataBase?.close()
        })
        
    }
    
    
    

    
}
