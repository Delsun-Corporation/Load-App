import Foundation 
import ObjectMapper 

class UnitsModelClass: Mappable { 

	var success: Bool? 
	var status: NSNumber? 
	var data: [UnitsData]? 
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

class UnitsData: Mappable {

	var id: String?
	var description: String?
    //For physical activity
    var title: String = ""
    var isSelected: Bool = false

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		id <- map["_id"]
		description <- map["description"]
        title <- map["title"]
        isSelected <- map["is_selected"]
	}
} 

//MARK: - FOR PHYSICAL ACTIVITY

class PhysicalActivityModelClass: Mappable {

    var success: Bool?
    var status: NSNumber?
    var data: [UnitsData]?
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
