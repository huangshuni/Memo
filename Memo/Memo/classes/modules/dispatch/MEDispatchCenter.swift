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
    static let service = MEDispatchService.service
    
    public static func dispatchContent(menuIndex: MEMenuItem) -> Void {
    
        let homeViewController = (sideMenu.contentViewController as! BaseNavigationController).viewControllers.first as! MEHomeViewController
        var title: String
        var dataList:[MEItemModel] = []
        switch menuIndex {
        case .MenuAll:
            title = menu_All_Title
            dataList = service.getAllItem()
            prepareShowList(homeViewController: homeViewController, dataList: dataList)
        case .MenuWait:
            title = menu_Wait_Title
            dataList = service.getWaitItem()
            prepareShowList(homeViewController: homeViewController, dataList: dataList)
        case .MenuFinsh:
            title = menu_Finsh_Title
            dataList = service.getFinshItem()
            prepareShowList(homeViewController: homeViewController, dataList: dataList)
        case .MenuOverDate:
            title = menu_OverDate_Title
            dataList = service.getOverDateItem()
            prepareShowList(homeViewController: homeViewController, dataList: dataList)
        case .MenuSetting:
            title = menu_Setting_Title
            prepareShowSettings(homeViewController: homeViewController)
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
    
    static func prepareShowList(homeViewController: MEHomeViewController, dataList: [MEItemModel]) -> Void {
    
        //准备数据
        //若当前视图不是目标视图，则切换
        if !homeViewController.currentViewController!.isKind(of: METableViewController.classForCoder()) {
            let searchTable = METableViewController()
            searchTable.dataList = dataList
            homeViewController.changeController(toViewController: searchTable)
        } else {
            let searchTable = homeViewController.childViewControllers.first as! METableViewController
            searchTable.dataList = dataList
        }
    }
}




