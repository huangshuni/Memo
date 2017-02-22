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
        editDateTitleLabel.attributedText = MEAttributeStrings.getTextAttributeString(string: "编辑日期:")
        notifyDateTitleLabel.attributedText = MEAttributeStrings.getTextAttributeString(string: "提醒日期")
    }

    func setModel(model: MEItemModel) -> Void {
        
        changeFlagColor(state: model.state)
        titleLabel.attributedText = MEAttributeStrings.getTextAttributeString(string: model.title)
        if let content = model.content {
            contentLabel.attributedText = MEAttributeStrings.getTextAttributeString(string: content)
        } else {
            contentLabel.text = ""
        }
        if let imgList = model.imgList {
            if imgList.count > 0 {
                imageView1.image = UIImage.init(named: imgList[0])
            }
            if imgList.count > 1 {
                imageView2.image = UIImage.init(named: imgList[1])
            }
        }
        let editDateStr = NSDate.getFormatterDateTime(dateStamp: model.editDate, formatter: dateFormatStr)
        editDateLabel.attributedText = MEAttributeStrings.getTextAttributeString(string: editDateStr)
        if let notifyDate = model.notifyDate {
            notifyDateTitleLabel.isHidden = false
            notifyDateLabel.isHidden = false
            let notifyDateStr = NSDate.getFormatterDateTime(dateStamp: notifyDate, formatter: dateFormatStr)
            notifyDateLabel.attributedText = MEAttributeStrings.getTextAttributeString(string: notifyDateStr)
        } else {
            notifyDateTitleLabel.isHidden = true
            notifyDateLabel.isHidden = true
        }
        
    }
    
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
}
