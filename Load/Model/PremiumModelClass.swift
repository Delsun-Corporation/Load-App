import Foundation 
import ObjectMapper

class PremiumModelClass: Mappable { 

	var specializationIds: [Int]?
	var updatedAt: String? 
	var specializationDetails: [PremiumSpecializationDetails]?
    var languageId: [Int]?
	var createdAt: String? 
	var userDetail: PremiumUserDetail?
	var userId: NSNumber?
    
	var languageDetails: [LanguageDetails]? 
	var about: String? 
	var id: NSNumber? 
    var cardDetails: [CardDetails]?
    var isAutoTopup: Bool?
    var autoTopupAmount: NSNumber?
    var minimumBalance: NSNumber?
    var viewPremiumProfile: String = ""
    var viewPremiumFeed: String = ""

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		specializationIds <- map["specialization_ids"] 
		updatedAt <- map["updated_at"] 
		specializationDetails <- map["specialization_details"]
        languageId <- map["language_id"]
		createdAt <- map["created_at"] 
		userDetail <- map["user_detail"] 
		userId <- map["user_id"] 
		languageDetails <- map["language_details"] 
		about <- map["about"] 
		id <- map["id"]
        cardDetails <- map["card_details"]
        isAutoTopup <- map["is_auto_topup"]
        autoTopupAmount <- map["auto_topup_amount"]
        viewPremiumProfile <- map["premium_profile_permission"]
        viewPremiumFeed <- map["feed_permission"]
        minimumBalance <- map["minimum_balance"]
	}
} 

class LanguageDetails: Mappable { 

	var updatedAt: String? 
	var createdAt: String? 
	var id: NSNumber? 
	var isActive: Bool? 
	var name: String? 
	var code: String? 

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		updatedAt <- map["updated_at"] 
		createdAt <- map["created_at"] 
		id <- map["id"] 
		isActive <- map["is_active"] 
		name <- map["name"] 
		code <- map["code"] 
	}
} 

class PremiumUserDetail: Mappable {

	var id: NSNumber? 
	var isActive: NSNumber? 
	var name: String? 
	var photo: String? 

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		id <- map["id"] 
		isActive <- map["is_active"] 
		name <- map["name"] 
		photo <- map["photo"] 
	}
} 

class PremiumSpecializationDetails: Mappable { 

	var updatedAt: Any? 
	var createdAt: Any? 
	var id: NSNumber? 
	var isActive: Bool? 
	var name: String? 
	var code: String? 

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		updatedAt <- map["updated_at"] 
		createdAt <- map["created_at"] 
		id <- map["id"] 
		isActive <- map["is_active"] 
		name <- map["name"] 
		code <- map["code"] 
	}
}

class CardDetails: Mappable {
    
    var id: String?
    var creditCardId: String?
    var isDefault: NSNumber?
    var createdAt: String?
    var userId: NSNumber?
    var updatedAt: String?
    var countryId: Int?
    var postalCode: String?
    var number: String?
    var expiryDate: String?
    var city: String?
    var name: String?
    var state: String?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        id <- map["_id"]
        creditCardId <- map["credit_card_id"]
        isDefault <- map["is_default"]
        createdAt <- map["created_at"]
        userId <- map["user_id"]
        updatedAt <- map["updated_at"]
        countryId <- map["country_id"]
        postalCode <- map["postal_code"]
        number <- map["credit_card_number"]
        expiryDate <- map["expiry_date"]
        city <- map["city"]
        name <- map["name"]
        state <- map["state_province_region"]
    }
}
