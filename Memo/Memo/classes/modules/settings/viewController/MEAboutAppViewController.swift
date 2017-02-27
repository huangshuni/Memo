//
//  MEAboutAppViewController.swift
//  Memo
//
//  Created by 君若见故 on 17/2/27.
//  Copyright © 2017年 huangshuni. All rights reserved.
//

import UIKit

class MEAboutAppViewController: BaseViewController {

    @IBOutlet weak var versionTitleLabel: UILabel!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var updateButton: UIButton!
    let appId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        versionTitleLabel.attributedText = MEAttributeStrings.getTitleAttributeString(string: setting_app_version)
        versionLabel.attributedText = MEAttributeStrings.getTextAttributeString(string: YHDeviceInfo.appVersion)
        updateButton.setAttributedTitle(MEAttributeStrings.getMenuAttributeString(string: setting_app_updateBtnTitle, size: 17.0, color: UIColor.getColor(rgb: whiteColor)), for: .normal)
        updateButton.backgroundColor = UIColor.getColor(rgb: blueColor)
    }
    @IBAction func clickUpdate(_ sender: UIButton) {
        
        //测试代码
        self.alertInfo(info: ["update": true, "title": setting_app_alertTitle, "body": "有新版本可供使用"])
        
        YHAppInfoManager.getAppInfoFromAppStore(appID: appId) { (dic) in
            
            let version = dic["version"] as! String
            if version == YHDeviceInfo.appVersion {
                //存在新版本
                self.alertInfo(info: ["update": true, "title": setting_app_alertTitle, "body": "有新版本\(version)可供使用"])
            } else {
                //不存在，提示用户
                self.alertInfo(info: ["update": false, "title": setting_app_alertTitle, "body": setting_app_alertbody])
            }
        }
    }
    
    private func alertInfo(info: NSDictionary) -> Void {
        
        let result = info["update"] as! Bool
        let title = info["title"] as! String
        let body = info["body"] as! String
        var okButtonTitle: String!
        var cancelButtonTitle: String!
        let alert = UIAlertController.init(title: title, message: body, preferredStyle: .alert)
        if result {
            okButtonTitle = setting_app_alertOKBtnTitle
            cancelButtonTitle = setting_app_alertCancelBtnTitle
            let okAction = UIAlertAction.init(title: okButtonTitle, style: .default) { (action) in
                
                YHAppInfoManager.entryAppStore(appID: self.appId)
            }
            let cancelAction = UIAlertAction.init(title: cancelButtonTitle, style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            alert.addAction(okAction)
        } else {
            okButtonTitle = setting_app_alertOKBtn2Title
            let okAction = UIAlertAction.init(title: okButtonTitle, style: .cancel, handler: nil)
            alert.addAction(okAction)
        }
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}







