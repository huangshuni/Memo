//
//  MELeftMenuViewController.swift
//  Memo
//
//  Created by 君若见故 on 17/2/20.
//  Copyright © 2017年 huangshuni. All rights reserved.
//

import UIKit
import RESideMenu

public enum MEMenuItem: Int {
    case MenuAll, MenuWait, MenuFinsh, MenuOverDate, MenuSetting
}

class MELeftMenuViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuTitleLabel: UILabel!
    let menuList = [menu_All_Title, menu_Wait_Title, menu_Finsh_Title, menu_OverDate_Title, menu_Setting_Title]
    var selectItem = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        menuTitleLabel.attributedText = MEAttributeStrings.getMenuAttributeString(string: menu_Title, size: 22.0, color: UIColor.black)
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return menuList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.selectionStyle = .none
        var attributesStr: NSAttributedString!
        if indexPath.row == selectItem {
             attributesStr = MEAttributeStrings.getMenuAttributeString(string: menuList[indexPath.row], size: 21.0, color: UIColor.getColor(rgb: greenColor))
        } else {
            attributesStr = MEAttributeStrings.getMenuAttributeString(string: menuList[indexPath.row], size: 17.0, color: UIColor.black)
        }
        cell?.textLabel?.attributedText = attributesStr
        return cell!
    }
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectItem = indexPath.row
        tableView.reloadData()
        MEDispatchCenter.dispatchContent(menuIndex: MEMenuItem(rawValue: indexPath.row)!)
    }
}
