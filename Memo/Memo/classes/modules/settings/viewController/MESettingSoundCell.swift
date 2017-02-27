//
//  MESettingSoundCell.swift
//  Memo
//
//  Created by 君若见故 on 17/2/27.
//  Copyright © 2017年 huangshuni. All rights reserved.
//

import UIKit

class MESettingSoundCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var `switch`: UISwitch!
    var changeValueAction: ((Bool) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func clickSwitch(_ sender: UISwitch) {
        if let block = changeValueAction {
            block(sender.isOn)
        }
    }
}
