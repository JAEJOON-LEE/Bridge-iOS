//
//  ItemInfo+ResponseData.swift
//  Bridge-iOS
//
//  Created by Park Gyurim on 2021/10/05.
//

import Foundation

struct ItemInfo : Codable {
    var member : Member
    var usedPostDetail : UsedPostDetail
}

struct UsedPostDetail : Codable {
    var camps : [String]
    var category : String
    var createdAt : String // recieve value like "2021-10-03T21:34:20.209447"
    var description : String
    var like : Bool
    var likeCount : Int
    var postId : Int
    var postImages : [postImages]
    var price : Float
    var title : String
    var viewCount : Int
}

struct Member : Codable, Hashable {
    var description : String
    var memberId : Int
    var profileImage : String
    var username : String
}

struct postImages : Codable, Hashable {
    var image : String // image url
    var imageId : Int
}
