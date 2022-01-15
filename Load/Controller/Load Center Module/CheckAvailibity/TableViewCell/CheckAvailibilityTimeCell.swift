//
//  CheckAvailibilityTimeCell.swift
//  Load
//
//  Created by Haresh Bhai on 23/08/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

protocol CheckAvailibilityTimeDelegate: class {
    func CheckAvailibilityTimeDidFinish(row:Int, section:Int)
}

class CheckAvailibilityTimeCell: UITableViewCell {

    //MARK:- @IBOutlet
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var btnCell: UIButton!
    
    //MARK:- Variables
    var clientBookedDatesArray: ClientBookedDatesModelClass?
    var section: Int = 0
    weak var delegate:CheckAvailibilityTimeDelegate?
    
    //MARK:- Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setupUI(index:Int, date:String) {
        self.setupFont()
        self.lblTime.text = GetAllData?.data?.availableTimes?[index].name?.lowercased()
        self.showClient(date: date, time: (GetAllData?.data?.availableTimes?[index].id?.stringValue ?? ""))
    }
    
    func setupFont() {
        self.lblTime.font = themeFont(size: 11, fontname: .ProximaNovaRegular)
        self.lblTime.setColor(color: .appthemeBlackColor)
    }
    
    func showClient(date:String, time: String) {
        let data = self.clientBookedDatesArray?.list?.filter({ (data) -> Bool in
            return (data.selectedDate?.contains(date))! && data.availableTimeId?.stringValue == time
        })
        self.btnCell.isUserInteractionEnabled = true
        if data?.count != 0 {            
            let str1 = self.lblTime.text!
            let str2 = (data?.first?.fromUserDetail?.name ?? "")
            let formattedString = NSMutableAttributedString()
            formattedString.normal(str1).normal("      ").bold(str2)
            self.lblTime.attributedText = formattedString
            self.btnCell.isUserInteractionEnabled = false
        }
    }
    
    func showColor(index:Int) {
        self.viewBack.backgroundColor = self.tag == index ? UIColor.appthemeRedColor : UIColor(red: 244/255, green: 244/255, blue: 244/255, alpha: 1)
        self.lblTime.textColor = self.tag == index ? UIColor.white : UIColor.black
    }
    
    @IBAction func btnCellClicked(_ sender: Any) {
        self.delegate?.CheckAvailibilityTimeDidFinish(row: self.tag, section: self.section)
    }    
}
