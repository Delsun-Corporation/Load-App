//
//  ResistanceConfirmationPageVc.swift
//  Load
//
//  Created by iMac on 12/02/21.
//  Copyright © 2021 Haresh Bhai. All rights reserved.
//

import UIKit

class ResistanceConfirmationPageVc: UIViewController  {

    //MARK:- Variables
    lazy var mainView: ResistanceConfirmationPageView = { [unowned self] in
        return self.view as! ResistanceConfirmationPageView
    }()
    
    lazy var mainModelView: ResistanceConfirmationPageViewModel = {
        return ResistanceConfirmationPageViewModel(theController: self)
    }()

    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainView.setupUI(theController: self)
        self.mainModelView.setupUI()
        
        mainView.txtTotalDuration.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)

    }

    override func viewWillAppear(_ animated: Bool) {
        self.mainModelView.setupNavigationbar(title: getCommonString(key: "Here's_what_you_just_completed!_key"))
        changeColorAccordingToClickable()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let viewWithTag = self.navigationController!.view.viewWithTag(1000) {
            viewWithTag.removeFromSuperview()
        }
    }

    //MARK: - IBAction method
    @IBAction func btnTotalDurationTapped(_ sender: UIButton) {
        self.mainView.txtTotalDuration.becomeFirstResponder()
    }
    
    @IBAction func btnAddClicked(_ sender: UIButton) {
        let obj: LibraryExerciseVC = AppStoryboard.Library.instance.instantiateViewController(withIdentifier: "LibraryExerciseVC") as! LibraryExerciseVC
        obj.mainModelView.delegate = self
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    @IBAction func btnNextTapped(_ sender: UIButton) {
        
        let exerciseArray: NSMutableArray = NSMutableArray()

        for model in self.mainModelView.exercisesMainArray {
            let exerciseSubArray: NSMutableArray = NSMutableArray()
            for modelValue in model.exercisesArray {
                let dict: NSDictionary = ["weight" : modelValue.weight ?? "",
                                          "rest" : modelValue.rest ?? "",
                                          "reps" : modelValue.reps ?? "",
                                          "duration" : modelValue.duration ?? ""]
                exerciseSubArray.add(dict)
            }
            
            let dict: NSDictionary = ["name": model.exerciseName ?? "", "data": exerciseSubArray, "library_id": model.userId == nil ? 0 : model.id ?? 0, "common_library_id": model.userId == nil ? model.id ?? 0 : 0, "exercise_link": model.exerciseLink ?? ""]
            
            exerciseArray.add(dict)
            
        }
        print(exerciseArray)

        let strColon = mainView.txtTotalDuration.text?.replacingOccurrences(of: "  ", with: ":") ?? ""
        self.mainModelView.apiCallForSaveUpdatedData(totalDuration: strColon, exercise: exerciseArray)
        
    }
    
    //Other function
    
    func redirectToRPEScreen(){
        let obj = AppStoryboard.Calendar.instance.instantiateViewController(withIdentifier: "RPESelectionVc") as! RPESelectionVc
        obj.mainModelView.delegateDismissRPESelection = self
        obj.mainModelView.controllerMoveFrom = .trainingLog
        obj.mainModelView.trainingLogId = self.mainModelView.trainingLogId
        let nav = UINavigationController(rootViewController: obj)
        nav.modalPresentationStyle = .overCurrentContext
        self.present(nav, animated: true, completion: nil)
    }
}


//MARK: - Dismiss Delegate

extension ResistanceConfirmationPageVc: delegateDismissRPESelection{
    func dismissdelegateDismissRPESelection() {
        self.mainModelView.delegateConfirmation?.dismissConfirmationPage()
    }
}

//MARK: - TextField delegate

extension ResistanceConfirmationPageVc: UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == mainView.txtTotalDuration {
            
            let charsLimit = 10

            let startingLength = textField.text?.count ?? 0
            let lengthToAdd = string.count
            let lengthToReplace =  range.length
            let newLength = startingLength + lengthToAdd - lengthToReplace

