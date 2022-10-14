//
//  Constant.swift
//  Berry
//
//  Created by Haresh Bhai on 29/10/18.
//  Copyright © 2018 Haresh Bhai. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import CoreLocation
import AudioToolbox

//MARK: - Variables
let GOOGLE_MAP_KEY = "AIzaSyBV0HIVN8V1IUiaVB9TocO6hcJfwKWfUMM"

let googleMapKey = "AIzaSyBOOpOc8SNjr5x5WWgZIhz5g-lINaelIDI" 

let SERVER_VALIDATION = SLOW_INTERNET_VALIDATION
let SLOW_INTERNET_VALIDATION = "The network connection was lost"

let userDefault = UserDefaults.standard
let USER_DETAILS_KEY = "userDetails"
var SELECTED_ACCOUNT_TYPE = "Free"

var SELECTED_LIBRARY_TAB = ""
var SELECTED_EXERCISE_LIBRARY_TAB = ""
var SELECTED_LOADCENTER_TAB = 0
var FILTER_MODEL:FilterModelClass?

var GetAllData: GetAllDataModelClass?
var TEST_IMAGE_URL = "https://avatars3.githubusercontent.com/u/13130705?v=4"
var TEST_COVER_IMAGE_URL = "https://www.incimages.com/uploaded_files/image/970x450/getty_509107562_2000133320009280346_351827.jpg"

//Check vimeo video exist or not base url
var strVimeoBaseURL = "https://vimeo.com/api/oembed.json?url="
var strYoutubeBaseURL = "https://www.youtube.com/oembed?format=json&url="
let serverDateFormatter: DateFormatter = {
    let result = DateFormatter()
    result.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SZ"
    result.locale = Locale(identifier: "en_US_POSIX")
    result.timeZone = TimeZone(secondsFromGMT: 0)
    return result
}()

func LOADLog(_ message: Any) {
    #if DEBUG
    print("\(message)")
    #endif
}


func getSecondsToHoursMinutesSeconds (seconds:Int) -> String {
    if seconds == 0 {
        return "0 Sec"
    }
    let (h, m, s) = secondsToHoursMinutesSeconds (seconds: seconds)
    if s == 0 {
        return "\(getStringFrom(seconds: h)) Hours \(getStringFrom(seconds: m)) Min"
    }
    return "\(getStringFrom(seconds: h)) Hours \(getStringFrom(seconds: m)) Min \(getStringFrom(seconds: s)) Sec"
}

func getSecondsToHoursMinutesSecondsFormate(seconds:Int) -> String {
    if seconds == 0 {
        return "00:00:00"
    }
    let (h, m, s) = secondsToHoursMinutesSeconds (seconds: seconds)
    if s == 0 {
        return "\(getStringFrom(seconds: h)):\(getStringFrom(seconds: m)):00"
    }
    return "\(getStringFrom(seconds: h)):\(getStringFrom(seconds: m)):\(getStringFrom(seconds: s))"
}

func geHoursMinutesSecondsTOSecondsFormate(data:String) -> String {
    let firstArray = data.split(separator: ":")
    
    var fHr = 0.0
    var fMin = 0.0
    var fSec = 0.0
    
    if firstArray.count == 3{
        fHr = (Double(firstArray[0] ) ?? 0) * 60 * 60
        fMin = (Double(firstArray[1]) ?? 0) * 60
        fSec = (Double(firstArray[2]) ?? 0)
    }else if firstArray.count == 2 {
        fHr = (Double(firstArray[0] ) ?? 0) * 60
        fMin = (Double(firstArray[1]) ?? 0)
    }else if firstArray.count == 1{
        fHr = (Double(firstArray[0] ) ?? 0) * 60
    }
    
    let firstCount = fHr + fMin + fSec
    return "\(firstCount)"
}

func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
    return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
}

func getStringFrom(seconds: Int) -> String {
    return seconds < 10 ? "0\(seconds)" : "\(seconds)"
}

func getPlacemark(forLocation location: CLLocation, completionHandler: @escaping (CLPlacemark?, String?) -> ()) {
    let geocoder = CLGeocoder()
    
    geocoder.reverseGeocodeLocation(location, completionHandler: {
        placemarks, error in
        
        if let err = error {
            completionHandler(nil, err.localizedDescription)
        } else if let placemarkArray = placemarks {
            if let pm = placemarkArray.first {
                //                    print(pm.country)
                //                    print(pm.locality)
                //                    print(pm.subLocality)
                //                    print(pm.thoroughfare)
                //                    print(pm.postalCode)
                //                    print(pm.subThoroughfare)
                var addressString : String = ""
                if pm.subLocality != nil {
                    addressString = addressString + pm.subLocality! + ", "
                }
                if pm.thoroughfare != nil {
                    addressString = addressString + pm.thoroughfare! + ", "
                }
                if pm.locality != nil {
                    addressString = addressString + pm.locality! + ", "
                }
                if pm.country != nil {
                    addressString = addressString + pm.country! + ", "
                }
                if pm.postalCode != nil {
                    addressString = addressString + pm.postalCode! + " "
                }
                completionHandler(pm, addressString)
            } else {
                completionHandler(nil, "Placemark was nil")
            }
        } else {
            completionHandler(nil, "Unknown error")
        }
    })
}

