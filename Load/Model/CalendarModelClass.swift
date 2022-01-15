import Foundation 
import ObjectMapper 

class CalendarModelClass: Mappable { 

	var no: [Int]? 
	var date: [String]? 
    var isEnable: [Bool]?

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		no <- map["no"] 
		date <- map["date"]
        isEnable <- map["is_enable"]
	}
}
