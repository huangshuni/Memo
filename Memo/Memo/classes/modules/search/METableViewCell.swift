//
//  METableViewCell.swift
//  Memo
//
//  Created by 君若见故 on 17/2/22.
//  Copyright © 2017年 huangshuni. All rights reserved.
//

import UIKit

class METableViewCell: UITableViewCell {

    @IBOutlet weak var flagView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var editDateLabel: UILabel!
    @IBOutlet weak var editDateTitleLabel: UILabel!
    @IBOutlet weak var notifyDateLabel: UILabel!
    @IBOutlet weak var notifyDateTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        flagView.layer.cornerRadius = 8
        flagView.layer.masksToBounds = true
        editDateTitleLabel.attributedText = MEAttributeStrings.getDateAttributeString(string: date_Edit)
        contentView.backgroundColor = UIColor.getColor(rgb: textBGColor)
    }

    func setModel(model: MEItemModel) -> Void {
        
        changeFlagColor(state: model.state)
        titleLabel.attributedText = MEAttributeStrings.getTitleAttributeString(string: model.title)
        if let content = model.content {
            contentLabel.attributedText = MEAttributeStrings.getTextAttributeString(string: content)
        } else {
            contentLabel.text = ""
        }
        adjustImage(imageList: model.imgList)
        let editDateStr = NSDate.getFormatterDateTime(dateStamp: model.editDate, formatter: dateFormatStr)
        editDateLabel.attributedText = MEAttributeStrings.getDateAttributeString(string: editDateStr)
        if let notifyDate = model.notifyDate {
            notifyDateTitleLabel.attributedText = MEAttributeStrings.getDateAttributeString(string: date_Notify)
            let notifyDateStr = NSDate.getFormatterDateTime(dateStamp: notifyDate, formatter: dateFormatStr)
            notifyDateLabel.attributedText = MEAttributeStrings.getDateAttributeString(string: notifyDateStr)
        } else {
            notifyDateTitleLabel.text = nil
            notifyDateLabel.text = nil
        }
        
    }
    //调整标示颜色
    private func changeFlagColor(state: ModelStates) -> Void {
    
        var color: UIColor?
        if state == .ModelStatesWait {
            //待办
            color = UIColor.getColor(rgb: waitColor)
        } else if state == .ModelStatesFinsh {
            //完成
            color = UIColor.getColor(rgb: blueColor)
        } else if state == .ModelStatesOverdDate {
            //过期
            color = UIColor.getColor(rgb: overDateColor)
        }
        flagView.backgroundColor = color
    }
    //调整图片，为了适配第三方cell自动行高，必须明确是否有照片，无则置为nil
    private func adjustImage(imageList: [String]?) -> Void {
    
        if imageList == nil || imageList?.count == 0 {
            imageView1.image = nil
            imageView2.image = nil
        } else {
            if imageList!.count > 0 {
                imageView1.image = UIImage.init(named: imageList![0])
                imageView2.image = nil
            }
            if imageList!.count > 1 {
                imageView2.image = UIImage.init(named: imageList![1])
            }
        }
    }
    
    
    
}
