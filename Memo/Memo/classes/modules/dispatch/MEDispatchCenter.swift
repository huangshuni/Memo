//
//  MEDispatchCenter.swift
//  Memo
//
//  Created by 君若见故 on 17/2/22.
//  Copyright © 2017年 huangshuni. All rights reserved.
//

import UIKit
import RESideMenu

//记录当前所在目录
fileprivate var currentMenuItem: MEMenuItem = .MenuWait

public class MEDispatchCenter: NSObject {

    static let sideMenu = {
    
        return UIApplication.shared.keyWindow?.rootViewController as! RESideMenu
    }()
    static let service = MEDispatchService.service
    
    public static func dispatchContent(menuIndex: MEMenuItem) -> Void {
    
        currentMenuItem = menuIndex
        let homeViewController = (sideMenu.contentViewController as! BaseNavigationController).viewControllers.first as! MEHomeViewController
        var title: String
        let dataList:[MEItemModel] = service.getData(type: self.getCurrentSearchType(), index: 0) as! [MEItemModel]
        switch menuIndex {
        case .MenuAll:
            title = menu_All_Title
            prepareShowList(homeViewController: homeViewController, dataList: dataList)
        case .MenuWait:
            title = menu_Wait_Title
            prepareShowList(homeViewController: homeViewController, dataList: dataList)
        case .MenuFinsh:
            title = menu_Finsh_Title
            prepareShowList(homeViewController: homeViewController, dataList: dataList)
        case .MenuOverDate:
            title = menu_OverDate_Title
            prepareShowList(homeViewController: homeViewController, dataList: dataList)
        case .MenuSetting:
            title = menu_Setting_Title
            prepareShowSettings(homeViewController: homeViewController)
        }
        homeViewController.title = title
        sideMenu.hideViewController()
    }
    
    //刷新当前分类的数据
    public static func refreshCurrentData() -> Void {
    
        dispatchContent(menuIndex: currentMenuItem)
    }
    public static func getMoreData(index: Int) -> [MEItemModel] {
    
        return service.getData(type: self.getCurrentSearchType(), index: index) as! [MEItemModel]
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
    
    //将当前分类转化为对应的搜索分类
    static func getCurrentSearchType() -> MESearchType {
    
        switch currentMenuItem {
        case .MenuAll:
            return .MESearchTypeAll
        case .MenuWait:
            return .MESearchTypeWait
        case .MenuFinsh:
            return .MESearchTypeFinish
        case .MenuOverDate:
            return .MESearchTypeOverdDate
        default:
            return .MESearchTypeWait
        }

    }
}




