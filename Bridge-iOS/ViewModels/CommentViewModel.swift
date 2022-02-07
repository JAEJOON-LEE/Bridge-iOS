//
//  CommentViewModel.swift
//  Bridge-iOS
//
//  Created by 이재준 on 2021/10/10.
//

import Foundation
import Combine
import Alamofire

final class CommentViewModel : ObservableObject {
    var commentList : CommentList
    let token : String
    @Published var  isMyComment : Bool = false
    let postId : Int
    let commentId : Int
    let memberId : Int
    
    @Published var isLiked : Bool?
    @Published var likeCount : Int = 0
    
    @Published var isMenuClicked : Bool = false
    @Published var showAction : Bool = false
    @Published var showConfirmDeletion : Bool = false
    @Published var showCommentModify : Bool = false
    
    init(token : String, commentList : CommentList, postId : Int, commentId : Int, memberId : Int, isMyComment : Bool) {
        self.token = token
        self.commentList = commentList
        self.postId = postId
        self.commentId = commentId
        self.memberId = memberId
        self.isMyComment = isMyComment
        
//        self.isCocClicked = false
    }
    
    var content : String { commentList.content }
    var createdAt : String { commentList.createdAt }
    var profileImage : String { commentList.member?.profileImage ?? "https://static.thenounproject.com/png/741653-200.png"}
    var userName : String { commentList.member?.username ?? "Anonymous" }
    var commetMemberId : Int { commentList.member?.memberId ?? -1}
    
    
    func deleteComment() {
        let url = "http://ALB-PRD-BRIDGE-BRIDGE-898468050.ap-northeast-2.elb.amazonaws.com/board-posts/\(postId)/comments/\(commentId)"
        let header: HTTPHeaders = [ "X-AUTH-TOKEN" : token ]
        
        AF.request(url,
                   method: .delete,
                   encoding: URLEncoding.default,
                   headers: header
        ).responseJSON { json in
//            print(json)
        }
    }
    
    func likeComment(isliked : Bool) {
        let url = "http://ALB-PRD-BRIDGE-BRIDGE-898468050.ap-northeast-2.elb.amazonaws.com/comments/\(commentId)/likes"
        let header: HTTPHeaders = [ "X-AUTH-TOKEN" : token ]
        let method : HTTPMethod = isliked ? .delete : .post
        
        AF.request(url,
                   method: method,
                   encoding: URLEncoding.default,
                   headers: header
        ).response { json in
            print(json)
        }
    }
    
    func likeCommentOfComment(isliked : Bool, cocId : Int) {
        let url = "http://ALB-PRD-BRIDGE-BRIDGE-898468050.ap-northeast-2.elb.amazonaws.com/comments/\(cocId)/likes"
        let header: HTTPHeaders = [ "X-AUTH-TOKEN" : token ]
        let method : HTTPMethod = isliked ? .delete : .post
        
        AF.request(url,
                   method: method,
                   encoding: URLEncoding.default,
                   headers: header
        ).response { json in
            print(json)
        }
    }
    
    func convertReturnedDateString(_ timeString : String) -> String {
        var str = timeString
        str.removeSubrange(str.index(str.endIndex, offsetBy: -7)..<str.endIndex)
        str.remove(at: str.index(str.startIndex, offsetBy: 10))
        str.insert(" ", at: str.index(str.startIndex, offsetBy: 10))
        
        let korNow = Date(timeIntervalSinceNow: 32400) // UTC + 9H
        let timetravel = korNow.timeIntervalSince(str.toDate() ?? Date())
        
        if Int(timetravel) < 60 {
            return "\(Int(timetravel)) Seconds ago"
        } else if (60 <= Int(timetravel)) && (Int(timetravel) < 3600) {
            return "\(Int(timetravel) / 60) Minutes ago"
        } else if (3600 <= Int(timetravel)) && (Int(timetravel) < 86400) {
            return "\(Int(timetravel) / 3600) Hours ago"
        } else if (86400 <= Int(timetravel)) && (Int(timetravel) < (86400 * 7)) { // 7일까지
            return "\(Int(timetravel) / 86400) Days ago"
        } else {
            str.removeSubrange(str.index(str.endIndex, offsetBy: -9)..<str.endIndex)
            return str
        }
    }
}

/*
 
 struct CommentList : Codable, Hashable {
     var commentId : Int
     var content : String
     var anonymous : Bool
     var like : Bool
     var likeCount : Int
     var comments : [Comments]
     var commentMember : CommentMember?
     var createdAt : String
     var member : CommentMember
 }

 struct Comments : Codable, Hashable {
     var commentId : Int
     var content : String
     var anonymous : Bool
     var like : Bool
     var likeCount : Int
     var comments : [Comments]
     var createdAt : String
     var member : CommentMember
 }

 struct CommentMember : Codable, Hashable {
     var memberId : Int?
     var username : String?
     var description : String?
     var profileImage : String?
 }
 */
