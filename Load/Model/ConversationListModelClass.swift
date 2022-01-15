import Foundation
import ObjectMapper

class ConversationListModelClass: Mappable {
    
    var success: Bool?
    var message: String?
    var data: [ConversationData]?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        success <- map["success"]
        message <- map["message"]
        data <- map["data"]
    }
}

class ConversationData: Mappable {
    
    var createdAt: String?
    var fromName: String?
    var id: NSNumber?
    var unreadCount: NSNumber?
    var fromPhoto: String?
    var updatedAt: String?
    var toName: String?
    var fromId: NSNumber?
    var toPhoto: String?
    var toId: NSNumber?
    var lastMessage: String?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        createdAt <- map["created_at"]
        fromName <- map["from_name"]
        id <- map["id"]
        unreadCount <- map["unread_count"]
        fromPhoto <- map["from_photo"]
        updatedAt <- map["updated_at"]
        toName <- map["to_name"]
        fromId <- map["from_id"]
        toPhoto <- map["to_photo"]
        toId <- map["to_id"]
        lastMessage <- map["last_message"] 
    }
}