            return newLength <= charsLimit

        }
        
        return true
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        
        if textField == self.mainView.txtTotalDuration{
            let str = mainView.txtTotalDuration.text!
            
            if mainView.txtTotalDuration.text?.count == 3{
                if mainView.txtTotalDuration.text?.last == " "{
                    
                }else{
                    let position = 1
                    let subStr = str.prefix(upTo: str.index(str.startIndex, offsetBy: position)) + str.suffix(from: str.index(str.startIndex, offsetBy: (position + 1)))
                    self.mainView.txtTotalDuration.text = String(subStr)
                }
            }
            
            if mainView.txtTotalDuration.text?.count == 7{
                if mainView.txtTotalDuration.text?.last == " "{
                    
                }else{
                    let position = 5
                    let subStr = str.prefix(upTo: str.index(str.startIndex, offsetBy: position)) + str.suffix(from: str.index(str.startIndex, offsetBy: (position + 1)))
                    self.mainView.txtTotalDuration.text = String(subStr)
                }
            }
            
            if mainView.txtTotalDuration.text?.count ?? 0 < 3{
                mainView.txtTotalDuration.text = mainView.txtTotalDuration.text?.trimmingCharacters(in: .whitespacesAndNewlines)
                mainView.txtTotalDuration.text! += "  "
            }
            else if (mainView.txtTotalDuration.text?.count ?? 0 < 7) && (mainView.txtTotalDuration.text?.count ?? 0 > 3){
                mainView.txtTotalDuration.text = mainView.txtTotalDuration.text?.trimmingCharacters(in: .whitespacesAndNewlines)
                mainView.txtTotalDuration.text! += "  "
            }
            
            if mainView.txtTotalDuration.text?.count == 3{
                mainView.txtTotalDuration.text = mainView.txtTotalDuration.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            }else if mainView.txtTotalDuration.text?.count == 7{
                mainView.txtTotalDuration.text = mainView.txtTotalDuration.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            }
            
        }
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
            
        if textField == mainView.txtTotalDuration{
            
            let strColon = mainView.txtTotalDuration.text?.replacingOccurrences(of: "  ", with: ":")
            print("text:\(strColon)")

            if strColon?.count ?? 0 < 8{
                makeToast(strMessage: getCommonString(key: "Please_enter_total_duration_key"))
                return false
            }
            
            if let textFiedlText = strColon?.contains(":"){
                let dataArray = strColon?.split(separator: ":")
                print("dataArray count : \(dataArray?.count)")

                if dataArray?.count == 3{
                    print("dataArray 3 count 0: \(dataArray?[0])")
                    print("dataArray 3 count 1: \(dataArray?[1])")
                    print("dataArray 3 count 2: \(dataArray?[2])")

                    if Int(String(dataArray?[1] ?? "")) ?? 0 > 59{
                        makeToast(strMessage: "Please enter valid minutes")
                        return false
                    }else if Int(String(dataArray?[2] ?? "")) ?? 0 > 59{
                        makeToast(strMessage: "Please enter valid seconds")
                        return false
                    }

                }
            }else{
                return false
            }

//            self.mainModelView.apiCallGetAndUpdateData(isForUpdate: true, txtTotalDuration: strColon ?? "", txtTotalDistance: "", txtAvgSpeed: "", txtAvgPace: "", progress: false)
        }

        self.changeColorAccordingToClickable()

        return true
    }

}
//MARK: - Validation clickable or not

extension ResistanceConfirmationPageVc{
    
    func checkLogItClickableOrNot() -> Bool{

        let strColon = mainView.txtTotalDuration.text?.replacingOccurrences(of: "  ", with: ":")
        
        if strColon?.count ?? 0 < 8{
            return false
        }
        else if self.mainView.txtTotalDuration.text == "" {
            return false
        }
        else if self.mainView.txtTotalDuration.text?.toTrim() == "00  00  00".toTrim(){
            return false
        }
        else if self.mainModelView.exercisesMainArray.count == 0{
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
            mainView.btnNext.backgroundColor = UIColor.appthemeOffRedColor
            mainView.btnNext.isUserInteractionEnabled = true
        }else{
            mainView.btnNext.backgroundColor = UIColor.appthemeGrayColor
            mainView.btnNext.isUserInteractionEnabled = false
        }
    }
    
}

//MARK: - ScrollView Delegate

extension ResistanceConfirmationPageVc: UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentSize.height+75 <= mainView.safeAreaHeight{
            return
        }
        
        if self.mainView.scrollView.panGestureRecognizer.translation(in: scrollView).y > 0{
            
            UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                
                self.mainView.vwNext.alpha = 0.0
                self.mainView.vwNext.isUserInteractionEnabled = false

                self.mainView.layoutIfNeeded()

            }, completion: nil)
            
        }
        else{
            
            if (scrollView.contentOffset.y > 0 && scrollView.contentOffset.y < (scrollView.contentSize.height - scrollView.frame.size.height)){
                print("middle")
            }else{
                
                if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)) {
                    scrollEndMethod()
                }
            }
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        scrollEndMethod()
    }
    
    func scrollEndMethod(){
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
             
            self.mainView.vwNext.alpha = 1.0
            self.mainView.vwNext.isUserInteractionEnabled = true

            self.mainView.layoutIfNeeded()
        }, completion: nil)

    }
    
    func buttonVisibleOrNot(){
        if (mainView.scrollView.contentOffset.y + mainView.safeAreaHeight - 75) >= mainView.scrollView.contentSize.height{
            self.mainView.vwNext.alpha = 1.0
            self.mainView.vwNext.isUserInteractionEnabled = true
        }else{
            self.mainView.vwNext.alpha = 0.0
            self.mainView.vwNext.isUserInteractionEnabled = false
        }
    }
    
}
