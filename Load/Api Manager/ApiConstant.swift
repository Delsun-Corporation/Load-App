//
//  ApiConstant.swift
//  Berry
//
//  Created by Haresh Bhai on 29/10/18.
//  Copyright © 2018 Haresh Bhai. All rights reserved.
//

import Foundation
import SwiftyJSON

//MARK: - Main URLS
//let SERVER_URL = "http://3.18.106.118/load/" //"http://192.168.0.108:1001"
let SERVER_URL = "http://178.128.45.110/load/" //http://178.128.56.249/load/"
let SERVER_URL_v2 = "http://139.59.237.151:5000/"
let BASE_URL_AUTH = SERVER_URL + "api/auth/"
let BASE_URL = SERVER_URL + "api/"
let BASE_URL_v2 = SERVER_URL_v2 + "api/"


//MARK: - URLS Names
let LOGIN = "login"
let RESET_PASSWORD = "reset-password"
let SIGN_UP = "sign-up"
let GET_ALL_DATA = "get-all-data"
let CREATE_TRAINING_LOG = "create-training-log"
let GET_TRAINING_LOG = "get-training-log"
let SAVE_IS_LOG_FLAG = "save-is-log-flag"
let TRAINING_LOG_DELETE = "training-log-delete"
let TRAINING_LOG_UPDATE = "training-log-update"
let COMPLETE_TRAINING_LOG = "complete-training-log"
let TRAINING_LOG_LIST = "training-log-list"
let LIBRARY_CREATE = "library-create"
let LIBRARY_LIST = "library-list"
let LIBRARY_DELETE = "library-delete"
let LIBRARY_SET_FAVORITE = "library-set-favorite"
let LIBRARY_SHOW = "library-show"
let LIBRARY_UPDATE = "library-update"
let LOAD_CENTER_CREAT = "load-center-create"
let LOAD_CENTER_LIST = "load-center-list"
let LOAD_CENTER_FEED_SEARCH_LIST = "load-center-feed-search-list"
let LOAD_CENTER_EVENT_SHOW = "load-center-event-show"
let TRAININIG_LOG_LIST = "training-log-list"
let USERS_LIST = "users-list"
let USER = "user"
let USER_UPDATE = "user-update"
let MESSAGES_USER_LIST = "messages-user-list"
let USER_LIST = "users-list"
let PROFESSIONAL_PROFILE_SHOW = "professional-profile-show"
let UPDATE_LATITUDE_LONGITUDE = "update-latitude-longitude"
let FOLLOW_UNFOLLOW_USER = "follow-unfollow-user"
let FEED_LIKE = "feed-like"
let COMMENT_LIST = "comment-list"
let CREATE_COMMENT = "create-comment"
let UPDATE_ACCOUNT_DATA = "update-account-type"
let UPDATE_ACCOUNT_SNOOZE = "update-account-snooze"
let NOTIFICATION_LIST = "notification-list"
let NOTIFICATION_READ = "notification-read"
let GET_CLIENT_BOOKED_DATES = "get-client-booked-dates"
let STORE_REQUEST_TO_MAKE_CLIENT = "store-request-to-make-client"
let CREATE_OR_UPDATE_PROFESSIONAL_PROFILE = "create-or-update-professional-profile"
let GET_PROFESSIONAL_PROFILE_DETAILS = "get-professional-profile-details"
let GET_SETTING_PROGRAM = "get-setting-program"
let SETTING_CREATE_UPDATE_PROGRAM = "setting-create-update-program"
let SETTING_CREATE_UPDATE_PRIMIUM = "setting-create-update-primium"
let GET_SETTING_PRIMIUM = "get-setting-primium"
let ADD_BILLING_INFORMATION = "add-billing-information"
let CREATE_TRAINING_PROGRAM = "create-training-program"
let SAVE_WORKOUT_LIST = "save-workout-list"
let CHECK_PROGRAM_IS_AVAILABLE = "check-program-is-available"
let GET_SETTING_TRAINING_DETAILS = "get-setting-training-detail"
let CREATE_DAILY_PROGRAMS = "create-daily-programs"
let UPDATE_DAILY_PROGRAM = "update-daily-program"
let CREATE_WEEK_WISE_DAILY_PROGRAMS = "create-week-wise-daily-programs"
let UPDATE_WEEK_WISE_DAILY_PROGRAMS = "update-week-wise-daily-programs"
let LIBRARY_GRAPH_DETAILS = "library-graph-details"
let SAVE_TEMPLETE_TO_WORKOUT = "save-template-to-workout"
let GET_EVENT_TYPES_LIST = "get-event-types-list"
let GET_CONVERSATION_DETAIL_CUSTOM = "get-conversation-detail-custom"
let LOG_RESISTANCE_VALIDATION_LIST = "log-resistance-validation-list"
let CUSTOM_COMMON_LIBRARY_DETAILS = "custom-common-library-details"
let CREATE_UPDATE_COMMON_LIBRARY_DETAILS = "create-update-common-library-detail"
let GET_EMERGENCY_CONTACT_DETAILS = "get-emergency-contact-details"
let ALL_TRAINING_UNITS_LIST = "all-training-units-list"
let SAVE_CONTACT_NUMBER = "save-contact-number"
let REPORT_FEED = "load-center-feed-report-list"
let SUBMIT_REPORT = "load-center-feed-add-report"
let LOG_CARDIO_VALIDATION_LIST = "log-cardio-validation-list"
let BOOKMARK_LIST = "bookmark-list"
let ADD_REMOVE_BOOKMARK = "create-delete-bookmark"
let GET_TRAINING_LOG_SUMMAARY_DETAILS = "get-training-log-summary-details"
let PROFESSIONAL_USER_LIST = "professional-user-list"
let BOOKMARK_LIST_VIEW_ALL = "bookmark-list-view-all"
let GET_AND_UPDATE_CONFIRMATION_DATA = "save-generated-calculation"
let LOAD_CENTER_REQUEST_SHOW = "load-center-request-show"
let LOAD_CENTER_REQUEST_UPDATE = "load-center-request-update"
let LOAD_CENTER_REQUEST_DELETE = "load-center-request-delete"
let TRAINING_PROGRAM_FLAGS = "program-flags"
let LIBRARY_UPDATE_CUSTOM_LIBRARY_EXERCISE_LINK = "library-exercise-link-update"
let GET_RESISTANCE_CONFIRMATION_DATA = "save-generated-calculation-resistance-log"
let UPDATE_RESISTANCE_CONFIRMATION_TRAINING_LOG = "update-confirmation-resistance-training-log"
let DELETE_TRAINING_PROGRAMS = "delete-training-programs"
let ALL_PHYSICAL_ACTIVITY_LIST = "all-physical-activity-level-list"
let GET_AND_UPDATE_CONFIRMATION_DATA_FOR_TRAINING_PROGRAM = "save-generated-calculation-training-program"
let GET_TRAINING_PROGRAM_SUMMAARY_DETAILS = "get-training-program-summary-details"
let TIME_UNDER_TENSION_LIST_SETTING = "time-under-tention"
let TIME_UNDER_TENSION_UPDATE_DATA_SETTING = "time-under-tention-update"

