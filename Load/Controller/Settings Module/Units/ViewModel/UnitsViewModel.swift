//
//  UnitsViewModel.swift
//  Load
//
//  Created by iMac on 23/01/20.
//  Copyright © 2020 Haresh Bhai. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol UnitstDelegate: AnyObject {
    func UnitsFinish(id:Int, title:String)
}

class UnitsViewModel {
    
    //MARK:- Variables
    fileprivate weak var theController:UnitsVC!
    var selectedId:Int = 0
    var selectedTitle:String = ""
    weak var delegate:UnitstDelegate?
    var profileDetails: UnitsModelClass?
    var isUpdated:Bool = false

    //MARK:- Functions
    init(theController:UnitsVC) {
        self.theController = theController
    }
    
    func setupUI() {
        self.getUnitsList()
    }
    
    func setupNavigationbar(title:String) {
        
        self.theController.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        self.theController.navigationItem.hidesBackButton = true
        
        if let vwnav = ViewNavMedium.instanceFromNib() as? ViewNavMedium {
            
            vwnav.imgBackground.isHidden = true
            vwnav.btnback.isHidden = false
            vwnav.btnSave.isHidden = true
            vwnav.btnSave.isHidden = true
            
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
    
    func getUnitsList() {
        let param = ["": ""] as [String : Any]
        print(JSON(param))
        
        ApiManager.shared.MakeGetAPI(name: ALL_TRAINING_UNITS_LIST , params: param as [String : Any], progress: true, vc: self.theController, isAuth: false, completionHandler: { (response, error) in
            if response != nil {
                let json = JSON(response!)
                print(json)
                let success = json.getBool(key: .success)
                if success {
                    self.profileDetails = UnitsModelClass(JSON: json.dictionaryObject!)
                    let view = (self.theController.view as? UnitsView)
                    view?.tableView.reloadData()
                }
                else {
                    
                }
            }
        })
    }
}

//MARK: - navigation delegate
extension UnitsViewModel: CustomNavigationWithSaveButtonDelegate{
    
    func CustomNavigationClose() {
        self.theController.navigationController?.popViewController(animated: true)
        if self.theController.mainModelView.isUpdated {
            self.delegate?.UnitsFinish(id: self.selectedId, title: self.selectedTitle)
        }
    }
    
    func CustomNavigationSave() {
        //        self.validateDetails()
    }
    
}
