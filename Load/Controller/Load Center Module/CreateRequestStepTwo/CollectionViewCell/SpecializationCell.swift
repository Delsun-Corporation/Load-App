//
//  SpecializationCell.swift
//  Load
//
//  Created by Haresh Bhai on 27/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

protocol SpecializationDelegate: class {
    func SpecializationDidFinish(id:String)
}

class SpecializationCell: UICollectionViewCell {

    @IBOutlet weak var btnTag: CustomButton!
    var model:Specializations?
    var isSelectedTag:Bool = false
    weak var delegate: SpecializationDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupUI(model:Specializations) {
        self.setupFont()
        self.changeUI()
        self.model = model
        self.btnTag.setTitle(str: model.name!)
    }

    @IBAction func btnTagClicked(_ sender: Any) {
        self.isSelectedTag = !self.isSelectedTag
        self.delegate?.SpecializationDidFinish(id: (model?.id?.stringValue)!)
        self.changeUI()
    }
    
    func setupFont() {
        self.btnTag.titleLabel?.font = themeFont(size: 15, fontname: .Helvetica)
        self.btnTag.setColor(color: .appthemeBlackColor)
    }
    
    func changeUI() {
        if self.isSelectedTag {
            self.btnTag.backgroundColor = .appthemeRedColor
            self.btnTag.setColor(color: .appthemeWhiteColor)
        }
        else {
            self.btnTag.backgroundColor = .appthemeWhiteColor
            self.btnTag.setColor(color: .appthemeBlackColor)
        }
    }
}
