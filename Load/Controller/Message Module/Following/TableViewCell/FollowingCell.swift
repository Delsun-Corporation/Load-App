//
//  FollowingCell.swift
//  Load
//
//  Created by Haresh Bhai on 26/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import SDWebImage
import MGSwipeTableCell

protocol SelectFollowingDelegate: class {
    func SelectFollowingDidFinish(index:Int, isSelected:Bool)
}

class FollowingCell: MGSwipeTableCell {

    //MARK:- @IBOutlet
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var btnSelect: UIButton!
    @IBOutlet weak var leftImage: NSLayoutConstraint!
    
    //MARK:- Variables
    weak var delegateSelect: SelectFollowingDelegate?
    var isSelectedRow: Bool = false
    
    //MARK:- Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setupUI(model: MessageList) {
        self.setupFont()
        self.lblName.text = model.name
        self.imgProfile.sd_setImage(with: model.photo?.toURL(), placeholderImage: UIImage(named: "ic_menu_splash_holder"), options: .highPriority, completed: nil)
        self.lblDate.text = "Last workout 1 d"
        
        let image = isSelectedRow ? UIImage(named: "ic_round_check_box_select") : UIImage(named: "ic_round_check_box_unselect")
        btnSelect.setImage(image, for: .normal)
    }
    
    func showSelect(isShow:Bool = true) {
        self.leftImage.constant = isShow ? 50 : 16
        self.btnSelect.isHidden = !isShow
    }
    
    func setupFont() {
        self.imgProfile.setCircle()
        
        self.lblName.font = themeFont(size: 14, fontname: .Helvetica)
        self.lblDate.font = themeFont(size: 11, fontname: .Helvetica)
        
        self.lblName.setColor(color: .appthemeBlackColor)
        self.lblDate.setColor(color: .appthemeBlackColorAlpha50)
    }
    
    @IBAction func btnSelectClicked(_ sender: UIButton) {
        isSelectedRow = !isSelectedRow
        self.delegateSelect?.SelectFollowingDidFinish(index: self.tag, isSelected: isSelectedRow)
        let image = isSelectedRow ? UIImage(named: "ic_round_check_box_select") : UIImage(named: "ic_round_check_box_unselect")
        sender.setImage(image, for: .normal)
    }
}