// Paypal

let PAYPAL_USERNAME = "ARZqKTKyCe5fBsJKbObf5khLoEyfmVfVXkdBHBpr4Q4qumYGDrmZngwT2TnbcP12NndX1kXHGbdv_R1L"
let PAYPAL_PASSWORD = "EL5G7QamYcZ3w9aUAVfQojekcRyPZ-OMPAksLZlU67mEvz3WBx6WebTMUTTyzB4T1bUs53aAFNJxyJ_N"
let PAYPAL_OAUTH2_TOKEN = "https://api.sandbox.paypal.com/v1/oauth2/token"
let PAYPAL_CREDIT_CARDS = "https://api.sandbox.paypal.com/v1/vault/credit-cards"
let PAYPAL_GET_CARD = "https://api.sandbox.paypal.com/v1/vault/credit-cards/"

enum APIKeys: String {
    case success = "success"
    case status = "status"
    case message = "message"
    case data = "data"
    case id = "id"
    case photo = "photo"
    case country_code = "country_code"
    case mobile = "mobile"
    case date_of_birth = "date_of_birth"
    case name = "name"
    case country_id = "country_id"
    case facebook = "facebook"
    case account_id = "account_id"
    case is_snooze = "is_snooze"
    case selected_date = "selected_date"
    case confirmed_status = "confirmed_status"
    case user_snooze_detail = "user_snooze_detail"
    case start_date = "start_date"
    case end_date = "end_date"
    case access_token = "access_token"
    case token_type = "token_type"
    case details = "details"
    case field = "field"
    case race_distance_id = "race_distance_id"
    case race_time = "race_time"
    case contact1 = "contact_1"
    case contact2 = "contact_2"
}


extension JSON {
    func getString(key: APIKeys) -> String {
        return self[key.rawValue].string ?? ""
    }
    
    func getInt(key: APIKeys) -> Int {
        return self[key.rawValue].int ?? 0
    }
    
    func getBool(key: APIKeys) -> Bool {
        return self[key.rawValue].bool ?? false
    }
    
    func getDouble(key: APIKeys) -> Double {
        return self[key.rawValue].double ?? 0.0
    }
    
    func getFloat(key: APIKeys) -> Float {
        return self[key.rawValue].float ?? 0.0
    }
    
    func getDictionary(key: APIKeys) -> JSON {
        return JSON(self[key.rawValue].dictionary ?? [String: JSON]())
    }
    
    func getArray(key: APIKeys) -> [JSON] {
        return self[key.rawValue].array ?? [JSON]()
    }
    
    mutating func setValue(key: APIKeys, value: String) {
        self[key.rawValue].string = value
    }
    
    mutating func setIntValue(key: APIKeys, value: Int) {
        self[key.rawValue].int = value
    }
    
    mutating func setBoolValue(key: APIKeys, value: Bool) {
        self[key.rawValue].bool = value
    }
    
    mutating func setNumberValue(key: APIKeys, value: NSNumber) {
        self[key.rawValue].number = value
    }
}


extension Date {
    func getNextMonth() -> Date?{
        return NSCalendar.current.date(byAdding: .month, value: 1, to: self)
    }
    
    func getPreviousMonth() -> Date?{
        return NSCalendar.current.date(byAdding: .month, value: -1, to: self)
    }
    
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self))) ?? Date()
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth()) ?? Date()
    }
    
    func position() -> Int {
        let weekday = Calendar.current.component(.weekday, from: self)
        return weekday == 1 ? 7 : (weekday - 1)
    }
    
    func count() -> Int {
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: self)
        let numDays = range?.count
        return numDays ?? 0
    }
    
    var month: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        return dateFormatter.string(from: self)
    }
    
    var monthName: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        return dateFormatter.string(from: self)
    }
    
    var year: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: self)
    }
    
    func toString(dateFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateFormatter.dateFormat = dateFormat //"dd MMMM yyyy"
        return dateFormatter.string(from: self)
    }
}
