import Foundation 
import ObjectMapper 

class LoadCenterFeedSearchList: Mappable { 

	var list: [LoadCenterFeedList]?
	var count: NSNumber? 

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		list <- map["list"] 
		count <- map["count"] 
	}
} 

class LoadCenterFeedList: Mappable {

	var countryDetail: LoadCenterFeedCountryDetail?
	var profileDetail: ProfileDetail? 
	var countryId: NSNumber? 
	var name: String? 
	var photo: String? 
	var id: NSNumber? 

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		countryDetail <- map["country_detail"] 
		profileDetail <- map["profile_detail"] 
		countryId <- map["country_id"] 
		name <- map["name"] 
		photo <- map["photo"] 
		id <- map["id"] 
	}
} 

class ProfileDetail: Mappable {

	var rate: String? 
	var userId: NSNumber? 
	var id: NSNumber? 

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		rate <- map["rate"] 
		userId <- map["user_id"] 
		id <- map["id"] 
	}
} 

class LoadCenterFeedCountryDetail: Mappable { 

	var name: String? 
	var id: NSNumber? 

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		name <- map["name"] 
		id <- map["id"] 
	}
} 

