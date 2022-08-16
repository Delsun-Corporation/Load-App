//
//  AddExerciseVC.swift
//  Load
//
//  Created by Haresh Bhai on 12/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import AVKit
import XCDYouTubeKit

class AddExerciseVC: UIViewController, BackToScreenDelegate, RegionSelectionSelectedDelegate, EquipmenSelectedDelegate {
        
    //MARK:- Variables
    lazy var mainView: AddExerciseView = { [unowned self] in
        return self.view as! AddExerciseView
        }()
    
    lazy var mainModelView: AddExerciseViewModel = {
        return AddExerciseViewModel(theController: self)
    }()
    
    //MARK:- ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainView.setupUI(theController: self)
        changeColorAccordingToClickable()
        self.mainModelView.setupUI()
        
        DispatchQueue.main.async {
            self.mainModelView.showImages()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setColor()
        
        if self.mainModelView.isEdit == false{
            setUpNavigationBarTitle(strTitle: getCommonString(key: "Add_Exercise_key"))
        }else{
            setUpNavigationBarTitle(strTitle: getCommonString(key: "Edit_Exercise_key"))
        }
        
    }
    
    //MARK:- @IBAction
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnRegionClicked(_ sender: Any) {
        if self.mainModelView.selectedId == nil {
            makeToast(strMessage: getCommonString(key: "Please_select_category_key"))
            return
        }
        self.view.endEditing(true)
        
        let obj: RegionSelectionMainVc = AppStoryboard.Library.instance.instantiateViewController(withIdentifier: "RegionSelectionMainVc") as! RegionSelectionMainVc
        obj.strTitle = self.mainView.txtCategory.text ?? ""
        obj.mainModelView.isHeaderHide = true
        obj.mainModelView.delegate = self
        obj.mainModelView.selectedId = self.mainModelView.selectedId
        
        obj.mainModelView.selectedArray = self.mainModelView.selectedArray
        obj.mainModelView.selectedSubBodyPartIdArray = self.mainModelView.selectedSubBodyPartIdArray
        obj.mainModelView.selectedNameArray = self.mainModelView.selectedNameArray

        let nav = UINavigationController(rootViewController: obj)
        nav.modalPresentationStyle = .overFullScreen
        present(nav, animated: true, completion: nil)
        
        //TODO: - Yash changes
        /*
        let obj: RegionSelectionVC = AppStoryboard.Library.instance.instantiateViewController(withIdentifier: "RegionSelectionVC") as! RegionSelectionVC
        obj.mainModelView.isHeaderHide = true
        obj.mainModelView.delegate = self
        obj.mainModelView.selectedId = self.mainModelView.selectedId
        obj.mainModelView.selectedArray = self.mainModelView.selectedArray
        obj.mainModelView.selectedSubBodyPartIdArray = self.mainModelView.selectedSubBodyPartIdArray
        
        print("Name array : \(self.mainModelView.selectedNameArray)")
        
        obj.mainModelView.selectedNameArray = self.mainModelView.selectedNameArray
        let nav = UINavigationController(rootViewController: obj)
        nav.modalPresentationStyle = .overFullScreen
        present(nav, animated: true, completion: nil)*/
    }
    
    @IBAction func btnPartClicked(_ sender: Any) {
        if self.mainView.txtCategory.text?.toTrim() == "" {
            let activity = self.mainModelView.getCategory()?.first
            self.mainView.txtCategory.text = activity?.name?.capitalized
            self.mainModelView.categoryId = activity?.id?.stringValue ?? ""
            self.mainModelView.selectedId = activity?.id ?? 0
        }
        self.mainView.txtCategory.becomeFirstResponder()
    }
    
    @IBAction func btnMechanicsClicked(_ sender: Any) {
        if self.mainView.txtMechanics.text?.toTrim() == "" {
            let activity = GetAllData?.data?.mechanics?.first
            self.mainView.txtMechanics.text = activity?.name?.capitalized
            self.mainModelView.mechanicsId = activity?.id?.stringValue ?? ""
        }
        self.mainView.txtMechanics.becomeFirstResponder()
    }
    
    @IBAction func btnTargetedMusclesClicked(_ sender: Any) {
        var dataEntry: [MultiSelectionDataEntry] = [MultiSelectionDataEntry]()
        guard let targetedMusclesArray = GetAllData?.data?.targetedMuscles else { return }
        
        for data in targetedMusclesArray {
            let isSelected = self.mainModelView.selectedTargetedMusclesId.contains((data.id) as! Int)
            dataEntry.append(MultiSelectionDataEntry(id: (data.id?.stringValue)!, title: data.name!, isSelected: isSelected))
        }
        let obj = AppStoryboard.Library.instance.instantiateViewController(withIdentifier: "MultiSelectionVC") as! MultiSelectionVC
        obj.mainModelView.delegate = self
        obj.mainModelView.data = dataEntry
        obj.mainModelView.title = getCommonString(key: "Targeted_Muscles_key")
        
        let nav = UINavigationController(rootViewController: obj)
        nav.modalPresentationStyle = .overFullScreen
        self.navigationController?.present(nav, animated: true, completion: nil)
    }
    
