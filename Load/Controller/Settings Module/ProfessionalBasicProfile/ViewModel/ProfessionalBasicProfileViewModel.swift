//
//  ProfessionalBasicProfileViewModel.swift
//  Load
//
//  Created by Haresh Bhai on 02/09/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps
import GooglePlacePicker

class ProfessionalBasicProfileViewModel: CredentialsArrayDelegate {
    
    //MARK:- Variables
    fileprivate weak var theController:ProfessionalBasicProfileVC!
    weak var delegate: ProfessionalBasicProfileDelegate?
    
    var filterSpecialization:String = ""
    var selectedCoordinate : CLLocationCoordinate2D?
    var selectedAddress : String = ""
    var searchResult:[GMSAutocompletePrediction] = []
    let clearButton = UIButton(frame: CGRect(x: 0, y: 0, width: 16, height: 16))
    let placesClient = GMSPlacesClient()
    var isSelectedText = false
    let langSpokenPickerView = UIPickerView()
    let langWritenPickerView = UIPickerView()
    
    var filterArray:[FilterActivityModelClass] = [FilterActivityModelClass]()
    var selectedArray:[Int] = [Int]()
    var selectedNameArray:[String] = [String]()
    
    var selectedProfession:String = ""
    var selectedLangSpoken:Int = 0
    var selectedLangWriten:Int = 0
    var txtIntroduction:String = ""
    var selectedLatitude:Double = 0.0
    var selectedLongitude:Double = 0.0
    var CredentialsArray: NSMutableArray = NSMutableArray()
    
    //MARK:- Functions
    init(theController:ProfessionalBasicProfileVC) {
        self.theController = theController
    }
    
    func setupUI() {
        let view = (self.theController.view as? ProfessionalBasicProfileView)        
        langSpokenPickerView.delegate = theController
        langSpokenPickerView.backgroundColor = UIColor.white
        view?.txtLanguageSpoken.inputView = langSpokenPickerView
        
        langWritenPickerView.delegate = theController
        langWritenPickerView.backgroundColor = UIColor.white
        view?.txtLanguageWriten.inputView = langWritenPickerView
        if self.selectedLatitude != 0 {
            setUpPinOnMap(lat: self.selectedLatitude, long:self.selectedLongitude, flag: 0)
        }
        else {
            setUpPinOnMap(lat: userCurrentLocation?.coordinate.latitude ?? 0.0, long:userCurrentLocation?.coordinate.longitude ?? 0.0, flag: 0)
        }
        animateTableView(isHidden: true, duration: 0.0)
        view?.txtLocation.delegate = self.theController
        view?.txtLocation.clearButtonMode = .whileEditing
//        view?.mapView.isUserInteractionEnabled = false
        
        view?.locationTableView.estimatedRowHeight = 50.0
        view?.locationTableView.rowHeight = 50.0
        view?.txtLocation.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
        self.initialize()
        self.showDetails()
    }
    
