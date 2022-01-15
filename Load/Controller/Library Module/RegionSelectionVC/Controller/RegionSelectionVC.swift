//
//  RegionSelectionVC.swift
//  Load
//
//  Created by Haresh Bhai on 26/11/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

protocol RegionSelectionSelectedDelegate: class {
    func RegionSelectionSelectedDidFinish(ids:[Int], subIds:[Int], names:[String],currentIndex:Int)
}

class RegionSelectionVC: UIViewController {
    
    @IBOutlet weak var btnSelect: UIButton!
    var currentIndex = 0
    
    //MARK:- Variables
    lazy var mainView: RegionSelectionView = { [unowned self] in
        return self.view as! RegionSelectionView
        }()
    
    lazy var mainModelView: RegionSelectionViewModel = {
        return RegionSelectionViewModel(theController: self)
    }()
    
    //MARK:- ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.mainModelView.isHeaderHide {
            btnSelect.setTitle(str: getCommonString(key: "Save_key"))
            setUpNavigationBarTitle(strTitle: getCommonString(key: "Region_key"), color: .black)
        }
        else {
            setUpNavigationBarTitle(strTitle: getCommonString(key: "Filters_key"), color: .black)
        }
        self.navigationController?.setWhiteColor()
        self.mainView.setupUI(theController: self)
        
        DispatchQueue.main.async {
            
            self.mainModelView.delegate?.RegionSelectionSelectedDidFinish(ids: self.mainModelView.selectedArray, subIds: self.mainModelView.selectedSubBodyPartIdArray, names: self.mainModelView.selectedNameArray,currentIndex: 2)
            // set current index as 2 so data is not fill pu in 0 and 1 index
        }
    }
    
    //MARK:- @IBAction
    @IBAction func btnCloseClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //Method is not used
    @IBAction func btnSelectClicked(_ sender: Any) {
        if self.mainModelView.selectedArray.count == 0 {
            makeToast(strMessage: getCommonString(key: "Please_select_region_key"))
        }
        else {

            //TODO: - Yash changes
//            self.mainModelView.delegate?.RegionSelectionSelectedDidFinish(ids: self.mainModelView.selectedArray, subIds: self.mainModelView.selectedSubBodyPartIdArray, names: self.mainModelView.selectedNameArray)
            self.dismiss(animated: true, completion: nil)
        }
    }
}

