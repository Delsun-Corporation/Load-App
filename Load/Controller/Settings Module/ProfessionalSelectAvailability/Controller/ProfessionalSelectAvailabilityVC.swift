//
//  ProfessionalSelectAvailabilityVC.swift
//  Load
//
//  Created by Haresh Bhai on 04/09/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class ProfessionalSelectAvailabilityVC: UIViewController {

    //MARK:- Variables
    lazy var mainView: ProfessionalSelectAvailabilityView = { [unowned self] in
        return self.view as! ProfessionalSelectAvailabilityView
    }()
    
    lazy var mainModelView: ProfessionalSelectAvailabilityViewModel = {
        return ProfessionalSelectAvailabilityViewModel(theController: self)
    }()
    
    var isKeyboardOpen = false
    var selectedAvailibility = ""  //set blank so in calendar show previous data as less alpha
    var selectedCustomDayName = [String]()
    
    //MARK:- ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainView.setupUI(theController: self)
        self.mainModelView.setupUI()
        self.mainModelView.createTimeRangePicketData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
                
        self.mainModelView.setupNavigationbar(title: getCommonString(key: "AVAILABILITY_key").capitalized)
        self.navigationController?.setWhiteColor()
        self.navigationController?.addShadow()
        
        setupKeyboard()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let viewWithTag = self.navigationController!.view.viewWithTag(102) {
            viewWithTag.removeFromSuperview()
        }
    }
    
    func setupKeyboard() {
        NotificationCenter.default.addObserver(self, selector:#selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }


}

//MARK:- IBAction method
extension ProfessionalSelectAvailabilityVC {
    
    @IBAction func btnPreviuosMonthTapped(_ sender: Any) {
        self.mainModelView.isReloaded = [false, false, false, false, false, false]
        self.mainModelView.currentShowMonth = self.mainModelView.currentShowMonth.getPreviousMonth()!
        self.mainModelView.setupUI()
    }
    
    @IBAction func btnNextMonthTapped(_ sender: UIButton) {
        self.mainModelView.isReloaded = [false, false, false, false, false, false]
        self.mainModelView.currentShowMonth = self.mainModelView.currentShowMonth.getNextMonth()!
        self.mainModelView.setupUI()
    }

}



extension ProfessionalSelectAvailabilityVC {
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        
        if let keyboardRectValue = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size
        {
            let keyboardHeight = keyboardRectValue.height
            
            print("keyBorad Height : \(keyboardHeight) ")
            
            UIView.animate(withDuration: 0.5, animations: {
                self.mainView.constraintTopOfTblCalendar.constant = -keyboardHeight
                   self.view.layoutIfNeeded()
                
            }, completion: nil)
        }

    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        UIView.animate(withDuration: 0.5, animations: {
            self.mainView.constraintTopOfTblCalendar.constant = 25.0
            self.view.layoutIfNeeded()
            
        }, completion: nil)

    }
    
}
