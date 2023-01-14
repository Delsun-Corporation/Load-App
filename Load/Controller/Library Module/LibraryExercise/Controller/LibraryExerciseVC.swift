//
//  LibraryExerciseVC.swift
//  Load
//
//  Created by Haresh Bhai on 05/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

protocol AddExerciseDelegate: AnyObject {
    func AddExerciseDidFinish(listArray: [LibraryExerciseModelClass])
    func AddAllExerciseDidFinish(listArray: [LibraryLogList])
}

class LibraryExerciseVC: UIViewController {
    
    //MARK:- Variables
    lazy var mainView: LibraryExerciseView = { [unowned self] in
        return self.view as! LibraryExerciseView
    }()
    
    lazy var mainModelView: LibraryExerciseViewModel = {
        return LibraryExerciseViewModel(theController: self)
    }()
    
    //MARK:- ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBarTitle(strTitle: "Library")
        self.mainView.setupUI(theController: self)
        // Do any additional setup after loading the view.
    }
    
    //MARK:- @IBAction
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnAddClicked(_ sender: Any) {
        var listArray: [LibraryLogList] = [LibraryLogList]()
        for model in self.mainView.listArray {
            for modelSub in model.list ?? [] {
                for modelSub1 in modelSub.data ?? [] {
                    if modelSub1.selected {
                        listArray.append(modelSub1)
                    }
                }
            }
        }
        
        for model in self.mainView.listFavoriteArray {
            for modelSub1 in model.list ?? [] {
                if modelSub1.selected {
                    let array = LibraryLogList(JSON: modelSub1.toJSON())
                    listArray.append(array!)
                }
            }
        }
        
        self.navigationController?.popViewController(animated: true)
        self.mainModelView.delegate?.AddAllExerciseDidFinish(listArray: listArray)
    }
}