    @IBAction func btnActionForceClicked(_ sender: Any) {
        if self.mainView.txtActionForce.text?.toTrim() == "" {
            let activity = self.mainModelView.getActionForce(motion: mainView.txtMotion.text ?? "")?.first
            self.mainView.txtActionForce.text = activity?.name?.capitalized
            self.mainModelView.actionForceId = activity?.id?.stringValue ?? ""
        }
        self.mainView.txtActionForce.becomeFirstResponder()
    }
    
    @IBAction func btnEquipmentClicked(_ sender: Any) {
//        if self.mainView.txtEquipment.text?.toTrim() == "" {
//            let activity = GetAllData?.data?.equipments?.first
//            self.mainView.txtEquipment.text = activity?.name?.capitalized
//            self.mainModelView.equipmentIds.removeAll()
//            self.mainModelView.equipmentIds.append(activity?.id?.stringValue ?? "")
//        }
//        self.mainView.txtEquipment.becomeFirstResponder()
        
        let obj: EquipmentSelectionVC = AppStoryboard.Library.instance.instantiateViewController(withIdentifier: "EquipmentSelectionVC") as! EquipmentSelectionVC
        obj.mainModelView.delegate = self
        obj.mainModelView.selectedArray = self.mainModelView.selectedEquipmentArray
        obj.mainModelView.selectedNameArray = self.mainModelView.selectedEquipmentNameArray
        let nav = UINavigationController(rootViewController: obj)
        nav.modalPresentationStyle = .overFullScreen
        present(nav, animated: true, completion: nil)
    }
    
    @IBAction func btnNextClicked(_ sender: Any) {
        self.mainModelView.ValidateDetails()
    }
    
    @IBAction func btnLinkTapped(_ sender: UIButton) {
        
        if sender.isSelected == true{
            
            let videoUrl = self.mainView.txtLink.text.toTrim()
            
            if videoUrl.contains("vimeo"){
                
                let vimeoId = self.getVimeoVideoString(strStreamingURL: videoUrl)

                let obj = AppStoryboard.Library.instance.instantiateViewController(withIdentifier: "LoadVimeoVideoVc") as! LoadVimeoVideoVc
                obj.vimeoId = vimeoId
                obj.modalPresentationStyle = .fullScreen
                self.present(obj, animated: true, completion: nil)
                
            }else{
                self.youtubeVideoPlay()
            }
        }
    }
    
    @IBAction func btnMovementTapped(_ sender: UIButton) {
        
        if self.mainView.txtMovement.text?.toTrim() == "" {
            let activity = "Bilateral"
            self.mainView.txtMovement.text = activity.capitalized
        }

        self.mainView.txtMovement.becomeFirstResponder()
    }
    
    @IBAction func btnMotionTapped(_ sender: UIButton) {
        
        if self.mainView.txtMotion.text?.toTrim() == "" {
            let activity = "Static"
            self.mainView.txtMotion.text = activity.capitalized
        }

        self.mainView.txtMotion.becomeFirstResponder()
    }
    
    //MARK: - Other function
    
    func youtubeVideoPlay(){
        
        let weakPlayerViewController =  AVPlayerViewController()
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
        } catch(let error) {
            print(error.localizedDescription)
        }

        let youtubeId = self.mainView.txtLink.text.toTrim().youtubeID ?? ""
        self.showLoader()
        
