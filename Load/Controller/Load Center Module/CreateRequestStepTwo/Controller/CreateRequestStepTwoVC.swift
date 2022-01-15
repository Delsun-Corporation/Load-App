//
//  CreateRequestStepTwoVC.swift
//  Load
//
//  Created by Haresh Bhai on 24/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class CreateRequestStepTwoVC: UIViewController, TypesOfTrainingSelectedDelegate, FilterSpecializationSelectedDelegate {
    
    //MARK:- Variables
    lazy var mainView: CreateRequestStepTwoView = { [unowned self] in
        return self.view as! CreateRequestStepTwoView
        }()
    
    lazy var mainModelView: CreateRequestStepTwoViewModel = {
        return CreateRequestStepTwoViewModel(theController: self)
    }()
    
    //MARK:- ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let viewWithTag = self.navigationController!.view.viewWithTag(1000) {
            viewWithTag.removeFromSuperview()
        }
        self.navigationController?.setWhiteColor()
        self.mainView.setupUI(theController: self)
        self.mainModelView.setupUI()
        // Do any additional setup after loading the view.
    }
    
    //MARK:- @IBAction
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSpecializationClicked(_ sender: Any) {
        self.view.endEditing(true)
        
        let obj: FilterSpecializationVC = AppStoryboard.LoadCenter.instance.instantiateViewController(withIdentifier: "FilterSpecializationVC") as! FilterSpecializationVC
        obj.mainModelView.delegate = self
        obj.mainModelView.isHideheader = true
        obj.mainModelView.selectedArray = self.mainModelView.selectedArraySpecialization
        obj.mainModelView.selectedNameArray = self.mainModelView.selectedNameArraySpecialization
        let nav = UINavigationController(rootViewController: obj)
        nav.modalPresentationStyle = .overFullScreen
        present(nav, animated: true, completion: nil)
    }
    
    @IBAction func btnCoachExperienceClicked(_ sender: Any) {
        if self.mainView.txtCoachExperience.text?.toTrim() == "" {
            let activity = coachExperienceArray().first ?? ""
            self.mainView.txtCoachExperience.text = activity + " years"
            self.mainModelView.coachExperience = activity
        }
        self.mainView.txtCoachExperience.becomeFirstResponder()
    }
    
    @IBAction func btnTypesOfTrainingClicked(_ sender: Any) {
        self.view.endEditing(true)
        let obj: TypesOfTrainingSelectionVC = AppStoryboard.LoadCenter.instance.instantiateViewController(withIdentifier: "TypesOfTrainingSelectionVC") as! TypesOfTrainingSelectionVC
        obj.mainModelView.delegate = self
        obj.mainModelView.selectedArray = self.mainModelView.selectedArray
        obj.mainModelView.selectedNameArray = self.mainModelView.selectedNameArray
        let nav = UINavigationController(rootViewController: obj)
        nav.modalPresentationStyle = .overFullScreen
        present(nav, animated: true, completion: nil)
        
//        var dataEntry: [MultiSelectionDataEntry] = [MultiSelectionDataEntry]()
//        for data in (GetAllData?.data?.trainingTypes)! {
//            let isSelected = self.mainModelView.typesOfTraining.contains((data.id?.stringValue)!)
//            dataEntry.append(MultiSelectionDataEntry(id: (data.id?.stringValue)!, title: data.name!, isSelected: isSelected))
//        }
//        let obj = MultiSelectionVC(nibName: "MultiSelectionVC", bundle: nil)
//        obj.mainModelView.delegate = self
//        obj.mainModelView.data = dataEntry
//        obj.mainModelView.title = getCommonString(key: "Types_of_training_key")
//        obj.modalPresentationStyle = .overCurrentContext
//        self.present(obj, animated: false, completion: nil)
    }
    
    func TypesOfTrainingSelectedDidFinish(ids: [Int], names: [String]) {
        self.mainModelView.selectedArray = ids
        self.mainModelView.selectedNameArray = names
        let formattedNameString = (names.map{String($0)}).joined(separator: ", ")
        self.mainView.txtTypesOfTraining.text = formattedNameString
    }
    
    func FilterSpecializationSelectedDidFinish(ids: [Int], names: [String]) {
        self.mainModelView.selectedArraySpecialization = ids
        self.mainModelView.selectedNameArraySpecialization = names
        let formattedNameString = (names.map{String($0)}).joined(separator: ", ")
        self.mainView.txtSpecialization.text = formattedNameString
    }
    
    @IBAction func btnLocationClicked(_ sender: Any) {
        if self.mainView.txtLocation.text?.toTrim() == "" {
            let activity = GetAllData?.data?.countries?.first
            self.mainView.txtLocation.text = activity?.name?.capitalized
            self.mainModelView.location = (activity?.id?.stringValue)!
        }
        self.mainView.txtLocation.becomeFirstResponder()
    }
    
    @IBAction func btnMarathonClicked(_ sender: Any) {
        self.mainModelView.changeSportType(isMarathone: true)
    }
    
    @IBAction func btnUltraMarathonClicked(_ sender: Any) {
        self.mainModelView.changeSportType(isMarathone: false)
    }
    
    @IBAction func btnNextClicked(_ sender: Any) {
        self.mainModelView.validateDetails()
    }
    
//    func MultiSelectionDidFinish(selectedData: [MultiSelectionDataEntry]) {
//        var data:[String] = [String]()
//        var selectedTargetedMusclesId: [String] = [String]()
//        
//        for model in selectedData {
//            data.append(model.title)
//            selectedTargetedMusclesId.append(model.id)
//        }
//        self.mainView.txtTypesOfTraining.text = data.joined(separator: " / ")
//        self.mainModelView.typesOfTraining = selectedTargetedMusclesId
//    }    
}
