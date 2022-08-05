//
//  HeartRateViewModel.swift
//  Load
//
//  Created by iMac on 30/07/20.
//  Copyright © 2020 Haresh Bhai. All rights reserved.
//

import Foundation

protocol HeartRateDelegate: AnyObject {
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

}

//MARK: - HR related data

extension HeartRateViewModel{
    
    func getHRList() -> [String] {
        return [ (getUserDetail()?.data?.user?.dateOfBirth ?? "") == "" ? "" : self.getHRMax(date: getUserDetail()?.data?.user?.dateOfBirth ?? ""), "Customize"]
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
