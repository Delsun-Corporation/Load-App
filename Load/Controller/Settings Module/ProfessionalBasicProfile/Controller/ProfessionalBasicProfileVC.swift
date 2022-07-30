//
//  ProfessionalBasicProfileVC.swift
//  Load
//
//  Created by Haresh Bhai on 02/09/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import CoreLocation

protocol ProfessionalBasicProfileDelegate: class {
    func ProfessionalBasicProfileFinish(Profession:String, locationString:String, Latitude:Double, Longitude:Double, Introduction:String, ActivityArray:[Int], LangSpoken:Int, LangWriten:Int, CredentialsArray: NSMutableArray)
}

class ProfessionalBasicProfileVC: UIViewController, ProfessionalRequirementDelegate, FilterActivitySelectedDelegate, MapViewSelectedDelegate {
    
    //MARK:- Variables
    lazy var mainView: ProfessionalBasicProfileView = { [unowned self] in
        return self.view as! ProfessionalBasicProfileView
        }()
    
    lazy var mainModelView: ProfessionalBasicProfileViewModel = {
        return ProfessionalBasicProfileViewModel(theController: self)
    }()
    
    //MARK:- Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        self.navigationController?.setWhiteColor()
        self.mainView.delegate = self
        self.mainView.setupUI(theController: self)
        self.mainModelView.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.mainModelView.setupNavigationbar(title: getCommonString(key: "Basic_Profile_key"))
        
        self.navigationController?.setWhiteColor()
        self.navigationController?.addShadow()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let viewWithTag = self.navigationController!.view.viewWithTag(102) {
            viewWithTag.removeFromSuperview()
        }
    }
    
    //MARK:- @IBAction
    func btnBackClicked() {
        self.navigationController?.popViewController(animated: true)
        self.mainModelView.delegate?.ProfessionalBasicProfileFinish(Profession: self.mainModelView.selectedProfession, locationString: self.mainModelView.selectedAddress, Latitude: self.mainModelView.selectedLatitude, Longitude: self.mainModelView.selectedLongitude, Introduction: self.mainModelView.txtIntroduction, ActivityArray: self.mainModelView.selectedArray, LangSpoken: self.mainModelView.selectedLangSpoken, LangWriten: self.mainModelView.selectedLangWriten, CredentialsArray: self.mainModelView.CredentialsArray)
    }
    
    @IBAction func btnProfessionClicked(_ sender: Any) {
        let obj = AppStoryboard.Settings.instance.instantiateViewController(withIdentifier: "ProfessionalRequirementVC") as! ProfessionalRequirementVC
        obj.mainModelView.delegate = self
        
        obj.mainModelView.navigationHeader = getCommonString(key: "Profession_key")
        obj.mainModelView.placeholder = getCommonString(key: "Share_us_a_little_bit_about_your_profession_key")
        if self.mainModelView.selectedProfession != "" {
//            obj.mainView.txtTextView.text = self.mainModelView.selectedProfession
            obj.mainModelView.text = self.mainModelView.selectedProfession
        }
        obj.mainModelView.isScreen = 1
        self.navigationController?.pushViewController(obj, animated: true)
    }   
    
    @IBAction func btnIntrodunctionClicked(_ sender: Any) {
        let obj = AppStoryboard.Settings.instance.instantiateViewController(withIdentifier: "ProfessionalRequirementVC") as! ProfessionalRequirementVC
        obj.mainModelView.delegate = self
        obj.mainModelView.navigationHeader = getCommonString(key: "Introduction_key")
        obj.mainModelView.placeholder = getCommonString(key: "Share_us_a_little_bit_about_yourself_key")
        if self.mainModelView.txtIntroduction != "" {
//            obj.mainView.txtTextView.text = self.mainModelView.txtIntroduction
            obj.mainModelView.text = self.mainModelView.txtIntroduction
        }
        obj.mainModelView.isScreen = 2
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    @IBAction func btnActivityClicked(_ sender: Any) {        
        let obj = AppStoryboard.Settings.instance.instantiateViewController(withIdentifier: "ProfessionalActivityVC") as! ProfessionalActivityVC
        obj.mainModelView.delegate = self
        obj.mainModelView.selectedArray = self.mainModelView.selectedArray
        obj.mainModelView.selectedNameArray = self.mainModelView.selectedNameArray
        let nav = UINavigationController(rootViewController: obj)
        nav.modalPresentationStyle = .overFullScreen
        present(nav, animated: true, completion: nil )
    }
    
    @IBAction func btnAcademicUploadClicked(_ sender: Any) {
        self.mainModelView.AcademicUploadClicked()
    }
    
    @IBAction func btnLanguageSpokenClicked(_ sender: Any) {
        if self.mainView.txtLanguageSpoken.text?.toTrim() == "" {
            self.mainView.txtLanguageSpoken.text = GetAllData?.data?.languages?.first?.name
            self.mainModelView.selectedLangSpoken = GetAllData?.data?.languages?.first?.id?.intValue ?? 0
        }
        self.mainView.txtLanguageSpoken.becomeFirstResponder()
    }
    
    @IBAction func btnLanguageWritenClicked(_ sender: Any) {
        self.mainView.txtLanguageWriten.becomeFirstResponder()
    }
    
    func ProfessionalRequirementFinish(text: String, isScreen:Int) {
        if isScreen == 1 {
            self.mainView.txtProfession.text = text
            self.mainModelView.selectedProfession = text
        }
        else {
            self.mainView.lblIntroduction.text = text
            self.mainModelView.txtIntroduction = text
        }
    }
    
    func FilterActivitySelectedDidFinish(ids: [Int], names: [String]) {
        self.mainModelView.selectedArray = ids
        self.mainModelView.selectedNameArray = names
        let formattedNameString = (names.map{String($0)}).joined(separator: ", ")
        self.mainModelView.filterSpecialization = formattedNameString
    }
    
    func FilterActivityClose() {
        
    }
    
    func MapViewLocationSelected(selectedLocation: CLLocationCoordinate2D) {
        self.mainModelView.selectedCoordinate = selectedLocation
        self.mainModelView.setUpPinOnMapAccodtingToSelected(lat: selectedLocation.latitude, long: selectedLocation.longitude)
        getPlacemark(forLocation: CLLocation(latitude: selectedLocation.latitude, longitude: selectedLocation.longitude), completionHandler: { (placemark, address) in
            if placemark != nil {
                self.mainView.txtLocation.text = address
                self.mainModelView.selectedAddress = address ?? ""
                self.mainModelView.selectedLatitude = selectedLocation.latitude
                self.mainModelView.selectedLongitude = selectedLocation.longitude
            }
        })
    }
}
