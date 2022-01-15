//
//  CreateRequestStepOneViewModel.swift
//  Load
//
//  Created by Haresh Bhai on 22/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class CreateRequestStepOneViewModel: CustomNavigationDelegate {

    //MARK:- Variables
    fileprivate weak var theController:CreateRequestStepOneVC!
    var selectedDateStartTraining:Date?
    
    var editRequestData : RequestData?
    var isEdit : Bool = false
    
    init(theController:CreateRequestStepOneVC) {
        self.theController = theController
    }
    
    //MARK:- Functions
    func setupUI() {
        
        if isEdit{
            self.setData()
        }
        
        self.DOBSetup()

    }
    
    func setData(){
        if let vw = theController.view as? CreateRequestStepOneView{
            vw.txtTitle.text = self.editRequestData?.title
            vw.txtStartTraining.text = convertDateFormater(self.editRequestData!.startDate, dateFormat: "MM/dd/yyyy")
            vw.txtDescription.text = self.editRequestData?.yourself
            
            let convertToString = convertDateFormater(self.editRequestData?.startDate ?? "", dateFormat: "MM/dd/yyyy")
            self.selectedDateStartTraining = convertDate(convertToString, dateFormat: "MM/dd/yyyy")
            print("selectedDateStartTraining:\(self.selectedDateStartTraining)")
        }
    }
    
    func DOBSetup() {
        let view = (theController.view as? CreateRequestStepOneView)
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePicker.Mode.date
        
        if #available(iOS 13.4, *) {
            datePickerView.preferredDatePickerStyle = .wheels
            //datePickerView.setValue(UIColor.clear, forKey: "magnifierLineColor")
            datePickerView.setValue(false, forKey: "highlightsToday")
        }
        datePickerView.backgroundColor = UIColor.white

        datePickerView.setValue(UIColor.appthemeOffRedColor, forKeyPath: "textColor")
        view?.txtStartTraining.inputView = datePickerView
        
        
        if isEdit{
            datePickerView.setDate(selectedDateStartTraining ?? Date(), animated: false)
        }else{
            datePickerView.setDate(Date(), animated: false)
        }

        datePickerView.addTarget(self, action: #selector(datePickerValueChanged), for: UIControl.Event.valueChanged)        
    }
    
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        let view = (theController.view as? CreateRequestStepOneView)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateFormatter.dateFormat = "MM/dd/yyyy"
        view?.txtStartTraining.text = dateFormatter.string(from: sender.date)
        self.selectedDateStartTraining = sender.date
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
            
            let dict = [NSAttributedString.Key.font: themeFont(size: 20, fontname: .HelveticaBold)]
            myMutableString.append(NSAttributedString(string: title, attributes: dict))
            vwnav.lblTitle.attributedText = myMutableString
            
            vwnav.tag = 1000
            vwnav.delegate = self
            self.theController.navigationController?.view.addSubview(vwnav)
        }        
    }
    
    func CustomNavigationClose() {
        self.theController.dismiss(animated: true, completion: nil)
    }
    
    func validateDetails() {
        let view = (self.theController.view as? CreateRequestStepOneView)
        if view?.txtTitle.text?.toTrim() == "" {
            makeToast(strMessage: getCommonString(key: "Please_enter_title_key"))
        }
        else if self.selectedDateStartTraining == nil {
            makeToast(strMessage: getCommonString(key: "Please_select_training_date_key"))
        }        
        else if view?.txtDescription.text?.toTrim() == "" {
            makeToast(strMessage: getCommonString(key: "Please_enter_about_key"))
        }
        else {
            let obj: CreateRequestStepTwoVC = AppStoryboard.LoadCenter.instance.instantiateViewController(withIdentifier: "CreateRequestStepTwoVC") as! CreateRequestStepTwoVC
            obj.mainModelView.isEdit = self.isEdit
            obj.mainModelView.editRequestData = self.editRequestData
            obj.mainModelView.selectedDateStartTraining = self.selectedDateStartTraining
            obj.mainModelView.requestTitle = (view?.txtTitle.text?.toTrim())!
            obj.mainModelView.requestDescription = (view?.txtDescription.text?.toTrim())!
            self.theController.navigationController?.pushViewController(obj, animated: true)
        }
    }
}
