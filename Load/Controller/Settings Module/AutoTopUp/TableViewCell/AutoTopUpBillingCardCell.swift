//
//  AutoTopUpBillingCardCell.swift
//  Load
//
//  Created by Haresh Bhai on 11/09/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import MGSwipeTableCell

protocol AutoTopUpBillingCardDelegate: class {
    func AutoTopUpBillingCardButton(section:Int, row:Int)
}

class AutoTopUpBillingCardCell: MGSwipeTableCell {

    //MARK:- @IBOutlet
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtValue: UITextField!
    @IBOutlet weak var viewLine: UIView!
    @IBOutlet weak var imgChecked: UIImageView!
    @IBOutlet weak var btnCell: UIButton!
    
    //MARK:- Variables
    weak var delegateAutoBilling:AutoTopUpBillingCardDelegate?
    
    //MARK:- Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)        
        // Configure the view for the selected state
    }
    
    func setupUI(indexPath: IndexPath, title: String, text: String, placeHolder:String) {
        self.tag = indexPath.section
        self.txtValue.tag = indexPath.row
        self.setupFont()
        self.lblTitle.text = title
        self.txtValue.placeholder = placeHolder
        self.txtValue.text = text
    }
    
    func setupFont() {
        self.lblTitle.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.txtValue.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        
        self.lblTitle.setColor(color: .appthemeBlackColor)
        self.txtValue.setColor(color: .appthemeBlackColorAlpha30)
    }
    
    //MARK:- @IBAction
    @IBAction func btnCellClicked(_ sender: UIButton) {
        self.delegateAutoBilling?.AutoTopUpBillingCardButton(section: self.tag, row: sender.tag)
    }
}
