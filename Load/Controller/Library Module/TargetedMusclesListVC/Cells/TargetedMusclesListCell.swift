//
//  TargetedMusclesListCell.swift
//  Load
//
//  Created by Christopher Kevin on 29/08/22.
//  Copyright © 2022 Haresh Bhai. All rights reserved.
//

import Foundation
import UIKit

class TargetedMusclesListCell: UITableViewCell {
    @IBOutlet weak var lblTargetedMuscle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupUI(text: String) {
        setupFont()
        lblTargetedMuscle.text = text
        selectionStyle = .none
    }
    
    private func setupFont() {
        lblTargetedMuscle.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        
        lblTargetedMuscle.setColor(color: .appthemeBlackColor)
    }
}
