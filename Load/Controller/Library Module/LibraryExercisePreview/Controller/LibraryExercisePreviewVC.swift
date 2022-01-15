//
//  LibraryExercisePreviewVC.swift
//  Load
//
//  Created by Haresh Bhai on 13/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class LibraryExercisePreviewVC: UIViewController {

    @IBOutlet weak var btnEdit: UIButton!
    
    //MARK:- Variables
    lazy var mainView: LibraryExercisePreviewView = { [unowned self] in
        return self.view as! LibraryExercisePreviewView
    }()
    
    lazy var mainModelView: LibraryExercisePreviewViewModel = {
        return LibraryExercisePreviewViewModel(theController: self)
    }()
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mainView.setupUI(theController: self)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if self.mainView.listComman != nil {
            self.btnEdit.isHidden = true
        }
        
        self.mainModelView.handlerForExerciseName = {[weak self] (strTitle) in
            self?.setUpNavigationBarTitle(strTitle: strTitle)
            self?.navigationController?.setColor()
        }
        
        self.mainModelView.setupUI()
    }
    
    // MARK: @IBAction
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnEditClicked(_ sender: Any) {
        let obj: AddExerciseVC = AppStoryboard.Library.instance.instantiateViewController(withIdentifier: "AddExerciseVC") as! AddExerciseVC
        obj.mainModelView.isEdit = true
        obj.mainModelView.libraryId = self.mainModelView.libraryId
        obj.mainModelView.libraryPreviewModel = self.mainModelView.libraryPreviewModel
        self.navigationController?.pushViewController(obj, animated: true)
    }
}
