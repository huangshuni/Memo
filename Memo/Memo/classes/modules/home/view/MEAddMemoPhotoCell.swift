//
//  MEAddMemoPhotoCell.swift
//  Memo
//
//  Created by huangshuni on 2017/3/5.
//  Copyright © 2017年 huangshuni. All rights reserved.
//

import UIKit

class MEAddMemoPhotoCell: UICollectionViewCell {

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var deletePhotoBtn: UIButton!
    
    typealias deletePhotoBlock = (UIButton) -> Void
    var deleteBlcok : deletePhotoBlock?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func deletePhotoAction(_ sender: UIButton) {
        deleteBlcok!(sender)
    }
}
