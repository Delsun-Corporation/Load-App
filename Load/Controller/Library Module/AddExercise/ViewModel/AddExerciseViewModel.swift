//
//  AddExerciseViewModel.swift
//  Load
//
//  Created by Haresh Bhai on 12/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireSwiftyJSON
import SwiftyJSON

class AddExerciseViewModel {
    
    // MARK: Variables
    fileprivate weak var theController:AddExerciseVC!
    let regionPickerView = UIPickerView()
    let partPickerView = UIPickerView()
    let mechanicsPickerView = UIPickerView()
    let actionForcePickerView = UIPickerView()
    let equipmentPickerView = UIPickerView()
    
    let motionPickerView = UIPickerView()
    let movementPickerView = UIPickerView()

    var regionId: String = ""
    var categoryId: String = ""
    var subBodyPartId: String = ""
    var mechanicsId: String = ""
    var actionForceId: String = ""
    var equipmentIds: [Int] = []
    var selectedTargetedMusclesId: [Int] = []
    var isEdit:Bool = false
    var libraryId:String = ""
    var libraryPreviewModel: LibraryLogList?
    var selectedArray:[Int] = [Int]()
    var selectedSubBodyPartIdArray:[Int] = [Int]()
    var selectedNameArray:[String] = [String]()
    var selectedId:NSNumber?

    var selectedEquipmentArray:[Int] = [Int]()
    var selectedEquipmentNameArray:[String] = [String]()
    
    init(theController:AddExerciseVC) {
        self.theController = theController
    }
    
    // MARK: Functions
    func setupUI() {
        let view = (self.theController.view as? AddExerciseView)
        
        partPickerView.delegate = theController
        partPickerView.backgroundColor = UIColor.white
        view?.txtCategory.inputView = partPickerView
        
        mechanicsPickerView.delegate = theController
        mechanicsPickerView.backgroundColor = UIColor.white
        view?.txtMechanics.inputView = mechanicsPickerView
                
        actionForcePickerView.delegate = theController
        actionForcePickerView.backgroundColor = UIColor.white
        view?.txtActionForce.inputView = actionForcePickerView
        
        equipmentPickerView.delegate = theController
        equipmentPickerView.backgroundColor = UIColor.white
        view?.txtEquipment.inputView = equipmentPickerView
        
        motionPickerView.delegate = theController
        motionPickerView.backgroundColor = UIColor.white
        view?.txtMotion.inputView = motionPickerView

        movementPickerView.delegate = theController
        movementPickerView.backgroundColor = UIColor.white
        view?.txtMovement.inputView = movementPickerView
        
        if isEdit {
            self.showEditDetails()
        }
    }
    
    func showEditDetails() {
        guard let view = (self.theController.view as? AddExerciseView), let model = self.libraryPreviewModel else { return }
        view.txtExercise.text = model.exerciseName
        view.txtRegion.text = getRegionNames(ids: model.regionsIds ?? [] )
        
        //MARK: - TODO: - Yash changes
        self.selectedNameArray = view.txtRegion.text?.components(separatedBy: ", ") ?? []
        print("selectedNameArray : \(self.selectedNameArray)")
        
        view.txtCategory.text = getCategoryName(id: model.categoryId ?? 0)
        view.txtMechanics.text = getMechanicsName(id: model.mechanicsId ?? 0)
        view.txtMotion.text = model.motion
        view.txtMovement.text = model.movement
        
        var array: [String] = []
        for data in model.targetedMusclesIds ?? [] {
            array.append("\(data)")
        }
        
        view.txtTargetedMuscles.text = getTargetedMusclesName(ids: model.targetedMusclesIds ?? [])
        view.txtActionForce.text = getActionForceName(id: model.actionForceId ?? 0)
        view.txtEquipment.text = getEquipmentsNames(ids: model.equipmentIds ?? [])
        view.txtLink.text = model.exerciseLink ?? ""

        self.categoryId = model.categoryId?.stringValue ?? ""
        self.selectedId = model.categoryId ?? 0
        var arrayReg: [Int] = []
        
        if let regionIds = model.regionsIds {
            for data in regionIds {
                arrayReg.append(Int(data) ?? 0)
            }
        }
        
        self.selectedArray = arrayReg
//        self.regionId = model.regionsIds
        // self.subBodyPartId = model.bodySubPartId?.stringValue ?? ""
        self.mechanicsId = model.mechanicsId?.stringValue ?? ""
        self.selectedTargetedMusclesId = model.targetedMusclesIds?.compactMap { Int($0) } ?? []
        self.actionForceId = model.actionForceId?.stringValue ?? ""
        self.equipmentIds = model.equipmentIds?.compactMap { Int($0) } ?? []
        
        for data in self.equipmentIds {
            self.selectedEquipmentArray.append(Int(data) )
        }

        if !(model.exerciseLink == nil || model.exerciseLink == ""){
            self.theController.textViewDidChange(view.txtLink ?? UITextView())
        }
        
        self.theController.changeColorAccordingToClickable()
    
    }
    
