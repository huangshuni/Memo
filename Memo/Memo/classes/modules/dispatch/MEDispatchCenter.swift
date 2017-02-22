//
//  MEDispatchCenter.swift
//  Memo
//
//  Created by 君若见故 on 17/2/22.
//  Copyright © 2017年 huangshuni. All rights reserved.
//

import UIKit
import RESideMenu

public class MEDispatchCenter: NSObject {

    static let sideMenu = {
    
        return UIApplication.shared.keyWindow?.rootViewController as! RESideMenu
    }()
    
    public static func dispatchContent(menuIndex: MEMenuItem) -> Void {
    
        let homeViewController = (sideMenu.contentViewController as! BaseNavigationController).viewControllers.first as! MEHomeViewController
        if menuIndex == .MenuSetting {
            //设置
            prepareShowSettings(homeViewController: homeViewController)
        } else {
            //列表
            prepareShowList(homeViewController: homeViewController)
            
        }
        var title: String
        switch menuIndex {
        case .MenuAll:
            title = menu_All_Title
        case .MenuWait:
            title = menu_Wait_Title
        case .MenuFinsh:
            title = menu_Finsh_Title
        case .MenuOverDate:
            title = menu_OverDate_Title
        case .MenuSetting:
            title = menu_Setting_Title
        }
        homeViewController.title = title
        sideMenu.hideViewController()
    }
    
    static func prepareShowSettings(homeViewController: MEHomeViewController) -> Void {
    
        //准备数据
        //若当前视图不是目标视图，则切换
        if !homeViewController.currentViewController!.isKind(of: MESettingsViewController.classForCoder()) {
            homeViewController.changeController(toViewController: MESettingsViewController())
        }
        
    }
    
    static func prepareShowList(homeViewController: MEHomeViewController) -> Void {
    
        //准备数据
        //若当前视图不是目标视图，则切换
        let item1 = MEItemModel(title: "1111", content: "撒娇圣诞节啊打电话就撒娇和打开的贺卡和大伙啥时候大红大红大点哈宽宏大度哈哈等哈看的哈客户端煎熬撒娇圣诞节啊打电话就撒娇和打开的贺卡和大伙啥时候大红大红大点哈宽宏大度哈哈等哈看的哈客户端煎熬撒娇圣诞节啊打电话就撒娇和打开的贺卡和大伙啥时候大红大红大点哈宽宏大度哈哈等哈看的哈客户端煎熬", imgList: ["Stars", "Stars"], editDate: "1487756989", notifyDate: nil, isTurnNotify: false, isFinsh: false, overDate: false, state: .ModelStatesWait)
        let item2 = MEItemModel(title: "说就哈德建设大街很深刻的哈哈是打火机刷卡号地块啥都开会撒谎的哭声", content: "撒娇圣诞节啊打电话就撒娇和打开的贺卡和大伙啥时候大红大红大点哈宽宏大度哈哈等哈看的哈客户端煎熬撒娇圣诞节啊打电话就", imgList: ["add", "back"], editDate: "1487756989", notifyDate: "1487756989", isTurnNotify: true, isFinsh: true, overDate: false, state: .ModelStatesFinsh)
        let dataList = [item1, item2]
        if !homeViewController.currentViewController!.isKind(of: METableViewController.classForCoder()) {
            let searchTable = METableViewController()
            homeViewController.changeController(toViewController: searchTable)
        } else {
            let searchTable = homeViewController.childViewControllers.first as! METableViewController
            searchTable.dataList = dataList
        }
    }
}




