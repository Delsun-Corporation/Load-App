//
//  LibraryExercisePreviewDetailsViewModel.swift
//  Load
//
//  Created by Haresh Bhai on 13/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import FirebaseAnalytics

class LibraryExercisePreviewDetailsViewModel {
   
    //MARK:- Variables
    fileprivate weak var theController:LibraryExercisePreviewDetailsVC!
    var list: LibraryLogList?
    var favoritelist: FavoriteList?
    var isLinkHide:Bool = false
    var isDefaultExercise = false
    
    init(theController:LibraryExercisePreviewDetailsVC) {
        self.theController = theController
    }
    
    func setupUI() {
        if self.isLinkHide {
            let view = (self.theController.view as? LibraryExercisePreviewDetailsView)
            view?.viewLinkHeight.constant = 0
            view?.viewLink.isHidden = true
        }
        
        if list != nil {
            self.showDetailsList()
        }
        else if favoritelist != nil {
            self.showDetailsFavoritelist()
        }
    }
    
    func showDetailsList() {
        print("⚠️", self.list?.equipmentIds)
        let view = (self.theController.view as? LibraryExercisePreviewDetailsView)
        view?.lblExercise.text = self.list?.exerciseName
        view?.lblMechanics.text = getMechanicsName(id: self.list?.mechanicsId ?? 0)
//        var array: [String] = []
//        for data in self.list?.targetedMusclesIds ?? [] {
//            array.append("\(data)")
//        }
        
        view?.lblTargetedMuscles.text = dataSetPerfectlyInLabel(text: getTargetedMusclesName(ids: self.list?.targetedMusclesIds ?? []))
        view?.lblActionForce.text = getActionForceName(id: self.list?.actionForceId ?? 0)
        view?.lblEquipment.text = getEquipmentsNames(ids: self.list?.equipmentIds ?? [])
        view?.lblMotion.text = self.list?.motion ?? "Static"
        view?.lblMovement.text = self.list?.movement ?? "Bilateral"
//        view?.lblLink.text =  ""
        
        view?.txtLink.text = self.list?.exerciseLink ?? ""

//        if !(self.list?.exerciseLink == nil || self.list?.exerciseLink == ""){
            self.theController.textViewDidChange(view?.txtLink ?? UITextView())
//        }
        let primaryIds = self.list?.regionsPrimarySelectionIds.compactMap { Int($0) } ?? []
        let secondaryIds = self.list?.regionsSecondarySelectionIds.compactMap { Int($0) } ?? []
       
        print("primaryIds:\(primaryIds)")
        print("secondaryIds:\(secondaryIds)")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            ApiManager.shared.showProgress(vc: self.theController)
            self.showImages(primaryIds: primaryIds.compactMap({ $0 }), secondaryIds: secondaryIds.compactMap({ $0 }))
        }
    }
    
    func showDetailsFavoritelist() {
        let view = (self.theController.view as? LibraryExercisePreviewDetailsView)
        view?.lblExercise.text = self.favoritelist?.exerciseName
        view?.lblMechanics.text = getMechanicsName(id: self.favoritelist?.mechanicsId ?? 0)
//        var array: [String] = []
//        for data in self.favoritelist?.targetedMusclesIds ?? [] {
//            array.append("\(data)")
//        }
        view?.lblTargetedMuscles.text = getTargetedMusclesName(ids: self.favoritelist?.targetedMusclesIds ?? [])
        view?.lblActionForce.text = getActionForceName(id: self.favoritelist?.actionForceId ?? 0)
        view?.lblEquipment.text = getEquipmentsNames(ids: self.favoritelist?.equipmentIds ?? [])
        
//        view?.txtLink.text = self.favoritelist?.exerciseLink ?? ""
        
//        view?.lblLink.text = ""
    }
    
    //Genereal Library (All Over)
    func showImages(primaryIds:[Int],secondaryIds: [Int]) {
        let view = (self.theController.view as? LibraryExercisePreviewDetailsView)
        for view in view?.viewImage.subviews ?? [] {
            view.removeFromSuperview()
        }
        
        let filter = GetAllData?.data?.regions?.filter({ (model) -> Bool in
            return primaryIds.contains(model.id?.intValue ?? 0)
        })
        
        for images in filter ?? [] {
            if images.image != "" {
                let imageView = UIImageView()
                imageView.contentMode = .scaleAspectFit
                imageView.frame = CGRect(x: 0, y: 0, width: (view?.viewImage.bounds.width ?? 0), height: (view?.viewImage.bounds.height ?? 0))
                view?.viewImage.addSubview(imageView)
                imageView.sd_setImage(with: images.image?.toURL(), completed: { (_,error,_,_) in
                    self.theController.stopAnimating()
                    if let error = error as? NSError {
                        print("⚠️", error.localizedDescription)
                        Analytics.logEvent("library_images_error", parameters: ["message": error.localizedDescription])
                    }
                })
            }
        }
        
        let filter2 = GetAllData?.data?.regions?.filter({ (model) -> Bool in
            return secondaryIds.contains(model.id?.intValue ?? 0)
        })
        
        for images in filter2 ?? [] {
            if images.image != "" {
                let imageView = UIImageView()
                imageView.contentMode = .scaleAspectFit
                imageView.frame = CGRect(x: 0, y: 0, width: (view?.viewImage.bounds.width ?? 0), height: (view?.viewImage.bounds.height ?? 0))
                view?.viewImage.addSubview(imageView)
                imageView.sd_setImage(with: images.secondaryImage?.toURL(), completed: nil)
            }
        }
    }

    //Custom library added region ids
    func showImages(regionIds:[Int]) {
        let view = (self.theController.view as? LibraryExercisePreviewDetailsView)
        for view in view?.viewImage.subviews ?? [] {
            view.removeFromSuperview()
        }
        
        let filter = GetAllData?.data?.regions?.filter({ (model) -> Bool in
            return regionIds.contains(model.id?.intValue ?? 0)
        })
        
        for images in filter ?? [] {
            if images.image != "" {
                let imageView = UIImageView()
                imageView.contentMode = .scaleAspectFit
                imageView.frame = CGRect(x: 0, y: 0, width: (view?.viewImage.bounds.width ?? 0), height: (view?.viewImage.bounds.height ?? 0))
                view?.viewImage.addSubview(imageView)
                if regionIds.first == images.id?.intValue {
                    imageView.sd_setImage(with: images.image?.toURL(), completed: nil)
                }
                else {
                    imageView.sd_setImage(with: images.secondaryImage?.toURL(), completed: nil)
                }
            }
        }
    }
    
    func dataSetPerfectlyInLabel(text:String) -> String{
        
        var customText = ""
        
        text.enumerated().forEach { (idx, character) in
            let prevChar = text[text.index(text.startIndex, offsetBy: max(0, idx-1))]
            if character == " " && prevChar != "," {
                customText.append("\u{00a0}")
            }
            else {
                customText.append(character)
            }
        }
        
        return customText

    }
    
    func apiCallCommonUpdateLibrary(txtData:String) {
        let param = [
            "common_libraries_id": self.list?.id ?? 0,
            "exercise_link" : txtData,
            ] as [String : Any]
        print(JSON(param))
        
        ApiManager.shared.MakePostAPI(name: CREATE_UPDATE_COMMON_LIBRARY_DETAILS, params: param as [String : Any], vc: self.theController, isAuth:false) { (response, error) in
            if response != nil {
                let json = JSON(response!)
                print(json)
                let success = json.getBool(key: .success)
                let message = json.getString(key: .message)
                
                if success {
                    
                }
                else {
                    makeToast(strMessage: message)
                }
            }
        }
    }

}
