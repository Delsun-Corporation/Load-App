//
//  ResistanceTrainingLogVC.swift
//  Load
//
//  Created by Haresh Bhai on 04/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import SwiftyJSON
import IQKeyboardManagerSwift

class ResistanceTrainingLogVC: UIViewController, NewMessageSelectDelegate, UITextFieldDelegate {

    //MARK:- Variables
    lazy var mainView: ResistanceTrainingLogView = { [unowned self] in
        return self.view as! ResistanceTrainingLogView
    }()
    
    lazy var mainModelView: ResistanceTrainingLogViewModel = {
        return ResistanceTrainingLogViewModel(theController: self)
    }()
    
    var scrollCurrentOffset = CGFloat()
    
    //MARK:- ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainView.setupUI()
        self.mainView.mainScrollView.delegate = self
        self.mainModelView.setupUI()
        setDelegate()
    }

    func setDelegate(){
        [self.mainView.txtWhen,self.mainView.txtName,self.mainView.txtIntensity,self.mainView.txtTrainingGoal].forEach { (txt) in
            txt?.delegate = self
        }
        
    }
    
    //MARK:- @IBAction
    @IBAction func btnTrainingGoalClicked(_ sender: Any) {
        if self.mainModelView.intensityId == "" {
            return
        }
        if self.mainView.txtTrainingGoal.text == "" && self.mainModelView.trainingGoalId == "" {
            let activity = self.mainModelView.getTrainingGoal().first
            self.mainView.txtTrainingGoal.text = activity?.name?.capitalized
            self.mainModelView.trainingGoalId = (activity?.id?.stringValue)!
            self.mainModelView.getValicationFromId()
//            self.mainModelView.exercisesMainArray.removeAll()
//            self.mainView.tableViewHeight.constant = 0
            for (index, data) in self.mainModelView.exercisesMainArray.enumerated() {
                for (indexSub, _) in data.exercisesArray.enumerated() {
                    self.mainModelView.exercisesMainArray[index].exercisesArray[indexSub].weight = ""
                    self.mainModelView.exercisesMainArray[index].exercisesArray[indexSub].reps = ""
                    self.mainModelView.exercisesMainArray[index].exercisesArray[indexSub].rest = ""
                }
            }
            self.mainView.tableView.reloadData()
        }
        
        for (index, data) in self.mainModelView.getTrainingGoal().enumerated() {
            if Int(self.mainModelView.trainingGoalId) ?? 0 == data.id?.intValue {
                self.mainModelView.trainingGoalPickerView.selectRow(index, inComponent: 0, animated: false)
            }
        }
        self.mainView.txtTrainingGoal.becomeFirstResponder()
    }
    
    @IBAction func btnWhenClicked(_ sender: Any) {
        self.mainView.txtWhen.becomeFirstResponder()
    }
    
    @IBAction func btnIntensityClicked(_ sender: Any) {
        if self.mainView.txtIntensity.text == "" {
            let activity = GetAllData?.data?.trainingIntensity?.first
            self.mainView.txtIntensity.text = activity?.name?.capitalized
            self.mainModelView.intensityId = (activity?.id?.stringValue) ?? ""
            
//            self.mainModelView.exercisesMainArray.removeAll()
//            self.mainView.tableViewHeight.constant = 0
            for (index, data) in self.mainModelView.exercisesMainArray.enumerated() {
                for (indexSub, _) in data.exercisesArray.enumerated() {
                    self.mainModelView.exercisesMainArray[index].exercisesArray[indexSub].weight = ""
                    self.mainModelView.exercisesMainArray[index].exercisesArray[indexSub].reps = ""
                    self.mainModelView.exercisesMainArray[index].exercisesArray[indexSub].rest = ""
                }
            }
            self.mainView.tableView.reloadData()
        }
        self.mainView.txtIntensity.becomeFirstResponder()
    }
    
    @IBAction func btnLogItClicked(_ sender: Any) {
        if self.mainModelView.isEdit {
            self.mainModelView.ValidateDetails()
        }
        else {
            if self.mainModelView.trainingId != "" {
                self.mainModelView.apiCallSaveIsLogFlag()
            }
            else {
                self.mainModelView.ValidateDetails()
            }
        }
    }
    
    @IBAction func btnAddClicked(_ sender: Any) {
        
        if self.mainModelView.intensityId == "" {
            makeToast(strMessage: getCommonString(key: "Please_select_intensity_key"))
        }
        else if self.mainView.txtTrainingGoal.text?.toTrim() == "" {
            makeToast(strMessage: getCommonString(key: "Please_select_training_goal_key"))
        }
        else {
            let obj: LibraryExerciseVC = AppStoryboard.Library.instance.instantiateViewController(withIdentifier: "LibraryExerciseVC") as! LibraryExerciseVC
            obj.mainModelView.delegate = self
            self.navigationController?.pushViewController(obj, animated: true)
        }
    }
    
    @IBAction func btnSendCustomTrainingGoalClicked(_ sender: Any) {
        self.mainView.txtTrainingGoal.text = self.mainView.txtCustomTrainingGoal.text?.toTrim()
        self.mainView.txtCustomTrainingGoal.text = ""
        self.mainModelView.showCustomTrainingGoal(isShow: false)
        //TODO: - Yash Changes // add below line
        self.mainView.txtCustomTrainingGoal.resignFirstResponder()
        self.mainView.mainScrollView.contentOffset.y  = 0
    }

    
    @IBAction func btnSaveAsTempleteClicked(_ sender: Any) {
        self.view.endEditing(true)
        self.mainModelView.ValidateDetails(isSavedWorkout: true)
    }
    
    @IBAction func btnSendToFriendClicked(_ sender: Any) {
        self.view.endEditing(true)
        if !self.mainModelView.ValidateDetailsForShare() {
            return
        }
        
        let obj: NewMessageSelectVC
            = AppStoryboard.Messages.instance.instantiateViewController(withIdentifier: "NewMessageSelectVC") as! NewMessageSelectVC
        obj.mainModelView.delegate = self
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    func NewMessageSelectDidFinish(name: String, id: String) {
        self.mainModelView.shareFriend(toId: id)
    }
    
    //MARK: - Check button clickable or not
    func checkLogItClickableOrNot() -> Bool{

        if self.mainView.txtWhen.text == "" {
            return false
        }
        else if self.mainView.txtName.text == "" {
            return false
        }
        else if self.mainView.txtIntensity.text == "" {
            return false
        }
        else if self.mainView.txtTrainingGoal.text == "" {
            return false
        }
        else if self.mainModelView.exercisesMainArray.count == 0 {
            return false
        }
        else {
            for (index, model) in self.mainModelView.exercisesMainArray.enumerated() {
                for modelValue in model.exercisesArray {
                    if modelValue.weight == "" || modelValue.weight == nil {
                        return false
                    }
                    else if (modelValue.reps == "" || modelValue.reps == nil) && (modelValue.duration == "" || modelValue.duration == nil){
                        if self.mainModelView.isSelectedDuration[index] {
                            return false
                        }
                        else {
                            return false
                        }
                    }
                    else if modelValue.rest == "" || modelValue.rest == nil {
                        return false
                    }
                }
            }
        
        }
        
        return true
    }
   
    func changeColorAccordingToClickable(){
        if checkLogItClickableOrNot(){
            mainView.btnLogIt.backgroundColor = UIColor.appthemeOffRedColor
            mainView.btnLogIt.isUserInteractionEnabled = true
            
            [self.mainView.btnSaveAsTemplete,self.mainView.btnSendToFriend].forEach { (btn) in
                btn?.borderColor = UIColor.appthemeOffRedColor
                btn?.borderWidth = 1
                btn?.setTitleColor(UIColor.appthemeOffRedColor, for: .normal)
                btn?.isUserInteractionEnabled = true
            }
            
        }else{
            mainView.btnLogIt.backgroundColor = UIColor.appthemeGrayColor
            mainView.btnLogIt.isUserInteractionEnabled = false
            
            [self.mainView.btnSaveAsTemplete,self.mainView.btnSendToFriend].forEach { (btn) in
                btn?.borderColor = UIColor.appthemeBlackColor
                btn?.borderWidth = 1
                btn?.setTitleColor(UIColor.appthemeBlackColor, for: .normal)
                btn?.isUserInteractionEnabled = false
            }
        }
    }

    //MARK: - TextField delegate
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        IQKeyboardManager.shared.enableAutoToolbar = true
        
        if textField == mainView.txtTrainingGoal{
            self.mainView.heightCustomTrainingGoal.constant = 0
            self.mainView.viewCustomTrainingGoal.isHidden = true
            self.mainModelView.trainingGoalPickerView.reloadAllComponents()
        }
        
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField == self.mainView.txtTrainingGoal {
            self.mainModelView.setTrainingGoal(isSet: true)
        }
        
        self.mainView.tableView.reloadData()
        
        changeColorAccordingToClickable()
        return true
    }
    
}

