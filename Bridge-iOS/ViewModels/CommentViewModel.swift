//
//  CommentViewModel.swift
//  Bridge-iOS
//
//  Created by 이재준 on 2021/10/10.
//

import Foundation

final class CommentViewModel : ObservableObject {
    let commentList : CommentList
    
    init(commentList : CommentList) {
        self.commentList = commentList
    }
    
    var content : String { commentList.content }
    var createdAt : String { commentList.createdAt }
    var profileImage : String { commentList.member?.profileImage ?? "nil"}
    var userName : String { commentList.member?.username ?? "nil" }
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
