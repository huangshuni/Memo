//
//  MEHomeViewController.swift
//  Memo
//
//  Created by 君若见故 on 17/2/20.
//  Copyright © 2017年 huangshuni. All rights reserved.
//

import UIKit
import RESideMenu

class MEHomeViewController: BaseViewController, RESideMenuDelegate {
    
    var currentViewController: UIViewController?
    var sideMenu: RESideMenu {
        get {
            return UIApplication.shared.keyWindow?.rootViewController as! RESideMenu
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = menu_Wait_Title
        sideMenu.delegate = self
        addSearchTableViewController()
        addNavigationBarButton()
    
        //测试代码
//        MENotifyCenter.center.getNotificationAuth()
//        MENotifyCenter.center.checkNotificationAuth()
        //测试代码
//        let item = MEDispatchService.service.getFinshItem().first
//        MENotifyCenter.center.registerNotification(model: item!)
        //测试代码
//        for item in MEDispatchService.service.getAllItem() {
//            MESpotlightCenter.center.addSearchItem(model: item)
//        }
        
        //测试代码
//        MEDataBase.defaultDB.insertAndUpdateModelToDatabase(model: item!)
        
        //测试代码
//       let arr = MEDataBase.defaultDB.selectModelArrayInDatabase()
//        print(arr)
        
        //测试代码
//        let arr = MEDataBase.defaultDB.selectModelArrayInDatabase("isFinsh", value: "1")
//        print(arr)
        
        //测试代码
//        MEDataBase.defaultDB.deleteModelInDatabase("isFinsh", value: "1")
//        let arr1 = MEDataBase.defaultDB.selectModelArrayInDatabase()
//        MEDataBase.defaultDB.deleteModelInDatabase(model: arr1[0] as!MEItemModel)
//        print(arr1)
    }

    func addSearchTableViewController() -> Void {
        
        let searchTable = METableViewController()
        addChildViewController(searchTable)
        searchTable.didMove(toParentViewController: self)
        view.addSubview(searchTable.view)
        currentViewController = searchTable
        MEDispatchCenter.dispatchContent(menuIndex: .MenuWait)
    }
    
    func addNavigationBarButton() -> Void {
    
        let leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "list"), style: .plain, target: self, action: #selector(clickMenu))
        navigationItem.leftBarButtonItem = leftBarButtonItem
        let rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(clickAdd))
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    func changeController(toViewController: UIViewController) -> Void {
    
        addChildViewController(toViewController)
        transition(from: currentViewController!, to: toViewController, duration: 0.25, options: .beginFromCurrentState, animations: nil, completion: { flag in
            
            toViewController.didMove(toParentViewController: self)
            self.currentViewController?.willMove(toParentViewController: self)
            self.currentViewController?.removeFromParentViewController()
            toViewController.view.frame = self.view.bounds
            self.view.addSubview(toViewController.view)
            self.currentViewController = toViewController
        })
    }
    
    func clickMenu() -> Void {
    
        log.debug("menu ..")
        sideMenu.presentLeftMenuViewController()
    }
    func clickAdd() -> Void {
    
        log.debug("add ..")
        
        let vc = MEAddMemoViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    func showContent() -> Void {
        
        log.debug("content ..")
        sideMenu.hideViewController()
    }
    // MARK: - RESideMenuDelegate
    func sideMenu(_ sideMenu: RESideMenu!, didShowMenuViewController menuViewController: UIViewController!) {
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .stop, target: self, action: #selector(showContent))
    }
    func sideMenu(_ sideMenu: RESideMenu!, didHideMenuViewController menuViewController: UIViewController!) {
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "list"), style: .plain, target: self, action: #selector(clickMenu))
        
    }
    
    
}
