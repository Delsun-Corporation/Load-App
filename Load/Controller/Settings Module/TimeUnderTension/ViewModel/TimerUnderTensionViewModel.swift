//
//  TimerUnderTensionViewModel.swift
//  Load
//
//  Created by iMac on 01/08/20.
//  Copyright © 2020 Haresh Bhai. All rights reserved.
//

import Foundation
import SwiftyJSON

class TimeUnderTensionViewModel{
    
    fileprivate weak var theController:TimerUnderTensionVc!

    init(theController:TimerUnderTensionVc) {
        self.theController = theController
    }
    
    var arrayTimeUnderTensionList = [TimeUnderTensionList]()
    
    //MARK:- SetupUI
    func setupUI(){
        self.apiCallForList()
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

//MARK: - navigation delegate
extension TimeUnderTensionViewModel: CustomNavigationWithSaveButtonDelegate{
    
    func CustomNavigationClose() {
        self.theController.backButtonAction()
    }
    
    func CustomNavigationSave() {
        self.theController.redirectToInfoScreen()
    }
    
}

//MARK:- API calling
extension TimeUnderTensionViewModel {
    
    func apiCallForList(isLoading:Bool = true) {
        
        ApiManager.shared.MakeGetAPIWithoutAuth(name: TIME_UNDER_TENSION_LIST_SETTING, params: [:], vc: self.theController) { (response, error) in
            if response != nil {
                let json = JSON(response!)
                print(json)
                let success = json.getBool(key: .success)
                if success {
                    
                    self.arrayTimeUnderTensionList = []
                    
                    let model = TimeUnderTensionModel(JSON: json.dictionaryObject!)
                    self.arrayTimeUnderTensionList = model?.data ?? []
                    if let view = self.theController.view as? TimeUnderTensionView{
                        view.tblTimeUnderTension.reloadData()
                    }
                }
                else {
                    self.arrayTimeUnderTensionList = []
                    if let view = self.theController.view as? TimeUnderTensionView{
                        view.tblTimeUnderTension.reloadData()
                    }
                }
            }
        }
    }
    
    func apiCallForUpdateDataList(index: Int, tensionId: String, tempo1: String, tempo2: String, tempo3: String, tempo4: String,isSelected:Int) {
        
        let param = ["time_under_tention_id": tensionId,
                     "tempo1" : tempo1,
                     "tempo2" : tempo2,
                     "tempo3" : tempo3,
                     "tempo4" : tempo4
                    ]
        
        ApiManager.shared.MakePostAPI(name: TIME_UNDER_TENSION_UPDATE_DATA_SETTING, params: param, progress: false, vc: self.theController, isAuth: false) { (response, error) in
            if response != nil {
                let json = JSON(response!)
                print(json)
                let success = json.getBool(key: .success)
                if success {
                    
                    let data = json.getDictionary(key: .data)

                    if let model = TimeUnderTensionList(JSON: data.dictionaryObject!){
                        self.arrayTimeUnderTensionList[index] = model
                        self.arrayTimeUnderTensionList[index].id = model.timeUnderTensionId
                        self.arrayTimeUnderTensionList[index].selectedIndex = isSelected
                    }
                    
                    if let view = self.theController.view as? TimeUnderTensionView{
                        view.tblTimeUnderTension.reloadData()
                    }
                }
                else {
                }
            }
        }
        
    }

}
