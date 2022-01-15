//
//  CreateEventStepSecondView.swift
//  Load
//
//  Created by Haresh Bhai on 25/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import GoogleMaps

protocol MapViewSelectedDelegate: class {
    func MapViewLocationSelected(selectedLocation: CLLocationCoordinate2D)
}

class CreateEventStepOneView: UIView, UITextFieldDelegate, GMSMapViewDelegate {

    //MARK:- @IBOutlet    
    @IBOutlet weak var locationTableView: UITableView!
    @IBOutlet weak var lblEventName: UILabel!
    @IBOutlet weak var txtEventName: UITextField!
    @IBOutlet weak var imgEventName: UIImageView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var imgDate: UIImageView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var txtTime: UITextField!
    @IBOutlet weak var imgTime: UIImageView!
    @IBOutlet weak var lblTImeArlier: UILabel!
    @IBOutlet weak var txtTimeArlier: UITextField!
    @IBOutlet weak var imgTimeArlier: UIImageView!
    @IBOutlet weak var lblEventTime: UILabel!
    @IBOutlet weak var txtEventTime: UITextField!
    @IBOutlet weak var imgEventTime: UIImageView!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var txtLocation: UITextField!
    @IBOutlet weak var lblLocationTitle: UILabel!
    @IBOutlet weak var imgLocation: UIImageView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var constraintTableViewHeight: NSLayoutConstraint! // 0
    
    @IBOutlet weak var lblFillUPTheBasics: UILabel!
    @IBOutlet weak var lblEventTitle: UILabel!
    @IBOutlet weak var txtEvent: UITextField!
    @IBOutlet weak var imgEvent: UIImageView!

    @IBOutlet weak var lblPublic: UILabel!
    @IBOutlet weak var txtPublic: UITextField!
    @IBOutlet weak var imgPublic: UIImageView!
    @IBOutlet weak var lblGuest: UILabel!
    @IBOutlet weak var txtGuest: UITextField!
    @IBOutlet weak var imgGuest: UIImageView!
    
    var delegate: MapViewSelectedDelegate?
    
    //MARK:- Functions
    func setupUI() {
        self.setupFont()
        self.txtEvent.delegate = self
        self.txtEventName.delegate = self
        self.txtTimeArlier.delegate = self
        self.txtGuest.delegate = self
        self.mapView.delegate = self
    }
    
