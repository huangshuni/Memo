//
//  METableTableViewController.swift
//  Memo
//
//  Created by 君若见故 on 17/2/21.
//  Copyright © 2017年 huangshuni. All rights reserved.
//

import UIKit
import UITableView_FDTemplateLayoutCell

class METableViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    
    var dataList: [MEItemModel] = [] {
        didSet {
            updateValue()
        }
    }
    var resultList: [MEItemModel] = []
    var searchViewController: UISearchController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        deploySearchViewController()
        tableView.register(UINib.init(nibName: "METableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView.tableHeaderView = searchViewController?.searchBar
        tableView.separatorStyle = .none
        resultList = dataList
    }
    //设置搜索框
    func deploySearchViewController() -> Void {
    
        searchViewController = UISearchController.init(searchResultsController: nil)
        searchViewController?.searchBar.delegate = self
        searchViewController?.searchBar.barStyle = .default
        searchViewController?.searchBar.sizeToFit()
        searchViewController?.searchResultsUpdater =  self
        searchViewController?.dimsBackgroundDuringPresentation = false
        searchViewController?.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
        defineCancelButton()
    }
    
    //设置搜索框的返回按钮
    func defineCancelButton() -> Void {
    
        let attribute = [NSFontAttributeName: UIFont.systemFont(ofSize: 15.0), NSForegroundColorAttributeName: UIColor.black]
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.classForCoder() as! UIAppearanceContainer.Type]).setTitleTextAttributes(attribute, for: .normal)
    }
    //刷新视图
    private func updateValue() -> Void {
        
        resultList = dataList
        tableView.reloadData()
    }
    
    // MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return resultList.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! METableViewCell
        cell.selectionStyle = .none
        cell.setModel(model: resultList[indexPath.row])
        return cell
    }
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        log.debug(indexPath.row)
        self.searchViewController?.searchBar.resignFirstResponder()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     
        return tableView.fd_heightForCell(withIdentifier: "cell", cacheBy: indexPath, configuration: { (cell) in
            let itemCell = cell as! METableViewCell
            itemCell.setModel(model: self.resultList[indexPath.row])
        })
        
    }
    
    // MARK: - UISearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController) {

        if searchController.isActive {
            let result = dataList.filter { (str) -> Bool in
                return true
            }
            resultList = result
        } else {
            resultList = dataList
        }
        tableView.reloadData()
    }
    
    // MARK: - UISearchBarDelegate
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        searchBar.text = ""
        searchViewController?.searchBar.setShowsCancelButton(false, animated: true)
    }
}
