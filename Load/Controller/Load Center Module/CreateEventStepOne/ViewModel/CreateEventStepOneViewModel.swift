//
//  CreateEventStepOneViewModel.swift
//  Load
//
//  Created by Haresh Bhai on 25/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlacePicker
import SwiftyJSON

class CreateEventStepOneViewModel: CustomNavigationDelegate {

    //MARK:- Variables
    fileprivate weak var theController:CreateEventStepOneVC!
    let pickerView = UIPickerView()
//    var totalDays:Int = 0
    var totalHrs:Int = 0
    var totalMins:Int = 0
    var eventTypeArray: [EventTypesModel] = []
    var selectedArray:[Int] = [Int]()
    var selectedNameArray:[String] = [String]()
    
    //Step One
    var eventType:String = ""
    var selectedPublicType:Int?
    var maxGuest:String = ""

    //Step Two
    var selectedDate:Date?
    var selectedTime:Date?
    var selectedCoordinate : CLLocationCoordinate2D?
    var selectedAddress : String = ""
    var searchResult:[GMSAutocompletePrediction] = []
    let clearButton = UIButton(frame: CGRect(x: 0, y: 0, width: 16, height: 16))
    let placesClient = GMSPlacesClient()
    var isSelectedText = false

    let publicArray: [String] = ["Invitation only", "For public"]
    let comeEarlierArray: [String] = ["Yes", "No"]

    var selectedType:Int?
    let publicPickerView = UIPickerView()
    let comeEarlierPickerView = UIPickerView()

    init(theController:CreateEventStepOneVC) {
        self.theController = theController
    }
    
    //MARK:- Functions
    func setupUI() {
        self.getEventTypesList()
        let view = (self.theController.view as? CreateEventStepOneView)
        
        publicPickerView.delegate = theController
        publicPickerView.backgroundColor = UIColor.white
        view?.txtPublic.inputView = publicPickerView
        
        comeEarlierPickerView.delegate = theController
        comeEarlierPickerView.backgroundColor = UIColor.white
        view?.txtTimeArlier.inputView = comeEarlierPickerView
        
        let screen = UIScreen.main.bounds.width / 2
        for index in 0..<2 {
            let label = UILabel()
            label.textAlignment = .center
            label.font = themeFont(size: 21, fontname: .Regular) //themeFont(size: 15, fontname: .ProximaNovaRegular)
            if index == 0 {
                label.frame = CGRect(x: (screen * CGFloat(index)) + 73, y: (pickerView.frame.height - 30) / 2, width: screen, height: 30)
                label.text = "hrs"
            }
            else {
                label.frame = CGRect(x: (screen * CGFloat(index)) - 5, y: (pickerView.frame.height - 30) / 2, width: screen, height: 30)
                label.text = "min"
            }
            label.textColor = .appthemeRedColor
            self.pickerView.addSubview(label)
        }
        
        pickerView.delegate = theController
        pickerView.backgroundColor = UIColor.white
        view?.txtEventTime.inputView = pickerView
        
        setUpPinOnMap(lat: userCurrentLocation?.coordinate.latitude ?? 0.0, long:userCurrentLocation?.coordinate.longitude ?? 0.0, flag: 0)
        animateTableView(isHidden: true, duration: 0.0)
        view?.txtLocation.delegate = self.theController
        view?.txtLocation.clearButtonMode = .whileEditing
        view?.mapView.isUserInteractionEnabled = true

        view?.locationTableView.estimatedRowHeight = 50.0
        view?.locationTableView.rowHeight = 50.0
        view?.txtLocation.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
        self.initialize()        
        self.DOBSetup()
    }
    
    func DOBSetup() {
        let view = (theController.view as? CreateEventStepOneView)
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePicker.Mode.date
        
        if #available(iOS 13.4, *) {
            datePickerView.preferredDatePickerStyle = .wheels
            //datePickerView.setValue(UIColor.clear, forKey: "magnifierLineColor")
            datePickerView.setValue(false, forKey: "highlightsToday")
        }
        
        datePickerView.backgroundColor = UIColor.white
        
