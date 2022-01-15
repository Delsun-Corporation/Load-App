//
//  ListingsVC.swift
//  Load
//
//  Created by Haresh Bhai on 20/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class ListingsVC: UIViewController {
    
    //MARK:- Variables
    lazy var mainView: ListingsView = { [unowned self] in
        return self.view as! ListingsView
        }()
    
    lazy var mainModelView: ListingsViewModel = {
        return ListingsViewModel(theController: self)
    }()
    
    //MARK:- ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainView.setupUI()
        self.mainModelView.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setColor()
        SELECTED_LOADCENTER_TAB = 1
        
        print(LOAD_CENTER_TYPE.LISTING.rawValue)
        self.mainModelView.apiCallLibraryList(status: LOAD_CENTER_TYPE.LISTING.rawValue)

    }    
}
