//
//  Coupon+ResponseData.swift
//  Bridge-iOS
//
//  Created by Park Gyurim on 2022/01/14.
//

import Foundation

// shop list
struct ShopList : Codable {
    var shopList : [Shop]
}

struct Shop : Codable, Hashable {
    var shopId : Int
    var name : String
    //var rate : Float
    var reviewCount : Int
    var benefit : String
    var image : String
}

// shop info
struct ShopInfo : Codable {
    var shopId : Int
    var name : String
    var location : String
    var coordinate : String
    var description : String
    var oneLineDescription : String
    //var rate : Float
    var reviewCount : Int
    var benefit : String
    var images : [ShopImage]
}

struct ShopImage : Codable, Hashable {
    var imageId : Int
    var image : String
}

// review
struct ReviewList : Codable {
    var reviewList : [Review]
}
struct Review : Codable, Hashable {
    var reviewId : Int
    var content : String
    //var rate : Float
    var createdAt : String
    var member : Member
}

/*
 struct Member : Codable, Hashable {
     var description : String
     var memberId : Int
     var profileImage : String
     var username : String
 }
*/
