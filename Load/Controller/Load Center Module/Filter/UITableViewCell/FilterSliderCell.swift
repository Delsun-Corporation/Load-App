//
//  FilterSliderCell.swift
//  Load
//
//  Created by Haresh Bhai on 26/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import RangeSeekSlider

protocol FilterSliderDelegate: class {
    func FilterSliderDidFinish(section:Int, start:CGFloat, end:CGFloat)
}

class FilterSliderCell: UITableViewCell {

    //MARK:- @IBOutlet
    @IBOutlet weak var lblMin: UILabel!
    @IBOutlet weak var lblMax: UILabel!
    @IBOutlet weak var slider: RangeSeekSlider!
    
    //MARK:- Variables
    var delegate:FilterSliderDelegate?
    var section:Int = 0
    
    //MARK:- Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupUI(min:CGFloat, max:CGFloat, isShow:Bool = false) {
        self.slider.delegate = self
        self.slider.lineHeight = 4
        self.slider.minValue = min
        self.slider.maxValue = max
        self.slider.minDistance = 1
        if section == 6 {
            self.slider.selectedMinValue = FILTER_MODEL?.YOEStart ?? min + 7
            self.slider.selectedMaxValue = FILTER_MODEL?.YOEEnd ?? max - 20
        }
        else {
            self.slider.selectedMinValue = FILTER_MODEL?.RateStart ?? min + 7
            self.slider.selectedMaxValue = FILTER_MODEL?.RateEnd ?? max - 20
        }

        self.slider.tintColor = .black
        if isShow {
            self.slider.numberFormatter.numberStyle = .currency
            self.slider.numberFormatter.locale = Locale(identifier: "en_US")
        }
        self.lblMin.text = isShow ? "$"+String(Int(min)) : String(Int(min))
        self.lblMax.text = isShow ? "$"+String(Int(max)) : String(Int(max))
        self.slider.selectedHandleDiameterMultiplier = 1
        self.slider.minLabelFont = themeFont(size: 15, fontname: .HelveticaBold)
        self.slider.maxLabelFont = themeFont(size: 15, fontname: .HelveticaBold)
    }
}

// MARK: - RangeSeekSliderDelegate

extension FilterSliderCell: RangeSeekSliderDelegate {
    
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        print("Standard slider updated. Min Value: \(minValue) Max Value: \(maxValue)")
        self.delegate?.FilterSliderDidFinish(section: self.section, start: minValue, end: maxValue)
    }
    
    func didStartTouches(in slider: RangeSeekSlider) {
        print("did start touches")
    }
    
    func didEndTouches(in slider: RangeSeekSlider) {
        print("did end touches")
    }
}
