//
//  ProfessionalSelectAvailabilityViewModel.swift
//  Load
//
//  Created by Haresh Bhai on 04/09/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol SelectAvailabilityDelegate: class {
    func SelectAvailabilityFinish(isCustom:Bool, AvailabilityArray: [String])
}

class ProfessionalSelectAvailabilityViewModel {

    //MARK:- Variables
    fileprivate weak var theController:ProfessionalSelectAvailabilityVC!
    var headerArray:[String] = ["Any day", "Weekdays only", "Weekends only", "Message to discuss", "Custom"]
    var headerArraySelected:[Bool] = [false, false, false, false, false]
    var headerArrayName:[String] = ["ANY_DAY", "WEEKDAYS_ONLY", "WEEKENDS_ONLY", "MESSAGE_TO_DISCUSS", "CUSTOM"]

    var customArray:[String] = ["MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY", "SUNDAY"]
    var customArraySelected:[Bool] = [false, false, false, false, false, false, false]
    
    weak var delegate:SelectAvailabilityDelegate?
    
    var nameArray: [String] = []
    
    //Calendar data
    var calendarArray: CalendarModelClass?
    var currentShowMonth = Date()
    var isReloaded: [Bool] = [false, false, false, false, false, false]
    
    var arrayMain = [JSON]()


    //MARK:- Functions
    init(theController:ProfessionalSelectAvailabilityVC) {
        self.theController = theController
    }
    
    func setupUI() {
        
        let data = self.makeDateArray(date: currentShowMonth, position: currentShowMonth.startOfMonth().position(), PreviousCount: currentShowMonth.getPreviousMonth()!.count(), currentCount: currentShowMonth.startOfMonth().count())
        calendarArray = CalendarModelClass(JSON: JSON(data).dictionaryObject!)

        if let view = self.theController.view as? ProfessionalSelectAvailabilityView {
            view.lblMonthName.text = self.currentShowMonth.toString(dateFormat: "MMMM yyyy").uppercased()
            view.tblCalendar.reloadData()
        }

        if nameArray.count != 0 {
            self.showDetails()
        }
    }
    
    func setupNavigationbar(title:String) {
        
        self.theController.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        self.theController.navigationItem.hidesBackButton = true
        
        if let vwnav = ViewNavMedium.instanceFromNib() as? ViewNavMedium {
            
            vwnav.imgBackground.isHidden = true
            vwnav.btnback.isHidden = false
            vwnav.btnSave.isHidden = true
            
            var hightOfView = 0
            if UIScreen.main.bounds.height >= 812 {
                hightOfView = 44
            }
            else {
                hightOfView = 20
            }
            
            vwnav.frame = CGRect(x: 0, y: CGFloat(hightOfView), width: self.theController.navigationController?.navigationBar.frame.width ?? 320, height: vwnav.frame.height)
            
            let myMutableString = NSMutableAttributedString()
            
            let dict = [NSAttributedString.Key.font: themeFont(size: 16, fontname: .ProximaNovaBold)]
            myMutableString.append(NSAttributedString(string: title, attributes: dict))
            vwnav.lblTitle.attributedText = myMutableString
            
            vwnav.lblTitle.textColor = .black
            
            vwnav.tag = 102
            vwnav.delegate = self
            
            self.theController.navigationController?.view.addSubview(vwnav)
            
        }
    }
    