func getCountryName(forLocation location: CLLocation, completionHandler: @escaping (CLPlacemark?, String?) -> ()) {
    let geocoder = CLGeocoder()
    
    geocoder.reverseGeocodeLocation(location, completionHandler: {
        placemarks, error in
        
        if let err = error {
            completionHandler(nil, err.localizedDescription)
        } else if let placemarkArray = placemarks {
            if let pm = placemarkArray.first {
                var addressString : String = ""
                
                if pm.country != nil {
                    addressString = addressString + pm.country!
                }
                completionHandler(pm, addressString)
            } else {
                completionHandler(nil, "Placemark was nil")
            }
        } else {
            completionHandler(nil, "Unknown error")
        }
    })
}

func getWeek(startDate:Date, endDate: Date, selectedDate:Date, days: [String]) -> (Int, Int)? {
    let weekdayTest = Calendar.current.component(.weekday, from: startDate).makeRealWeekDay()
    guard let testStartDate = Calendar.current.date(byAdding: .day, value: -(weekdayTest - 1), to: startDate) else {
        return nil
    }
    
    var weekNumber = 0
    let diffInDays = (Calendar.current.dateComponents([.day], from: testStartDate, to: selectedDate).day ?? 0) + 1
    let datesBetweenArray = Date.dates(from: testStartDate, to: selectedDate)
    
    var weekCount = 1
    var dayCount = 0
    
    for index in 0..<diffInDays {
        dayCount += 1
        
        if dayCount == 8 {
            weekCount += 1
            dayCount = 1
        }
        
        if weekNumber == days.count {
            weekNumber = 0
        }
        
        if datesBetweenArray.count != 0 {
            if datesBetweenArray[index] == selectedDate {
                let day = selectedDate.toString(dateFormat: "EEEE").uppercased()
                if days.contains(day) {
                    weekNumber += 1
                }
            }
            else {
                let day = datesBetweenArray[index].toString(dateFormat: "EEEE").uppercased()
                if days.contains(day) {
                    weekNumber += 1
                }
            }
        }
    }
    return (weekNumber, weekCount)
}

func json(from object:Any) -> String? {
    guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
        return nil
    }
    return String(data: data, encoding: String.Encoding.utf8)
}

extension Int {
    func makeRealWeekDay() -> Int {
        if self == 1 {
            return 7
        }
        else {
            return self - 1
        }
    }
}
func coachExperienceArray() -> [String] {
    var array:[String] = [String]()
    for i in 0..<51 {
        array.append("\(i)")
        array.append("\(i).5")
    }
    array.removeLast()   
    return array
}

func rateArray() -> [String] {
    var array:[String] = [String]()
    for i in 0..<6 {
        array.append("\(i)")
        array.append("\(i).5")
    }
    array.removeLast()
    return array
}

func genderArray() -> [String] {
    var array:[String] = [String]()
    array.append("Male")
    array.append("Female")
    array.append("Other")
    return array
}

func getCountryName(id:NSNumber) -> String {
    var name: String = ""
    for data in GetAllData?.data?.countries ?? [] {
        if id == data.id, let _name = data.name {
            name = _name
        }
    }
    return name
}

func getRegionName(id:NSNumber) -> String {
    var name: String = ""
    for data in GetAllData?.data?.regions ?? [] {
        if id == data.id, let _name = data.name {
            name = _name
        }
    }
    return name
}

func getRegionNames(ids:[String]) -> String {
    var name: String = ""
    
    for dataId in ids {
        for data in GetAllData?.data?.regions ?? [] {
            if dataId == data.id?.stringValue {
                if name.isEmpty {
                    name += data.name ?? ""
                }
                else {
                    name += ", " + (data.name ?? "")
                }
                
            }
        }
    }
    
    return name
}

func getTrainingGoalName(id: NSNumber) -> String {
    var name: String = ""
    for data in GetAllData?.data?.trainingGoal ?? [] {
        if id == data.id, let _name = data.name {
            name = _name
        }
    }
    return name
}

func getTrainingGoalTargetHRName(id:NSNumber) -> String {
    var name: String = ""
    for data in GetAllData?.data?.trainingGoal ?? [] {
        if id == data.id, let _targetHr = data.targetHr {
            name = _targetHr
        }
    }
    return name
}

func getIntensityName(id:NSNumber) -> String {
    var name: String = ""
    for data in GetAllData?.data?.trainingIntensity ?? [] {
        if id == data.id, let _name = data.name {
            name = _name
        }
    }
    return name
}

func getRaceDistanceName(id:Int) -> String {
    var name: String = ""
    for data in GetAllData?.data?.raceDistance ?? [] {
        if id == data.id?.intValue, let _name = data.name {
            name = _name
        }
    }
    return name
}

func getTrainingActivityPath(id:Int) -> String {
    var name: String = ""
    for data in GetAllData?.data?.trainingActivity ?? [] {
        if id == data.id?.intValue {
            name = data.iconPath ?? ""
        }
    }
    return name
}

func getLanguagesName(id:Int) -> String {
    var name: String = ""
    for data in GetAllData?.data?.languages ?? [] {
        if id == data.id?.intValue, let _name = data.name {
            name = _name
        }
    }
    return name
}

func getAccountName(id: Int? = nil, idStr: String? = nil) -> String {
    var name: String = "Free"
    if let _id = id {
        for data in GetAllData?.data?.accounts ?? [] {
            if _id == data.id?.intValue, let _name = data.name {
                name = _name.capitalized
            }
        }
    }
    else if let _id = idStr {
        for data in GetAllData?.data?.accounts ?? [] {
            if _id == data.idStr, let _name = data.name {
                name = _name.capitalized
            }
        }
    }
    
    return name
}

