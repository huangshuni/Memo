//
//  MEImageView+load.swift
//  Memo
//
//  Created by 君若见故 on 17/3/14.
//  Copyright © 2017年 huangshuni. All rights reserved.
//

import UIKit

extension UIImageView {

    func setLocalImage(path: String) -> Void {
        
        var image: UIImage? = nil;
        DispatchQueue.global().async {
            image =  UIImage.init(contentsOfFile: path)
            DispatchQueue.main.async {
                self.image = image;
            }
        }
    }
    
}
