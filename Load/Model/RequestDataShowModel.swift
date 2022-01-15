import Foundation 
import ObjectMapper 

class RequestDataShowModel: Mappable { 

	var success: Bool? 
	var status: Int = 0
	var data: RequestData?
	var message: String = ""

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		success <- map["success"] 
		status <- map["status"] 
		data <- map["data"] 
		message <- map["message"] 
	}
} 

class RequestData: Mappable {

	var id: Int = 0
	var userId: Int = 0
	var title: String = ""
	var startDate: String = ""
	var birthDate: String = ""
	var yourself: String = ""
	var countryId: Int = 0
	var specializationIds: [String] = []
	var trainingTypeIds: [String] = []
	var experienceYear: String = ""
    var rating: Double = 0.0
	var createdAt: String = ""
	var updatedAt: String = ""
	var userDetail: UserDetailData?
    var countryData : Countries?

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		id <- map["id"] 
		userId <- map["user_id"] 
		title <- map["title"] 
		startDate <- map["start_date"] 
		birthDate <- map["birth_date"] 
		yourself <- map["yourself"] 
		countryId <- map["country_id"] 
		specializationIds <- map["specialization_ids"] 
		trainingTypeIds <- map["training_type_ids"] 
		experienceYear <- map["experience_year"] 
		rating <- map["rating"] 
		createdAt <- map["created_at"] 
		updatedAt <- map["updated_at"] 
		userDetail <- map["user_detail"]
        countryData <- map["country_detail"]
	}
} 

class UserDetailData: Mappable {

	var id: Int = 0
	var name: String = ""
	var email: String = ""
	var countryCode: String = ""
	var mobile: String = ""
	var facebook: String = ""
	var dateOfBirth: String = ""
	var gender: String = ""
	var height: Int = 0
	var weight: Int = 0
	var photo: String = ""
	var goal: Any? 
	var countryId: Int = 0
	var latitude: String = ""
	var longitude: String = ""
	var membershipCode: Any? 
	var userType: String = ""
	var accountId: Int = 0
	var isActive: Int = 0
	var isProfileComplete: Int = 0
	var emailVerifiedAt: String = ""
	var mobileVerifiedAt: String = ""
	var expiredAt: Any? 
	var lastLoginAt: String = ""
	var socketId: String = ""
	var isOnline: Int = 0
	var isSnooze: Int = 0
	var createdAt: String = ""
	var updatedAt: String = ""

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		id <- map["id"] 
		name <- map["name"] 
		email <- map["email"] 
		countryCode <- map["country_code"] 
		mobile <- map["mobile"] 
		facebook <- map["facebook"] 
		dateOfBirth <- map["date_of_birth"] 
		gender <- map["gender"] 
		height <- map["height"] 
		weight <- map["weight"] 
		photo <- map["photo"] 
		goal <- map["goal"] 
		countryId <- map["country_id"] 
		latitude <- map["latitude"] 
		longitude <- map["longitude"] 
		membershipCode <- map["membership_code"] 
		userType <- map["user_type"] 
		accountId <- map["account_id"] 
		isActive <- map["is_active"] 
		isProfileComplete <- map["is_profile_complete"] 
		emailVerifiedAt <- map["email_verified_at"] 
		mobileVerifiedAt <- map["mobile_verified_at"] 
		expiredAt <- map["expired_at"] 
		lastLoginAt <- map["last_login_at"] 
		socketId <- map["socket_id"] 
		isOnline <- map["is_online"] 
		isSnooze <- map["is_snooze"] 
		createdAt <- map["created_at"] 
		updatedAt <- map["updated_at"] 
	}
} 