    func makeMainArray(){
        
        //For EveryDay
        var dict = JSON()
        dict["title"].stringValue = "Everyday"
        dict["selected"].boolValue = false
        
        var InnerArray = [JSON]()
        
        var innerDict = JSON()
        innerDict["name"].stringValue = "Monday"
        innerDict["selected_day"].boolValue = false
        innerDict["openning_hours"].stringValue = ""
        innerDict["break"].stringValue = ""
        InnerArray.append(innerDict)
        
        innerDict = JSON()
        innerDict["name"].stringValue = "Tuesday"
        innerDict["selected_day"].boolValue = false
        innerDict["openning_hours"].stringValue = ""
        innerDict["break"].stringValue = ""
        InnerArray.append(innerDict)
        
        innerDict = JSON()
        innerDict["name"].stringValue = "Wednesday"
        innerDict["selected_day"].boolValue = false
        innerDict["openning_hours"].stringValue = ""
        innerDict["break"].stringValue = ""
        InnerArray.append(innerDict)
        
        innerDict = JSON()
        innerDict["name"].stringValue = "Thursday"
        innerDict["selected_day"].boolValue = false
        innerDict["openning_hours"].stringValue = ""
        innerDict["break"].stringValue = ""
        InnerArray.append(innerDict)
        
        innerDict = JSON()
        innerDict["name"].stringValue = "Friday"
        innerDict["selected_day"].boolValue = false
        innerDict["openning_hours"].stringValue = ""
        innerDict["break"].stringValue = ""
        InnerArray.append(innerDict)
        
        innerDict = JSON()
        innerDict["name"].stringValue = "Saturday"
        innerDict["selected_day"].boolValue = false
        innerDict["openning_hours"].stringValue = ""
        innerDict["break"].stringValue = ""
        InnerArray.append(innerDict)
        
        innerDict = JSON()
        innerDict["name"].stringValue = "Sunday"
        innerDict["selected_day"].boolValue = false
        innerDict["openning_hours"].stringValue = ""
        innerDict["break"].stringValue = ""
        InnerArray.append(innerDict)
        
        dict["data"].arrayObject = InnerArray
        
        self.arrayMain.append(dict)
        
        //For Weekdays only
        
        dict = JSON()
        dict["title"].stringValue = "Weekdays only"
        dict["selected"].boolValue = false
        
        InnerArray = [JSON]()
        
        innerDict = JSON()
        innerDict["name"].stringValue = "Monday"
        innerDict["selected_day"].boolValue = false
        innerDict["openning_hours"].stringValue = ""
        innerDict["break"].stringValue = ""
        InnerArray.append(innerDict)
        
        innerDict = JSON()
        innerDict["name"].stringValue = "Tuesday"
        innerDict["selected_day"].boolValue = false
        innerDict["openning_hours"].stringValue = ""
        innerDict["break"].stringValue = ""
        InnerArray.append(innerDict)
        
        innerDict = JSON()
        innerDict["name"].stringValue = "Wednesday"
        innerDict["selected_day"].boolValue = false
        innerDict["openning_hours"].stringValue = ""
        innerDict["break"].stringValue = ""
        InnerArray.append(innerDict)
        
        innerDict = JSON()
        innerDict["name"].stringValue = "Thursday"
        innerDict["selected_day"].boolValue = false
        innerDict["openning_hours"].stringValue = ""
        innerDict["break"].stringValue = ""
        InnerArray.append(innerDict)
        
        innerDict = JSON()
        innerDict["name"].stringValue = "Friday"
        innerDict["selected_day"].boolValue = false
        innerDict["openning_hours"].stringValue = ""
        innerDict["break"].stringValue = ""
        InnerArray.append(innerDict)
        
        dict["data"].arrayObject = InnerArray
        
        self.arrayMain.append(dict)
        
        //For Weekends only
        
        dict = JSON()
        dict["title"].stringValue = "Weekends only"
        dict["selected"].boolValue = false
        
        InnerArray = [JSON]()
        
        innerDict = JSON()
        innerDict["name"].stringValue = ""
        innerDict["openning_hours"].stringValue = ""
        innerDict["break"].stringValue = ""
        InnerArray.append(innerDict)

        dict["data"].arrayObject = InnerArray
        self.arrayMain.append(dict)
        
        //Message to discuss
        
        dict = JSON()
        dict["title"].stringValue = "Message to discuss"
        dict["selected"].boolValue = false
        
//        InnerArray = [JSON]()
//
//        innerDict = JSON()
//        innerDict["name"].stringValue = ""
//        innerDict["openning_hours"].stringValue = ""
//        innerDict["break"].stringValue = ""
//        InnerArray.append(innerDict)
//
//        dict["data"].arrayObject = InnerArray
        self.arrayMain.append(dict)

        
        //For Custom selection
        dict = JSON()
        dict["title"].stringValue = "Custom"
        dict["selected"].boolValue = false
        
        InnerArray = [JSON]()
        
        innerDict = JSON()
        innerDict["name"].stringValue = "Monday"
        innerDict["selected_day"].boolValue = false
        innerDict["openning_hours"].stringValue = ""
        innerDict["break"].stringValue = ""
        InnerArray.append(innerDict)
        
        innerDict = JSON()
        innerDict["name"].stringValue = "Tuesday"
        innerDict["selected_day"].boolValue = false
        innerDict["openning_hours"].stringValue = ""
        innerDict["break"].stringValue = ""
        InnerArray.append(innerDict)
        
        innerDict = JSON()
        innerDict["name"].stringValue = "Wednesday"
        innerDict["selected_day"].boolValue = false
        innerDict["openning_hours"].stringValue = ""
        innerDict["break"].stringValue = ""
        InnerArray.append(innerDict)
        
        innerDict = JSON()
        innerDict["name"].stringValue = "Thursday"
        innerDict["selected_day"].boolValue = false
        innerDict["openning_hours"].stringValue = ""
        innerDict["break"].stringValue = ""
        InnerArray.append(innerDict)
        
        innerDict = JSON()
        innerDict["name"].stringValue = "Friday"
        innerDict["selected_day"].boolValue = false
        innerDict["openning_hours"].stringValue = ""
        innerDict["break"].stringValue = ""
        InnerArray.append(innerDict)
        
        innerDict = JSON()
        innerDict["name"].stringValue = "Saturday"
        innerDict["selected_day"].boolValue = false
        innerDict["openning_hours"].stringValue = ""
        innerDict["break"].stringValue = ""
        InnerArray.append(innerDict)
        
        innerDict = JSON()
        innerDict["name"].stringValue = "Sunday"
        innerDict["selected_day"].boolValue = false
        innerDict["openning_hours"].stringValue = ""
        innerDict["break"].stringValue = ""
        InnerArray.append(innerDict)
        
        dict["data"].arrayObject = InnerArray
        
        self.arrayMain.append(dict)

        
    }
    
