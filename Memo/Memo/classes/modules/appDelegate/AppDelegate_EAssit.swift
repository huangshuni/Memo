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
    //自检模型状态
    public func checkStatus() -> Void {
        
        let result = MEDataBase.defaultDB.selectModelArrayInDatabase(.MESearchTypeWait, startSelectLine: 0) as! [MEItemModel]
        for model in result {
            if model.checkStatusIsOverDate() {
                MEDBManager.manager.updateItemState(identifier: model.id, state: .ModelStatesOverdDate)
            }
        }
    }
    
    
    //加载设置
    public func loadSetting() {
        
        let model = MESettingsModel.settingsModel
        let setAvaliable = UserDefaults.standard.object(forKey: "MESet") as? Bool
        if setAvaliable != nil && setAvaliable == true{
            let font = UserDefaults.standard.object(forKey: "MESetFontStyle") as! String
            let fontSize = UserDefaults.standard.object(forKey: "MESetFontSize") as! CGFloat
            let soundOn = UserDefaults.standard.bool(forKey: "MESetNotifyVoice")
            
            model.soundsOpen = soundOn
            model.size = fontSize
            model.font = font
        }
    }
    
    //保存设置
    public func saveSetting(){
        
        let model = MESettingsModel.settingsModel
        UserDefaults.standard.set(model.soundsOpen, forKey: "MESetNotifyVoice")
        UserDefaults.standard.set(model.size, forKey: "MESetFontSize")
        UserDefaults.standard.set(model.font, forKey: "MESetFontStyle")
        UserDefaults.standard.set(true, forKey: "MESet")
        UserDefaults.standard.synchronize()
        
    }
}









