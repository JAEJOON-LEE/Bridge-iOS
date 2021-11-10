//
//  Comment+ResponseData.swift
//  Bridge-iOS
//
//  Created by 이재준 on 2021/10/10.
//

import Foundation

struct TotalCommentList : Codable, Hashable {
    var commentList : [CommentList]
}

struct CommentList : Codable, Hashable {
    var commentId : Int
    var content : String
    var anonymous : Bool
    var like : Bool
    var likeCount : Int
    var comments : [Comments]
    var createdAt : String
    var member : CommentMember?
    var modifiable : Bool
}

struct Comments : Codable, Hashable {
    var commentId : Int
    var content : String
    var anonymous : Bool
    var like : Bool
    var likeCount : Int
    var comments : [Comments]?
    var createdAt : String
    var member : CommentMember?
    var modifiable : Bool
}

struct CommentMember : Codable, Hashable {
    var memberId : Int?
    var username : String?
    var description : String?
    var profileImage : String?
}
