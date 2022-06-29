//
//  LibraryVC.swift
//  Load
//
//  Created by Haresh Bhai on 12/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class LibraryVC: UIViewController {

    //MARK:- Variables
    lazy var mainView: LibraryView = { [unowned self] in
        return self.view as! LibraryView
    }()
    
    lazy var mainModelView: LibraryViewModel = {
        return LibraryViewModel(theController: self)
    }()
    
    //MARK:- ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mainView.setupUI(theController: self)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpNavigationBarTitle(strTitle: "Library")
        self.navigationController?.setColor()
        SJSwiftSideMenuController.enableSwipeGestureWithMenuSide(menuSide: .NONE)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SJSwiftSideMenuController.enableSwipeGestureWithMenuSide(menuSide: .LEFT)
    }
    
    //MARK:- @IBAction
    @IBAction func btnAddExerciseClicked(_ sender: Any) {
        let obj : AddExerciseVC = AppStoryboard.Library.instance.instantiateViewController(withIdentifier: "AddExerciseVC") as! AddExerciseVC
        obj.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    @IBAction func btnInfoClicked(_ sender: Any) {
        
        
    }
}
