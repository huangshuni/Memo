//
//  MEDispatchService.swift
//  Memo
//
//  Created by 君若见故 on 17/2/23.
//  Copyright © 2017年 huangshuni. All rights reserved.
//

import UIKit

class MEDispatchService {
    
    static let service = MEDispatchService()
    private init() { }

    //获取数据
    func getData(type: MESearchType, index: Int) -> Array<Any> {
    
        return MEDataBase.defaultDB.selectModelArrayInDatabase(type, startSelectLine: index)
    }
    
}






