//
//  MELeftMenuViewController.swift
//  Memo
//
//  Created by 君若见故 on 17/2/20.
//  Copyright © 2017年 huangshuni. All rights reserved.
//

import UIKit

class MELeftMenuViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var menuLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    let menuList = [menu_All_Title, menu_Wait_Title, menu_Finsh_Title, menu_OverDate_Title, menu_Setting_Title]
    var selectItem = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
        cell?.textLabel?.text = menuList[indexPath.row]
        var fontColor: UIColor!
        var fontSize: CGFloat = 17.0
        
        if indexPath.row == selectItem {
             fontColor = UIColor.getColor(rgb: greenColor)
             fontSize = 21.0
        } else {
             fontColor = UIColor.black
        }
        cell?.textLabel?.textColor = fontColor
        cell?.textLabel?.font = UIFont.systemFont(ofSize: fontSize)
        return cell!
    }
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectItem = indexPath.row
        tableView.reloadData()
    }
}
