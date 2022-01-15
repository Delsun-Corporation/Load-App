//
//  EventVC.swift
//  Load
//
//  Created by Haresh Bhai on 20/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class EventVC: UIViewController {

    //MARK:- Variables
    lazy var mainView: EventView = { [unowned self] in
        return self.view as! EventView
    }()
    
    lazy var mainModelView: EventViewModel = {
        return EventViewModel(theController: self)
    }()
    
    //MARK:- ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainView.setupUI()
        self.mainModelView.setupUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.apiCalling), name: Notification.Name(NOTIFICATION_CENTER_LIST.LOAD_CENTER_EVENT_PAGE_REFRESH.rawValue), object: nil)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        SELECTED_LOADCENTER_TAB = 2
    }
    
    @objc func apiCalling(){
        self.mainModelView.apiCallLibraryList(status: LOAD_CENTER_TYPE.EVENT.rawValue,isLoading: false)
    }
}
