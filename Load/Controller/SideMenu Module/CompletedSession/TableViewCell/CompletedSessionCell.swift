//
//  CompletedSessionCell.swift
//  Load
//
//  Created by Haresh Bhai on 12/08/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class CompletedSessionCell: UITableViewCell {

    @IBOutlet weak var imgType: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var lbl2: UILabel!
    @IBOutlet weak var lbl3: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setupUI() {
        self.imgType.image = self.imgType.image?.withRenderingMode(.alwaysTemplate)
        self.imgType.tintColor = UIColor.black
        
        self.lblTitle.text = "Strength Training week 2"
        self.lbl1.text = "06.08.2019, 07:30 PM (1 hour)"
        self.lbl2.text = "Geoffery"
        self.lbl3.text = "Session ID: 1234567"
    }
}