    func showDetails() {
        var isCustom:Bool = true
        for data in self.nameArray {
            for (indexPath, dataValue) in self.headerArrayName.enumerated() {
                if dataValue == data {
                    headerArraySelected[indexPath] = true
                    isCustom = false
                }
            }
        }
        
        if isCustom {
            self.headerArraySelected[4] = true
            for data in self.nameArray {
                for (indexPath, dataValue) in self.customArray.enumerated() {
                    if dataValue == data {
                        customArraySelected[indexPath] = true
                        isCustom = false
                    }
                }
            }
        }
    }
    
    func getDetails() {
        var isCustom:Bool = false
        var nameArray: [String] = []
        for (index, _) in self.headerArray.enumerated() {
            if headerArraySelected[index] == true {
                if index == 4 {
                    isCustom = true
                }
                else {
                    nameArray.append(headerArrayName[index])
                }
            }
        }
        
        if isCustom {
            for (index, _) in self.customArray.enumerated() {
                if customArraySelected[index] == true {
                    nameArray.append(customArray[index])
                }
            }
        }
        self.delegate?.SelectAvailabilityFinish(isCustom: isCustom, AvailabilityArray: nameArray)
    }
}


//MARK: - Navigation delegate
extension ProfessionalSelectAvailabilityViewModel: CustomNavigationWithSaveButtonDelegate{
    
    func CustomNavigationClose() {
        self.getDetails()
        self.theController.backButtonAction()
    }
    
    func CustomNavigationSave() {
        
    }

}

//MARK:- Calendar related functions
extension ProfessionalSelectAvailabilityViewModel {
    
    func makeDateArray(date: Date, position:Int, PreviousCount: Int, currentCount:Int) -> NSDictionary {
    
        var arrayDate:[String] = []
        var arrayNo:[Int] = []
        var isEnable:[Bool] = []
        
        if position != 1 {
            for i in (PreviousCount - (position - 2))...PreviousCount {
                arrayNo.append(i)
                let day = i > 9 ? "\(i)" : "0\(i)"
                arrayDate.append((date.getPreviousMonth()?.year)! + "-" + (date.getPreviousMonth()?.month)! + "-" + day)
                isEnable.append(false)
            }
        }
        
        for i in 1...currentCount {
            arrayNo.append(i)
            let day = i > 9 ? "\(i)" : "0\(i)"
            arrayDate.append((date.year) + "-" + (date.month) + "-" + day)
            isEnable.append(true)
        }
        
        if arrayNo.count < 42 {
            for i in 1...(42 - arrayNo.count) {
                arrayNo.append(i)
                let day = i > 9 ? "\(i)" : "0\(i)"
                arrayDate.append((date.getNextMonth()?.year)! + "-" + (date.getNextMonth()?.month)! + "-" + day)
                isEnable.append(false)
            }
        }
        return ["no":arrayNo,"date":arrayDate, "is_enable": isEnable]
    }
    
}
