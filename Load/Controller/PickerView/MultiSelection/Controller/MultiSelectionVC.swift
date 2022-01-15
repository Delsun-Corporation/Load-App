//
//  MultiSelectionVC.swift
//  Load
//
//  Created by Haresh Bhai on 14/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
protocol MultiSelectionDelegate: class {
    func dismissPopupScreen()
    func MultiSelectionDidFinish(selectedData: [MultiSelectionDataEntry])
}

class MultiSelectionVC: UIViewController {

    //MARK:- Variables
    lazy var mainView: MultiSelectionView = { [unowned self] in
        return self.view as! MultiSelectionView
    }()
    
    lazy var mainModelView: MultiSelectionViewModel = {
        return MultiSelectionViewModel(theController: self)
    }()
    
    //MARK:- ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainView.setupUI(theController: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.mainModelView.setupNavigationbar(title: self.mainModelView.title)
        self.navigationController?.setWhiteColor()
        self.navigationController?.addShadow()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let viewWithTag = self.navigationController!.view.viewWithTag(1002) {
            viewWithTag.removeFromSuperview()
        }

    }

    //MARK:- @IBAction
    @IBAction func btnCancelClicked(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
        self.mainModelView.delegate?.dismissPopupScreen()
    }
    
    @IBAction func btnDoneClicked(_ sender: Any) {
        let data: [MultiSelectionDataEntry] = self.mainModelView.data.filter { (model) -> Bool in
            model.isSelected == true
        }
        if data.count == 0 {
            makeToast(strMessage: getCommonString(key: "Please_select_at_least_one_key"))
            return
        }
        self.dismiss(animated: false, completion: nil)
        self.mainModelView.delegate?.MultiSelectionDidFinish(selectedData: data)
    }
}