func getCategoryName(id:NSNumber) -> String {
    var name: String = ""
    for data in GetAllData?.data?.getSortedCategory() ?? [] {
        if id == data.id, let _name = data.name {
            name = _name
        }
    }
    return name
}

func getMechanicsName(id:NSNumber) -> String {
    var name: String = ""
    for data in GetAllData?.data?.mechanics ?? [] {
        if id == data.id, let _name = data.name {
            name = _name
        }
    }
    return name
}

func getTargetedMusclesName(ids:[String]) -> String {
    var name: String = ""
    
    for dataId in ids {
        for data in GetAllData?.data?.targetedMuscles ?? [] {
            if dataId == data.id?.stringValue {
                if name.isEmpty {
                    name += data.name ?? ""
                }
                else {
                    name += ", " + (data.name ?? "")
                }
            }
        }
    }
    
    return name
}

func getActionForceName(id:NSNumber) -> String {
    var name: String = ""
    for data in GetAllData?.data?.actionForce ?? [] {
        if id == data.id, let _name = data.name {
            name = _name
        }
    }
    return name
}

func getEquipmentsName(id:NSNumber) -> String {
    var name: String = ""
    for data in GetAllData?.data?.equipments ?? [] {
        if id == data.id, let _name = data.name {
            name = _name
        }
    }
    return name
}

func getEquipmentsNames(ids:[String]) -> String {
    var name: String = ""
    
    for dataId in ids {
        for data in GetAllData?.data?.equipments ?? [] {
            if dataId == data.id?.stringValue {
                if name == "" {
                    name += data.name ?? ""
                }
                else {
                    name += ", " + (data.name ?? "")
                }
            }
        }
    }
    
    return name
}

func getEquipmentsNames(ids:[Int]) -> String {
    var name: String = ""
    
    for dataId in ids {
        for data in GetAllData?.data?.equipments ?? [] {
            if dataId == data.id?.intValue {
                if name == "" {
                    name += data.name ?? ""
                }
                else {
                    name += ", " + (data.name ?? "")
                }
            }
        }
    }
    
    return name
}

func showAccountType(index:Int) -> String {
    if index == 0 {
        return ACCOUNT_TYPE.FREE.rawValue
    }
    else if index == 1 {
        return ACCOUNT_TYPE.PREMIUM.rawValue
    }
    else {
        return ACCOUNT_TYPE.PROFESSIONAL.rawValue
    }
}

//MARK: - Enum 
enum AppStoryboard : String {
    case Main = "Main"
    case Home = "Home"
    case Calendar = "Calendar"
    case Library = "Library"
    case LoadCenter = "LoadCenter"
    case Settings = "Settings"
    case Messages = "Messages"
    case SideMenu = "SideMenu"
    case OTP = "OTPStoryboard"
    var instance : UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
}

enum GENDER_TYPE: String {
    case MALE = "MALE"
    case FEMALE = "FEMALE"
    case OTHER = "OTHER"
}

enum PROFESSIONAL_LIST_TYPE:Int {
    case TYPE = 0
    case CANCELLATION = 1
    case PAYMENT = 2
}

enum LOAD_CENTER_TYPE:String {
    case FEED = "FEED"
    case REQUEST = "REQUEST"
    case EVENT = "EVENT"
    case LISTING = "LISTING"
}

enum VISIBLE_TO :String {
    case INVITATION_ONLY = "INVITATION_ONLY"
    case PUBLIC = "PUBLIC"
}

enum ACCOUNT_TYPE: String {
    case FREE = "Free"
    case PREMIUM = "Premium"
    case PROFESSIONAL = "Professional"
}

enum TRAINING_LOG_STATUS: String {
    case CARDIO = "CARDIO"
    case RESISTANCE = "RESISTANCE"
    case PRESET = "PRESET"
    case CUSTOM = "CUSTOM"
}

enum CLIENT_BOOKING_STATUS: String {
    case ACCEPTED = "ACCEPTED"
    case REJECTED = "REJECTED"
}

enum NOTIFICATION_CENTER_LIST: String {
    case RESISTANCE_NOTIFICATION = "RESISTANCE_NOTIFICATION"
    case CARDIO_NOTIFICATION = "CARDIO_NOTIFICATION"
    case LIBRARY_LIST_NOTIFICATION = "LIBRARY_LIST_NOTIFICATION"
    case LIBRARY_LIST_SEARCH_NOTIFICATION = "LIBRARY_LIST_SEARCH_NOTIFICATION"
    case LIBRARY_EXERCISE_LIST_SEARCH_NOTIFICATION = "LIBRARY_EXERCISE_LIST_SEARCH_NOTIFICATION"
    case LOAD_CENTER_CLOSE_CREATE_SCREEN = "LOAD_CENTER_CLOSE_CREATE_SCREEN"
    case LOAD_CENTER_SEARCH_NOTIFICATION = "LOAD_CENTER_SEARCH_NOTIFICATION"
    case LOAD_CENTER_FILTER_NOTIFICATION = "LOAD_CENTER_FILTER_NOTIFICATION"
    case MESSAGE_SEARCH_NOTIFICATION = "MESSAGE_SEARCH_NOTIFICATION"
    case EDIT_FOLLOWERS_NOTIFICATION = "EDIT_FOLLOWERS_NOTIFICATION"
    case CALENDAR_RELOADING = "CALENDAR_RELOADING"
    case LOAD_CENTER_EVENT_PAGE_REFRESH = "LOAD_CENTER_EVENT_PAGE_REFRESH"
    case LOAD_CENTER_BOOKMARK_PAGE_REFRESH = "LOAD_CENTER_BOOKMARK_PAGE_REFRESH"
    case LOAD_CENTER_REQUEST_LIST_UPDATE = "LOAD_CENTER_REQUEST_LIST_UPDATE"
    
