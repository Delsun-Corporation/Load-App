import Foundation
import ObjectMapper

class ListingModelClass: Mappable {
    
    var professionalUserList: [ProfessionalUserList]?
    var requestList: [RequestList]?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        professionalUserList <- map["professional_user_list"]
        requestList <- map["request_list"]
    }
}

class RequestList: Mappable {
    
    var title: String?
    var trainingTypeDetails: [TrainingTypeDetails]?
    var userId: NSNumber?
    var userDetail: RequestUserDetail?
    var yourself: String?
    var startDate: String?
    var trainingTypeIds: [String]?
    var specializationDetails: [specializationDetails]?
    var id: Int = 0
    var countryData : Countries?


    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        title <- map["title"]
        trainingTypeDetails <- map["training_type_details"]
        userId <- map["user_id"]
        userDetail <- map["user_detail"]
        yourself <- map["yourself"]
        startDate <- map["start_date"]
        trainingTypeIds <- map["training_type_ids"]
        specializationDetails <- map["specialization_details"]
        id <- map["id"]
        countryData <- map["country_detail"]

    }
}

class RequestUserDetail: Mappable {
    
    var photo: String?
    var name: String?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        photo <- map["photo"]
        name <- map["name"]
    }
}

class TrainingTypeDetails: Mappable {
    
    var createdAt: Any?
    var name: String?
    var updatedAt: Any?
    var code: String?
    var isActive: Bool?
    var id: NSNumber?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        createdAt <- map["created_at"]
        name <- map["name"]
        updatedAt <- map["updated_at"]
        code <- map["code"]
        isActive <- map["is_active"]
        id <- map["id"]
    }
}

class ProfessionalUserList: Mappable {
    
    var data: [ProfessionalData]?
    var name: String?
    var id: Int = 0
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        data <- map["data"]
        name <- map["name"]
        id <- map["id"]
    }
}

class ProfessionalData: Mappable {
    
    var updatedAt: Any?
    var languagesSpoken: String?
    var languagesWritten: String?
    var userId: NSNumber?
    var academicAndCertifications: String?
    var specializationIds: [String]?
    var experienceAndAchievements: String?
    var id: NSNumber?
    var introduction: String?
    var createdAt: Any?
    var termsOfService: String?
    var userDetail: TrainingUserDetail?
    var specializationDetails: specializationDetails?

    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        updatedAt <- map["updated_at"]
        languagesSpoken <- map["languages_spoken"]
        languagesWritten <- map["languages_written"]
        userId <- map["user_id"]
        academicAndCertifications <- map["academic_and_certifications"]
        specializationIds <- map["specialization_ids"]
        experienceAndAchievements <- map["experience_and_achievements"]
        id <- map["id"]
        introduction <- map["introduction"]
        createdAt <- map["created_at"]
        termsOfService <- map["terms_of_service"]
        userDetail <- map["user_detail"]
        specializationDetails <- map["specialization_details"]
    }
}


class TrainingUserDetail: Mappable {
    
    var name: String?
    var id: NSNumber?
    var photo: String?
    var email: String?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        id <- map["id"]
        photo <- map["photo"]
        email <- map["email"]
    }
}

class specializationDetails: Mappable {
    
    var name: String?
    var id: NSNumber?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        id <- map["id"]
    }
}
