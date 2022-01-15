//
//  FilterRatingCell.swift
//  Load
//
//  Created by Haresh Bhai on 17/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import FloatRatingView

protocol FilterRatingDelegate: class {
    func FilterRatingDidFinish(rate:Double)
}

class FilterRatingCell: UITableViewCell {

    //MARK:- @IBOutlet
    @IBOutlet weak var rateView: FloatRatingView!
    
    //MARK:- Variables
    weak var delegate: FilterRatingDelegate?
    
    //MARK:- Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.rateView.delegate = self
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension FilterRatingCell: FloatRatingViewDelegate {
    
    // MARK: FloatRatingViewDelegate
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Double) {
        self.delegate?.FilterRatingDidFinish(rate: ratingView.rating)
    }
}
