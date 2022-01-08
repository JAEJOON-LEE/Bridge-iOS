//
//  Board+ResponseData.swift
//  Bridge-iOS
//
//  Created by 이재준 on 2021/10/08.
//

import Foundation

struct TotalPostList : Codable, Hashable {
    var postList : [PostList]
}

struct PostList : Codable, Hashable {
    var member : BoardMember?
    var postInfo : BoardPostInfo
}

struct BoardPostInfo : Codable, Hashable{
    var postId : Int
    var title : String
    var likeCount : Int
    var commentCount : Int
    var description : String
    var image : String?
    var anonymous : Bool
    var createdAt : String
}

struct BoardMember : Codable, Hashable {
    var memberId : Int?
    var username : String?
    var description : String?
    var profileImage : String?
}

struct TotalPlayPostList : Codable,Hashable {
    var playPostList : [PlayPostList]
}

struct PlayPostList : Codable, Hashable {
    var postId : Int
    var postType : String
    var title : String
    var image : String?
    var description : String
    var likeCount : Int
    var commentCount : Int
    var createdAt : String
}
