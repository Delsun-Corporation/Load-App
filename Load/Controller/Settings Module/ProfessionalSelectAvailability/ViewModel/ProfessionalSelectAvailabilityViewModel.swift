//
//  ProfessionalSelectAvailabilityViewModel.swift
//  Load
//
//  Created by Haresh Bhai on 04/09/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol SelectAvailabilityDelegate: AnyObject {
    func SelectAvailabilityFinish(AvailabilityArray: [[String: Any]])
}

class ProfessionalSelectAvailabilityViewModel {

    //MARK:- Variables
    fileprivate weak var theController:ProfessionalSelectAvailabilityVC!
    var headerArray:[String] = ["Any day", "Weekdays only", "Weekends only", "Message to discuss", "Custom"]
    var headerArraySelected:[Bool] = [false, false, false, false, false]
    var headerArrayName:[String] = ["ANY_DAY", "WEEKDAYS_ONLY", "WEEKENDS_ONLY", "MESSAGE_TO_DISCUSS", "CUSTOM"]

    var customArray:[String] = ["MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY", "SUNDAY"]
    var customArraySelected:[Bool] = [false, false, false, false, false, false, false]
    var defaultHours: String = "00:00 AM - 00:00 PM"
    
    weak var delegate:SelectAvailabilityDelegate?
    
    var availability: [ProfessionalAvailability]?
    
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
        
        guard let view = self.theController.view as? ProfessionalSelectAvailabilityView else {
            return
        }
        view.lblMonthName.text = self.currentShowMonth.toString(dateFormat: "MMMM yyyy").uppercased()
        view.tblCalendar.reloadData()
        
        if availability == nil || availability?.isEmpty == true {
            makeMainArray()
        } else {
            showDetails()
        }
        
        view.tblShowData.reloadData()
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
        innerDict["openning_hours"].stringValue = defaultHours
        innerDict["break"].stringValue = defaultHours
        InnerArray.append(innerDict)
        
        innerDict = JSON()
        innerDict["name"].stringValue = "Tuesday"
        innerDict["selected_day"].boolValue = false
        innerDict["openning_hours"].stringValue = defaultHours
        innerDict["break"].stringValue = defaultHours
        InnerArray.append(innerDict)
        
        innerDict = JSON()
        innerDict["name"].stringValue = "Wednesday"
        innerDict["selected_day"].boolValue = false
        innerDict["openning_hours"].stringValue = defaultHours
        innerDict["break"].stringValue = defaultHours
        InnerArray.append(innerDict)
        
        innerDict = JSON()
        innerDict["name"].stringValue = "Thursday"
        innerDict["selected_day"].boolValue = false
        innerDict["openning_hours"].stringValue = defaultHours
        innerDict["break"].stringValue = defaultHours
        InnerArray.append(innerDict)
        
        innerDict = JSON()
        innerDict["name"].stringValue = "Friday"
        innerDict["selected_day"].boolValue = false
        innerDict["openning_hours"].stringValue = defaultHours
        innerDict["break"].stringValue = defaultHours
        InnerArray.append(innerDict)
        
        innerDict = JSON()
        innerDict["name"].stringValue = "Saturday"
        innerDict["selected_day"].boolValue = false
        innerDict["openning_hours"].stringValue = defaultHours
        innerDict["break"].stringValue = defaultHours
        InnerArray.append(innerDict)
        
        innerDict = JSON()
        innerDict["name"].stringValue = "Sunday"
        innerDict["selected_day"].boolValue = false
        innerDict["openning_hours"].stringValue = defaultHours
        innerDict["break"].stringValue = defaultHours
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
        innerDict["openning_hours"].stringValue = defaultHours
        innerDict["break"].stringValue = defaultHours
        InnerArray.append(innerDict)
        
        innerDict = JSON()
        innerDict["name"].stringValue = "Tuesday"
        innerDict["selected_day"].boolValue = false
        innerDict["openning_hours"].stringValue = defaultHours
        innerDict["break"].stringValue = defaultHours
        InnerArray.append(innerDict)
        
