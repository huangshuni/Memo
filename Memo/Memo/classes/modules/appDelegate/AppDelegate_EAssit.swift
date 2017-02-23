//
//  AppDelegate_EAssit.swift
//  Memo
//
//  Created by 君若见故 on 17/2/20.
//  Copyright © 2017年 huangshuni. All rights reserved.
//

import Foundation
import RESideMenu
import IQKeyboardManagerSwift

extension AppDelegate {

    //设置默认控制器
    public func deployRootViewController() -> Void {
    
        let home = MEHomeViewController()
        let nav = BaseNavigationController.init(rootViewController: home);
        let leftMenu = MELeftMenuViewController()
        let sideMenu = RESideMenu.init(contentViewController: nav, leftMenuViewController: leftMenu, rightMenuViewController: nil)
        sideMenu?.backgroundImage = UIImage.init(named: "Stars")
        sideMenu?.contentViewScaleValue = 1
        sideMenu?.panGestureEnabled = false
//        sideMenu?.interactivePopGestureRecognizerEnabled = true
        sideMenu?.panFromEdge = false
        sideMenu?.contentViewShadowEnabled = true
        sideMenu?.contentViewShadowColor = UIColor.black
        sideMenu?.contentViewShadowOpacity = 0.3
        sideMenu?.contentViewShadowRadius = 10
        
        window = UIWindow()
        window!.makeKeyAndVisible()
        window?.rootViewController = sideMenu
    }
    //设置全局样式
    public func deployGlobalStyle() -> Void {
    
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.getColor(rgb: whiteColor), NSFontAttributeName: UIFont.systemFont(ofSize: 21)]


    }
    //设置键盘管理
    public func deploykeyBoard() -> Void {
    
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
    }
    //设置日志记录
    public func deployLog() -> Void {
    
        YHLogger.logger.startLog()
    }
    
}