//MARK: - ScrollView delegate

extension ResistanceTrainingLogVC : UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        scrollCurrentOffset = scrollView.contentOffset.y
        
//        if isKeyboardOpen == true {
//            return
//        }
        
        if scrollView.contentSize.height <= mainView.safeAreaHeight {
            return
        }
        
        if self.mainView.mainScrollView.panGestureRecognizer.translation(in: scrollView).y > 0{
            
            if scrollView.contentOffset.y <= (scrollView.contentSize.height - scrollView.frame.size.height){
//                print("Up")
//                print("scrollView.contentOffset.y :\(scrollView.contentOffset.y)")
//                print("scrollView.height :\(scrollView.frame.size.height)")
//
//                print("Final : \(scrollView.contentOffset.y - scrollView.frame.size.height)")

                let checkHeight = (scrollView.contentOffset.y + scrollView.frame.size.height) - scrollView.contentSize.height
                
                
//                if checkHeight <= -150{
//                    UIView.animate(withDuration: 0.2) {
//                        self.mainView.constraintBottomVwMainBottom.constant = -80
//                        self.mainView.layoutIfNeeded()
//                    }
//                }else{
//                    UIView.animate(withDuration: 0.2) {
//                        self.mainView.constraintBottomVwMainBottom.constant = 0
//                        self.mainView.layoutIfNeeded()
//                    }
//                }
                
                //Old setup
                /*
                if checkHeight <= -65{
                    
                    UIView.animate(withDuration: 0.2, animations: {
                        self.mainView.constraintBottomVwMainBottom.constant = -150
                        self.mainView.layoutIfNeeded()

                    }) { (status) in
                        [self.mainView.vwSendToFriend,self.mainView.vwSaveAsTemplate].forEach { (vw) in
                            vw?.isHidden = true
                        }
                    }
*/
                
                if checkHeight <= -80{
                    
                    UIView.animate(withDuration: 0.2, animations: {
                        self.mainView.constraintBottomVwMainBottom.constant = -80
                        self.mainView.layoutIfNeeded()

                    }) { (status) in
                        [self.mainView.vwSendToFriend,self.mainView.vwSaveAsTemplate].forEach { (vw) in
                            vw?.isHidden = true
                        }
                    }
                    
                }else{
                    
                    UIView.animate(withDuration: 0.2, animations: {
                        self.mainView.constraintBottomVwMainBottom.constant = 0
                        self.mainView.layoutIfNeeded()
                        
                    }) { (status) in
                        
                        UIView.animate(withDuration: 0.1, delay: 0.4, options: .curveEaseInOut, animations: {
                        }) { (status) in
                            
                            if checkHeight >= (-60){
                                [self.mainView.vwSendToFriend,self.mainView.vwSaveAsTemplate].forEach { (vw) in
                                    vw?.isHidden = false
                                }
                            }
                        }
                    }
                    
                }
                
//                checkHeight-> 50 ---> 1(alpha)
//                     checkHeight ---> (?)
                
                if checkHeight >= -63{
                    self.mainView.vwSendToFriend.alpha = 1 - (((-checkHeight) * 1)/50)
                    self.mainView.vwSaveAsTemplate.alpha = 1 - (((-checkHeight) * 1)/50)
                }else{
                    self.mainView.vwSendToFriend.alpha = 0
                    self.mainView.vwSaveAsTemplate.alpha = 0
                }
            }
        }
        else{
            
            if (scrollView.contentOffset.y > 0 && scrollView.contentOffset.y < (scrollView.contentSize.height - scrollView.frame.size.height) - 80){
            }else{
                
                if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height) - 80) {
                    scrollEndMethod()
                }
            }
        }
    }
    
    func scrollEndMethod(){
        
        if (self.mainView.mainScrollView.contentOffset.y >= (self.mainView.mainScrollView.contentSize.height - self.mainView.mainScrollView.frame.size.height) - 80){
            
//            UIView.animate(withDuration: 0.2) {
//                self.mainView.constraintBottomVwMainBottom.constant = 0
//                self.mainView.layoutIfNeeded()
//            }
            
            UIView.animate(withDuration: 0.2, animations: {
                self.mainView.constraintBottomVwMainBottom.constant = 0
                self.mainView.layoutIfNeeded()
                
            }) { (status) in
                
                UIView.animate(withDuration: 0.1, delay: 0.4, options: .curveEaseInOut, animations: {
                }) { (status) in

//                    [self.mainView.vwSendToFriend,self.mainView.vwSaveAsTemplate].forEach { (vw) in
//                        makeToast(strMessage: "DOWN DOWN DOWN")
//                        print("DOWN DOWN DONW")
//                        vw?.isHidden = false
//                    }
                }
            }
            
            let checkHeight = (self.mainView.mainScrollView.contentOffset.y + self.mainView.mainScrollView.frame.size.height) - self.mainView.mainScrollView.contentSize.height
            
            if checkHeight < -80{
                
                UIView.animate(withDuration: 0.2, animations: {
                    
                }) { (status) in
                    [self.mainView.vwSendToFriend,self.mainView.vwSaveAsTemplate].forEach { (vw) in
                        vw?.isHidden = true
                    }
                }
                
            }else{
                
                if checkHeight >= (-65){
                    [self.mainView.vwSendToFriend,self.mainView.vwSaveAsTemplate].forEach { (vw) in
                        vw?.isHidden = false
                    }
                }
            }
            
//                     checkHeight-> 50 ---> 1(alpha)
//                     checkHeight ---> (?)

            if checkHeight >= -63{
                self.mainView.vwSendToFriend.alpha = 1 - (((-checkHeight) * 1)/50)/1
                self.mainView.vwSaveAsTemplate.alpha = 1 - (((-checkHeight) * 1)/50)/1
            }else{
                self.mainView.vwSendToFriend.alpha = 0
                self.mainView.vwSaveAsTemplate.alpha = 0
            }
        }
        
    }
    
}
