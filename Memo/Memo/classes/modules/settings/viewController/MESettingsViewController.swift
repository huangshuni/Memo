//
//  MESettingsViewController.swift
//  Memo
//
//  Created by 君若见故 on 17/2/22.
//  Copyright © 2017年 huangshuni. All rights reserved.
//

import UIKit

class MESettingsViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    let settingsModel = MESettingsModel.settingsModel
    var dataList: [String] = []
    var resultList: [Any] = []
    var fontList:[NSDictionary] = []
    var fontSizeList:[NSDictionary] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = menu_Setting_Title
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
        initializeTableView()
    }
    
    private func initializeTableView() -> Void {
    
        tableView.backgroundColor = UIColor.getColor(rgb: textBGColor)
        tableView.register(UINib.init(nibName: "MESettingSoundCell", bundle: nil), forCellReuseIdentifier: "soundCell")
        dataList = [setting_item_sound, setting_item_font, setting_item_fontSize, setting_item_about]
        resultList = [settingsModel.soundsOpen, getFont(), getFontSize(), ""]
    }
    
    private func getFont() -> String {
        
        let fontList: [NSDictionary] = NSArray.arrayFromPlist("MEFont")! as! [NSDictionary]
        self.fontList = fontList
        for dic in fontList {
            if dic["code"] as! String == MESettingsModel.settingsModel.font {
                return dic["name"] as? String ?? ""
            }
        }
        return ""
    }
    
    private func getFontSize() -> String {
    
        fontSizeList = [["name": "大", "size": MEFontSize.big], ["name": "中", "size": MEFontSize.normal], ["name": "小", "size": MEFontSize.small]]
        if settingsModel.size == MEFontSize.big.rawValue {
            return "大"
        } else if settingsModel.size == MEFontSize.normal.rawValue {
            return "中"
        } else {
            return "小"
        }
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let soundCell = tableView.dequeueReusableCell(withIdentifier: "soundCell")! as! MESettingSoundCell
            soundCell.titleLabel.attributedText = MEAttributeStrings.getTextAttributeString(string: dataList[indexPath.row])
            soundCell.switch.isOn = resultList[indexPath.section] as! Bool
            soundCell.selectionStyle = .none
            soundCell.changeValueAction = { isOn in
                self.settingsModel.soundsOpen = isOn
            }
            return soundCell
        } else {
            var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
            if cell == nil {
                cell = UITableViewCell.init(style: .value1, reuseIdentifier: "cell")
            }
            cell?.textLabel?.attributedText = MEAttributeStrings.getTextAttributeString(string: dataList[indexPath.section])
            cell?.detailTextLabel?.attributedText = MEAttributeStrings.getTextAttributeString(string: resultList[indexPath.section] as! String)
            cell?.accessoryType = .disclosureIndicator
            cell?.selectionStyle = .none
            return cell!
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailVC = MESettingDetailViewController()
        if indexPath.section == 1 {
            //选择字体
            detailVC.title = setting_font_title
            detailVC.dataList = fontList
            detailVC.type = .DetailTypeFont
            navigationController?.pushViewController(detailVC, animated: true)
        } else if indexPath.section == 2 {
            //选择字号
            detailVC.title = setting_fontsize_title
            detailVC.dataList = fontSizeList
            detailVC.type = .DetailTypeFontSize
            navigationController?.pushViewController(detailVC, animated: true)
        } else if indexPath.section == 3 {
            //关于App
            let aboutVC = MEAboutAppViewController()
            navigationController?.pushViewController(aboutVC, animated: true)
        }
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 0.0
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 8.0
    }
    
}
