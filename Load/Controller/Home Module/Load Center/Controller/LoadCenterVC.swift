//
//  LoadCenterVC.swift
//  Load
//
//  Created by Haresh Bhai on 19/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class LoadCenterVC: UIViewController {

    //MARK:- Variables
    lazy var mainView: LoadCenterView = { [unowned self] in
        return self.view as! LoadCenterView
    }()
    
    lazy var mainModelView: LoadCenterViewModel = {
        return LoadCenterViewModel(theController: self)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBarTitle(strTitle: getCommonString(key: "Load_Center_key"))
        self.navigationController?.setColor()
        self.mainView.setupUI(theController: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setColor()
    }

    //MARK:- @IBAction
    @IBAction func btnAddClicked(_ sender: Any) {
        let obj: CreateLoadCenterVC = AppStoryboard.LoadCenter.instance.instantiateViewController(withIdentifier: "CreateLoadCenterVC") as! CreateLoadCenterVC
        let nav = UINavigationController(rootViewController: obj)
        nav.modalPresentationStyle = .overFullScreen
        self.present(nav, animated: false, completion: nil)
    }
    
    @IBAction func btnFilterClicked(_ sender: Any) {
        let obj: FilterVC = AppStoryboard.LoadCenter.instance.instantiateViewController(withIdentifier: "FilterVC") as! FilterVC
        let nav = UINavigationController(rootViewController: obj)
        nav.modalPresentationStyle = .overFullScreen
        self.present(nav, animated: true, completion: nil )
    }
    
    @IBAction func btnBookmarkTapped(_ sender: UIButton) {
        let obj = AppStoryboard.LoadCenter.instance.instantiateViewController(withIdentifier: "BookmarkLoadCenterVc") as! BookmarkLoadCenterVc
        let nav = UINavigationController(rootViewController: obj)
        nav.modalPresentationStyle = .overFullScreen
        self.present(nav, animated: true, completion: nil )
    }
    
}
