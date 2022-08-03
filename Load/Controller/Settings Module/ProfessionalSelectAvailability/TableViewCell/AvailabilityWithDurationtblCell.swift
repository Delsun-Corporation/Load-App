//
//  AvailabilityWithDurationtblCell.swift
//  Load
//
//  Created by Yash on 21/06/21.
//  Copyright © 2021 Haresh Bhai. All rights reserved.
//

protocol AvailibilityDurationCellDelegate {
    func selectedDayInCustom(section:Int, row: Int)
}

import UIKit
import SwiftyJSON

class AvailabilityWithDurationtblCell: UITableViewCell {

    //MARK:- Outlet
    
    @IBOutlet weak var vwDayNameAndCheckmark: UIView!
    @IBOutlet weak var vwDuration: UIView!
    @IBOutlet weak var lblDayName: UILabel!
    @IBOutlet weak var vwLine: UIView!
    @IBOutlet weak var heightOfConstraintvwNameAndCheckmark: NSLayoutConstraint!
    @IBOutlet weak var imgCheckmark: UIImageView!
    @IBOutlet weak var btnDaySelect: UIButton!
    @IBOutlet weak var heightConstraintVwDuration: NSLayoutConstraint!
    @IBOutlet weak var txtOpeningHours: UITextField!
    @IBOutlet weak var txtBreak: UITextField!
    lazy var timeRangePicker: UIPickerView = {
        let view = UIPickerView()
        return view
    }()
    
    var sectionTag = 0
    var indexPath: IndexPath?
    var delegateAvailibility : AvailibilityDurationCellDelegate?
    var timeRangePickerData = [[DatePickerRangeDataModel]]()
    
    var onChangeOpeningHours: ((String, IndexPath) -> Void)?
    var onChangeBreakHours: ((String, IndexPath) -> Void)?
    
    //MARK:- View life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.timeRangePicker.delegate = self
        self.timeRangePicker.dataSource = self
        txtOpeningHours.inputView = timeRangePicker
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func getValueFromPickerView() -> String {
        var selectedDict: [Int: String] = [:]
        
        for timeRange in 0..<timeRangePicker.numberOfComponents {
            let selectedRow = timeRangePicker.selectedRow(inComponent: timeRange)
            guard let viewInRow = timeRangePicker.view(forRow: selectedRow, forComponent: timeRange) as? LOADCustomPickerView,
                  let text = viewInRow.titleLabel.text else {
                continue
            }
            selectedDict[timeRange] = text
        }
        
        // Convert dict to string for date time range
        var parsedString = ""
        for timeRange in 0..<timeRangePicker.numberOfComponents {
            parsedString += "\(selectedDict[timeRange] ?? "")"
        }
        
        return parsedString
    }
    
}

//MARK:- Button action

extension AvailabilityWithDurationtblCell {
    
    @IBAction func btnDaySelectedTapped(_ sender: UIButton) {
        if self.sectionTag == 4 {
            self.delegateAvailibility?.selectedDayInCustom(section: sectionTag, row: sender.tag)
        }
    }
    
}

//MARK: - TextField delegate

extension AvailabilityWithDurationtblCell: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtOpeningHours {
            txtOpeningHours.text = getValueFromPickerView()
            guard let openingHours = txtOpeningHours.text, let indexPath = indexPath else {
                return
            }
            onChangeOpeningHours?(openingHours, indexPath)
        } else if textField == txtBreak {
            guard let openingHours = txtBreak.text, let indexPath = indexPath else {
                return
            }
            onChangeBreakHours?(openingHours, indexPath)
        }
        
    }
    
}

extension AvailabilityWithDurationtblCell: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        9
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        timeRangePickerData[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let view = LOADCustomPickerView()
        view.titleLabel.font = themeFont(size: 18, fontname: .ProximaNovaRegular)
        view.titleLabel.textColor = UIColor.appthemeOffRedColor
        view.titleLabel.text = timeRangePickerData[component][row].title
        return view
    }
}