    func setupFont() {
        self.locationTableView.register(UINib(nibName: "PlaceResultTableViewCell", bundle: nil), forCellReuseIdentifier: "PlaceResultTableViewCell")
        self.lblEventName.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.txtEventName.font = themeFont(size: 18, fontname: .ProximaNovaRegular)
        self.lblDate.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.txtDate.font = themeFont(size: 18, fontname: .ProximaNovaRegular)
        self.lblTime.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.txtTime.font = themeFont(size: 18, fontname: .ProximaNovaRegular)
        self.lblTImeArlier.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.txtTimeArlier.font = themeFont(size: 18, fontname: .ProximaNovaRegular)
        self.lblEventTime.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.txtEventTime.font = themeFont(size: 18, fontname: .ProximaNovaRegular)
        self.lblLocation.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.txtLocation.font = themeFont(size: 18, fontname: .ProximaNovaRegular)
        self.lblLocationTitle.font = themeFont(size: 18, fontname: .ProximaNovaRegular)
        self.lblFillUPTheBasics.font = themeFont(size: 20, fontname: .ProximaNovaBold)
        self.lblEventTitle.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.txtEvent.font = themeFont(size: 18, fontname: .ProximaNovaRegular)
        self.lblPublic.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.txtPublic.font = themeFont(size: 18, fontname: .ProximaNovaRegular)
        self.lblGuest.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.txtGuest.font = themeFont(size: 18, fontname: .ProximaNovaRegular)
        self.btnNext.titleLabel?.font = themeFont(size: 17, fontname: .Helvetica)
        
        self.lblEventName.setColor(color: .appthemeBlackColorAlpha30)
        self.txtEventName.setColor(color: .appthemeBlackColor)
        self.lblDate.setColor(color: .appthemeBlackColorAlpha30)
        self.txtDate.setColor(color: .appthemeBlackColor)
        self.lblTime.setColor(color: .appthemeBlackColorAlpha30)
        self.txtTime.setColor(color: .appthemeBlackColor)
        self.lblTImeArlier.setColor(color: .appthemeBlackColorAlpha30)
        self.txtTimeArlier.setColor(color: .appthemeBlackColor)
        self.lblEventTime.setColor(color: .appthemeBlackColorAlpha30)
        self.txtEventTime.setColor(color: .appthemeBlackColor)
        self.lblLocation.setColor(color: .appthemeBlackColorAlpha30)
        self.txtLocation.setColor(color: .appthemeBlackColor)
        self.lblLocationTitle.setColor(color: .appthemeBlackColor)
        self.lblFillUPTheBasics.setColor(color: .appthemeBlackColor)
        self.lblEventTitle.setColor(color: .appthemeBlackColorAlpha30)
        self.txtEvent.setColor(color: .appthemeBlackColor)
        self.lblPublic.setColor(color: .appthemeBlackColorAlpha30)
        self.txtPublic.setColor(color: .appthemeBlackColor)
        self.lblGuest.setColor(color: .appthemeBlackColorAlpha30)
        self.txtGuest.setColor(color: .appthemeBlackColor)
        self.btnNext.setColor(color: .appthemeWhiteColor)
        
        self.lblEventName.text = getCommonString(key: "Event_Name_key")
        self.txtEventName.placeholder = getCommonString(key: "Name_key")
        self.lblDate.text = getCommonString(key: "When_will_it_be?_key")
        self.txtDate.placeholder = getCommonString(key: "Select_date_key")
        self.lblTime.text = getCommonString(key: "What_time_will_it_start?_key")
        self.txtTime.placeholder = getCommonString(key: "Select_time_key")
        self.lblTImeArlier.text = getCommonString(key: "Do_goests_required_to_come_earlier?_key")
        self.txtTimeArlier.placeholder = getCommonString(key: "Select_option_key")
        self.lblEventTime.text = getCommonString(key: "How_long_is_the_event?_key")
        self.txtEventTime.placeholder = getCommonString(key: "Enter_time_key")
        self.lblLocation.text = getCommonString(key: "Where_will_it_be?_key")
        self.txtLocation.placeholder = getCommonString(key: "Location_key")
        self.lblLocationTitle.text = getCommonString(key: "Is_this_the_event_place?_key")
        self.lblFillUPTheBasics.text = getCommonString(key: "Fill_up_the_basics_key")
        self.lblEventTitle.text = getCommonString(key: "First,_what_type_of_event_are_you_holding?:_key")
        self.txtEvent.placeholder = getCommonString(key: "Enter_event_key")
        self.lblPublic.text = getCommonString(key: "Is_it_open_for_public?_key")
        self.txtPublic.placeholder = getCommonString(key: "Select_type_key")
        self.lblGuest.text = getCommonString(key: "Now_the_maximum_number_of_guests_key")
        self.txtGuest.placeholder = getCommonString(key: "Enter_guest_key")
        self.btnNext.setTitle(str: getCommonString(key: "Save_and_Continue_key"))
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text,
            let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange,
                                                       with: string)
            if textField == self.txtEvent {
                self.imgEvent.isHidden = updatedText == ""
            }
            else if textField == self.txtEventName {
                self.imgEventName.isHidden = updatedText == ""
            }
            else if textField == self.txtTimeArlier {
                self.imgTimeArlier.isHidden = updatedText == ""
            }
            else if textField == self.txtGuest {
                self.imgGuest.isHidden = updatedText == ""
            }
        }
        return true
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        self.delegate?.MapViewLocationSelected(selectedLocation: coordinate)
    }
}
