import Foundation
import ObjectMapper

class EventDetailsModelClass: Mappable {
    
    var createdAt: String?
    var userDetail: UserDetail?
    var amenitiesAvailable: [AmenitiesAvailable]?
    var title: String?
    var dateTime: String?
    var updatedAt: String?
    var latitude: String?
    var maxGuests: NSNumber?
    var id: NSNumber?
    var earlierTime: String?
    var userId: NSNumber?
    var eventPrice: NSNumber?
    var eventName: String?
    var cancellationPolicyDetail: CancellationPolicyDetail?
    var longitude: String?
    var generalRules: String?
    var location: String?
    var isCompleted: NSNumber?
    var duration: NSNumber?
    var visibleTo: String?
    var cancellationPolicyId: NSNumber?
    var nearestEvents: [NearestEvents]?
    var currencyDetail: CurrencyDetail?
    var description: String?
    var currencyId: NSNumber?
    var eventImage: String?
    var eventTypeIds: [Int]?
    var isBookmarked: Bool = false

    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        createdAt <- map["created_at"]
        userDetail <- map["user_detail"]
        amenitiesAvailable <- map["amenities_available"]
        title <- map["title"]
        dateTime <- map["date_time"]
        updatedAt <- map["updated_at"]
        latitude <- map["latitude"]
        maxGuests <- map["max_guests"]
        id <- map["id"]
        earlierTime <- map["earlier_time"]
        userId <- map["user_id"]
        eventPrice <- map["event_price"]
        eventName <- map["event_name"]
        cancellationPolicyDetail <- map["cancellation_policy_detail"]
        longitude <- map["longitude"]
        generalRules <- map["general_rules"]
        location <- map["location"]
        isCompleted <- map["is_completed"]
        duration <- map["duration"]
        visibleTo <- map["visible_to"]
        cancellationPolicyId <- map["cancellation_policy_id"]
        nearestEvents <- map["nearest_events"]
        currencyDetail <- map["currency_detail"]
        description <- map["description"]
        currencyId <- map["currency_id"]
        eventImage <- map["event_image"]
        eventTypeIds <- map["event_type_ids"]
        isBookmarked <- map["is_bookmarked"]
    }
}

class CurrencyDetail: Mappable {
    
    var code: String?
    var isActive: Bool?
    var name: String?
    var id: NSNumber?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        code <- map["code"]
        isActive <- map["is_active"]
        name <- map["name"]
        id <- map["id"]
    }
}

class NearestEvents: Mappable {
    
    var title: String?
    var earlierTime: String?
    var id: NSNumber?
    var latitude: Any?
    var eventImage: String?
    var duration: NSNumber?
    var amenitiesAvailable: [AmenitiesAvailable]?
    var userId: NSNumber?
    var isCompleted: NSNumber?
    var maxGuests: NSNumber?
    var updatedAt: String?
    var location: String?
    var currencyId: Any?
    var dateTime: String?
    var eventName: String?
    var distance: Any?
    var createdAt: String?
    var description: String?
    var visibleTo: String?
    var eventPrice: NSNumber?
    var longitude: Any?
    var cancellationPolicyId: Any?
    var generalRules: Any?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        title <- map["title"]
        earlierTime <- map["earlier_time"]
        id <- map["id"]
        latitude <- map["latitude"]
        eventImage <- map["event_image"]
        duration <- map["duration"]
        amenitiesAvailable <- map["amenities_available"]
        userId <- map["user_id"]
        isCompleted <- map["is_completed"]
        maxGuests <- map["max_guests"]
        updatedAt <- map["updated_at"]
        location <- map["location"]
        currencyId <- map["currency_id"]
        dateTime <- map["date_time"]
        eventName <- map["event_name"]
        distance <- map["distance"]
        createdAt <- map["created_at"]
        description <- map["description"]
        visibleTo <- map["visible_to"]
        eventPrice <- map["event_price"]
        longitude <- map["longitude"]
        cancellationPolicyId <- map["cancellation_policy_id"]
        generalRules <- map["general_rules"]
    }
}

class CancellationPolicyDetail: Mappable {
    
    var isActive: Bool?
    var name: String?
    var updatedAt: String?
    var code: String?
    var createdAt: String?
    var id: NSNumber?
    var description: String?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        isActive <- map["is_active"]
        name <- map["name"]
        updatedAt <- map["updated_at"]
        code <- map["code"]
        createdAt <- map["created_at"]
        id <- map["id"]
        description <- map["description"]
    }
}

class AmenitiesAvailable: Mappable {
    
    var data: Bool?
    var name: String?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        data <- map["data"]
        name <- map["name"]
    }
}

class EventDetailsUserDetail: Mappable {
    
    var height: NSNumber?
    var countryDetail: EventDetailsCountryDetail?
    var goal: Any?
    var createdAt: String?
    var facebook: String?
    var updatedAt: String?
    var latitude: String?
    var id: NSNumber?
    var countryCode: String?
    var expiredAt: Any?
    var emailVerifiedAt: Any?
    var longitude: String?
    var lastLoginAt: String?
    var isActive: NSNumber?
    var photo: String?
    var membershipCode: Any?
    var userType: String?
    var isProfileComplete: NSNumber?
    var dateOfBirth: String?
    var mobile: String?
    var weight: NSNumber?
    var mobileVerifiedAt: Any?
    var email: String?
    var countryId: NSNumber?
    var gender: String?
    var accountId: NSNumber?
    var name: String?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        height <- map["height"]
        countryDetail <- map["country_detail"]
        goal <- map["goal"]
        createdAt <- map["created_at"]
        facebook <- map["facebook"]
        updatedAt <- map["updated_at"]
        latitude <- map["latitude"]
        id <- map["id"]
        countryCode <- map["country_code"]
        expiredAt <- map["expired_at"]
        emailVerifiedAt <- map["email_verified_at"]
        longitude <- map["longitude"]
        lastLoginAt <- map["last_login_at"]
        isActive <- map["is_active"]
        photo <- map["photo"]
        membershipCode <- map["membership_code"]
        userType <- map["user_type"]
        isProfileComplete <- map["is_profile_complete"]
        dateOfBirth <- map["date_of_birth"]
        mobile <- map["mobile"]
        weight <- map["weight"]
        mobileVerifiedAt <- map["mobile_verified_at"]
        email <- map["email"]
        countryId <- map["country_id"]
        gender <- map["gender"]
        accountId <- map["account_id"]
        name <- map["name"]
    }
}

class EventDetailsCountryDetail: Mappable {
    
    var countryCode: String?
    var name: String?
    var updatedAt: Any?
    var code: String?
    var createdAt: Any?
    var id: NSNumber?
    var isActive: Bool?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        countryCode <- map["country_code"]
        name <- map["name"]
        updatedAt <- map["updated_at"]
        code <- map["code"]
        createdAt <- map["created_at"]
        id <- map["id"]
        isActive <- map["is_active"]
    }
}