    //    case OPEN_SAVEDWORKOUT_NOTIFICATION = "OPEN_SAVEDWORKOUT_NOTIFICATION"
    //    case HIDE_NAV_SAVEDWORKOUT_NOTIFICATION = "HIDE_NAV_SAVEDWORKOUT_NOTIFICATION"
    
    case LOAD_CARDIO_UPDATED_TOTAL_DISTANCE = "LOAD_CARDIO_UPDATED_TOTAL_DISTANCE"
    case LOAD_RESISTANCE_UPDATED_VOLUME = "LOAD_RESISTANCE_UPDATED_VOLUME"
    
    case LOAD_TRAINING_PROGRAM_CARDIO_TOTAL_DISTANCE = "LOAD_TRAINING_PROGRAM_CARDIO_TOTAL_DISTANCE"
    case LOAD_UPDATE_ADDED_BANK_CARD_RELOAD = "LOAD_UPDATE_ADDED_BANK_CARD_RELOAD"
    
}

enum TARGET_SHOW_OR_EDIT{
    case onlyShow
    case editable
}

enum MOVE_FROM_START_OR_COMPLETED_TRAINING_PROGRAM_CARDIO{
    case clickOnStart
    case clickOnComplete
}

enum MOVE_FROM_GENERATED_CALCULATION_TRAINING_LOG_OR_PROGRAM{
    case trainingLog
    case trainingProgram
}

enum OPPOSITE_USER_ACCOUNT_TYPE {
    case premium,free
    case professional
}

//MARK: - Functions
func ShowProgress() {
    //    SVProgressHUD.show()
}

func DismissProgress() {
    //    SVProgressHUD.dismiss()
}

func convertDate(_ date: String, dateFormat: String) -> Date {
    if date.isEmpty {
        return Date()
    }
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = dateFormat
    let date = dateFormatter.date(from: date)
    return date ?? Date()
}

func convertDateFormater(_ date: String, format:String = "yyyy-MM-dd HH:mm:ss", dateFormat: String) -> String {
    if date.isEmpty {
        return ""
    }
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    guard let date = dateFormatter.date(from: date) else {
        return ""
    }
    dateFormatter.dateFormat = dateFormat
    return dateFormatter.string(from: date)
}

func convertStringToISO8601(_ date: String, dateFormat: String) -> String {
    if date == "" {
        return ""
    }
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = dateFormat
    let date = dateFormatter.date(from: date)
    return (date?.iso8601) ?? ""
}

func DateToString(Formatter:String,date:Date) -> String{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = Formatter
    //  dateFormatter.locale = NSLocale(localeIdentifier: "en_US") as Locale!
    let FinalDate:String = dateFormatter.string(from: date)
    return FinalDate
}

extension UIImageView {
    func setCircle() {
        self.layer.cornerRadius = self.bounds.width / 2
        self.clipsToBounds = true
    }
    
    func setImageColor(color: UIColor) {
      let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
      self.image = templateImage
      self.tintColor = color
    }

}

extension UILabel {
    func setColor(color: UIColor) {
        self.textColor = color
    }
    
    func setColorWithAlpha(color: UIColor, set: CGFloat) {
        self.textColor = color.withAlphaComponent(set)
    }
}


extension UITextField {
    func setColor(color: UIColor) {
        self.textColor = color
    }
}

extension UITextView {
    func setColor(color: UIColor) {
        self.textColor = color
    }
}

extension UIButton {
    func setColor(color: UIColor) {
        self.setTitleColor(color, for: .normal)
    }
    
    func setTitle(str: String) {
        self.setTitle(str, for: .normal)
    }
}


extension String {
    func localToUTC(dateFormat:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.calendar = NSCalendar.current
        dateFormatter.timeZone = TimeZone.current
        
        guard let dt = dateFormatter.date(from: self) else {
            return ""
        }
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = dateFormat
        
        return dateFormatter.string(from: dt)
    }
    
    func UTCToLocal(dateFormat:String = "yyyy-MM-dd HH:mm:ss", returnFormat:String = "yyyy-MM-dd HH:mm:ss") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        if self == "" {
            return ""
        }
        guard let dt = dateFormatter.date(from: self) else {
            return ""
        }
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = returnFormat
        
        return dateFormatter.string(from: dt)
    }
    
    func getYear() -> Int {
        let start = self        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        guard let startDate = dateFormatter.date(from: start) else {
            return 0
        }
        let endDate:Date = Date()
        let cal = NSCalendar.current
        let components = cal.dateComponents([.year], from: startDate, to: endDate)
        return components.year ?? 0
    }
    
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
    
    func heightOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.height
    }
    
    func sizeOfString(usingFont font: UIFont) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        return self.size(withAttributes: fontAttributes)
    }
    
    func convertDateFormater(format:String = "yyyy-MM-dd HH:mm:ss", isUTC:Bool = false) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        if isUTC {
            dateFormatter.timeZone = TimeZone(identifier: "UTC")
        }
        let date = dateFormatter.date(from: self)
//        if date == nil{  
//            return Date()
//        }
        return date ?? Date()
    }
}

