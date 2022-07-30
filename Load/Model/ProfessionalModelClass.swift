import Foundation 
import ObjectMapper 

class ProfessionalModelClass: Mappable { 

	var specializationDetails: [ProfessionalSpecializationDetails]?
	var isAutoAccept: NSNumber? 
	var cancellationPolicyId: NSNumber? 
	var id: NSNumber? 
	var rate: String? 
	var perMultipleSessionRate: NSNumber? 
	var professionalTypeId: NSNumber?
    var locationName: String?
	var languagesWrittenIds: [String]? 
	var specializationIds: [Int]?
	var currencyId: NSNumber? 
    var amenities: [Amenities]?
    var amenitiesV2: [String]?
	var languagesSpokenIds: [String]? 
	var paymentOptionDetail: PaymentOptionDetail?
	var currencyDetail: ProfessionalCurrencyDetail?
	var experienceAndAchievements: String? 
	var generalRules: String? 
	var perSessionRate: NSNumber?
	var createdAt: Any? 
	var termsOfService: String? 
	var academicAndCertifications: String? 
	var updatedAt: String? 
	var cancellationPolicyDetail: ProfessionalCancellationPolicyDetail?
	var introduction: String? 
	var sessionDuration: String? 
	var paymentOptionId: NSNumber? 
	var userId: NSNumber? 
	var days: [String]?
    var sessionPerPackage: NSNumber?
	var sessionMaximumClients: NSNumber? 
	var basicRequirement: String?
	var languagesWrittenDetails: [ProfessionalLanguagesWrittenDetails]?
	var languagesSpokenDetails: [ProfessionalLanguagesSpokenDetails]?
	var profession: String? 
    var userDetail: ProfessionalUserDetail?
    var professionalTypeDetail: ProfessionalTypeDetail?
    var academicCredentials: [AcademicCredentials]?
    var isForms: Bool?
    var isAnswerd: Bool?

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		specializationDetails <- map["specialization_details"] 
		isAutoAccept <- map["is_auto_accept"] 
		cancellationPolicyId <- map["cancellation_policy_id"] 
		id <- map["id"] 
		rate <- map["rate"] 
		perMultipleSessionRate <- map["per_multiple_session_rate"] 
		professionalTypeId <- map["professional_type_id"]
        locationName <- map["location_name"]
		languagesWrittenIds <- map["languages_written_ids"]
        specializationIds <- map["specialization_ids"]
		currencyId <- map["currency_id"]
        newApiConfig ? amenitiesV2 <- map["amenities"] : amenities <- map["amenities"]
		languagesSpokenIds <- map["languages_spoken_ids"] 
		paymentOptionDetail <- map["payment_option_detail"] 
		currencyDetail <- map["currency_detail"] 
		experienceAndAchievements <- map["experience_and_achievements"] 
		generalRules <- map["general_rules"] 
		perSessionRate <- map["per_session_rate"] 
		createdAt <- map["created_at"] 
		termsOfService <- map["terms_of_service"] 
		academicAndCertifications <- map["academic_and_certifications"] 
		updatedAt <- map["updated_at"] 
		cancellationPolicyDetail <- map["cancellation_policy_detail"] 
		introduction <- map["introduction"] 
		sessionDuration <- map["session_duration"] 
		paymentOptionId <- map["payment_option_id"] 
		userId <- map["user_id"] 
		days <- map["days"]
        sessionPerPackage <- map["session_per_package"]
		sessionMaximumClients <- map["session_maximum_clients"] 
		basicRequirement <- map["basic_requirement"] 
		languagesWrittenDetails <- map["languages_written_details"] 
		languagesSpokenDetails <- map["languages_spoken_details"] 
		profession <- map["profession"]
        userDetail <- map["user_detail"]
        professionalTypeDetail <- map["professional_type_detail"]
        academicCredentials <- map["academic_credentials"]
        isForms <- map["is_forms"]
        isAnswerd <- map["is_answerd"]
	}
} 

class ProfessionalLanguagesSpokenDetails: Mappable {

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

class ProfessionalLanguagesWrittenDetails: Mappable {

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

class ProfessionalCancellationPolicyDetail: Mappable {

	var code: String? 
	var description: String? 
	var name: String? 
	var isActive: Bool? 
	var id: NSNumber? 

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		code <- map["code"] 
		description <- map["description"] 
		name <- map["name"] 
		isActive <- map["is_active"] 
		id <- map["id"] 
	}
} 

class ProfessionalCurrencyDetail: Mappable {

	var code: String? 
	var name: String? 
	var isActive: Bool? 
	var id: NSNumber? 

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		code <- map["code"] 
		name <- map["name"] 
		isActive <- map["is_active"] 
		id <- map["id"] 
	}
} 

class Amenities: Mappable {
    
    var value: Bool?
    var name: String?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        value <- map["value"]
        name <- map["name"]
    }
}

class ProfessionalSpecializationDetails: Mappable {

	var code: String? 
	var name: String? 
	var isActive: Bool?
    var isActiveV2: String?
	var id: NSNumber? 
	var createdAt: String?
	var updatedAt: String? 

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		code <- map["code"] 
		name <- map["name"] 
        newApiConfig ? isActiveV2 <- map["is_active"] : isActive <- map["is_active"]
		id <- map["id"] 
		createdAt <- map["created_at"] 
		updatedAt <- map["updated_at"] 
	}
} 

class PaymentOptionDetail: Mappable {
    
    var isActive: Bool?
    var description: String?
    var code: String?
    var createdAt: String?
    var updatedAt: String?
    var id: NSNumber?
    var name: String?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        isActive <- map["is_active"]
        description <- map["description"]
        code <- map["code"]
        createdAt <- map["created_at"]
        updatedAt <- map["updated_at"]
        id <- map["id"]
        name <- map["name"]
    }
}

class ProfessionalUserDetail: Mappable {
    
    var name: String?
    var longitude: String?
    var id: NSNumber?
    var latitude: String?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        longitude <- map["longitude"]
        id <- map["id"]
        latitude <- map["latitude"]
    }
}

class ProfessionalTypeDetail: Mappable {
    
    var updatedAt: String?
    var description: String?
    var code: String?
    var name: String?
    var isActive: Bool?
    var id: NSNumber?
    var createdAt: String?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        updatedAt <- map["updated_at"]
        description <- map["description"]
        code <- map["code"]
        name <- map["name"]
        isActive <- map["is_active"]
        id <- map["id"]
        createdAt <- map["created_at"]
    }
}

class AcademicCredentials: Mappable {
    
    var awardingInstitution: String?
    var courseOfStudy: String?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        awardingInstitution <- map["AwardingInstitution"]
        courseOfStudy <- map["CourseOfStudy"]
    }
}
