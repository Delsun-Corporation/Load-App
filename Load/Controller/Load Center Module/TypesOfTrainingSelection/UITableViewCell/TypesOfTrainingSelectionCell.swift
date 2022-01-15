//
//  FilterSpecializationCell.swift
//  Load
//
//  Created by Haresh Bhai on 17/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

protocol TypesOfTrainingDelegate: class {
    func TypesOfTrainingDidFinish(section:Int, index:Int)
}

class TypesOfTrainingSelectionCell: UITableViewCell {

    //MARK:- @IBOutlet
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgCheck: UIImageView!
    @IBOutlet weak var viewLine: UIView!
    
    //MARK:- Variables
    var ischecked:Bool = false
    var index:Int = 0
    weak var delegate:TypesOfTrainingDelegate?
    
    //MARK:- Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupFont()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
                          
    func showDefaults(isShow:Bool) {        
        self.ischecked = isShow
        self.imgCheck.isHidden = !isShow
        self.lblTitle.textColor = isShow ? UIColor.appthemeRedColor : UIColor.appthemeBlackColor
    }
    
    func setupFont() {
        self.lblTitle.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblTitle.setColor(color: .appthemeBlackColor)
    }
    
    //MARK:- @IBAction
    @IBAction func btnSelectClicked(_ sender: Any) {
        self.ischecked = !self.ischecked
        self.imgCheck.isHidden = !self.ischecked
        self.lblTitle.textColor = self.ischecked ? UIColor.appthemeRedColor : UIColor.appthemeBlackColor
        self.delegate?.TypesOfTrainingDidFinish(section: self.tag, index: self.index)
    }    
}
