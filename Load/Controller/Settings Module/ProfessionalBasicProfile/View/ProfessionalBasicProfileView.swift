//
//  ProfessionalBasicProfileView.swift
//  Load
//
//  Created by Haresh Bhai on 02/09/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import GoogleMaps
import GoogleMaps

class ProfessionalBasicProfileView: UIView, GMSMapViewDelegate {

    //MARK:-  @IBOutlet
    @IBOutlet weak var lblProfessionTitle: UILabel!
    @IBOutlet weak var txtProfession: UITextField!
    
    @IBOutlet weak var lblLocationTitle: UILabel!
    @IBOutlet weak var txtLocation: UITextField!
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var heightMapView: NSLayoutConstraint!
    
    @IBOutlet weak var lblIntroductionTitle: UILabel!
    @IBOutlet weak var lblIntroduction: UILabel!
    
    @IBOutlet weak var lblActivityTitle: UILabel!
    
    @IBOutlet weak var lblAcademicTitle: UILabel!
    
    @IBOutlet weak var lblLanguageSpokenTitle: UILabel!
    @IBOutlet weak var txtLanguageSpoken: UITextField!
    
    @IBOutlet weak var lblLanguageWritenTitle: UILabel!
    @IBOutlet weak var txtLanguageWriten: UITextField!
    
    @IBOutlet weak var locationTableView: UITableView!
    @IBOutlet weak var constraintTableViewHeight: NSLayoutConstraint! // 0
    
    var delegate: MapViewSelectedDelegate?

    //MARK:- Functions
    func setupUI(theController: ProfessionalBasicProfileVC) {
        self.heightMapView.constant = UIScreen.main.bounds.width
        self.setupFont()
        self.locationTableView.register(UINib(nibName: "PlaceResultTableViewCell", bundle: nil), forCellReuseIdentifier: "PlaceResultTableViewCell")
        self.locationTableView.dataSource = theController
        self.locationTableView.delegate = theController
        self.mapView.delegate = self
    }
    
    func setupFont() {
        self.lblProfessionTitle.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.txtProfession.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblLocationTitle.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.txtLocation.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblIntroductionTitle.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblIntroduction.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblActivityTitle.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblAcademicTitle.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblLanguageSpokenTitle.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.txtLanguageSpoken.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblLanguageWritenTitle.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.txtLanguageWriten.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        
        self.lblProfessionTitle.setColor(color: .appthemeBlackColor)
        self.txtProfession.setColor(color: .appthemeBlackColorAlpha30)
        self.lblLocationTitle.setColor(color: .appthemeBlackColor)
        self.txtLocation.setColor(color: .appthemeBlackColorAlpha30)
        self.lblIntroductionTitle.setColor(color: .appthemeBlackColor)
        self.lblIntroduction.setColor(color: .appthemeBlackColorAlpha30)
        self.lblActivityTitle.setColor(color: .appthemeBlackColor)
        self.lblAcademicTitle.setColor(color: .appthemeBlackColor)
        self.lblLanguageSpokenTitle.setColor(color: .appthemeBlackColor)
        self.txtLanguageSpoken.setColor(color: .appthemeBlackColorAlpha30)
        self.lblLanguageWritenTitle.setColor(color: .appthemeBlackColor)
        self.txtLanguageWriten.setColor(color: .appthemeBlackColorAlpha30)
        
        self.lblProfessionTitle.text = getCommonString(key: "Profession_key")
        self.lblLocationTitle.text = getCommonString(key: "Location_key")
        self.lblIntroductionTitle.text = getCommonString(key: "Introduction_key")
        self.lblActivityTitle.text = getCommonString(key: "Activites_key")
        self.lblAcademicTitle.text = getCommonString(key: "Credentials_key")
        self.lblLanguageSpokenTitle.text = getCommonString(key: "Language(s)_key")
        self.lblLanguageWritenTitle.text = getCommonString(key: "Language_writen_key")
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        self.delegate?.MapViewLocationSelected(selectedLocation: coordinate)
    }
}
