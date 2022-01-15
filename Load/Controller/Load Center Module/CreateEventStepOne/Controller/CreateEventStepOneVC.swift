//
//  CreateEventStepOneVC.swift
//  Load
//
//  Created by Haresh Bhai on 25/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import CoreLocation

class CreateEventStepOneVC: UIViewController, EventTypeSelectedDelegate, MapViewSelectedDelegate {
   
    //MARK:- Variables
    lazy var mainView: CreateEventStepOneView = { [unowned self] in
        return self.view as! CreateEventStepOneView
    }()
    
    lazy var mainModelView: CreateEventStepOneViewModel = {
        return CreateEventStepOneViewModel(theController: self)
    }()
    
    //MARK:- ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()        
        self.mainView.setupUI()
        self.mainModelView.setupUI()
        self.mainView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.mainModelView.setupNavigationbar(title: getCommonString(key: "Let’s_set_up_event_key"))
    }
    
    //MARK:- @IBAction
    
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnOpenForPublicClicked(_ sender: Any) {
        if self.mainView.txtPublic.text?.toTrim() == "" {
            let activity = self.mainModelView.publicArray.first
            self.mainView.txtPublic.text = activity
            self.mainModelView.selectedType = 0
            self.mainView.imgPublic.image = UIImage(named: "ic_check_marck")
        }
        self.mainView.txtPublic.becomeFirstResponder()
    }
    
    @IBAction func btnEbentTypeClicked(_ sender: Any) {
        self.view.endEditing(true)
        let obj: EventTypeSelectionVC = AppStoryboard.LoadCenter.instance.instantiateViewController(withIdentifier: "EventTypeSelectionVC") as! EventTypeSelectionVC
        obj.mainModelView.delegate = self
        obj.mainModelView.typeArray = self.mainModelView.eventTypeArray
        obj.mainModelView.selectedArray = self.mainModelView.selectedArray
        obj.mainModelView.selectedNameArray = self.mainModelView.selectedNameArray
        let nav = UINavigationController(rootViewController: obj)
        nav.modalPresentationStyle = .overFullScreen
        present(nav, animated: true, completion: nil)
    }
    
    @IBAction func btnDateClicked(_ sender: Any) {
        if self.mainView.txtDate.text?.toTrim() == "" {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = DateFormatter.Style.medium
            dateFormatter.timeStyle = DateFormatter.Style.none
            dateFormatter.dateFormat = "MM/dd/yyyy"
            self.mainView.txtDate.text = dateFormatter.string(from: Date())
            self.mainModelView.selectedDate = Date()
            self.mainView.imgDate.image = UIImage(named: "ic_check_marck")
        }
        self.mainView.txtDate.becomeFirstResponder()
    }
    
    @IBAction func btnTimeClicked(_ sender: Any) {
        if self.mainView.txtTime.text?.toTrim() == "" {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = DateFormatter.Style.medium
            dateFormatter.timeStyle = DateFormatter.Style.none
            dateFormatter.dateFormat = "HH:mm a"
            self.mainView.txtTime.text = dateFormatter.string(from: Date())
            self.mainModelView.selectedTime = Date()
            self.mainView.imgTime.image = UIImage(named: "ic_check_marck")
        }
        self.mainView.txtTime.becomeFirstResponder()
    }
    
    @IBAction func btnComeEarlierClicked(_ sender: Any) {
        if self.mainView.txtTimeArlier.text?.toTrim() == "" {
            let activity = self.mainModelView.comeEarlierArray.first
            self.mainView.txtTimeArlier.text = activity
            self.mainView.imgTimeArlier.image = UIImage(named: "ic_check_marck")
        }
        self.mainView.txtTimeArlier.becomeFirstResponder()
    }
    
    @IBAction func btnHowlongEventClicked(_ sender: Any) {
        if self.mainView.txtEventTime.text?.toTrim() == "" {
            self.mainModelView.totalHrs =  0
            self.mainModelView.totalMins =  0
            self.mainView.txtEventTime.text = getSecondsToHoursMinutesSeconds(seconds: self.mainModelView.getMinutes() * 60)
            self.mainView.imgEventTime.isHidden = false
        }
        self.mainView.txtEventTime.becomeFirstResponder()
    }
    
    @IBAction func btnNextClicked(_ sender: Any) {
        self.mainModelView.validateDetails()
    }
    
    func EventTypeSelectedDidFinish(ids: [Int], names: [String]) {
        self.mainModelView.selectedArray = ids
        self.mainModelView.selectedNameArray = names
        let formattedNameString = (names.map{String($0)}).joined(separator: ", ")
        self.mainView.txtEvent.text = formattedNameString
    }
    
    func MapViewLocationSelected(selectedLocation: CLLocationCoordinate2D) {
        self.mainModelView.selectedCoordinate = selectedLocation
        self.mainModelView.setUpPinOnMapAccodtingToSelected(lat: selectedLocation.latitude, long: selectedLocation.longitude)
        getPlacemark(forLocation: CLLocation(latitude: selectedLocation.latitude, longitude: selectedLocation.longitude), completionHandler: { (placemark, address) in
            if placemark != nil {
                self.mainView.txtLocation.text = address
            }
        })
    }
}
