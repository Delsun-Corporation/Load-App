import Foundation
import ObjectMapper

class OtherUserDetailsModelClass: Mappable {
    
    var specializationDetails: [SpecializationDetails]?
    var userDetail: OtherUserDetail?
    var conversationDetail: Any?
    var termsOfService: String?
    var updatedAt: Any?
//    var academicAndCertifications: String?
    var specializationIds: [String]?
    var userId: NSNumber?
    var experienceAndAchievements: String?
    var languagesWrittenDetails: [LanguagesWrittenDetails]?
    var introduction: String?
    var languagesSpoken: [String]?
    var languagesWritten: [String]?
    var languagesSpokenDetails: [LanguagesSpokenDetails]?
    var createdAt: Any?
    var id: NSNumber?
    var isFollowing: Bool?
    var nearestProfessionalProfile: [NearestProfessionalProfile]?
    var academicCredentials: [AcademicCredentialsDetails]?
    var sessionMaximumClients: NSNumber?
    var perMultipleSessionRate: NSNumber?
    var sessionDuration: NSNumber?
    var paymentOptionDetail: PaymentOptionDetails?
    var isBookmarked:Bool = false
    var amenities: [Amenities]?


    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        specializationDetails <- map["specialization_details"]
        userDetail <- map["user_detail"]
        conversationDetail <- map["conversation_detail"]
        termsOfService <- map["terms_of_service"]
        updatedAt <- map["updated_at"]
//        academicAndCertifications <- map["academic_and_certifications"]
        specializationIds <- map["specialization_ids"]
        userId <- map["user_id"]
        experienceAndAchievements <- map["experience_and_achievements"]
        languagesWrittenDetails <- map["languages_written_details"]
        introduction <- map["introduction"]
        languagesSpoken <- map["languages_spoken"]
        languagesWritten <- map["languages_written"]
        languagesSpokenDetails <- map["languages_spoken_details"]
        createdAt <- map["created_at"]
        id <- map["id"]
        isFollowing <- map["is_following"]
        nearestProfessionalProfile <- map["nearest_professional_profile"]
        academicCredentials <- map["academic_credentials"]
        sessionMaximumClients <- map["session_maximum_clients"]
        perMultipleSessionRate <- map["per_multiple_session_rate"]
        sessionDuration <- map["session_duration"]
        paymentOptionDetail <- map["payment_option_detail"]
        isBookmarked <- map["is_bookmarked"]
        amenities <- map["amenities"]
    }
}

class PaymentOptionDetails: Mappable {

    var id: NSNumber?
    var name: String?
    var code: String?
    var description: String?
    var isActive: Bool?
    var createdAt: Any?
    var updatedAt: Any?

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
    }
}


class AcademicCredentialsDetails: Mappable {

    var awardingInstitution: String?
    var courseOfStudy: String?

    required init?(map: Map){
    }

    func mapping(map: Map) {
//        awardingInstitution <- map["AwardingInstitution"]
//        courseOfStudy <- map["CourseOfStudy"]

        //Outter main list show above key and inner API have different key like added below
        
        awardingInstitution <- map["awarding"]
        courseOfStudy <- map["course"]

    }
}

class LanguagesSpokenDetails: Mappable {
    
    var id: NSNumber?
    var name: String?
    var isActive: Bool?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        isActive <- map["is_active"]
    }
}

class LanguagesWrittenDetails: Mappable {
    
    var id: NSNumber?
    var name: String?
    var isActive: Bool?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        isActive <- map["is_active"]
    }
}

class OtherUserDetail: Mappable {
    
    var countryDetail: OtherUserCountryDetail?
    var countryId: NSNumber?
    var isProfileComplete: NSNumber?
    var photo: String?
    var gender: String?
    var goal: String?
    var mobile: String?
    var id: NSNumber?
    var isActive: NSNumber?
    var countryCode: String?
    var name: String?
    var userType: String?
    var accountDetails: AccountDetails?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        countryDetail <- map["country_detail"]
        countryId <- map["country_id"]
        isProfileComplete <- map["is_profile_complete"]
        photo <- map["photo"]
        gender <- map["gender"]
        goal <- map["goal"]
        mobile <- map["mobile"]
        id <- map["id"]
        isActive <- map["is_active"]
        countryCode <- map["country_code"]
        name <- map["name"]
        userType <- map["user_type"]
        accountDetails <- map["account_detail"]
    }
}

class OtherUserCountryDetail: Mappable {
    
    var name: String?
    var isActive: Bool?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        isActive <- map["is_active"]
    }
}

class AccountDetails: Mappable {
    
    var name: String?
    var isActive: Bool?
    var code = ""
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        isActive <- map["is_active"]
        code <- map["code"]
    }
}


class SpecializationDetails: Mappable {
    
    var id: NSNumber?
    var name: String?
    var isActive: Bool?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        isActive <- map["is_active"]
    }
}


class NearestProfessionalProfile: Mappable {
    
    var userId: NSNumber?
    var specializationDetails: [SpecializationDetails]?
    var userDetail: UserDetail?
    var id: NSNumber?
    var rate: String?

    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        userId <- map["user_id"]
        specializationDetails <- map["specialization_details"]
        userDetail <- map["user_detail"]
        id <- map["id"]
        rate <- map["rate"]
    }
}
