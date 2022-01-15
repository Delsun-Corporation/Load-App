//
//  AddRowCell.swift
//  Load
//
//  Created by Haresh Bhai on 04/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

protocol AddRowDelegate: class {
    func AddRowClicked()
    func RemoveRowClicked()
}

class AddRowCell: UITableViewCell {

    @IBOutlet weak var btnRemove: UIButton!
    weak var delegate: AddRowDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnAddClicked(_ sender: Any) {
        self.delegate?.AddRowClicked()
    }
    
    @IBAction func btnRemoveClicked(_ sender: Any) {
        self.delegate?.RemoveRowClicked()
    }
}