        innerDict = JSON()
        innerDict["name"].stringValue = "Wednesday"
        innerDict["selected_day"].boolValue = false
        innerDict["openning_hours"].stringValue = defaultHours
        innerDict["break"].stringValue = defaultHours
        InnerArray.append(innerDict)
        
        innerDict = JSON()
        innerDict["name"].stringValue = "Thursday"
        innerDict["selected_day"].boolValue = false
        innerDict["openning_hours"].stringValue = defaultHours
        innerDict["break"].stringValue = defaultHours
        InnerArray.append(innerDict)
        
        innerDict = JSON()
        innerDict["name"].stringValue = "Friday"
        innerDict["selected_day"].boolValue = false
        innerDict["openning_hours"].stringValue = defaultHours
        innerDict["break"].stringValue = defaultHours
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
        innerDict["openning_hours"].stringValue = defaultHours
        innerDict["break"].stringValue = defaultHours
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
        innerDict["openning_hours"].stringValue = defaultHours
        innerDict["break"].stringValue = defaultHours
        InnerArray.append(innerDict)
        
        innerDict = JSON()
        innerDict["name"].stringValue = "Tuesday"
        innerDict["selected_day"].boolValue = false
        innerDict["openning_hours"].stringValue = defaultHours
        innerDict["break"].stringValue = defaultHours
        InnerArray.append(innerDict)
        
        innerDict = JSON()
        innerDict["name"].stringValue = "Wednesday"
        innerDict["selected_day"].boolValue = false
        innerDict["openning_hours"].stringValue = defaultHours
        innerDict["break"].stringValue = defaultHours
        InnerArray.append(innerDict)
        
        innerDict = JSON()
        innerDict["name"].stringValue = "Thursday"
        innerDict["selected_day"].boolValue = false
        innerDict["openning_hours"].stringValue = defaultHours
        innerDict["break"].stringValue = defaultHours
        InnerArray.append(innerDict)
        
        innerDict = JSON()
        innerDict["name"].stringValue = "Friday"
        innerDict["selected_day"].boolValue = false
        innerDict["openning_hours"].stringValue = defaultHours
        innerDict["break"].stringValue = defaultHours
        InnerArray.append(innerDict)
        
        innerDict = JSON()
        innerDict["name"].stringValue = "Saturday"
        innerDict["selected_day"].boolValue = false
        innerDict["openning_hours"].stringValue = defaultHours
        innerDict["break"].stringValue = defaultHours
        InnerArray.append(innerDict)
        
        innerDict = JSON()
        innerDict["name"].stringValue = "Sunday"
        innerDict["selected_day"].boolValue = false
        innerDict["openning_hours"].stringValue = defaultHours
        innerDict["break"].stringValue = defaultHours
        InnerArray.append(innerDict)
        
        dict["data"].arrayObject = InnerArray
        
        self.arrayMain.append(dict)

        
    }
    
    func showDetails() {
        guard let availability = availability else {
            return
        }

        for object in availability {
            var dict = JSON()
            dict["title"].stringValue = object.title ?? ""
            dict["selected"].boolValue = object.selected ?? false
            
            var InnerArray = [JSON]()
            
            for data in object.data ?? [] {
                var innerDict = JSON()
                innerDict["name"].stringValue = data.name ?? ""
                innerDict["selected_day"].boolValue = data.selectedDay ?? false
                innerDict["openning_hours"].stringValue = data.openingHours ?? defaultHours
                innerDict["break"].stringValue = data.break ?? defaultHours
                InnerArray.append(innerDict)
            }
            
            dict["data"].arrayObject = InnerArray
            
            self.arrayMain.append(dict)
        }
    }
    
    func getDetails() {
        var selectedArray: [[String: Any]] = []
        
        for object in arrayMain {
            var _selectedArray: [String: Any] = [:]
            _selectedArray["title"] = object["title"].stringValue
            _selectedArray["selected"] = object["selected"].boolValue
            _selectedArray["data"] = object["data"].arrayObject
            selectedArray.append(_selectedArray)
        }
        
        self.delegate?.SelectAvailabilityFinish(AvailabilityArray: selectedArray)
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
