//
//  EventPhotoCell.swift
//  Load
//
//  Created by Haresh Bhai on 18/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class EventPhotoFinishCell: UITableViewCell {

    //MARK:- @IBOutlet
    @IBOutlet weak var imgEvent: UIImageView!
    
    //MARK:- Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupUI(model:EventDetailsModelClass) {
        self.imgEvent.sd_setImage(with: model.eventImage?.toURL(), completed: nil)
    }
}
