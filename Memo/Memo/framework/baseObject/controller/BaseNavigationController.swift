//
//  BaseNavigationController.swift
//  YHDevelopFramework_Swift
//
//  Created by 君若见故 on 16/10/9.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .lightContent
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.isTranslucent = false
        navigationBar.tintColor = UIColor.getColor(rgb: whiteColor)
        navigationBar.barTintColor = UIColor.getColor(rgb: blueColor)
        interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate
        navaigationTitle()
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.viewControllers.count != 0 {
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(back))
        }
        super.pushViewController(viewController, animated: true)
    }
    
    func back() {
        popViewController(animated: true)
    }
    
    func navaigationTitle() {
    
        UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: UIFont.init(name: MESettingsModel.settingsModel.font, size: 23.0)!, NSForegroundColorAttributeName: UIColor.getColor(rgb: whiteColor)]
    }
}
