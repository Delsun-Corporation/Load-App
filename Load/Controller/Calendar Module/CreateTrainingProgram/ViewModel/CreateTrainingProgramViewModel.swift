//
//  CreateTrainingProgramViewModel.swift
//  Load
//
//  Created by Haresh Bhai on 14/09/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import SwiftyJSON
import AlamofireSwiftyJSON
import Alamofire

protocol dismissTrainingProgramDelegate {
    func dismissReloadTrainigProgram()
    func onlyDismissTrainingProgram()
}

class CreateTrainingProgramViewModel: CustomNavigationDelegate {

    //MARK:- Variables
    fileprivate weak var theController:CreateTrainingProgramVC!
    
    var dataCheckVisibility: checkTrainngProgramVisibilityData?
    
    var delegateTrainingProgram: dismissTrainingProgramDelegate?
    
    //MARK:- Functions
    init(theController:CreateTrainingProgramVC) {
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
        self.delegateTrainingProgram?.dismissReloadTrainigProgram()
        self.theController.dismiss(animated: true, completion: nil)
    }
}

//MARK: - API calling

extension CreateTrainingProgramViewModel{
    
    func apiCallForGetProgramDetails() {
    
        let param = ["user_id": getUserDetail().data?.user?.id] as [String : Any]
        
        print(JSON(param))
        
        ApiManager.shared.MakePostAPI(name: TRAINING_PROGRAM_FLAGS, params: param as [String : Any], vc: self.theController, isAuth:false) { (response, error) in
            
            if response != nil {
                let json = JSON(response!)
                print(json)
                
                let success = json.getBool(key: .success)
                if success {
                    
                    self.theController.hideAllView()
                    let model = CheckTrainingProgramModel(JSON: json.dictionaryObject!)
                    self.dataCheckVisibility = model?.data
                    self.theController.setupData()
                }
                else {
                    let message = json.getString(key: .message)
                    makeToast(strMessage: message)
                }
            }
        }
        
    }
    
    func apiCallForDeleteProgram(programId:Int) {
    
        let param = ["training_program_id": programId] as [String : Any]
        
        print(JSON(param))
        
        ApiManager.shared.MakePostAPI(name: DELETE_TRAINING_PROGRAMS, params: param as [String : Any], vc: self.theController, isAuth:false) { (response, error) in
            
            if response != nil {
                let json = JSON(response!)
                print(json)
                
                let success = json.getBool(key: .success)
                if success {
                    
                    self.apiCallForGetProgramDetails()
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATION_CENTER_LIST.CALENDAR_RELOADING.rawValue), object: nil)
                    
                }
                else {
                    let message = json.getString(key: .message)
                    makeToast(strMessage: message)
                }
            }
        }
    }
    
}
