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
    let commentList : CommentList
    let token : String
    let isMyComment : Bool
    private let postId : Int
    private let commentId : Int
    
    @Published var isMenuClicked : Bool = false
    @Published var showAction : Bool = false
    @Published var showConfirmDeletion : Bool = false
    @Published var showPostModify : Bool = false
    
    init(token : String, commentList : CommentList, postId : Int, commentId : Int, isMyComment : Bool) {
        self.token = token
        self.commentList = commentList
        self.postId = postId
        self.commentId = commentId
        self.isMyComment = isMyComment
    }
    
    var content : String { commentList.content }
    var createdAt : String { commentList.createdAt }
    var profileImage : String { commentList.member?.profileImage ?? "nil"}
    var userName : String { commentList.member?.username ?? "nil" }
    
    
    func deleteComment() {
        let url = "http://3.36.233.180:8080/board-posts/\(postId)/comments/\(commentId)"
        let header: HTTPHeaders = [ "X-AUTH-TOKEN" : token ]
        
        AF.request(url,
                   method: .delete,
                   encoding: URLEncoding.default,
                   headers: header
        ).responseJSON { json in
//            print(json)
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