    func ValidateDetails() {
        let view = (self.theController.view as? AddExerciseView)
        if view?.txtExercise.text?.toTrim() == "" {
            makeToast(strMessage: getCommonString(key: "Please_enter_exercise_key"))
        }
        else if view?.txtCategory.text?.toTrim() == "" {
            makeToast(strMessage: getCommonString(key: "Please_select_category_key"))
        }
        else if view?.txtRegion.text?.toTrim() == "" {
            makeToast(strMessage: getCommonString(key: "Please_select_region_key"))
        }
//        else if view?.txtMechanics.text?.toTrim() == "" {
//            makeToast(strMessage: getCommonString(key: "Please_select_mechanics_key"))
//        }
//        else if view?.txtTargetedMuscles.text?.toTrim() == "" {
//            makeToast(strMessage: getCommonString(key: "Please_select_targeted_muscles_key"))
//        }
//        else if view?.txtActionForce.text?.toTrim() == "" {
//            makeToast(strMessage: getCommonString(key: "Please_select_action_/_force_key"))
//        }
//        else if view?.txtEquipment.text?.toTrim() == "" {
//            makeToast(strMessage: getCommonString(key: "Please_select_equipment_key"))
//        }
        
        else if view?.txtLink.text?.toTrim() != "" {
            
            if !(view?.btnLinkEnableDisable.isSelected ?? false){
                view?.txtLink.text = ""
            }
            
            moveToAddExerciseFininshVC()
        }
        else {
            moveToAddExerciseFininshVC()
        }
    }
    
    func moveToAddExerciseFininshVC(){
        let view = (self.theController.view as? AddExerciseView)
        let obj: AddExerciseFinishVC = AppStoryboard.Library.instance.instantiateViewController(withIdentifier: "AddExerciseFinishVC") as! AddExerciseFinishVC
        obj.mainModelView.delegate = self.theController
        obj.mainModelView.txtExercise = view?.txtExercise.text?.toTrim() ?? ""
        obj.mainModelView.regionIds = self.selectedArray
        obj.mainModelView.categoryId = self.categoryId
        obj.mainModelView.subBodyPartId = self.subBodyPartId
        obj.mainModelView.mechanicsId = self.mechanicsId
        obj.mainModelView.selectedTargetedMusclesId = self.selectedTargetedMusclesId
        obj.mainModelView.targetedMuscle = view?.txtTargetedMuscles.text?.toTrim() ?? ""
        obj.mainModelView.actionForceId = self.actionForceId
        obj.mainModelView.equipmentIds = self.equipmentIds
        obj.mainModelView.isEdit = self.isEdit
        obj.mainModelView.libraryId = self.libraryId
        obj.mainModelView.exerciseLink = view?.txtLink.text?.toTrim() ?? ""
        obj.mainModelView.libraryPreviewModel = self.libraryPreviewModel
        obj.mainModelView.motion = view?.txtMotion.text ?? ""
        obj.mainModelView.movement = view?.txtMovement.text ?? ""
        self.theController.navigationController?.pushViewController(obj, animated: true)
    }

    
    func getCategory() -> [Category]? {
        let data = GetAllData?.data?.getSortedCategory().filter({ (model) -> Bool in
            return model.name?.lowercased() != "Favorite".lowercased()
        })
        return data
    }
    
    func getActionForce(motion: String) -> [ActionForce]? {
        if (motion == "") {
            let data = GetAllData?.data?.actionForce?.filter({ (model) -> Bool in
                return true
            })
            return data
        }
        else if (motion == "Static") {
            let data = GetAllData?.data?.actionForce?.filter({ (model) -> Bool in
                return model.name?.lowercased() == "hold"
            })
            return data
        }
        else {
            let data = GetAllData?.data?.actionForce?.filter({ (model) -> Bool in
                return model.name?.lowercased() != "hold"
            })
            return data
        }
    }
    
    func showImages() {
        let view = (self.theController.view as? AddExerciseView)
        for view in view?.viewImage.subviews ?? [] {
            view.removeFromSuperview()
        }
        
        let filter = GetAllData?.data?.regions?.filter({ (model) -> Bool in
            return self.selectedArray.contains(model.id?.intValue ?? 0)
        })
        
        for images in filter ?? [] {
            if images.image != "" {
                let imageView = UIImageView()
                imageView.contentMode = .scaleAspectFit
                imageView.frame = CGRect(x: 0, y: 0, width: (view?.viewImage.bounds.width ?? 0), height: (view?.viewImage.bounds.height ?? 0))
                view?.viewImage.addSubview(imageView)
                if self.selectedArray.first == images.id?.intValue {
                    imageView.sd_setImage(with: images.image?.toURL(), completed: nil)
                }
                else {
                    imageView.sd_setImage(with: images.secondaryImage?.toURL(), completed: nil)
                }
            }
        }
    }

}
