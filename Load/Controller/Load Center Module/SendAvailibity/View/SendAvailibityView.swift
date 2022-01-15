//
//  SendAvailibityView.swift
//  Load
//
//  Created by Haresh Bhai on 27/08/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import FloatRatingView

class SendAvailibityView: UIView {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblNotes: UILabel!
    @IBOutlet weak var txtNotes: KMPlaceholderTextView!    

    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblRateCount: UILabel!
    @IBOutlet weak var rateView: FloatRatingView!
    @IBOutlet weak var btnSend: UIButton!
    
    func setupUI(theController: SendAvailibityVC) {
        self.layoutIfNeeded()
        self.setupFont()
    }
    
    func setupFont() {
        self.lblTitle.font = themeFont(size: 20, fontname: .ProximaNovaBold)
        self.lblDate.font = themeFont(size: 13, fontname: .ProximaNovaRegular)
        self.lblTime.font = themeFont(size: 14, fontname: .ProximaNovaBold)
        self.lblNotes.font = themeFont(size: 14, fontname: .ProximaNovaBold)
        self.txtNotes.font = themeFont(size: 13, fontname: .ProximaNovaRegular)
        self.lblPrice.font = themeFont(size: 20, fontname: .ProximaNovaBold)
        self.lblRateCount.font = themeFont(size: 10, fontname: .ProximaNovaRegular)
        self.btnSend.titleLabel?.font = themeFont(size: 16, fontname: .ProximaNovaBold)

        self.lblTitle.setColor(color: .appthemeBlackColor)
        self.lblDate.setColor(color: .appthemeBlackColor)
        self.lblTime.setColor(color: .appthemeBlackColor)
        self.lblNotes.setColor(color: .appthemeBlackColor)
        self.txtNotes.setColor(color: .appthemeBlackColor)
        self.lblPrice.setColor(color: .appthemeBlackColor)
        self.lblRateCount.setColor(color: .appthemeBlackColor)
        self.btnSend.setColor(color: .appthemeWhiteColor)
    }
}
