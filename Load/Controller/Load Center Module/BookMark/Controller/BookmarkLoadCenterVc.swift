//
//  BookmarkLoadCenterVc.swift
//  Load
//
//  Created by iMac on 18/03/20.
//  Copyright © 2020 Haresh Bhai. All rights reserved.
//

import UIKit

class BookmarkLoadCenterVc: UIViewController {

    //MARK:- Variables
    lazy var mainView: BookmarkLoadCenterView = { [unowned self] in
        return self.view as! BookmarkLoadCenterView
    }()
    
    lazy var mainModelView: BookmarkLoadCenterViewModel = {
        return BookmarkLoadCenterViewModel(theController: self)
    }()

    //MARK; - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavigationBarTitle(strTitle: getCommonString(key: "Saved_key"), color: .black)
        self.navigationController?.setWhiteColor()
        
        mainView.setupUI()
        mainModelView.setupUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.apiCalling), name: Notification.Name(NOTIFICATION_CENTER_LIST.LOAD_CENTER_BOOKMARK_PAGE_REFRESH.rawValue), object: nil)
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnCloseClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @objc func apiCalling(){
        self.mainModelView.apiCallLBookMarkList(isLoading: false)
    }
}
