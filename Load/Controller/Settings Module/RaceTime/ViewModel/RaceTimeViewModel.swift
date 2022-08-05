//
//  RaceTimeViewModel.swift
//  Load
//
//  Created by Haresh Bhai on 05/09/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

protocol RaceTimeDelegate: class {
    func RaceTimeFinish(raceDistanceId:String, raceTime:String)
}
class RaceTimeViewModel {
    
    //MARK:- Variables
    fileprivate weak var theController:RaceTimeVC!
    let pickerViewDistance = UIPickerView()
    let pickerViewTime = UIPickerView()
    var totalDays:String = "00"
    var totalHrs:String = "00"
    var totalMins:String = "00"
    
    var raceDistanceId:String = ""
    var raceTime:String = ""
    
    weak var delegate:RaceTimeDelegate?
    
    //MARK:- Functions
    init(theController:RaceTimeVC) {
        self.theController = theController
    }
    
    func setupUI() {
        pickerViewTime.delegate = self.theController
        pickerViewTime.dataSource = self.theController
        pickerViewTime.backgroundColor = UIColor.white
        pickerViewDistance.delegate = self.theController
        pickerViewDistance.dataSource = self.theController
        pickerViewDistance.backgroundColor = UIColor.white
        let screen = UIScreen.main.bounds.width / 3
        for index in 0..<3 {
            let label = UILabel()
            label.textAlignment = .center
            label.font = themeFont(size: 21, fontname: .Regular) //themeFont(size: 15, fontname: .ProximaNovaRegular)
            if index == 0 {
                label.frame = CGRect(x: (screen * CGFloat(index)) + 48, y: (pickerViewTime.frame.height - 30) / 2, width: screen, height: 30)
                label.text = "hrs"
            }
            else if index == 1 {
                label.frame = CGRect(x: (screen * CGFloat(index)) + 35, y: (pickerViewTime.frame.height - 30) / 2, width: screen, height: 30)
                label.text = "min"
            }
            else {
                label.frame = CGRect(x: (screen * CGFloat(index)) + 23, y: (pickerViewTime.frame.height - 30) / 2, width: screen, height: 30)
                label.text = "sec"
            }
            label.textColor = .appthemeRedColor
            self.pickerViewTime.addSubview(label)
        }
        
        let view = (self.theController.view as? RaceTimeView)
        view?.txtDistance.inputView = pickerViewDistance
        view?.txtTime.inputView = pickerViewTime
        
        view?.txtDistance.text = getRaceDistanceName(id: Int(self.raceDistanceId) ?? 0)
        view?.txtTime.text = self.raceTime
        
        if self.raceTime != ""{
            let timeArray = self.raceTime.components(separatedBy: ":")
            self.totalDays = timeArray[0]
            self.totalHrs = timeArray[1]
            self.totalMins = timeArray[2]
            pickerViewTime.selectRow(Int(timeArray[0]) ?? 0, inComponent: 0, animated: false)
            pickerViewTime.selectRow(Int(timeArray[1]) ?? 0, inComponent: 1, animated: false)
            pickerViewTime.selectRow(Int(timeArray[2]) ?? 0, inComponent: 2, animated: false)
        }
        
        if let raceDistance = GetAllData?.data?.raceDistance?.enumerated() {
            for (index, data) in raceDistance {
                if Int(self.raceDistanceId) ?? 0 == data.id?.intValue {
                    pickerViewDistance.selectRow(index, inComponent: 0, animated: false)
                }
            }
        }
    }
}
