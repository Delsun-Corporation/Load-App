//
//  CheckAvailibilityHeaderCell.swift
//  Load
//
//  Created by Haresh Bhai on 31/05/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class CheckAvailibilityHeaderCell: UITableViewCell {

    @IBOutlet weak var imgLeftConstant: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setImage(index: Int) {
        let width = UIScreen.main.bounds.width - 30
        let firstIndex = width / 7
        self.imgLeftConstant.constant = 15 + (firstIndex * CGFloat(index)) + (firstIndex / 2) - 6.5
    }
    
}
