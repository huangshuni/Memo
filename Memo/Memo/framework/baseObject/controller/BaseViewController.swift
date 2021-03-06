//
//  BaseViewController.swift
//  YHDevelopFramework_Swift
//
//  Created by 君若见故 on 16/10/8.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont.init(name: MESettingsModel.settingsModel.font, size: 23.0)!, NSForegroundColorAttributeName: UIColor.getColor(rgb: whiteColor)]
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = UIColor.getColor(rgb: textBGColor)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         log.debug("\(self.classForCoder) viewWillAppear")
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        log.debug("\(self.classForCoder) viewWillDisappear")
    }
}
