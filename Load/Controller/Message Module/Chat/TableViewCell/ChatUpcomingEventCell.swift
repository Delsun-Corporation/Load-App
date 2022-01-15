//
//  ChatUpcomingEventCell.swift
//  Load
//
//  Created by Haresh Bhai on 30/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class ChatUpcomingEventCell: UITableViewCell {

    //MARK:- @IBOutlet
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var btnPrice: UIButton!
    @IBOutlet weak var imgChat: UIImageView!
    @IBOutlet weak var lblChatDate: UILabel!
    //MARK:- Variables
    weak var delegate: ChatTrainingLogOREventDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        DispatchQueue.main.async {
            self.imgProfile.roundCorners(corners: [.topLeft, .topRight], radius: 10)
        }
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    //MARK:- Functions
    
    func setupUI(model: MessageListData) {
        self.setupFont()
        if model.ChatEvent != nil {
            self.imgProfile.sd_setImage(with: (SERVER_URL + (model.ChatEvent?.eventImage ?? "")).toURL(), completed: nil)
            self.lblName.text = model.ChatEvent?.eventName
            self.lblDescription.text = model.ChatEvent?.description
            
            self.lblDate.text = convertDateFormater(model.ChatEvent?.dateTime ?? "", format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", dateFormat: "EEEE, dd MMM yyyy")
            self.lblTime.text = "Time: " + convertDateFormater((model.ChatEvent?.dateTime ?? ""), format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ",  dateFormat: "HH:mm a") + " " + self.getDuration(time: model.ChatEvent?.duration?.intValue ?? 0)
            self.lblChatDate.text = convertDateFormater((model.createdAt!), format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ",  dateFormat: "HH:mm a")
            self.btnPrice.setTitle(str: "SGD $\(model.ChatEvent!.eventPrice!.stringValue)")
        }
        else {
            SocketIOHandler.shared.getEventDetails(id: model.eventId?.intValue ?? 0) { (json) in
                print(json![0])
                if json?.count != 0 && !json![0].isEmpty {
                    let logs = ChatEvent(JSON: json![0].dictionaryObject!)
                    self.delegate?.ChatEventReload(index: self.tag, event: logs!)
                }
            }
        }
    }
    
    func changeIcon(isLeft:Bool = true) {
        self.imgChat.image = isLeft ? UIImage(named: "ic_left_message") : UIImage(named: "ic_right_message")
    }
    
    func setupFont() {
        self.lblName.font = themeFont(size: 12, fontname: .HelveticaBold)
        self.lblDescription.font = themeFont(size: 10, fontname: .Helvetica)
        self.lblDate.font = themeFont(size: 10, fontname: .HelveticaBold)
        self.lblTime.font = themeFont(size: 10, fontname: .HelveticaBold)
        self.btnPrice.titleLabel?.font = themeFont(size: 10, fontname: .Helvetica)
        
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
    
}
