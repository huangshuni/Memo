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
        
        view.backgroundColor = UIColor.getColor(rgb: textBGColor)
        deploySearchViewController()
        tableView.register(UINib.init(nibName: "METableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView.tableHeaderView = searchViewController?.searchBar
        tableView.separatorStyle = .none
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
        if dataList.count == 0 {
            //无数据
            let noDataBGView = UIView.init(frame: tableView.bounds)
            noDataBGView.backgroundColor = UIColor.white
            tableView.backgroundView = noDataBGView
        } else {
            tableView.backgroundView = nil
        }
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
        if searchViewController!.isActive {
            self.searchViewController?.searchBar.resignFirstResponder()
            self.tableView.reloadData()
        } else {
            let vc = MEAddMemoViewController()
            vc.memoModel = resultList[indexPath.row]
            //        vc.reloadMemoModel(resultList[indexPath.row])
            navigationController?.pushViewController(vc, animated: true)
        }
       
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     
        return tableView.fd_heightForCell(withIdentifier: "cell", cacheBy: indexPath, configuration: { (cell) in
            let itemCell = cell as! METableViewCell
            itemCell.setModel(model: self.resultList[indexPath.row])
        })
        
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        log.debug("commit editing Style")
    }
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        var list: [UITableViewRowAction] = []
        let model = resultList[indexPath.row]
        if model.state.rawValue != ModelStates.ModelStatesWait.rawValue {
            let finshRow = UITableViewRowAction.init(style: .default, title: row_Finsh, handler: cellFinsh)
            finshRow.backgroundColor = UIColor.getColor(rgb: greenColor)
            list.append(finshRow)
        }
        let editRow = UITableViewRowAction.init(style: .default, title: row_Edit, handler: cellEdit)
        editRow.backgroundColor = UIColor.getColor(rgb: blueColor)
        let delRow = UITableViewRowAction.init(style: .default, title: row_Del, handler: cellDel)
        delRow.backgroundColor = UIColor.getColor(rgb: overDateColor)
        list.append(editRow)
        list.append(delRow)
        return list
    }
    
    // MARK: - UISearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController) {

        if searchController.isActive {
            let arr1 = MEDataBase.defaultDB.selectModelArrayInDatabase(.MESearchTypeAll, keyword: searchController.searchBar.text!, startSelectLine: 0) as! [MEItemModel]
            resultList = arr1
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
    // MARK: - cell rowAction
    //完成
    private func cellFinsh(rowAction: UITableViewRowAction, indexPath: IndexPath) -> Void {
        log.debug("cell Finsh")
        tableView.setEditing(false, animated: true)
        let model = self.resultList[indexPath.row]
        MEDBManager.manager.updateItemState(identifier: model.id, state: .ModelStatesFinsh)
        self.resultList.remove(at: indexPath.row)
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    //删除
    private func cellDel(rowAction: UITableViewRowAction, indexPath: IndexPath) -> Void {
        log.debug("cell Del")
        let alert = UIAlertController.init(title: "删除", message: "确认是否删除", preferredStyle: .alert)
        let okAction = UIAlertAction.init(title: "是", style: .default, handler: {action in
            alert.dismiss(animated: true, completion: nil)
            //从数据中移除该数据
            let model = self.resultList[indexPath.row]
            MEDBManager.manager.delItem(identifier: model.id)
            self.resultList.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            //移除该数据的通知
            MENotifyCenter.center.removeNotification(identifier: model.id)
        })
        let cancelAction = UIAlertAction.init(title: "否", style: .cancel, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
        
    }
    //编辑
    private func cellEdit(rowAction: UITableViewRowAction, indexPath: IndexPath) -> Void {
        log.debug("cell Edit")
        tableView.setEditing(false, animated: true)
//        self.tableView.reloadRows(at: [indexPath], with: .automatic);
        let vc = MEAddMemoViewController.init()
        vc.memoModel = self.resultList[indexPath.row]
        vc.memoEditing = true
        navigationController?.pushViewController(vc, animated: true)
    }
}
