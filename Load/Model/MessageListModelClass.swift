import Foundation 
import ObjectMapper 

class MessageListModelClass: Mappable { 

	var success: Bool? 
	var data: [MessageListData]? 
	var message: String? 

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		success <- map["success"] 
		data <- map["data"] 
		message <- map["message"] 
	}
} 

class MessageListData: Mappable {

	var message: String? 
	var toId: NSNumber? 
	var updatedAt: String? 
	var createdAt: String? 
	var conversationId: NSNumber? 
	var id: NSNumber? 
	var fromId: NSNumber? 
    var eventId: NSNumber?
    var trainingLogId: NSNumber?
    var type: NSNumber?
    var bookedClientId: NSNumber?
    var ChatTrainingLog: ChatTrainingLog?
    var ChatEvent: ChatEvent?

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		message <- map["message"] 
		toId <- map["to_id"] 
		updatedAt <- map["updated_at"] 
		createdAt <- map["created_at"] 
		conversationId <- map["conversation_id"] 
		id <- map["id"] 
		fromId <- map["from_id"]
        eventId <- map["event_id"]
        trainingLogId <- map["training_log_id"]
        type <- map["type"]
        bookedClientId <- map["booked_client_id"]
	}
} 

class ChatTrainingLog: Mappable {
    
    var iconPath: String?
    var data: [ChatTrainingLogData]?
    var name: String?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        iconPath <- map["icon_path"]
        data <- map["data"]
        name <- map["name"]
    }
}

class ChatTrainingLogData: Mappable {
    
    var value: String?
    var name: String?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        value <- map["value"]
        name <- map["name"]
    }
}


class ChatEvent: Mappable {
    
    var eventName: String?
    var dateTime: String?
    var id: NSNumber?
    var eventPrice: NSNumber?
    var duration: NSNumber?
    var eventImage: String?
    var description: String?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        eventName <- map["event_name"]
        dateTime <- map["date_time"]
        id <- map["id"]
        eventPrice <- map["event_price"]
        duration <- map["duration"]
        eventImage <- map["event_image"]
        description <- map["description"]
    }
}
