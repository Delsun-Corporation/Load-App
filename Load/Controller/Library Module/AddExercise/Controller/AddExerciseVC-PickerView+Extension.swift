//
//  AddExerciseVC-PickerView+Extension.swift
//  Load
//
//  Created by Haresh Bhai on 12/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

var selectedMotion: String = ""

extension AddExerciseVC: UIPickerViewDataSource, UIPickerViewDelegate {
    
    // MARK: UIPickerViewDelegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == self.mainModelView.partPickerView {
            return self.mainModelView.getCategory()?.count ?? 0
        }
//        else if pickerView == self.mainModelView.regionPickerView {
//            return GetAllData?.data?.bodySubParts?.count ?? 0
//        }
        else if pickerView == self.mainModelView.mechanicsPickerView {
            return GetAllData?.data?.mechanics?.count ?? 0
        }        
        else if pickerView == self.mainModelView.actionForcePickerView {
            return self.mainModelView.getActionForce(motion: selectedMotion)?.count ?? 0
        }
        else if pickerView == self.mainModelView.equipmentPickerView {
            return GetAllData?.data?.equipments?.count ?? 0
        } else if pickerView == self.mainModelView.motionPickerView {
            return 2
        } else if pickerView == self.mainModelView.movementPickerView {
            return 2
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let motionPickerValue = ["Static", "Dynamic"]
        let movementPickerValue = ["Bilateral", "Unilateral"]
        
//for view in pickerView.subviews{
//                view.backgroundColor = UIColor.clear
//            }        
        if pickerView == self.mainModelView.partPickerView {
            let activity = self.mainModelView.getCategory()?[row]
            let myView = PickerView.instanceFromNib() as! PickerView
            myView.setupUI()
            myView.imgIcon.image = nil
            myView.lblText.text = activity!.name?.capitalized
            return myView
        }
//        else if pickerView == self.mainModelView.regionPickerView {
//            let activity = GetAllData?.data?.bodySubParts![row]
//            let myView = PickerView.instanceFromNib() as! PickerView
//            myView.setupUI()
//            myView.imgIcon.image = nil
//            myView.lblText.text = activity!.name?.capitalized
//            return myView
//        }
        else if pickerView == self.mainModelView.mechanicsPickerView {
            let activity = GetAllData?.data?.mechanics![row]
            let myView = PickerView.instanceFromNib() as! PickerView
            myView.setupUI()
            myView.imgIcon.image = nil
            myView.lblText.text = activity!.name?.capitalized
            return myView
        }
        else if pickerView == self.mainModelView.actionForcePickerView {
            let activity = self.mainModelView.getActionForce(motion: selectedMotion)?[row]
            let myView = PickerView.instanceFromNib() as! PickerView
            myView.setupUI()
            myView.imgIcon.image = nil
            myView.lblText.text = activity?.name?.capitalized
            return myView
        }
        else if pickerView == self.mainModelView.equipmentPickerView {
            let activity = GetAllData?.data?.equipments![row]
            let myView = PickerView.instanceFromNib() as! PickerView
            myView.setupUI()
            myView.imgIcon.image = nil
            myView.lblText.text = activity!.name?.capitalized
            return myView
        }
        else if pickerView == self.mainModelView.motionPickerView {
            let activity = motionPickerValue[row]
            let myView = PickerView.instanceFromNib() as! PickerView
            myView.setupUI()
            myView.imgIcon.image = nil
            myView.lblText.text = activity.capitalized
            return myView
        } else if pickerView == self.mainModelView.movementPickerView {
            let activity = movementPickerValue[row]
            let myView = PickerView.instanceFromNib() as! PickerView
            myView.setupUI()
            myView.imgIcon.image = nil
            myView.lblText.text = activity.capitalized
            return myView
        }
        return UIView()
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let motionPickerValue = ["Static", "Dynamic"]
        let movementPickerValue = ["Bilateral", "Unilateral"]
        
        if pickerView == self.mainModelView.partPickerView {
            let activity = self.mainModelView.getCategory()?[row]
            self.mainView.txtCategory.text = activity?.name?.capitalized
            self.mainModelView.categoryId = (activity?.id?.stringValue)!
            self.mainModelView.selectedId = (activity?.id)!
            self.removeRegion()
        }
//        else if pickerView == self.mainModelView.regionPickerView {
//            let activity = GetAllData?.data?.bodySubParts![row]
//            self.mainView.txtRegion.text = activity?.name?.capitalized
//            self.mainModelView.subBodyPartId = (activity?.id?.stringValue)!
//            self.mainModelView.regionId = (activity?.parentId?.stringValue)!
//        }
        else if pickerView == self.mainModelView.mechanicsPickerView {
            let activity = GetAllData?.data?.mechanics![row]
            self.mainView.txtMechanics.text = activity?.name?.capitalized
            self.mainModelView.mechanicsId = (activity?.id?.stringValue)!
        }
        else if pickerView == self.mainModelView.actionForcePickerView {
            let activity = self.mainModelView.getActionForce(motion: selectedMotion)?[row]
            self.mainView.txtActionForce.text = activity?.name?.capitalized
            self.mainModelView.actionForceId = (activity?.id?.stringValue)!
        }
        else if pickerView == self.mainModelView.equipmentPickerView, let equipmentList = GetAllData?.data?.equipments,
            let equipmentId = equipmentList[row].id?.intValue
        {
            self.mainView.txtEquipment.text = equipmentList[row].name?.capitalized
            self.mainModelView.equipmentIds.removeAll()
            self.mainModelView.equipmentIds.append(equipmentId)
        }
        else if pickerView == self.mainModelView.motionPickerView {
            let activity = motionPickerValue[row]
            selectedMotion = activity
            
            let activityForces = self.mainModelView.getActionForce(motion: selectedMotion)
            if let activityForce = activityForces {
                self.mainView.txtActionForce.text = activityForce.first?.name?.capitalized
                self.mainModelView.actionForceId = (activityForce.first?.id?.stringValue) ?? "3"
            }
            
            self.mainModelView.actionForcePickerView.reloadAllComponents()
            self.mainView.txtMotion.text = selectedMotion.capitalized
        } else if pickerView == self.mainModelView.movementPickerView {
            let activity = movementPickerValue[row]
            self.mainView.txtMovement.text = activity.capitalized
        }
    }
    
    func removeRegion() {
        self.mainModelView.selectedArray = []
        self.mainModelView.selectedSubBodyPartIdArray = []
        self.mainModelView.selectedNameArray = []
        self.mainView.txtRegion.text = ""
        self.mainModelView.showImages()
    }
}

extension AddExerciseVC: MultiSelectionDelegate {

    func MultiSelectionDidFinish(selectedData: [MultiSelectionDataEntry]) {
        var data:[String] = [String]()
        var selectedTargetedMusclesId: [Int] = []
        
        for model in selectedData {
            guard let modelId = Int(model.id) else { return }
            data.append(model.title)
            selectedTargetedMusclesId.append(modelId)
        }
        self.mainView.txtTargetedMuscles.text = data.joined(separator: ", ")
        self.mainModelView.selectedTargetedMusclesId = selectedTargetedMusclesId
    }
    
    func dismissPopupScreen(){
        
    }
}
