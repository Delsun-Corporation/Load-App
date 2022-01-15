import Foundation 
import ObjectMapper 

class ReportModel: Mappable { 

	var data: ReportData?
	var success: Bool? 
	var status: NSNumber? 
	var message: String? 

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		data <- map["data"] 
		success <- map["success"] 
		status <- map["status"] 
		message <- map["message"] 
	}
} 

class ReportData: Mappable {

	var list: [ReportList]?
	var count: NSNumber? 

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		list <- map["list"] 
		count <- map["count"] 
	}
} 

class ReportList: Mappable {

	var name: String? 
	var id: NSNumber? 
	var isActive: Bool? 
	var sequence: Int?

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		name <- map["name"] 
		id <- map["id"] 
		isActive <- map["is_active"] 
		sequence <- map["sequence"] 
	}
} 

