//
//  Home+ResponseData.swift
//  Bridge-iOS
//
//  Created by Park Gyurim on 2021/09/28.
//

import Foundation

struct Element : Codable {
//    var campLast : Int
//    var areaLast : Int
    var postList : [Post]
}

struct Post : Codable, Hashable {
    let postId : Int
    let memberId : Int
    let title : String
    let price : Int
    let camp : String
    let viewCount : Int
    let image : String
    let createdAt : String
    let liked : Bool
}