    //MARK:- GMSAutocompletePrediction
    func initialize() {
        let view = (self.theController.view as? ProfessionalBasicProfileView)
        clearButton.setImage(UIImage(named: "ic_clear")!, for: [])
        
        view?.txtLocation.rightView = clearButton
        clearButton.addTarget(self, action: #selector(clearClicked), for: .touchUpInside)
        
        view?.txtLocation.clearButtonMode = .never
        view?.txtLocation.rightViewMode = .whileEditing
    }
    
    func showDetails() {
        let view = (self.theController.view as? ProfessionalBasicProfileView)
        view?.txtProfession.text = self.selectedProfession
        view?.lblIntroduction.text = self.txtIntroduction
        view?.txtLanguageSpoken.text = getLanguagesName(id: self.selectedLangSpoken)
        view?.txtLanguageWriten.text = getLanguagesName(id: self.selectedLangWriten)
        view?.txtLocation.text = self.selectedAddress
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        self.clearButton.isHidden = textField.text == "" ? true : false
        let text = textField.text!.toTrim()
        if text.count > 1 {
            self.fetchResult(strSearch: textField.text!)
        } else {
            self.animateTableView(isHidden: true, duration: 0.5)
        }
    }
    
    @objc func clearClicked(sender:UIButton) {
        let view = (self.theController.view as? ProfessionalBasicProfileView)
        view?.txtLocation.text = ""
        clearButton.isHidden = true
        animateTableView(isHidden: true, duration: 0.5)
    }
    
    func animateTableView(isHidden:Bool,duration:Double) {
        let view = (self.theController.view as? ProfessionalBasicProfileView)
        if isHidden {
            view?.constraintTableViewHeight.constant = 0
        }
        else {
            var height:CGFloat = 0.0
            if DEVICE_TYPE.IS_IPHONE {
                if DEVICE_TYPE.IS_IPHONE_5_OR_LESS {
                    height = searchResult.count > 3 ? CGFloat(50*3) : CGFloat(searchResult.count * 50)
                } else {
                    height = searchResult.count > 5 ? CGFloat(50*5) : CGFloat(searchResult.count * 50)
                }
            }
            else {
                height = searchResult.count > 3 ? CGFloat(50*3) : CGFloat(searchResult.count * 50)
            }
            view?.constraintTableViewHeight.constant = height
        }
    }
    
    func fetchResult(strSearch:String) {
        let view = (self.theController.view as? ProfessionalBasicProfileView)
        
        placesClient.autocompleteQuery(strSearch, bounds: nil, filter: nil) { [unowned self] (result, error) in
            print("error:=",error == nil ? "empty error" : error!.localizedDescription)
            self.searchResult.removeAll()
            if let dataList = result {
                self.searchResult = dataList
            }
            print("self.searchResult.count:=",self.searchResult.count)
            self.animateTableView(isHidden: self.searchResult.count == 0, duration: 0.5)
            view?.locationTableView.reloadData()
        }
    }
    
    func fetchLatLongFrom(predication:GMSAutocompletePrediction) {
        let view = (self.theController.view as? ProfessionalBasicProfileView)
        
        if predication.placeID != "" {
            let placeID = predication.placeID
            placesClient.lookUpPlaceID(placeID) { [weak self] (place, error) in
                guard let placeData = place else { return }
                let locationCoordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(placeData.coordinate.latitude, placeData.coordinate.longitude)
                
                view?.txtLocation.resignFirstResponder()
                let addressFrom = predication.attributedFullText.string
                self?.selectedAddress = addressFrom
                self?.selectedCoordinate = locationCoordinate
                self?.selectedLatitude = locationCoordinate.latitude
                self?.selectedLongitude = locationCoordinate.longitude
                view?.txtLocation.text = addressFrom
                self?.isSelectedText = true
                self?.setUpPinOnMapAccodtingToSelected(lat: self?.selectedCoordinate?.latitude ?? 0.0, long: self?.selectedCoordinate?.longitude ?? 0.0)
                self?.animateTableView(isHidden: true, duration: 0.5)
            }
        }
    }
    
    func setUpPinOnMap(lat:Double,long:Double,flag : Int) {
        let view = (self.theController.view as? ProfessionalBasicProfileView)
        
        if flag == 0 {   // Load time (First time Screen)
            let cameraCoord = CLLocationCoordinate2D(latitude: lat, longitude: long)
            view?.mapView.camera = GMSCameraPosition.camera(withTarget: cameraCoord, zoom: 15)
            let updateCamera = GMSCameraUpdate.setTarget(cameraCoord, zoom: 15)
            view?.mapView.animate(with: updateCamera)
        }
        else if flag == 1 {  // From location PinSetup
        }
        else if flag == 2 {   // To location PinSetup
        }
    }
    
    func setUpPinOnMapAccodtingToSelected(lat:Double,long:Double) {
        let view = (self.theController.view as? ProfessionalBasicProfileView)
        let cameraCoord = CLLocationCoordinate2D(latitude: lat, longitude: long)
        view?.mapView.camera = GMSCameraPosition.camera(withTarget: cameraCoord, zoom: 15)
        let updateCamera = GMSCameraUpdate.setTarget(cameraCoord, zoom: 15)
        view?.mapView.animate(with: updateCamera)
    }
    
    func AcademicUploadClicked() {
        let obj = AppStoryboard.Settings.instance.instantiateViewController(withIdentifier: "CredentialsVC") as! CredentialsVC
        obj.mainModelView.delegate = self
        obj.mainModelView.CredentialsArray = self.CredentialsArray
        self.theController.navigationController?.pushViewController(obj, animated: true)
    }
    
    func CredentialsArrayFinish(array: NSMutableArray) {
        self.CredentialsArray = array
    }
}
