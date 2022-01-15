import Foundation 
import ObjectMapper 

class FeedCommentListModelClass: Mappable { 

	var likeDetails: LikeDetails? 
	var commentDetails: CommentDetails? 

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		likeDetails <- map["like_details"] 
		commentDetails <- map["comment_details"] 
	}
} 

class CommentDetails: Mappable { 

	var count: NSNumber? 
	var list: [FeedCommentListList]? 

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		count <- map["count"] 
		list <- map["list"] 
	}
} 

class FeedCommentListList: Mappable {
    
    var userDetail: UserDetail?
    var updatedAt: String?
    var feedId: NSNumber?
    var userId: NSNumber?
    var createdAt: String?
    var comment: String?
    var id: NSNumber?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        userDetail <- map["user_detail"]
        updatedAt <- map["updated_at"]
        feedId <- map["feed_id"]
        userId <- map["user_id"]
        createdAt <- map["created_at"]
        comment <- map["comment"]
        id <- map["id"]
    }
} 

class LikeDetails: Mappable { 

	var isLiked: Bool? 
	var images: [Images]? 
	var updatedAt: String? 
	var createdAt: String? 
	var feedId: NSNumber? 
	var userDetail: Any? 
	var id: NSNumber? 
	var userIds: [String]? 

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		isLiked <- map["is_liked"] 
		images <- map["images"] 
		updatedAt <- map["updated_at"] 
		createdAt <- map["created_at"] 
		feedId <- map["feed_id"] 
		userDetail <- map["user_detail"] 
		id <- map["id"] 
		userIds <- map["user_ids"] 
	}
} 

class Images: Mappable { 

	var photo: String? 
	var id: NSNumber? 

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		photo <- map["photo"] 
		id <- map["id"] 
	}
} 

