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
        setUpNavigationBarTitle(strTitle: self.mainModelView.title, color:UIColor.black)
        self.navigationController?.setWhiteColor()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let viewWithTag = self.navigationController!.view.viewWithTag(1002) {
            viewWithTag.removeFromSuperview()
        }

    }
    
    private func saveUpdatedData() {
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

    //MARK:- @IBAction
    @IBAction func btnCancelClicked(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
        self.mainModelView.delegate?.dismissPopupScreen()
        saveUpdatedData()
    }
    
    @IBAction func btnDoneClicked(_ sender: Any) {
        saveUpdatedData()
    }
}
