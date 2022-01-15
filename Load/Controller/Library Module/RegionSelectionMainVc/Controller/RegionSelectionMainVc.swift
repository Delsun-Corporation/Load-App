//
//  RegionSelectionMainVc.swift
//  Load
//
//  Created by iMac on 31/01/20.
//  Copyright © 2020 Haresh Bhai. All rights reserved.
//

import UIKit

//protocol RegionSelectionSelectedDelegate: class {
//    func RegionSelectionSelectedDidFinish(ids:[Int], subIds:[Int], names:[String])
//}


class RegionSelectionMainVc: UIViewController,RegionSelectionSelectedDelegate {
    
    

    @IBOutlet weak var btnSelect: UIButton!

    
    //MARK:- Variables
    lazy var mainView: RegionSelectionMainView = { [unowned self] in
        return self.view as! RegionSelectionMainView
    }()
    
    lazy var mainModelView: RegionSelectionMainViewModel = {
        return RegionSelectionMainViewModel(theController: self)
    }()

    var strTitle = ""
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnSelect.setTitle(str: getCommonString(key: "Save_key"))
        self.mainView.setupUI()
        self.mainView.setupUICarbonTab(theController:self)
        setUpNavigationBarTitle(strTitle: self.strTitle + " " + getCommonString(key: "Region_key"), color: .black)
        self.navigationController?.setWhiteColor()
        
        // Do any additional setup after loading the view.
    }

    @IBAction func btnCloseClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func btnSelectClicked(_ sender: Any) {
        if self.mainModelView.selectedArray.count == 0 {
            makeToast(strMessage: getCommonString(key: "Please_select_region_key"))
        }
        else {
            
            print("name : \(self.mainModelView.selectedNameArray)")
            print("ids : \(self.mainModelView.selectedArray)")
            
            print("Array Repeat remove name : \(uniqueElementsFrom(array: self.mainModelView.selectedNameArray))")
            print("Array Repeat remove ids : \( uniqueElementsFrom(array: self.mainModelView.selectedArray))")
            
            self.mainModelView.delegate?.RegionSelectionSelectedDidFinish(ids: uniqueElementsFrom(array: self.mainModelView.selectedArray), subIds: self.mainModelView.selectedSubBodyPartIdArray, names: (uniqueElementsFrom(array: self.mainModelView.selectedNameArray)), currentIndex: 0)
            self.dismiss(animated: true, completion: nil)
        }
    }

    func RegionSelectionSelectedDidFinish(ids: [Int], subIds:[Int], names: [String], currentIndex: Int) {
        
        self.mainModelView.selectedArray = ids
        self.mainModelView.selectedSubBodyPartIdArray = subIds
        self.mainModelView.selectedNameArray = names
        self.mainModelView.showImages()
    }

}