        XCDYouTubeClient.default().getVideoWithIdentifier(youtubeId) { [weak self] (video, error) in
            
            self?.hideLoader()
            
            if video != nil {
                let streamURLs = video?.streamURLs
                let streamURL = streamURLs?[XCDYouTubeVideoQualityHTTPLiveStreaming] ?? streamURLs?[NSNumber(value: XCDYouTubeVideoQuality.HD720.rawValue)] ?? streamURLs?[NSNumber(value: XCDYouTubeVideoQuality.medium360.rawValue)] ?? streamURLs?[NSNumber(value: XCDYouTubeVideoQuality.small240.rawValue)]
                if let streamURL = streamURL {
                    weakPlayerViewController.player = AVPlayer(url: streamURL)
                }
                
                self?.present(weakPlayerViewController, animated: true) {
                    weakPlayerViewController.player?.play()
                }
            }
        }
    }

    
    func checkNextClickableOrNot() -> Bool{
        
        if mainView.txtExercise.text?.toTrim() == ""{
            return false
        }
            
        if mainView.txtCategory.text?.toTrim() == ""{
            return false
        }
        
        if mainView.txtRegion.text?.toTrim() == ""{
            return false
        }
        
//        if mainView.txtLink.text?.toTrim() != ""{
//            
//            if !(self.mainView.btnLinkEnableDisable.isSelected){
//                return false
//            }else{
//                return true
//            }
//        }
        
        return true
    }
    
    func changeColorAccordingToClickable(){
        if checkNextClickableOrNot(){
            mainView.btnNext.backgroundColor = UIColor.appthemeRedColor
            mainView.btnNext.isUserInteractionEnabled = true
            
        }else{
            mainView.btnNext.backgroundColor = UIColor.appthemeGrayColor
            mainView.btnNext.isUserInteractionEnabled = false
        }
    }
    
    func BackToScreenDidFinish() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func RegionSelectionSelectedDidFinish(ids: [Int], subIds: [Int], names: [String], currentIndex: Int) {
        print("name : \(names)")
        
        self.mainModelView.selectedArray = ids
        self.mainModelView.selectedSubBodyPartIdArray = subIds
        self.mainModelView.selectedNameArray = names
        let formattedNameString = (names.map{String($0)}).joined(separator: ", ")
        self.mainView.txtRegion.text = formattedNameString
        self.mainModelView.showImages()
        
        self.changeColorAccordingToClickable()
    }

    func EquipmenSelectedDidFinish(ids: [Int], names: [String]) {
        self.mainModelView.selectedEquipmentArray = ids
        self.mainModelView.selectedEquipmentNameArray = names
        self.mainModelView.equipmentIds.removeAll()
        for data in ids {
            self.mainModelView.equipmentIds.append(data)
        }
        let formattedNameString = (names.map{String($0)}).joined(separator: ", ")
        self.mainView.txtEquipment.text = formattedNameString
    }
}

//MARK: - UITextView delegate

extension AddExerciseVC: UITextViewDelegate{
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        self.mainView.txtLink.placeholder = ""
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if textView.text.toTrim() == ""{
            self.mainView.txtLink.placeholder = getCommonString(key: "Provide_the_exercise_URL_link_key")
            self.mainView.txtLink.text = ""
        }
        return true
    }

    func textViewDidChange(_ textView: UITextView) {
        
        print("trim:\(textView.text.toTrim())")
        print("trim:\(textView.text.count)")
        
        if textView.text.toTrim() != "" && textView.text.count > 18{
            
            if textView.text.lowercased().contains("youtube".lowercased()){
                
                if textView.text.count > 31{
                    print("check youtube url")
                    
                    self.checkYouTubeURLWithAPI(urlString: textView.text.toTrim()){ [weak self] json in
                        
                        if json == nil{
                            self?.mainView.btnLinkEnableDisable.isSelected = false
                        }else{
                            self?.mainView.btnLinkEnableDisable.isSelected = true
                        }
                        
                        self?.changeColorAccordingToClickable()
                    }
                
                }else{
                    self.mainView.btnLinkEnableDisable.isSelected = false
                }
                
            }else if textView.text.lowercased().contains("vimeo".lowercased()){
                
                if textView.text.count > 18{
                    print("check vimeo url")
                    self.checkVimeoURLWithAPI(urlString: textView.text.toTrim()){ [weak self] json in
                        
                        if json == nil{
                            self?.mainView.btnLinkEnableDisable.isSelected = false
                        }else{
                            self?.mainView.btnLinkEnableDisable.isSelected = true
                        }
                        
                        self?.changeColorAccordingToClickable()
                    }
                }
                
            }else{
               // makeToast(strMessage: getCommonString(key: "Please_input_links_from_Youtube_or_Vimeo_key"))
            }
        }else{
            self.mainView.btnLinkEnableDisable.isSelected = false
        
        }
        self.changeColorAccordingToClickable()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if !self.mainView.btnLinkEnableDisable.isSelected{
            makeToast(strMessage: getCommonString(key: "Please_input_links_from_Youtube_or_Vimeo_key"))
        }
    }
}

//MARK: - ScrollView Delegate

extension AddExerciseVC : UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentSize.height - 71 <= mainView.safeAreaHeight{
            return
        }
        
        if self.mainView.scrollView.panGestureRecognizer.translation(in: scrollView).y > 0{
            UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                
                [self.mainView.vwNext].forEach { (vw) in
                    vw?.alpha = 0.0
                }
                
                self.mainView.vwNext.isUserInteractionEnabled = false
                self.mainView.layoutIfNeeded()

            }, completion: nil)
            
        }
        else{
            
            if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)) {
                scrollEndMethod()
            }
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        scrollEndMethod()
    }
    
    func scrollEndMethod(){
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            
            [self.mainView.vwNext].forEach { (vw) in
                vw?.alpha = 1.0
            }
            
            self.mainView.vwNext.isUserInteractionEnabled = true
            self.mainView.layoutIfNeeded()
        }, completion: nil)

    }
    
}

//MARK: - TextField delegate

extension AddExerciseVC: UITextFieldDelegate{
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        self.changeColorAccordingToClickable()
        return true
    }
    
}
