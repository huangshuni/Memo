//
//  METableViewData.swift
//  Memo
//
//  Created by 君若见故 on 17/3/15.
//  Copyright © 2017年 huangshuni. All rights reserved.
//

import UIKit

class METableViewData {
    
    static func getSearchResult(key: String, index: Int) -> [MEItemModel] {
    
        return MEDataBase.defaultDB.selectModelArrayInDatabase(MEDispatchCenter.getCurrentSearchType(), keyword: key, startSelectLine: index) as! [MEItemModel]
    }
}