extension Date {
    func isBetweeen(date date1: Date, andDate date2: Date) -> Bool {
        return date1.compare(self) == self.compare(date2)
    }
    static func dates(from fromDate: Date, to toDate: Date) -> [Date] {
        var dates: [Date] = []
        var date = fromDate
        
        while date <= toDate {
            dates.append(date)
            guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else { break }
            date = newDate
        }
        return dates
    }
}


extension UINavigationController {
    
    func isHidden(isShow:Bool) {
        self.navigationBar.isHidden = !isShow
    }
    
    func getBarHeight() -> CGFloat {
        let navigationBarHeight: CGFloat = self.navigationBar.frame.height
        return navigationBarHeight
    }
    
    func setColor() {
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithDefaultBackground()
            appearance.backgroundImage = UIImage(named: "ic_header")?.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch)
            
            // Apply white color to all the nav bar buttons.
            let barButtonItemAppearance = UIBarButtonItemAppearance(style: .plain)
            barButtonItemAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.white]
            barButtonItemAppearance.disabled.titleTextAttributes = [.foregroundColor: UIColor.lightText]
            barButtonItemAppearance.highlighted.titleTextAttributes = [.foregroundColor: UIColor.label]
            barButtonItemAppearance.focused.titleTextAttributes = [.foregroundColor: UIColor.white]
            appearance.buttonAppearance = barButtonItemAppearance
            appearance.backButtonAppearance = barButtonItemAppearance
            appearance.doneButtonAppearance = barButtonItemAppearance
            
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
            navigationBar.standardAppearance = appearance
            navigationBar.scrollEdgeAppearance = appearance
            
        }
        else {
            self.navigationBar.setBackgroundImage(UIImage(named: "ic_header")?.resizeImage(targetSize: CGSize(width: UIScreen.main.bounds.width, height: 85), customHeight: getBarHeight()), for: .default)
            self.navigationBar.isTranslucent = false
        }
//        navigationBar.tintColor = .white
//        navigationBar.barTintColor = .white
//        self.navigationBar.isTranslucent = false
    }
    
    func setWhiteColor() {
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithDefaultBackground()
            appearance.backgroundImage = nil
            appearance.backgroundColor = .white
            appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
            appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
            navigationBar.standardAppearance = appearance
            navigationBar.scrollEdgeAppearance = appearance
        }
        else {
            self.navigationBar.shadowImage = UIImage()
            self.navigationBar.backgroundColor = .white
            self.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.navigationBar.isTranslucent = false
        }
//        navigationBar.tintColor = .black
//        navigationBar.barTintColor = .black
//        self.navigationBar.backgroundColor = .white
//        self.navigationBar.isTranslucent = false
    }
    
    func setWhiteColorWithLine() {
        self.navigationBar.backgroundColor = .white
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.isTranslucent = false
    }
    
    func setClearColor() {
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            appearance.backgroundImage = nil
            appearance.backgroundColor = .white
            navigationBar.standardAppearance = appearance
            navigationBar.scrollEdgeAppearance = appearance
        }
        
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.backgroundColor = .clear
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.isTranslucent = true
    }
    
    func removeShadow(){
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = true
        self.navigationBar.layer.shadowColor = UIColor.clear.cgColor
        self.navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.navigationBar.layer.shadowRadius = 0.0
        self.navigationBar.layer.shadowOpacity = 0.0
        self.navigationBar.layer.masksToBounds = false
    }
    
    func addShadow(){
        self.navigationBar.layer.shadowColor = UIColor.lightGray.cgColor
        self.navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 7)
        self.navigationBar.layer.shadowRadius = 7.0
        self.navigationBar.layer.shadowOpacity = 0.4
        self.navigationBar.layer.masksToBounds = false
    }
    
}


extension String {
    func replace(target: String, withString: String) -> String {
        return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
    }
}

struct DateISO: Codable {
    var date: Date
}

extension Date{
    var iso8601: String {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        guard let data = try? encoder.encode(DateISO(date: self)),
            let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as?  [String: String]
            else { return "" }
        return json.first?.value ?? ""
    }
}


extension UIImage {
    class func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 0.5)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image : UIImage = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()
        return image
    }
    
    func resizeImage(targetSize: CGSize, customHeight:CGFloat = 0) -> UIImage {
        let size = self.size
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        let newSize = widthRatio > heightRatio ?  CGSize(width: size.width * heightRatio, height: size.height * heightRatio) : CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        
        var topPadding: CGFloat = 20
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            topPadding = (window?.safeAreaInsets.top) ?? 0
        }
        
        let height = customHeight == 0 ? newSize.height : (customHeight + topPadding+2)
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: height)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage ?? UIImage()
    }
    
    func resize(maxWidthHeight : Double)-> UIImage? {
        
        let actualHeight = Double(size.height)
        let actualWidth = Double(size.width)
        var maxWidth = 0.0
        var maxHeight = 0.0
        
        if actualWidth > actualHeight {
            maxWidth = maxWidthHeight
            let per = (100.0 * maxWidthHeight / actualWidth)
            maxHeight = (actualHeight * per) / 100.0
        }else{
            maxHeight = maxWidthHeight
            let per = (100.0 * maxWidthHeight / actualHeight)
            maxWidth = (actualWidth * per) / 100.0
        }
        
        let hasAlpha = true
        let scale: CGFloat = 0.0
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: maxWidth, height: maxHeight), !hasAlpha, scale)
        self.draw(in: CGRect(origin: .zero, size: CGSize(width: maxWidth, height: maxHeight)))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage
    }
}

enum VerticalLocation: String {
    case bottom
    case top
}

