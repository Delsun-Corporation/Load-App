//
//  CreateEventStepFiveView.swift
//  Load
//
//  Created by Haresh Bhai on 19/08/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class CreateEventStepFiveView: UIView {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgPicture: UIImageView!
    @IBOutlet weak var lblUploadPicture: UILabel!
    @IBOutlet weak var btnUpload: UIButton!
    
    //MARK:- Functions
    func setupUI() {
        self.setupFont()
    }
    
    func setupFont() {
        self.lblTitle.font = themeFont(size: 20, fontname: .ProximaNovaBold)
        self.lblUploadPicture.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.btnUpload.titleLabel?.font = themeFont(size: 17, fontname: .Helvetica)

        self.lblTitle.setColor(color: .appthemeBlackColor)
        self.lblUploadPicture.setColor(color: .appthemeBlackColorAlpha30)
        self.btnUpload.setColor(color: .appthemeWhiteColor)
    }
}
