import Foundation 
import ObjectMapper 

class LoginModelClass: Mappable { 

	var success: Bool? 
	var status: NSNumber? 
	var data: DataLogin? 
	var message: String? 

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		success <- map["success"] 
		status <- map["status"] 
		data <- map["data"] 
		message <- map["message"] 
	}
} 

class DataLogin: Mappable {

	var user: User? 
	var accessToken: String? 
	var tokenType: String? 

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		user <- map["user"] 
		accessToken <- map["access_token"] 
		tokenType <- map["token_type"] 
	}
} 

class User: Mappable { 

	var id: NSNumber? 
	var name: String? 
	var email: String? 
	var mobile: String? 
	var dateOfBirth: String? 
	var gender: String? 
	var height: NSNumber?
    var weight: NSNumber?
	var photo: String? 
	var membershipCode: String? 
	var userType: Any? 
	var accountId: Int? 
	var isActive: NSNumber? 
	var expiredAt: Any? 
	var createdAt: String? 
	var updatedAt: String?
    var mobileVerifiedAt: String?
    var emailVerifiedAt: String?
    var isSnooze: NSNumber?
    var userSnoozeDetail: UserSnoozeDetail?
    var countryId: NSNumber?

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		id <- map["id"] 
		name <- map["name"] 
		email <- map["email"] 
		mobile <- map["mobile"] 
		dateOfBirth <- map["date_of_birth"] 
		gender <- map["gender"] 
		height <- map["height"]
        weight <- map["weight"]
		photo <- map["photo"] 
		membershipCode <- map["membership_code"] 
		userType <- map["user_type"] 
		accountId <- map["account_id"] 
		isActive <- map["is_active"] 
		expiredAt <- map["expired_at"] 
		createdAt <- map["created_at"] 
		updatedAt <- map["updated_at"]
        mobileVerifiedAt <- map["mobile_verified_at"]
        emailVerifiedAt <- map["email_verified_at"]
        isSnooze <- map["is_snooze"]
        userSnoozeDetail <- map["user_snooze_detail"]
        countryId <- map["country_id"]
	}
} 

class UserSnoozeDetail: Mappable {
    
    var id: NSNumber?
    var userId: NSNumber?
    var startDate: String?
    var endDate: String?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        userId <- map["user_id"]
        startDate <- map["start_date"]
        endDate <- map["end_date"]
    }
}

