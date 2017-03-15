//
//  MENotifyCenter.swift
//  Memo
//
//  Created by 君若见故 on 17/2/23.
//  Copyright © 2017年 huangshuni. All rights reserved.
//

import UIKit
import UserNotifications

//notificationCategoryID
public let notificationCategoryId = "notificationCategory"
public let notificationCategoryOKAction = "notificationCategory.okAction"
public let notificationCategoryCancelAction = "notificationCategory.cancelAction"

public class MENotifyCenter {
    
    private let handler = MENotificationHandler()
    static let center = MENotifyCenter()
    private init() { }
    
    //配置通知的代理
    public func deployNotification() -> Void {
        
        UNUserNotificationCenter.current().delegate = handler
        registerNotificationCategory()
    }
    
    //请求通知权限
    public func getNotificationAuth() -> Void {
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: { flag, error in
            if flag {
                log.info("获取通知权限成功")
            } else {
                log.info("获取通知权限失败： \(error)")
            }
        })
    }
    
    //检查通知权限
    public func checkNotificationAuth() -> Void {
        
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            
            if settings.authorizationStatus == .notDetermined {
                //未获取，去获取
                self.getNotificationAuth()
            } else if settings.alertSetting == .disabled ||
                settings.authorizationStatus == .denied ||
                settings.notificationCenterSetting == .disabled ||
                settings.lockScreenSetting == .disabled {
                
                self.alertUserGetAuth()
            }
        }
    }
    
    //注册通知
    public func registerNotification(model: MEItemModel) -> Void {
        
        let content = UNMutableNotificationContent()
        content.title = model.title
        content.subtitle = "\n"
        content.body = model.content ?? ""
        content.userInfo = ["id": model.id]
        content.categoryIdentifier = notificationCategoryId
        if MESettingsModel.settingsModel.soundsOpen {
            content.sound = UNNotificationSound.default()
        }
        var list: [UNNotificationAttachment] = []
        if model.imgList != nil, model.imgList!.count > 0 {
            
            let path = MEItemModel.getImagePath(imgName: model.imgList![0])
            let imgPath = self.copyFileToCache(path: path, name: model.imgList![0]) ?? ""
            let attachment = try? UNNotificationAttachment.init(identifier: model.imgList!.first!, url: URL.init(fileURLWithPath: imgPath), options: nil)
            if attachment == nil {
                log.error("通知初始化资源失败：attachment = nil")
                return
            }
            list.append(attachment!)
            content.attachments = list
        }
        //实际代码
        let timeInterval =  Double(model.notifyDate!)!/1000.0
        let dateStr = String(Int(timeInterval))
        let date = NSDate.getNSDateFromDateString(dateString: dateStr)!
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date as Date)
        let trigger = UNCalendarNotificationTrigger.init(dateMatching: dateComponents, repeats: false)
        //测试代码
        //let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 5, repeats: false)
        
        let identifier = model.id
        let request = UNNotificationRequest.init(identifier: identifier!, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    //移除通知
    public func removeNotification(identifier: String) -> Void {
    
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
    //弹窗去设置通知权限
    private func alertUserGetAuth() -> Void {
        
        let alertController = UIAlertController.init(title: notification_alert_title, message: notification_alert_content, preferredStyle: .alert)
        let okAction = UIAlertAction.init(title: notification_alert_ok, style: .default, handler: { action in
            DispatchQueue.main.async {
                if UIApplication.shared.canOpenURL(URL.init(string: UIApplicationOpenSettingsURLString)!) {
                    UIApplication.shared.open(URL.init(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
                }
            }
        })
        let cancelAction = UIAlertAction.init(title: notification_alert_cancel, style: .cancel, handler: nil)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        let root = UIApplication.shared.keyWindow?.rootViewController
        DispatchQueue.main.async {
            root?.present(alertController, animated: true, completion: nil)
        }
    }
    
    //配置可交互通知项
    private func registerNotificationCategory() -> Void {
        
        let category: UNNotificationCategory = {
            
            let okAction = UNNotificationAction.init(identifier: notificationCategoryOKAction, title: notification_category_ok, options: [.foreground])
            let cancelAction = UNNotificationAction.init(identifier: notificationCategoryCancelAction, title: notification_category_cancel, options: [.destructive])
            return UNNotificationCategory.init(identifier: notificationCategoryId, actions: [okAction, cancelAction], intentIdentifiers: [], options: [.customDismissAction])
        }()
        UNUserNotificationCenter.current().setNotificationCategories([category])
    }
    //复制文件从document到caches目录下，并返回caches目录下文件路径
    private func copyFileToCache(path: String, name: String) -> String? {
    
        let manager = FileManager.default
        let targetPath = YHFileManager.cachePath.appending("/\(name)")
        do {
            try manager.copyItem(atPath: path, toPath: targetPath)
        } catch {
            log.error("复制文件失败：\(error)")
            return nil
        }
        return targetPath
    }
}
