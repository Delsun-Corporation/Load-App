//
//  PhysicalActivityLevelViewModel.swift
//  Load
//
//  Created by iMac on 18/07/20.
//  Copyright © 2020 Haresh Bhai. All rights reserved.
//

protocol PhysicalAcitivtyFinishSelection {
    func selectedPhysicalActivity(id: Int)
}

import Foundation
import SwiftyJSON

class PhysicalActivityLevelViewModel {
    
    //MARK:- Variables
    fileprivate weak var theController:PhysicalActivityLevelVc!
    var profileDetails: PhysicalActivityModelClass?
    var selectedPhysicalActivityId = 0
    var isUpdated:Bool = false
    var delegateFinishActivityLevel : PhysicalAcitivtyFinishSelection?
    
    //MARK:- Functions
    init(theController:PhysicalActivityLevelVc) {
        self.theController = theController
    }
    
    func setupUI(){
        getPhysicalActivityList()
    }
    
    //MARK: - Setup navigation bar
    func setupNavigationbar(title:String) {
        
        self.theController.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        self.theController.navigationItem.hidesBackButton = true
        
        if let vwnav = ViewNavMedium.instanceFromNib() as? ViewNavMedium {
            
            vwnav.imgBackground.isHidden = true
            vwnav.btnback.isHidden = false
            vwnav.btnSave.isHidden = false
            vwnav.btnSave.setTitle(str: "")
            vwnav.btnSave.setBackgroundImage(UIImage(named: "ic_details"), for: .normal)
            
            var hightOfView = 0
            if UIScreen.main.bounds.height >= 812 {
                hightOfView = 44
            }
            else {
                hightOfView = 20
            }
            
            vwnav.frame = CGRect(x: 0, y: CGFloat(hightOfView), width: self.theController.navigationController?.navigationBar.frame.width ?? 320, height: 61)
            
            let myMutableString = NSMutableAttributedString()
            
            let dict = [NSAttributedString.Key.font: themeFont(size: 16, fontname: .ProximaNovaBold)]
            myMutableString.append(NSAttributedString(string: title, attributes: dict))
            vwnav.lblTitle.attributedText = myMutableString
            
            vwnav.lblTitle.textColor = .black
            
            vwnav.tag = 102
            vwnav.delegate = self
            
            self.theController.navigationController?.view.addSubview(vwnav)
            
        }
    }

}

//MARK: - API Calling
extension PhysicalActivityLevelViewModel {
    
    func getPhysicalActivityList() {
        let param = ["": ""] as [String : Any]
        print(JSON(param))
        
        ApiManager.shared.MakeGetAPI(name: ALL_PHYSICAL_ACTIVITY_LIST , params: param as [String : Any], progress: true, vc: self.theController, isAuth: false, completionHandler: { (response, error) in
            if response != nil {
                let json = JSON(response!)
                print(json)
                let success = json.getBool(key: .success)
                if success {
                    self.profileDetails = PhysicalActivityModelClass(JSON: json.dictionaryObject!)
                    let view = (self.theController.view as? PhysicalActivityLevelView)
                    view?.tblPhysicalActivity.reloadData()
                }
                else {
                    
                }
            }
        })
    }

}

//MARK: - navigation delegate
extension PhysicalActivityLevelViewModel: CustomNavigationWithSaveButtonDelegate{
    
    func CustomNavigationClose() {
        if self.isUpdated{
            self.delegateFinishActivityLevel?.selectedPhysicalActivity(id: self.selectedPhysicalActivityId)
        }
        
        self.theController.backButtonAction()
    }
    
    func CustomNavigationSave() {
        //Button Info tapped
        print("btn Info tapped")
        self.theController.moveToPhysicalActivityInfo()
        //        self.validateDetails()
    }
    
}
