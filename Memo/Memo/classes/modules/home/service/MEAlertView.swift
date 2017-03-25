//
//  MEAlertView.swift
//  Memo
//
//  Created by huangshuni on 2017/3/25.
//  Copyright © 2017年 huangshuni. All rights reserved.
//

import UIKit
import MBProgressHUD

class MEAlertView  {

   class func showAlertView(view:UIView) {
    
    DispatchQueue.main.async {
    
//        let hud =
            MBProgressHUD.showAdded(to: view, animated: true)
//        hud.mode = .indeterminate
//        hud.bezelView.color = UIColor.black
    }
    
    
    }
    
   class func hideAlertView(view:UIView) {
    
    DispatchQueue.main.async {
            
        MBProgressHUD.hide(for: view, animated: true)
      }
    }
    
}
