//
//  LoadMoreCell.swift
//  Load
//
//  Created by Haresh Bhai on 18/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

protocol LoadMoreDelegate: class {
    func LoadMoreDidFinish(tag:Int)
}

class LoadMoreCell: UITableViewCell {

    //MARK:- @IBOutlet
    @IBOutlet weak var lblTitle: UILabel!
    
    //MARK:- Variables
    weak var delegate:LoadMoreDelegate?

    //MARK:- Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupUI() {
        self.setupFont()
    }
    
    func setupFont() {
        self.lblTitle.font = themeFont(size: 12, fontname: .ProximaNovaRegular)
        self.lblTitle.setColor(color: .appthemeRedColor)
    }
    
    @IBAction func btnLoadMoreClicked(_ sender: Any) {
        self.delegate?.LoadMoreDidFinish(tag: self.tag)
    }    
}
