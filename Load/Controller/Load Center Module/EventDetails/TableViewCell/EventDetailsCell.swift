//
//  EventDetailsCell.swift
//  Load
//
//  Created by Haresh Bhai on 18/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import GoogleMaps

class EventDetailsCell: UITableViewCell {

    //MARK:- @IBOutlet
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var heightMapView: NSLayoutConstraint!
    
    //MARK:- Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        self.heightMapView.constant = UIScreen.main.bounds.width
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupUI(model:EventDetailsModelClass) {
        self.setupFont()
        self.lblDate.text = convertDateFormater((model.dateTime)!, dateFormat: "EEEE, dd MMM yyyy") //EEEE, dd MMM yyyy 'at' HH:mm a
        self.lblSubTitle.text = "Please arrive earlier " + model.earlierTime!
        self.lblTime.text = convertDateFormater((model.dateTime)!, dateFormat: "HH:mm a")
        self.lblLocation.text = model.location
       
        let coordinate:CLLocation = CLLocation(latitude: Double(model.latitude!)!, longitude: Double(model.longitude!)!)
        let camera = GMSCameraPosition.camera(withLatitude: coordinate.coordinate.latitude, longitude: coordinate.coordinate.longitude, zoom: 17.0)
        self.mapView?.animate(to: camera)
    }
    
    func setupUI(txtDate:Date, earlierTime: String, txtTime:Date, location: String, latitude: Double, longitude: Double, howLongTime: Int) {
        self.setupFont()
        self.lblDate.text = txtDate.toString(dateFormat: "EEEE, dd MMM yyyy")
        self.lblSubTitle.text = "Please arrive earlier " + earlierTime
        
        let calendar = Calendar.current
        let date = calendar.date(byAdding: .minute, value: howLongTime, to: txtTime)
        
        self.lblTime.text = txtTime.toString(dateFormat: "HH:mm a") + " - " + date!.toString(dateFormat: "HH:mm a")
        self.lblLocation.text = location
                        
        let coordinate:CLLocation = CLLocation(latitude: latitude, longitude: longitude)
        let camera = GMSCameraPosition.camera(withLatitude: coordinate.coordinate.latitude, longitude: coordinate.coordinate.longitude, zoom: 17.0)
        self.mapView?.animate(to: camera)
    }
    
    func setupFont() {
        self.lblDate.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblTime.font = themeFont(size: 15, fontname: .Helvetica)
        self.lblSubTitle.font = themeFont(size: 13, fontname: .ProximaNovaThin)
        self.lblLocation.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        
        self.lblDate.setColor(color: .appthemeBlackColor)
        self.lblTime.setColor(color: .appthemeBlackColor)
        self.lblSubTitle.setColor(color: .appthemeBlackColor)
        self.lblLocation.setColor(color: .appthemeBlackColor)
    }    
}
