//
//  ConfirmAvailibiltyChatCell.swift
//  Load
//
//  Created by Haresh Bhai on 27/08/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class ConfirmAvailibiltyChatCell: UITableViewCell {

    @IBOutlet weak var imgChat: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var btnAccept: UIButton!    
    @IBOutlet weak var btnDecline: UIButton!
    @IBOutlet weak var viewAccept: UIView!
    @IBOutlet weak var viewPending: UIView!
    @IBOutlet weak var btnPending: UIButton!
    
    var model: MessageListData?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setupUI(model: MessageListData) {
        self.model = model
        self.setupFont()
        self.getDetails()
    }
    
    func getDetails() {
        SocketIOHandler.shared.getClientBookDetails(id: self.model?.bookedClientId?.intValue ?? 0) { (json) in
            print(json![0])
            if json?.count != 0 && !json![0].isEmpty {
                let data = json![0]
                let name = data.getString(key: .name)
                let date = data.getString(key: .selected_date)
                let confirmed_status = data.getInt(key: .confirmed_status)
                
                self.lblDate.text = convertDateFormater(date, format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ",  dateFormat: "dd MMMM yyyy")
                self.lblTime.text = name
                
                if self.model?.fromId == getUserDetail().data?.user?.id {
                    self.viewAccept.isHidden = true
                    self.viewPending.isHidden = false
                    
                    var title = ""
                    if confirmed_status == 0 {
                        title = "Request Pending"
                    }
                    else if confirmed_status == 1 {
                        title = "Request Accepted"
                    }
                    else {
                        title = "Request Declined"
                    }
                    self.btnPending.setTitle(str: title)
                }
                else {
                    var title = ""
                    if confirmed_status == 0 {
                        self.viewAccept.isHidden = false
                        self.viewPending.isHidden = true
                        title = "Request Pending"
                    }
                    else if confirmed_status == 1 {
                        title = "Request Accepted"
                        self.viewAccept.isHidden = true
                        self.viewPending.isHidden = false
                    }
                    else {
                        title = "Request Declined"
                        self.viewAccept.isHidden = true
                        self.viewPending.isHidden = false
                    }
                    self.btnPending.setTitle(str: title)
                }
            }
        }
    }
    
    func changeIcon(isLeft:Bool = true) {
        self.imgChat.image = isLeft ? UIImage(named: "ic_left_message") : UIImage(named: "ic_right_message")
    }
    
    func setupFont() {
        self.lblTitle.font = themeFont(size: 13, fontname: .HelveticaBold)
        self.lblDate.font = themeFont(size: 12, fontname: .Helvetica)
        self.lblTime.font = themeFont(size: 12, fontname: .Helvetica)
        self.btnAccept.titleLabel?.font = themeFont(size: 12, fontname: .Helvetica)
        self.btnDecline.titleLabel?.font = themeFont(size: 12, fontname: .Helvetica)

        self.lblTitle.setColor(color: .appthemeBlackColor)
        self.lblDate.setColor(color: .appthemeBlackColor)
        self.lblTime.setColor(color: .appthemeBlackColor)
        self.btnAccept.setColor(color: .appthemeRedColor)
        self.btnDecline.setColor(color: .appthemeBlackColor)
    }
    
    @IBAction func btnAcceptClicked(_ sender: Any) {
        SocketIOHandler.shared.UpdateClientBookingStatus(id: self.model?.bookedClientId?.intValue ?? 0, status: CLIENT_BOOKING_STATUS.ACCEPTED.rawValue) { (json) in
            print(json![0])
            if json?.count != 0 && !json![0].isEmpty {
                let data = json![0]
                let id = data.getInt(key: .id)
                SocketIOHandler.shared.receiveUpdatedStatus(bookedClientId: id)
                self.getDetails()
            }
        }
    }
    
    @IBAction func btnDeclineClicked(_ sender: Any) {
        SocketIOHandler.shared.UpdateClientBookingStatus(id: self.model?.bookedClientId?.intValue ?? 0, status: CLIENT_BOOKING_STATUS.REJECTED.rawValue) { (json) in
            print(json![0])
            if json?.count != 0 && !json![0].isEmpty {
                let data = json![0]
                let id = data.getInt(key: .id)
                SocketIOHandler.shared.receiveUpdatedStatus(bookedClientId: id)
                self.getDetails()
            }
        }
    }
}
