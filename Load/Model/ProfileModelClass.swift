import Foundation 
import ObjectMapper 

class ProfileModelClass: Mappable { 

	var gender: String? 
	var expiredAt: Any? 
	var updatedAt: String? 
	var isProfileComplete: NSNumber? 
	var createdAt: String? 
	var goal: Any? 
	var dateOfBirth: String? 
	var weight: NSNumber? 
	var mobile: String?
    var countryCode: String?
	var userType: Any? 
	var photo: String? 
	var id: NSNumber? 
	var email: String? 
	var accountId: Any? 
	var height: NSNumber? 
	var name: String? 
	var membershipCode: Any? 
	var countryId: NSNumber? 
	var emailVerifiedAt: String? 
	var facebook: String? 
	var mobileVerifiedAt: String?
	var isActive: NSNumber? 
    var accountDetail: AccountDetail?
    var countryDetail: CountryDetail?
    var isSnooze: NSNumber?
    var userSnoozeDetail: UserSnoozeDetail?

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		gender <- map["gender"] 
		expiredAt <- map["expired_at"] 
		updatedAt <- map["updated_at"] 
		isProfileComplete <- map["is_profile_complete"] 
		createdAt <- map["created_at"] 
		goal <- map["goal"] 
		dateOfBirth <- map["date_of_birth"] 
		weight <- map["weight"] 
		mobile <- map["mobile"]
        countryCode <- map["country_code"]
		userType <- map["user_type"] 
		photo <- map["photo"] 
		id <- map["id"] 
		email <- map["email"] 
		accountId <- map["account_id"] 
		height <- map["height"] 
		name <- map["name"] 
		membershipCode <- map["membership_code"] 
		countryId <- map["country_id"] 
		emailVerifiedAt <- map["email_verified_at"] 
		facebook <- map["facebook"] 
		mobileVerifiedAt <- map["mobile_verified_at"] 
		isActive <- map["is_active"]
        accountDetail <- map["account_detail"]
        countryDetail <- map["country_detail"]
        isSnooze <- map["is_snooze"]
        userSnoozeDetail <- map["user_snooze_detail"]
	}
} 

class AccountDetail: Mappable {
    
    var name: String?
    var id: NSNumber?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        id <- map["id"]
    }
}

class CountryDetail: Mappable {
    
    var name: String?
    var id: NSNumber?
    var countryCode:String?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        id <- map["id"]
        countryCode <- map["country_code"]
    }
}
