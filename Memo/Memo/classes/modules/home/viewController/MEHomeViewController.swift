//
//  MEHomeViewController.swift
//  Memo
//
//  Created by 君若见故 on 17/2/20.
//  Copyright © 2017年 huangshuni. All rights reserved.
//

import UIKit

class MEHomeViewController: BaseViewController {
    
    var currentViewController: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = menu_Wait_Title
        addSearchTableViewController()
    }

    func addSearchTableViewController() -> Void {
        
        let searchTable = METableViewController()
        addChildViewController(searchTable)
        searchTable.didMove(toParentViewController: self)
        view.addSubview(searchTable.view)
        currentViewController = searchTable
    }
    
    func changeController(toViewController: UIViewController) -> Void {
    
        addChildViewController(toViewController)
        transition(from: currentViewController!, to: toViewController, duration: 0.225, options: .layoutSubviews, animations: nil, completion: { flag in
            toViewController.didMove(toParentViewController: self)
            self.currentViewController?.willMove(toParentViewController: self)
            self.currentViewController?.removeFromParentViewController()
            self.currentViewController = toViewController
        })
    }
}