extension UIView {
    func addShadow(location: VerticalLocation, color: UIColor = .black, opacity: Float = 0.5, radius: CGFloat = 5.0) {
        switch location {
        case .bottom:
            addShadow(offset: CGSize(width: 0, height: 10), color: color, opacity: opacity, radius: radius)
        case .top:
            addShadow(offset: CGSize(width: 0, height: -5), color: color, opacity: opacity, radius: radius)
        }
    }
    
    func addShadow(offset: CGSize, color: UIColor = .black, opacity: Float = 0.5, radius: CGFloat = 5.0) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
    }
    
     var safeAreaHeight: CGFloat {
         if #available(iOS 11, *) {
          return safeAreaLayoutGuide.layoutFrame.size.height
         }
         return bounds.height
    }

}


extension UIScrollView {
    func scrollToTop() {
        let desiredOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(desiredOffset, animated: true)
    }
}

extension String {
    func toFloat() -> CGFloat {
        
        if let n = NumberFormatter().number(from:self) {
            return CGFloat(truncating: n)
        }
        return 0.0
    }
}

func isValidEmail(testStr:String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: testStr)
}

func isValidPassword(testStr:String?) -> Bool {
    guard let testStr = testStr else {
        return false
    }
    // at least one digit
    // at least one lowercase
    // 8 characters total
    //        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{6,}")
    //    let passwordTest = NSPredicate(format: "SELF MATCHES %@", "(?=.*[0-9])(?=.*[a-z])(?=.*[@$!%^+=_~<>*#?&`{|-}`{/.,}`{'\"}`{•¥£€}`{:;}`{()}]).{6,}")
    let passwordTest = NSPredicate(format: "SELF MATCHES %@", "(?=.*[0-9])(?=.*[@$!%^+=_~<>*#?&`{|-}`{/.,}`{'\"}`{•¥£€}`{:;}`{()}]).{8,}")
    
    return passwordTest.evaluate(with: testStr)
}

func jsonString(from object:Any) -> String? {
    guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
        return nil
    }
    return String(data: data, encoding: String.Encoding.utf8)
}

func randomString(length: Int) -> String {
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    return String((0...length-1).map{ _ in (letters.randomElement() ?? String.Element("")) })
}

func isKeyPresentInUserDefaults(key: String) -> Bool {
    return UserDefaults.standard.object(forKey: key) != nil
}

func validatePhoneNumber(value: String) -> Bool {    
    let PHONE_REGEX = "^\\d{3}\\d{3}\\d{4}$"
    let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
    let result =  phoneTest.evaluate(with: value)
    return result
}

func timeAgoSinceDateNew(date:NSDate, numericDates:Bool) -> String {
    let calendar = NSCalendar.current
    let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
    let now = NSDate()
    let earliest = now.earlierDate(date as Date)
    let latest = (earliest == now as Date) ? date : now
    let components = calendar.dateComponents(unitFlags, from: earliest as Date,  to: latest as Date)
    let year = components.year ?? 0
    let month = components.month ?? 0
    let day = components.day ?? 0
    let weekOfYear = components.weekOfYear ?? 0
    let hour = components.hour ?? 0
    let minute = components.minute ?? 0
    let second = components.second ?? 0
    
    if (year >= 2) {
        return "\(year) years ago"
    } else if (year >= 1){
        if (numericDates){
            return "1 year ago"
        } else {
            return "Last year"
        }
    } else if (month >= 2) {
        return "\(month) months ago"
    } else if (month >= 1){
        if (numericDates){
            return "1 month ago"
        } else {
            return "Last month"
        }
    } else if (weekOfYear >= 2) {
        return "\(weekOfYear) weeks ago"
    } else if (weekOfYear >= 1){
        if (numericDates){
            return "1 week ago"
        } else {
            return "Last week"
        }
    } else if (day >= 2) {
        return "\(day) days ago"
    } else if (day >= 1){
        if (numericDates){
            return "1 day ago"
        } else {
            return "Yesterday"
        }
    } else if (hour >= 2) {
        return "\(hour) hours ago"
    } else if (hour >= 1){
        if (numericDates){
            return "1 hour ago"
        } else {
            return "An hour ago"
        }
    } else if (minute >= 2) {
        return "\(minute) minutes ago"
    } else if (minute >= 1){
        if (numericDates){
            return "1 minute ago"
        } else {
            return "A minute ago"
        }
    } else if (second >= 3) {
        return "\(second) seconds ago"
    } else {
        return "Just now"
    }
}

//func AlertView(title: String, message: String)
//{
//    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
//    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
//
//    let alertWindow = UIWindow(frame: UIScreen.main.bounds)
//    alertWindow.rootViewController = UIViewController()
//    alertWindow.windowLevel = UIWindow.Level.alert + 1;
//    alertWindow.makeKeyAndVisible()
//    alertWindow.rootViewController?.present(alert, animated: true, completion: nil)
//}

func setColorWithName(mainString: String, stringToColor: String) -> NSAttributedString {
    let range = (mainString as NSString).range(of: stringToColor)
    
    let attribute = NSMutableAttributedString.init(string: mainString)
    attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: ColorOrange() , range: range)
    
    return attribute
}

public func saveJSON(j: JSON, key: String) {
    guard let json = j.rawString() else {
        return
    }
    userDefault.setValue(json, forKey: key)
    // here I save my JSON as a string
}

