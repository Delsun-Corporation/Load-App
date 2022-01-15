import Foundation
import ObjectMapper

class EventModelClass: Mappable {
    
    var upcomingEvent: [UpcomingEvent]?
    var recentEvent: [RecentEvent]?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        upcomingEvent <- map["upcoming_event"]
        recentEvent <- map["recent_event"]
    }
}

class RecentEvent: Mappable {
    
    var id: NSNumber?
    var description: String?
    var eventPrice: NSNumber?
    var eventName: String?
    var locationMap: String?
    var visibleTo: String?
    var title: String?
    var eventImage: String?
    var userId: NSNumber?
    var isCompleted: NSNumber?
    var amenitiesAvailable: Any?
    var maxGuests: NSNumber?
    var earlierTime: String?
    var updatedAt: String?
    var duration: NSNumber?
    var createdAt: String?
    var location: String?
    var dateTime: String?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        description <- map["description"]
        eventPrice <- map["event_price"]
        eventName <- map["event_name"]
        locationMap <- map["location_map"]
        visibleTo <- map["visible_to"]
        title <- map["title"]
        eventImage <- map["event_image"]
        userId <- map["user_id"]
        isCompleted <- map["is_completed"]
        amenitiesAvailable <- map["amenities_available"]
        maxGuests <- map["max_guests"]
        earlierTime <- map["earlier_time"]
        updatedAt <- map["updated_at"]
        duration <- map["duration"]
        createdAt <- map["created_at"]
        location <- map["location"]
        dateTime <- map["date_time"]
    }
}

class UpcomingEvent: Mappable {
    
    var id: NSNumber?
    var description: String?
    var eventPrice: NSNumber?
    var eventName: String?
    var locationMap: String?
    var visibleTo: String?
    var title: String?
    var eventImage: String?
    var userId: NSNumber?
    var isCompleted: NSNumber?
    var amenitiesAvailable: Any?
    var maxGuests: NSNumber?
    var earlierTime: String?
    var updatedAt: String?
    var duration: NSNumber?
    var createdAt: String?
    var location: String?
    var dateTime: String?
    var isBookmarked: Bool = false
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        description <- map["description"]
        eventPrice <- map["event_price"]
        eventName <- map["event_name"]
        locationMap <- map["location_map"]
        visibleTo <- map["visible_to"]
        title <- map["title"]
        eventImage <- map["event_image"]
        userId <- map["user_id"]
        isCompleted <- map["is_completed"]
        amenitiesAvailable <- map["amenities_available"]
        maxGuests <- map["max_guests"]
        earlierTime <- map["earlier_time"]
        updatedAt <- map["updated_at"]
        duration <- map["duration"]
        createdAt <- map["created_at"]
        location <- map["location"]
        dateTime <- map["date_time"]
        isBookmarked <- map["is_bookmarked"]
    }
} 
