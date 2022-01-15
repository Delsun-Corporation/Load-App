//
//  HeartRateViewModel.swift
//  Load
//
//  Created by iMac on 30/07/20.
//  Copyright © 2020 Haresh Bhai. All rights reserved.
//

import Foundation

protocol HeartRateDelegate: class {
    func HeartRateFinish(HRMaxValue:String, HRRestValue:String,isHrMaxIsEstimated:Bool)
}

class HeartRateViewModel{
    
    fileprivate weak var theController:HeartRateVc!

    init(theController:HeartRateVc) {
        self.theController = theController
    }
    
    //MARK: - Variable
    var targatHRMax = ""
    var targatHRRest = ""
    var isHrMaxIsEstimated = true
    let targatHRMaxPickerView = UIPickerView()
    weak var delegate:HeartRateDelegate?

    var selectedIndex = 0

    //MARK: - SetupUI
    
    func setupUI(){
        
        if let view = (self.theController.view as? HeartRateView){
            
            targatHRMaxPickerView.delegate = theController
            
            if #available(iOS 13.4, *) {
                targatHRMaxPickerView.setValue(UIColor.clear, forKey: "magnifierLineColor")
            }
            
            targatHRMaxPickerView.backgroundColor = UIColor.white
            view.txtHRMaxValue.inputView = targatHRMaxPickerView
            
            view.txtHRMaxValue.text = self.targatHRMax
            view.txtHRRestValue.text = self.targatHRRest
            
//            self.targatHRMax = (getUserDetail().data?.user?.dateOfBirth ?? "") == "" ? "" : self.getHRMax(date: getUserDetail().data?.user?.dateOfBirth ?? "")
        }
    }
    
    func setupNavigationbar(title:String) {
        
        self.theController.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        self.theController.navigationItem.hidesBackButton = true
        
        if let vwnav = ViewNavMedium.instanceFromNib() as? ViewNavMedium {
            
            vwnav.imgBackground.isHidden = true
            vwnav.btnback.isHidden = false
            vwnav.btnSave.isHidden = true
//            vwnav.btnSave.isHidden = self.theController.btnSave.isHidden

            var hightOfView = 0
            if UIScreen.main.bounds.height >= 812 {
                hightOfView = 44
            }
            else {
                hightOfView = 20
            }
            
            vwnav.frame = CGRect(x: 0, y: CGFloat(hightOfView), width: self.theController.navigationController?.navigationBar.frame.width ?? 320, height: vwnav.frame.height)
            
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

//MARK: - HR related data

extension HeartRateViewModel{
    
    func getHRList() -> [String] {
        return [ (getUserDetail().data?.user?.dateOfBirth ?? "") == "" ? "" : self.getHRMax(date: getUserDetail().data?.user?.dateOfBirth ?? ""), "Customize"]
    }

    func getHRMax(date:String) -> String {
        let now = Date().toString(dateFormat: "yyyy")
        let birthday: String = convertDateFormater(date, format: "dd-MM-yyyy", dateFormat: "yyyy")
        let age = Int(now)! - Int(birthday)!
        //        let calendar = Calendar.current
        //        let ageComponents = calendar.dateComponents([.year], from: birthday, to: now)
        //        let age = ageComponents.year!
        let value = Int(206.9 - (0.67 * Double(age)))
        return "\(value)".replace(target: ".00", withString: "")
    }
    
}


//MARK: - navigation delegate
extension HeartRateViewModel: CustomNavigationWithSaveButtonDelegate{
    
    func CustomNavigationClose() {
        self.theController.btnCloseClicked()
    }
    
    func CustomNavigationSave() {
//        self.saveDetails()
    }

}