public func loadJSON(key: String) -> JSON {
    guard let json =  UserDefaults.standard.string(forKey: key)else {
        return JSON()
    }
    return isKeyPresentInUserDefaults(key: key) ? JSON.init(parseJSON: json) : JSON()
    // JSON from string must be initialized using .parse()
}

public func deleteJSON(key:String) {
    userDefault.removeObject(forKey: key)
}


//MARK: - Functions Color
func ColorOrange() -> UIColor {
    return UIColor(red: 218/255, green: 115/255, blue: 64/255, alpha: 1)
}

func ColorGraydark() -> UIColor {
    return UIColor(red: 244/255, green: 244/255, blue: 245/255, alpha: 1)
}

func ColorGray() -> UIColor {
    return UIColor(red: 163/255, green: 165/255, blue: 168/255, alpha: 1)
}

func ColorBGCard() -> UIColor {
    return UIColor(red: 241/255, green: 242/255, blue: 243/255, alpha: 1)
}

//MARK: - @IBDesignable

@IBDesignable class LabelButton: UILabel {
    var onClick: () -> Void = {}
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        onClick()
    }
}


//MARK: - Extensions

extension UITableView {
    func reloadData(completion: @escaping ()->()) {
        UIView.animate(withDuration: 0, animations: { self.reloadData() })
        { _ in completion() }        
    }
}

extension UICollectionView {
    func reloadData(completion: @escaping ()->()) {
        UIView.animate(withDuration: 0, animations: { self.reloadData() })
        { _ in completion() }
    }
}

extension UITapGestureRecognizer {
    
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText ?? NSAttributedString(string: ""))
        
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: 
            locationOfTouchInLabel.y - textContainerOffset.y);
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
}


extension UIImage {
    
    public class func gifImageWithData(data: NSData) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data, nil) else {
            return nil
        }
        
        return UIImage.animatedImageWithSource(source: source)
    }
    
    public class func gifImageWithURL(gifUrl:String) -> UIImage? {
        guard let bundleURL = NSURL(string: gifUrl)
            else {
                return nil
        }
        guard let imageData = NSData(contentsOf: bundleURL as URL) else {
            return nil
        }
        
        return gifImageWithData(data: imageData)
    }
    
    public class func gifImageWithName(name: String) -> UIImage? {
        guard let bundleURL = Bundle.main
            .url(forResource: name, withExtension: "gif") else {
                print("SwiftGif: This image named \"\(name)\" does not exist")
                return nil
        }
        
        guard let imageData = NSData(contentsOf: bundleURL) else {
            print("SwiftGif: Cannot turn image named \"\(name)\" into NSData")
            return nil
        }
        
        return gifImageWithData(data: imageData)
    }
    
    class func delayForImageAtIndex(index: Int, source: CGImageSource!) -> Double {
        var delay = 0.1
        
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifProperties: CFDictionary = unsafeBitCast(CFDictionaryGetValue(cfProperties, Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()), to: CFDictionary.self)
        
        var delayObject: AnyObject = unsafeBitCast(CFDictionaryGetValue(gifProperties, Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()), to: AnyObject.self)
        
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties, Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
        }
        
        delay = (delayObject as? Double) ?? 0.0
        
        if delay < 0.1 {
            delay = 0.1
        }
        
        return delay
    }
    
    class func gcdForPair(a: Int?, _ b: Int?) -> Int {
        var a = a
        var b = b
        if b == nil || a == nil {
            if b != nil {
                return b!
            } else if a != nil {
                return a!
            } else {
                return 0
            }
        }
        
        if let _a = a, let _b = b, _a < _b {
            let c = _a
            a = _b
            b = c
        }
        
        var rest: Int
        while true {
            if let _a = a, let _b = b {
                rest = _a % _b
                
                if rest == 0 {
                    return _b
                } else {
                    a = _b
                    b = rest
                }
            }
        }
    }
    
    class func gcdForArray(array: Array<Int>) -> Int {
        if array.isEmpty {
            return 1
        }
        
        var gcd = array[0]
        
        for val in array {
            gcd = UIImage.gcdForPair(a: val, gcd)
        }
        
        return gcd
    }
    
    class func animatedImageWithSource(source: CGImageSource) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        var images = [CGImage]()
        var delays = [Int]()
        
        for i in 0..<count {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(image)
            }
            
            let delaySeconds = UIImage.delayForImageAtIndex(index: Int(i), source: source)
            delays.append(Int(delaySeconds * 1000.0)) // Seconds to ms
        }
        
        let duration: Int = {
            var sum = 0
            
            for val: Int in delays {
                sum += val
            }
            
            return sum
        }()
        
        let gcd = gcdForArray(array: delays)
        var frames = [UIImage]()
        
        var frame: UIImage
        var frameCount: Int
        for i in 0..<count {
            frame = UIImage(cgImage: images[Int(i)])
            frameCount = Int(delays[Int(i)] / gcd)
            
            for _ in 0..<frameCount {
                frames.append(frame)
            }
        }
        
        let animation = UIImage.animatedImage(with: frames, duration: Double(duration) / 1000.0)
        
        return animation
    }
}

extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    func jpeg(_ quality: JPEGQuality) -> Data? {
        return self.jpegData(compressionQuality:  quality.rawValue)
    }
    
    func png() -> Data? {
        return self.pngData()
    }
}

extension String {
    func toTrim() -> String {
        let trimmedString = self.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmedString
    }
}

extension UIView {    
    //Button animation
    func fadeIn() {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: nil)
    }
    
    func fadeOut() {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.alpha = 0.0
        }, completion: nil)
    }
}