        datePickerView.setValue(UIColor.appthemeOffRedColor, forKeyPath: "textColor")
        datePickerView.minimumDate = Date()
        view?.txtDate.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(datePickerValueChanged), for: UIControl.Event.valueChanged)
        
        let datePickerView1:UIDatePicker = UIDatePicker()
        datePickerView1.datePickerMode = UIDatePicker.Mode.time
        if #available(iOS 13.4, *) {
            datePickerView1.preferredDatePickerStyle = .wheels
            datePickerView1.setValue(UIColor.clear, forKey: "magnifierLineColor")
            datePickerView1.setValue(false, forKey: "highlightsToday")
        }
        
        datePickerView1.backgroundColor = UIColor.white

        datePickerView1.setValue(UIColor.appthemeOffRedColor, forKeyPath: "textColor")
        view?.txtTime.inputView = datePickerView1
        datePickerView1.addTarget(self, action: #selector(timePickerValueChanged), for: UIControl.Event.valueChanged)
    }
    
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        let view = (theController.view as? CreateEventStepOneView)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateFormatter.dateFormat = "MM/dd/yyyy"
        view?.txtDate.text = dateFormatter.string(from: sender.date)
        self.selectedDate = sender.date
        view?.imgDate.image = UIImage(named: "ic_check_marck")
    }
    
    @objc func timePickerValueChanged(sender:UIDatePicker) {
        let view = (theController.view as? CreateEventStepOneView)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateFormatter.dateFormat = "HH:mm a"
        view?.txtTime.text = dateFormatter.string(from: sender.date)
        self.selectedTime = sender.date
        view?.imgTime.image = UIImage(named: "ic_check_marck")
    }
    
    func validateDetails() {
        let view = (self.theController.view as? CreateEventStepOneView)
        
        if view?.txtEvent.text!.toTrim() == "" {
            makeToast(strMessage: getCommonString(key: "Please_enter_type_of_event_key"))
        }
        else if view?.txtEventName.text!.toTrim() == "" {
            makeToast(strMessage: getCommonString(key: "Please_enter_event_key"))
        }
        else if self.selectedDate == nil {
            makeToast(strMessage: getCommonString(key: "Please_select_date_key"))
        }
        else if self.selectedTime == nil {
            makeToast(strMessage: getCommonString(key: "Please_select_time_key"))
        }
        else if view?.txtTimeArlier.text!.toTrim() == "" {
            makeToast(strMessage: getCommonString(key: "Please_select_come_earlier_key"))
        }
        else if view?.txtEventTime.text!.toTrim() == "" {
            makeToast(strMessage: getCommonString(key: "Please_enter_event_time_key"))
        }
        else if self.selectedType == nil {
            makeToast(strMessage: getCommonString(key: "Please_select_type_key"))
        }
        else if view?.txtGuest.text!.toTrim() == "" {
            makeToast(strMessage: getCommonString(key: "Please_enter_number_of_guest_key"))
        }
        else if view?.txtLocation.text!.toTrim() == "" {
            makeToast(strMessage: getCommonString(key: "Please_enter_loation_key"))
        }
        else if self.selectedCoordinate == nil {
            makeToast(strMessage: getCommonString(key: "Please_enter_loation_key"))
        }
        else {
            let obj = AppStoryboard.LoadCenter.instance.instantiateViewController(withIdentifier: "CreateEventStepSecondDetailVC") as! CreateEventStepSecondDetailVC
            obj.mainModelView.selectedPublicType = self.selectedPublicType
            obj.mainModelView.maxGuest = self.maxGuest
            obj.mainModelView.txtEventName = (view?.txtEventName.text!.toTrim())!
            obj.mainModelView.selectedDate = self.selectedDate
            obj.mainModelView.selectedTime = self.selectedTime
            obj.mainModelView.txtTimeArlier = (view?.txtTimeArlier.text!.toTrim())!
            obj.mainModelView.eventTime = self.getMinutes()
            obj.mainModelView.selectedCoordinate = self.selectedCoordinate
            obj.mainModelView.selectedAddress = self.selectedAddress
            obj.mainModelView.eventType = json(from: self.selectedArray) ?? ""
            obj.mainModelView.selectedPublicType = self.selectedPublicType
            obj.mainModelView.maxGuest = (view?.txtGuest.text!.toTrim())!
            self.theController.navigationController?.pushViewController(obj, animated: true)
        }
    }
   
    //MARK:- GMSAutocompletePrediction
    func initialize() {
        let view = (self.theController.view as? CreateEventStepOneView)
//        clearButton.setImage(UIImage(named: "ic_clear")!, for: [])
//
//        view?.txtLocation.rightView = clearButton
//        clearButton.addTarget(self, action: #selector(clearClicked), for: .touchUpInside)
        
        view?.txtLocation.clearButtonMode = .never
        view?.txtLocation.rightViewMode = .whileEditing
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
        let view = (self.theController.view as? CreateEventStepOneView)
        view?.txtLocation.text = ""
        clearButton.isHidden = true
        animateTableView(isHidden: true, duration: 0.5)
    }
    
    func animateTableView(isHidden:Bool,duration:Double) {
        let view = (self.theController.view as? CreateEventStepOneView)
        if isHidden {
            view?.constraintTableViewHeight.constant = 0
        } else {
//            view?.viewBGAutocomplete.isHidden = isHidden
            var height:CGFloat = 0.0
            if DEVICE_TYPE.IS_IPHONE {
                if DEVICE_TYPE.IS_IPHONE_5_OR_LESS {
                    height = searchResult.count > 3 ? CGFloat(50*3) : CGFloat(searchResult.count * 50)
                } else {
                    height = searchResult.count > 5 ? CGFloat(50*5) : CGFloat(searchResult.count * 50)
                }
            } else {
                height = searchResult.count > 3 ? CGFloat(50*3) : CGFloat(searchResult.count * 50)
            }
            view?.constraintTableViewHeight.constant = height
        }
        UIView.animate(withDuration: duration, animations: {
//            self.viewBGAutocomplete.layoutIfNeeded()
        }) { (completion) in
            if isHidden {
//                self.viewBGAutocomplete.isHidden = isHidden
            }
        }
    }
    
    func fetchResult(strSearch:String) {
        let view = (self.theController.view as? CreateEventStepOneView)

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
        let view = (self.theController.view as? CreateEventStepOneView)

        if predication.placeID != "" {
            let placeID = predication.placeID
            placesClient.lookUpPlaceID(placeID) { [weak self] (place, error) in
                guard let placeData = place else { return }
                let locationCoordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(placeData.coordinate.latitude, placeData.coordinate.longitude)
                
                view?.txtLocation.resignFirstResponder()
                let addressFrom = predication.attributedFullText.string
                self?.selectedAddress = addressFrom
                self?.selectedCoordinate = locationCoordinate
                view?.txtLocation.text = addressFrom
                self?.isSelectedText = true
                self?.setUpPinOnMapAccodtingToSelected(lat: self?.selectedCoordinate?.latitude ?? 0.0, long: self?.selectedCoordinate?.longitude ?? 0.0)
                self?.animateTableView(isHidden: true, duration: 0.5)
            }
        }
    }
    
    func setUpPinOnMap(lat:Double,long:Double,flag : Int) {
        let view = (self.theController.view as? CreateEventStepOneView)

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
        let view = (self.theController.view as? CreateEventStepOneView)
        view?.mapView.clear()
        let cameraCoord = CLLocationCoordinate2D(latitude: lat, longitude: long)
        view?.mapView.camera = GMSCameraPosition.camera(withTarget: cameraCoord, zoom: 15)
        let updateCamera = GMSCameraUpdate.setTarget(cameraCoord, zoom: 15)
        view?.mapView.animate(with: updateCamera)
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
        marker.map = view?.mapView
    } 
    
    func getMinutes() -> Int {
//        let days = self.totalDays * 24
        let hrs = self.totalHrs * 60
//        let min = days + hrs + self.totalMins
        let min = hrs + self.totalMins
        return min
    }
    
    func setupNavigationbar(title:String) {
        self.theController.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        self.theController.navigationController?.setColor()
        self.theController.navigationItem.hidesBackButton = true
        
        if let vwnav = ViewNav.instanceFromNib() as? ViewNav {
            
            var hightOfView = 0
            if UIScreen.main.bounds.height >= 812 {
                hightOfView = 44
            }
            else {
                hightOfView = 20
            }
            
            vwnav.frame = CGRect(x: 0, y: 0, width: self.theController.navigationController?.navigationBar.frame.width ?? 320, height: vwnav.frame.height + CGFloat(hightOfView))
            
            let myMutableString = NSMutableAttributedString()
            
            let dict = [NSAttributedString.Key.font: themeFont(size: 20, fontname: .HelveticaBold)]
            let dict1 = [NSAttributedString.Key.font: themeFont(size: 12, fontname: .Helvetica)]
            
            myMutableString.append(NSAttributedString(string: "Let’s set up\n", attributes: dict))
            myMutableString.append(NSAttributedString(string: "your big event.", attributes: dict))
            myMutableString.append(NSAttributedString(string: " (only for professional)", attributes: dict1))
            vwnav.lblTitle.attributedText = myMutableString
            vwnav.tag = 1000
            vwnav.delegate = self
            self.theController.navigationController?.view.addSubview(vwnav)
        }
    }
    
    func CustomNavigationClose() {
        self.theController.dismiss(animated: true, completion: nil)
    }
    
    func getEventTypesList() {
        
        let param = ["":""] as [String : Any]
        print(JSON(param))
        
        ApiManager.shared.MakeGetAPI(name: GET_EVENT_TYPES_LIST, params: param as [String : Any], progress: false, vc: self.theController, isAuth: false, completionHandler: { (response, error) in
            if response != nil {
                let json = JSON(response!)
                print(json)
                let success = json.getBool(key: .success)
                if success {
                    let data = json.getArray(key: .data)
                    for dataValue in data {
                        let model = EventTypesModel(JSON: dataValue.dictionaryObject!)
                        self.eventTypeArray.append(model!)
                    }
                }
                else {
                    let message = json.getString(key: .message)
                    makeToast(strMessage: message)
                }
            }
        })
    }
}
