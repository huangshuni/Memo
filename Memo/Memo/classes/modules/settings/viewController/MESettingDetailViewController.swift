//
//  MESettingDetailViewController.swift
//  Memo
//
//  Created by 君若见故 on 17/2/27.
//  Copyright © 2017年 huangshuni. All rights reserved.
//

import UIKit

enum MEDetailType {
    case DetailTypeFont, DetailTypeFontSize
}

class MESettingDetailViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var dataList: [Any] = []
    var type: MEDetailType = MEDetailType.DetailTypeFont
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
    }
    
    //处理字体选择
    private func handleFont(index: Int) -> Void {
    
        let dic = dataList[index] as! NSDictionary
        MESettingsModel.settingsModel.font = dic["code"] as! String
    }
    //处理字号选择
    private func handleFontSize(index: Int) -> Void {
    
        let dic = dataList[index] as! NSDictionary
        MESettingsModel.settingsModel.size = (dic["size"] as! MEFontSize).rawValue
    }
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.accessoryType = .none
        let dic = dataList[indexPath.row] as! NSDictionary
        var attributeStr: NSAttributedString!
        if type == .DetailTypeFont {
            attributeStr = MEAttributeStrings.getTextAttributeString(string: dic["name"] as! String)
            if MESettingsModel.settingsModel.font == dic["code"] as! String {
                cell?.accessoryType = .checkmark
            }
        } else if type == .DetailTypeFontSize {
            attributeStr = MEAttributeStrings.getTextAttributeString(string: dic["name"] as! String)
            if MESettingsModel.settingsModel.size == (dic["size"] as! MEFontSize).rawValue {
                cell?.accessoryType = .checkmark
            }
        }
        cell?.textLabel?.attributedText = attributeStr
        cell?.selectionStyle = .none
        return cell!
    }
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if type == .DetailTypeFont {
            handleFont(index: indexPath.row)
        } else if type == .DetailTypeFontSize {
            handleFontSize(index: indexPath.row)
        }
        tableView.reloadData()
    }
}
