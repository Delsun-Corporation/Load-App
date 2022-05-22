//
//  SelectTrainingProgramViewModel.swift
//  Load
//
//  Created by Haresh Bhai on 14/09/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

protocol dismissSelectTrainingProgramDelegate {
    func dismissSelectTrainingProgram()
}

class SelectTrainingProgramViewModel: CustomNavigationDelegate {
    
    //MARK:- Variables
    fileprivate weak var theController:SelectTrainingProgramVC!
    var isResistance:Bool = true
    var navTitle:String = ""
    
    var delegateDismiss: dismissSelectTrainingProgramDelegate?
    
    //MARK:- Functions
    init(theController:SelectTrainingProgramVC) {
        self.theController = theController
    }
    
    func setupUI() {
        apiCallForGetProgramDetails()
    }
    
    func setupNavigationbar(title:String) {
        self.theController.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        self.theController.navigationController?.setColor()
        self.theController.navigationItem.hidesBackButton = true
        
        if let vwnav = ViewNav.instanceFromNib() as? ViewNav {
            
            var hightOfView = 0
            if UIScreen.main.bounds.height >= 812 {
                hightOfView = 44
            }
            else {
                hightOfView = 20
            }
            
            vwnav.frame = CGRect(x: 0, y: 0, width: self.theController.navigationController?.navigationBar.frame.width ?? 320, height: vwnav.frame.height + CGFloat(hightOfView))
            
            let myMutableString = NSMutableAttributedString()
            
            let dict = [NSAttributedString.Key.font: themeFont(size: 20, fontname: .ProximaNovaBold)]
            myMutableString.append(NSAttributedString(string: title, attributes: dict))
            vwnav.lblTitle.attributedText = myMutableString
            
            vwnav.tag = 1000
            vwnav.delegate = self
            self.theController.navigationController?.view.addSubview(vwnav)
        }
    }
    
    func CustomNavigationClose() {
        self.delegateDismiss?.dismissSelectTrainingProgram()
        self.theController.dismiss(animated: true, completion: nil)
    }
}

//MARK: - API Calling

extension SelectTrainingProgramViewModel{
        
    func apiCallForGetProgramDetails() {
    
        let param = ["user_id": getUserDetail()?.data?.user?.id] as [String : Any]
        
        print(JSON(param))
        
        ApiManager.shared.MakePostAPI(name: TRAINING_PROGRAM_FLAGS, params: param as [String : Any],progress: false, vc: self.theController, isAuth:false) { (response, error) in
            
            if response != nil {
                let json = JSON(response!)
                print(json)
                
                let success = json.getBool(key: .success)
                if success {
                    let model = CheckTrainingProgramModel(JSON: json.dictionaryObject!)
                    self.theController.setupData(data: model?.data)
                }
                else {
                    let message = json.getString(key: .message)
                    makeToast(strMessage: message)
                }
            }
        }
        
    }

}
