import Foundation 
import ObjectMapper

class CardModelClass: Mappable { 

	var id: String? 
	var state: String? 
	var type: String? 
	var number: String? 
	var expireMonth: String? 
	var expireYear: String?
    var firstName: String?
	var lastName: String? 
	var billingAddress: BillingAddress? 
	var validUntil: String? 
	var createTime: String? 
	var updateTime: String? 
	var links: [Links]? 

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		id <- map["id"] 
		state <- map["state"] 
		type <- map["type"] 
		number <- map["number"] 
		expireMonth <- map["expire_month"] 
		expireYear <- map["expire_year"]
        firstName <- map["first_name"]
		lastName <- map["last_name"] 
		billingAddress <- map["billing_address"] 
		validUntil <- map["valid_until"] 
		createTime <- map["create_time"] 
		updateTime <- map["update_time"] 
		links <- map["links"] 
	}
} 

class Links: Mappable { 

	var href: String? 
	var rel: String? 
	var method: String? 

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		href <- map["href"] 
		rel <- map["rel"] 
		method <- map["method"] 
	}
} 

class BillingAddress: Mappable { 

	var line1: String? 
	var city: String? 
	var state: String? 
	var postalCode: String? 
	var countryCode: String? 
	var phone: String? 

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		line1 <- map["line1"] 
		city <- map["city"] 
		state <- map["state"] 
		postalCode <- map["postal_code"] 
		countryCode <- map["country_code"] 
		phone <- map["phone"] 
	}
} 

