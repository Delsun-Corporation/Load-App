//
//  AccountView.swift
//  Load
//
//  Created by Haresh Bhai on 26/08/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class AccountView: UIView {

    //MARK:- @IBOutlet
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblTypeOfAccount: UILabel!
    @IBOutlet weak var lblTypeOfAccountValue: UILabel!
    @IBOutlet weak var lblPlaningBreak: UILabel!
    @IBOutlet weak var lblPlaningBreakValue: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var btnUpgrade: UIButton!
    @IBOutlet weak var viewSnooze: UIView!
    @IBOutlet weak var btnSnooze: UIButton!    
    @IBOutlet weak var viewDate: UIView!
    @IBOutlet weak var txtStartDate: UITextField!
    @IBOutlet weak var txtEndDate: UITextField!
   
    //MARK:- Varibales
    var array: NSMutableArray = NSMutableArray()

    //MARK:- Functions
    func setupUI(theController: AccountVC) {
        self.setupFont()
        self.viewDate.isHidden = true
        self.lblDescription.isHidden = false
        if let _accountId = getUserDetail()?.data?.user?.accountId {
            self.lblTypeOfAccountValue.text = getAccountName(id: _accountId)
        }
        else if let _accountId = getUserDetail()?.data?.user?.accountIdStr {
            self.lblTypeOfAccountValue.text = getAccountName(idStr: _accountId)
        }
        self.btnSnooze.isSelected = getUserDetail()?.data?.user?.isSnooze?.intValue == 0 ? false : true
        if self.btnSnooze.isSelected {
            if let startDate = getUserDetail()?.data?.user?.userSnoozeDetail?.startDate {
                let date: Date = convertDate(startDate, dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SZ")
                print(date)
                theController.mainModelView.selectedDateStart = date
                self.txtStartDate.text = convertDateFormater(startDate, format: "yyyy-MM-dd'T'HH:mm:ss.SZ", dateFormat: "MM/dd/yyyy")
            }
            
            if let endDate = getUserDetail()?.data?.user?.userSnoozeDetail?.endDate {
                let date: Date = convertDate(endDate, dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SZ")
                print(date)
                theController.mainModelView.selectedDateEnd = date
                self.txtEndDate.text = convertDateFormater(endDate, format: "yyyy-MM-dd'T'HH:mm:ss.SZ", dateFormat: "MM/dd/yyyy")
            }
        }
        self.viewDate.isHidden = self.btnSnooze.isSelected ? false : true
        self.lblDescription.isHidden = self.btnSnooze.isSelected ? true : false
        if self.lblTypeOfAccountValue.text?.lowercased() == ACCOUNT_TYPE.FREE.rawValue.lowercased() {
            self.viewSnooze.isHidden = true
        }
        else if self.lblTypeOfAccountValue.text?.lowercased() == ACCOUNT_TYPE.PREMIUM.rawValue.lowercased() {
            self.viewSnooze.isHidden = false
        }
        else if self.lblTypeOfAccountValue.text?.lowercased() == ACCOUNT_TYPE.PROFESSIONAL.rawValue.lowercased() {
            self.viewSnooze.isHidden = true
        }
    }
    
    func setupFont() {
        self.lblTitle.font = themeFont(size: 20, fontname: .ProximaNovaBold)
        self.lblTypeOfAccount.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblTypeOfAccountValue.font = themeFont(size: 15, fontname: .ProximaNovaBold)
        self.lblPlaningBreak.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblPlaningBreakValue.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblDescription.font = themeFont(size: 11, fontname: .ProximaNovaRegular)
        self.btnUpgrade.titleLabel?.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.txtStartDate.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.txtEndDate.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        
        self.lblTitle.setColor(color: .appthemeBlackColor)
        self.lblTypeOfAccount.setColor(color: .appthemeBlackColor)
        self.lblTypeOfAccountValue.setColor(color: .appthemeBlackColor)
        self.lblPlaningBreak.setColor(color: .appthemeLightGrayColor)
        self.lblPlaningBreakValue.setColor(color: .appthemeBlackColor)
        self.lblDescription.setColor(color: .appthemeBlackColor)
        self.btnUpgrade.setColor(color: .appthemeRedColor)
        self.txtStartDate.setColor(color: .appthemeBlackColor)
        self.txtEndDate.setColor(color: .appthemeBlackColor)
    }    
}
