//
//  PostInfo+ResponseData.swift
//  Bridge-iOS
//
//  Created by 이재준 on 2021/10/08.
//

import Foundation

struct TotalBoardPostDetail : Codable {
    var boardPostDetail : BoardPostDetail
    var postMember : PostMember?
}

struct BoardPostDetail : Codable {
    var postId : Int
    var title : String
    var description : String
    var createdAt : String // recieve value like "2021-10-03T21:34:20.209447"
    var anonymous : Bool
    var like : Bool
    var likeCount : Int
    var postImages : [PostImages]
}

struct PostMember : Codable, Hashable {
    var description : String?
    var memberId : Int?
    var profileImage : String?
    var username : String?
}

struct PostImages : Codable, Hashable {
    var image : String // image url
    var imageId : Int
}
