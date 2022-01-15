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

	var id: Int = 0
	var name: String? 
	var code: String? 
	var description: String? 
	var isActive: NSNumber? 
	var createdAt: String? 
	var updatedAt: String?
    //For physical activity
    var title: String = ""
    var isSelected = 0

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		id <- map["id"] 
		name <- map["name"] 
		code <- map["code"] 
		description <- map["description"] 
		isActive <- map["is_active"] 
		createdAt <- map["created_at"] 
		updatedAt <- map["updated_at"]
        
        title <- map["title"]
        isSelected <- map["isSelected"]
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
