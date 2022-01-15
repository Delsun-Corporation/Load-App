//
//  EventCell.swift
//  Load
//
//  Created by Haresh Bhai on 21/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

protocol eventDelegateForBookmark{
    func selectionBookmarkEvent(selection:Bool,tag:Int)
}

class EventCell: UITableViewCell {

    //MARK:- @IBOutlet
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var btnPrice: UIButton!
    @IBOutlet weak var btnBookmark: UIButton!
    
    //MARK: - Variable
    
    var eventDelegate: eventDelegateForBookmark?
    
    //MARK: - View life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
    //MARK:- Functions
    func setupUI(model: UpcomingEvent) {
        self.setupFont()
        self.imgProfile.sd_setImage(with: model.eventImage!.toURL(), completed: nil)
        self.lblName.text = model.eventName
        self.lblDescription.text = model.description
        self.lblDate.text = convertDateFormater(model.dateTime!, dateFormat: "EEEE, dd MMM yyyy")
        self.lblTime.text = "Time: " + convertDateFormater(model.dateTime!, dateFormat: "HH:mm a") + " " + self.getDuration(time: (model.duration?.intValue)!)
        self.btnPrice.setTitle(str: "SGD $\(model.eventPrice!.stringValue)")
        self.btnBookmark.isSelected = model.isBookmarked
    }
    
    func setupFont() {
        self.imgProfile.roundCornersFrame(corners: [.topLeft, .topRight], radius: 10, width: UIScreen.main.bounds.width - 46)
        
        self.lblName.font = themeFont(size: 18, fontname: .ProximaNovaRegular)
        self.lblDescription.font = themeFont(size: 11, fontname: .ProximaNovaRegular)
        self.lblDate.font = themeFont(size: 12, fontname: .ProximaNovaBold)
        self.lblTime.font = themeFont(size: 11, fontname: .ProximaNovaRegular)
        self.btnPrice.titleLabel?.font = themeFont(size: 16, fontname: .ProximaNovaBold)
        
        self.lblName.setColor(color: .appthemeBlackColor)
        self.lblDescription.setColor(color: .appthemeBlackColor)
        self.lblDate.setColor(color: .appthemeBlackColor)
        self.lblTime.setColor(color: .appthemeBlackColor)
        self.btnPrice.setColor(color: .appthemeWhiteColor)
    }
    
    func getDuration(time:Int) -> String {
        print(time)
        if time <= 60 {
            return "\(time) Mins"
        }
        else if time > 1500 {
            var data = time
            var days = 0
            var hrs = 0
            var mins = 0
            
            for _ in 0..<61 {
                if data > 1440 {
                    data = data - 1440
                    days += 1
                    print(data)
                }
                else if data > 60 {
                    data = data - 60
                    hrs += 1
                    print(data)
                }
                else {
                    mins = data
                    print(data)
                }
            }
            var str = ""
            if days != 0 {
                str += "\(days) Days "
            }
            if hrs != 0 {
                str += "\(hrs) Hrs "
            }
            if mins != 0 {
                str += "\(mins) Mins"
            }
            else {
                str.removeLast()
            }
            return str
        }
        else {
            var data = time
            var hrs = 0
            var mins = 0
            for _ in 0..<24 {
                if data >= 60 {
                    data = data - 60
                    hrs += 1
                }
                else {
                    mins = data
                }
            }
            
            var str = ""
            if hrs != 0 {
                str += "\(hrs) Hrs "
            }
            if mins != 0 {
                str += "\(mins) Mins"
            }
            else {
                str.removeLast()
            }
            return str
        }
    }
    
    //MARK: - IBAction method
    
    
    @IBAction func btnBookmarkTapped(_ sender: Any) {
        btnBookmark.isSelected = !self.btnBookmark.isSelected
        self.eventDelegate?.selectionBookmarkEvent(selection: btnBookmark.isSelected, tag: self.tag)
    }
    
}