private struct AssociatedKeys {
    static var section = "section"
    static var row = "row"
}

extension UIButton {
    var section : Int {
        get {
            guard let number = objc_getAssociatedObject(self,   &AssociatedKeys.section) as? Int else {
                return -1
            }
            return number
        }
        
        set(value) {
            objc_setAssociatedObject(self,&AssociatedKeys.section,Int(value),objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    var row : Int {
        get {
            guard let number = objc_getAssociatedObject(self, &AssociatedKeys.row) as? Int else {
                return -1
            }
            return number
        }
        
        set(value) {
            objc_setAssociatedObject(self,&AssociatedKeys.row,Int(value),objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

extension UIView {
    
    // OUTPUT 1
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 1
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, frame: CGRect,radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        layer.shadowPath = UIBezierPath(rect: frame).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}


extension NSMutableAttributedString {
    
    func setColorForText(textForAttribute: String, withColor color: UIColor) {
        let range: NSRange = self.mutableString.range(of: textForAttribute, options: .caseInsensitive)
        
        // Swift 4.2 and above
        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        
        // Swift 4.1 and below
        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
    }
    
}

extension NSMutableAttributedString {
    @discardableResult func bold(_ text: String, font: UIFont = themeFont(size: 13, fontname: .HelveticaBold)) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [.font: font]
        let boldString = NSMutableAttributedString(string:text, attributes: attrs)
        append(boldString)
        return self
    }
    
    @discardableResult func normal(_ text: String) -> NSMutableAttributedString {
        let normal = NSAttributedString(string: text)
        append(normal)        
        return self
    }
    
    @discardableResult func normal12(_ text: String, font: UIFont = themeFont(size: 12, fontname: .ProximaNovaRegular)) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [.font: font]
        let boldString = NSMutableAttributedString(string:text, attributes: attrs)
        append(boldString)
        return self
    }
}


extension TTTAttributedLabel {
    func showTextOnTTTAttributeLable(str: String, readMoreText: String, readLessText: String, font: UIFont?, charatersBeforeReadMore: Int, activeLinkColor: UIColor, isReadMoreTapped: Bool, isReadLessTapped: Bool) {
        
        let text = str + readLessText
        let attributedFullText = NSMutableAttributedString.init(string: text)
        let rangeLess = NSString(string: text).range(of: readLessText, options: String.CompareOptions.caseInsensitive)
        //Swift 5
        // attributedFullText.addAttributes([NSAttributedStringKey.foregroundColor : UIColor.blue], range: rangeLess)
        attributedFullText.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.appthemeRedColor], range: rangeLess)
        
        var subStringWithReadMore = ""
        if text.count > charatersBeforeReadMore {
            let start = String.Index(encodedOffset: 0)
            let end = String.Index(encodedOffset: charatersBeforeReadMore)
            subStringWithReadMore = String(text[start..<end]) + readMoreText
        }
        
        let attributedLessText = NSMutableAttributedString.init(string: subStringWithReadMore)
        let nsRange = NSString(string: subStringWithReadMore).range(of: readMoreText, options: String.CompareOptions.caseInsensitive)
        //Swift 5
        // attributedLessText.addAttributes([NSAttributedStringKey.foregroundColor : UIColor.blue], range: nsRange)
        attributedLessText.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.appthemeRedColor], range: nsRange)
        //  if let _ = font {// set font to attributes
        //   self.font = font
        //  }
        self.attributedText = attributedLessText
        self.activeLinkAttributes = [NSAttributedString.Key.foregroundColor : UIColor.appthemeRedColor]
        //Swift 5
        // self.linkAttributes = [NSAttributedStringKey.foregroundColor : UIColor.blue]
        self.linkAttributes = [NSAttributedString.Key.foregroundColor : UIColor.appthemeRedColor]
        self.addLink(toTransitInformation: ["ReadMore":"1"], with: nsRange)
        
        if isReadMoreTapped {
            self.numberOfLines = 0
            self.attributedText = attributedFullText
            self.addLink(toTransitInformation: ["ReadLess": "1"], with: rangeLess)
        }
        if isReadLessTapped {
            self.numberOfLines = 3
            self.attributedText = attributedLessText
        }
    }
}


extension Date {
    public func setTimeZero() -> Date? {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
        components.hour = 0
        components.minute = 0
        components.second = 0
        
        return calendar.date(from: components)
    }
    
    public func setTimeEnd() -> Date? {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
        components.hour = 23
        components.minute = 59
        components.second = 59
        
        return calendar.date(from: components)
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension Date {
    var yesterday: Date { return Date().dayBefore }
    var tomorrow:  Date { return Date().dayAfter }
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon) ?? Date()
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon) ?? Date()
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self) ?? Date()
    }
    var monthNo: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
}

//MARK: - Remove dupliocate value

func uniqueElementsFrom<T: Hashable>(array: [T]) -> [T] {
  var set = Set<T>()
  let result = array.filter {
    guard !set.contains($0) else {
      return false
    }
    set.insert($0)
    return true
  }
  return result
}

//MARK: -  Set Vibration

func setVibration(){
    
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);

    UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
    
}

extension UIApplication {
    static var statusBarHeight: CGFloat {
        if #available(iOS 13.0, *) {
            let window = shared.windows.filter { $0.isKeyWindow }.first
            return window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        }
        return shared.statusBarFrame.height
    }
}

struct ScreenUtils {
    static var width: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    static var height: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    static var statusBarHeight: CGFloat {
        return UIApplication.statusBarHeight
    }
}
