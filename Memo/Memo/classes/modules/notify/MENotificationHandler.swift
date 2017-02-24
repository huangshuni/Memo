//
//  MENotificationHandler.swift
//  Memo
//
//  Created by 君若见故 on 17/2/24.
//  Copyright © 2017年 huangshuni. All rights reserved.
//

import UIKit
import UserNotifications

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
    
    private func handleAction(response: UNNotificationResponse) -> Void {
        
        let action = response.actionIdentifier
        if action == notificationCategoryOKAction {
            //通知栏交互，点击确认
            log.debug("ok" + action)
        } else if action == notificationCategoryCancelAction {
            log.debug("cancel" + action)
        }
    }
}
