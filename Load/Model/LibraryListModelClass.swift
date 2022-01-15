import Foundation
import ObjectMapper

class LibraryListModelClass: Mappable {
    
    var count: NSNumber?
    var list: [ListLibraryList]?
    var index:NSNumber?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        count <- map["count"]
        list <- map["list"]
    }
}

class ListLibraryList: Mappable {
    
    var id: NSNumber?
    var data: [LibraryLogList]?
    var name: String?
    var type: String?

    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        data <- map["data"]
        name <- map["name"]
        type <- map["type"]
    }
}

//class DataLibraryList: Mappable {
//
//    var id: NSNumber?
//    var exerciseName: String?
//    var bodyPartId: NSNumber?
//    var bodySubPartId: NSNumber?
//    var isFavorite: Bool?
//    var userId: NSNumber?
//    var mechanicDetail: MechanicDetail?
//    var selected:Bool = false
//    var exercisesArray:[ResistanceExerciseModelClass] = [ResistanceExerciseModelClass]()
//
//    required init?(map: Map){
//    }
//
//    func mapping(map: Map) {
//        id <- map["id"]
//        exerciseName <- map["exercise_name"]
//        bodyPartId <- map["body_part_id"]
//        bodySubPartId <- map["body_sub_part_id"]
//        isFavorite <- map["is_favorite"]
//        userId <- map["user_id"]
//        mechanicDetail <- map["mechanic_detail"]
//    }
//}

class MechanicDetail: Mappable {
    
    var id: NSNumber?
    var name: String?
    var code: String?
    var isActive: NSNumber?
    var createdAt: Any?
    var updatedAt: Any?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        code <- map["code"]
        isActive <- map["is_active"]
        createdAt <- map["created_at"]
        updatedAt <- map["updated_at"]
    }
}

