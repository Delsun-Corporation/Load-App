//
//  EventAboutCell.swift
//  Load
//
//  Created by Haresh Bhai on 26/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

protocol EventListDelegate: class {
    func EventAboutDidFinish(text: String)
    func EventAmentiesDidFinish(tag:Int, isOn:Bool)
}

class EventAboutCell: UITableViewCell, UITextViewDelegate {
    
    //MARK:- @IBOutlet
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblAbout: UILabel!
    @IBOutlet weak var txtAbout: KMPlaceholderTextView!
    
    //MARK:- Variables
    weak var delegate:EventListDelegate?
    
    //MARK:- Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.txtAbout.delegate = self
        self.setupFont()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupFont() {
        self.lblTitle.font = themeFont(size: 19, fontname: .HelveticaBold)
        self.lblAbout.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.txtAbout.font = themeFont(size: 18, fontname: .ProximaNovaRegular)

        self.lblTitle.setColor(color: .appthemeBlackColor)
        self.lblAbout.setColor(color: .appthemeBlackColorAlpha30)
        self.txtAbout.setColor(color: .appthemeBlackColor)

        self.lblTitle.text = getCommonString(key: "Let’s_get_more_detailed_key")
        self.lblAbout.text = getCommonString(key: "Tell_guests_more_about_your_event_key")
        self.txtAbout.placeholder = getCommonString(key: "Enter_about_key")
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        self.delegate?.EventAboutDidFinish(text: newText)
        return true
    }
}
