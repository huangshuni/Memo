//
//  MENotificationHandler.swift
//  Memo
//
//  Created by 君若见故 on 17/2/24.
//  Copyright © 2017年 huangshuni. All rights reserved.
//

import UIKit
import UserNotifications
import RESideMenu

class MENotificationHandler: NSObject, UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let category = response.notification.request.content.categoryIdentifier
        if category.compare(notificationCategoryId) == ComparisonResult.orderedSame {
            //优先处理通知按钮交互
            handleAction(response: response)
        } else if let info = response.notification.request.content.userInfo["id"] as? String {
            //再处理通知交互
            log.debug(info)
        }
        completionHandler()
    }
    
    //从通知栏进入应用
    public func entryFromNotification(identifier: String) -> Void {
        
        let model = MEDBManager.manager.getItem(identifier: identifier)
        let sideMenu = UIApplication.shared.keyWindow?.rootViewController as! RESideMenu
        let homeViewContreoller = (sideMenu.contentViewController as! BaseNavigationController).viewControllers.first as! MEHomeViewController
        let detailVC = MEAddMemoViewController()
        detailVC.memoModel = model
        detailVC.memoEditing = false
        homeViewContreoller.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    private func handleAction(response: UNNotificationResponse) -> Void {
        
        let identifier = response.notification.request.identifier
        let action = response.actionIdentifier
        if action == notificationCategoryOKAction {
            //通知栏交互，点击确认
            log.debug("ok" + action)
            MEDBManager.manager.updateItemState(identifier: identifier, state: .ModelStatesFinsh)
            
        } else if action == notificationCategoryCancelAction {
            log.debug("cancel" + action)
            MEDBManager.manager.updateItemState(identifier: identifier, state: .ModelStatesOverdDate)
        } else {
            //default
            entryFromNotification(identifier: identifier)
        }
    }
    
}
