//
//  ViewAllLoadCenterTblCell.swift
//  Load
//
//  Created by iMac on 20/05/20.
//  Copyright © 2020 Haresh Bhai. All rights reserved.
//

import UIKit
import FloatRatingView

protocol redirectMessageDelegate {
    func messageClickWithID(index:String)
}

class ViewAllLoadCenterTblCell: UITableViewCell {

    //MARK:- @IBOutlet
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var vwSartRatting: FloatRatingView!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblResistance: UILabel!
    @IBOutlet weak var txtvwResistanceDescription: UITextView!
    @IBOutlet weak var btnMessage: UIButton!
    @IBOutlet weak var btnBookmark: UIButton!

    var eventDelegate: eventDelegateForBookmark?
    var messageDelegate : redirectMessageDelegate?

    //MARK: - View life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupFont()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupFont() {
        self.imgProfile.roundCornersFrame(corners: [.topLeft, .topRight], radius: 10, width: UIScreen.main.bounds.width - 46)
        
        self.lblName.font = themeFont(size: 18, fontname: .ProximaNovaRegular)
        self.lblDescription.font = themeFont(size: 11, fontname: .ProximaNovaRegular)
        self.lblResistance.font = themeFont(size: 12, fontname: .ProximaNovaBold)
        self.txtvwResistanceDescription.font = themeFont(size: 11, fontname: .ProximaNovaRegular)
        self.btnMessage.titleLabel?.font = themeFont(size: 16, fontname: .ProximaNovaBold)
        
        self.txtvwResistanceDescription.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.lblName.setColor(color: .appthemeBlackColor)
        self.lblDescription.setColor(color: .appthemeBlackColor)
        self.lblResistance.setColor(color: .appthemeBlackColor)
        self.txtvwResistanceDescription.setColor(color: .appthemeBlackColor)
        self.btnMessage.setColor(color: .appthemeWhiteColor)
        
        btnBookmark.tag = self.tag
    }
    
    @IBAction func btnBookmarkTapped(_ sender: Any) {
        btnBookmark.isSelected = !self.btnBookmark.isSelected
        self.eventDelegate?.selectionBookmarkEvent(selection: btnBookmark.isSelected, tag: self.tag)
    }

    @IBAction func btnMessageTapped(_ sender: UIButton) {
        self.messageDelegate?.messageClickWithID(index: String(self.tag))
    }
    
    func setupData(data: ProfessionalList){
        self.lblName.text = data.userDetail?.name ?? ""
        self.imgProfile.sd_setImage(with: data.userDetail?.photo!.toURL(), completed: nil)
        self.lblDescription.text = data.introduction ?? ""
        self.btnBookmark.isSelected = data.isBookmarked ?? false
        self.vwSartRatting.rating = Double(data.rate ?? "0") ?? 0.0
        self.txtvwResistanceDescription.text = getSpecializations(model: data.specializationIds ?? [])
    }
    
    func getSpecializations(model:[SpecializationDetails]) -> String {
        var str:String = ""
        for data in model {
            str += (data.name! + ", ")
        }
        str = str.toTrim()
        return String(str.dropLast())
    }

    
}
