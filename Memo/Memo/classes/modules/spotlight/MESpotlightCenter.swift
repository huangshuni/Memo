//
//  MESpotlightCenter.swift
//  Memo
//
//  Created by 君若见故 on 17/2/24.
//  Copyright © 2017年 huangshuni. All rights reserved.
//

import UIKit
import CoreSpotlight
import MobileCoreServices

public class MESpotlightCenter: NSObject {
    
    private let search = CSSearchableIndex.default()
    
    static let center = MESpotlightCenter()
    private override init() {
        super.init()
    }
    
    //添加支持的搜索项
    public func addSearchItem(model: MEItemModel) -> Void {
    
        search.indexSearchableItems([getSearchItem(model: model)]) { (error) in
            if let err = error {
                log.info("add SearchItem: \(model.id) error: \(err)")
            }
        }
        
    }
    //移除指定搜索项
    public func delSearchItem(model: MEItemModel) -> Void {
    
        search.deleteSearchableItems(withIdentifiers: [model.id], completionHandler: { error in
            if let err = error {
                log.info("clear SearchItem: \(model.id) error: \(err)")
            }
        })
    }
    //清空所有搜索项
    public func clearAllSerchItem() -> Void {
    
        search.deleteAllSearchableItems { (error) in
            if let err = error {
                log.info("clear All SearchItem error: \(err)")
            }
        }
    }
    //处理spotlight 响应事件
    public func handleSpotlight(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Swift.Void) -> Bool {
    
        let identifier = userActivity.userInfo?[CSSearchableItemActivityIdentifier];
        log.debug(identifier)
        return true
    }
    
    //获取搜索项
    private func getSearchItem(model: MEItemModel) -> CSSearchableItem {
    
        let attributeSet = CSSearchableItemAttributeSet.init(itemContentType: kUTTypeData as String)
        attributeSet.title = model.title
        attributeSet.contentDescription = model.content
        let item = CSSearchableItem.init(uniqueIdentifier: model.id, domainIdentifier: model.id, attributeSet: attributeSet)
        return item
    }
    
}
