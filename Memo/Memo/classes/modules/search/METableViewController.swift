//
//  METableTableViewController.swift
//  Memo
//
//  Created by 君若见故 on 17/2/21.
//  Copyright © 2017年 huangshuni. All rights reserved.
//

import UIKit
import UITableView_FDTemplateLayoutCell
import MJRefresh

class METableViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    var dataList: [MEItemModel] = [] {
        didSet {
            updateValue()
        }
    }
    var resultList: [MEItemModel] = []
    var searchViewController: UISearchController?
    var keyboardIsShow: Bool = false
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.getColor(rgb: textBGColor)
        deploySearchViewController()
        deploytableview()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow)
            , name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide)
            , name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        searchViewController?.isActive = false
    }
    
    //设置tableview
    func deploytableview() -> Void {
    
        tableView.register(UINib.init(nibName: "METableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView.tableHeaderView = searchViewController?.searchBar
        tableView.separatorStyle = .none
        tableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: {[weak self] in
            
            var newList: [MEItemModel] = []
            if self!.searchViewController!.searchBar.showsCancelButton {
                //搜索的加载更多
                newList = METableViewData.getSearchResult(key: self!.searchViewController!.searchBar.text!,index: self!.resultList.count)
                self!.resultList.append(contentsOf: newList)
                self!.tableView.reloadData()
            } else {
                //正常的加载更多
                newList = MEDispatchCenter.getMoreData(index: self!.resultList.count)
                self!.dataList.append(contentsOf: newList)
            }
            if newList.count < selectSize {
                //无更多数据
                self!.tableView.mj_footer.endRefreshingWithNoMoreData()
            }
            
            if self!.tableView.mj_footer.isRefreshing() {
                self!.tableView.mj_footer.endRefreshing()
            }
        })
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
        tableView.mj_footer.resetNoMoreData()
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
            if keyboardIsShow {
                self.searchViewController?.searchBar.resignFirstResponder()
            } else {
                let vc = MEAddMemoViewController()
                vc.memoModel = resultList[indexPath.row]
                navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            let vc = MEAddMemoViewController()
            vc.memoModel = resultList[indexPath.row]
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
        if model.state.rawValue != ModelStates.ModelStatesFinsh.rawValue {
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
            let arr1 = METableViewData.getSearchResult(key: searchViewController!.searchBar.text!, index: 0)
            resultList = arr1
            tableView.mj_footer.resetNoMoreData()
        } else {
            resultList = dataList
        }
        tableView.reloadData()
    }
    
    // MARK: - UISearchBarDelegate
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        searchViewController?.searchBar.setShowsCancelButton(true, animated: true)
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
    // MARK: - 监视键盘事件
    func keyboardShow() -> Void {
        keyboardIsShow = true
    }
    func keyboardHide() -> Void {
        keyboardIsShow = false
    }
}
