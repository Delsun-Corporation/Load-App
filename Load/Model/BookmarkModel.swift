import Foundation 
import ObjectMapper 

class BookmarkModel: Mappable { 

	var success: Bool? 
	var status: Int = 0
	var data: [arrayMainBookMarkList]?
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

class arrayMainBookMarkList: Mappable{
    
    var name: String = ""
    var arraySubData: [arraySubBookmarkList]?
    

    required init?(map: Map){
    }

    func mapping(map: Map) {
        name <- map["name"]
        arraySubData <- map["data"]
    }
    
}

class arraySubBookmarkList: Mappable {

	var eventId: Int = 0
	var professionalId: Int = 0
	var eventDetail: EventDetail? 
	var professionalDetail: ProfessionalDetail? 

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		eventId <- map["event_id"] 
		professionalId <- map["professional_id"] 
		eventDetail <- map["event_detail"] 
		professionalDetail <- map["professional_detail"] 
	}
} 

class ProfessionalDetail: Mappable { 

	var id: Int = 0
	var userId: Int = 0
	var userDetail: UserDetailBookMark?

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		id <- map["id"] 
		userId <- map["user_id"] 
		userDetail <- map["user_detail"] 
	}
}

class EventDetail: Mappable {

    var id: NSNumber?
    var eventName: String?
    var eventImage: String?

    required init?(map: Map){
    }

    func mapping(map: Map) {
        id <- map["id"]
        eventName <- map["event_name"]
        eventImage <- map["event_image"]
    }
}


class UserDetailBookMark: Mappable {

	var id: Int = 0
	var name: String? 
	var photo: String? 

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		id <- map["id"] 
		name <- map["name"] 
		photo <- map["photo"] 
	}
} 

