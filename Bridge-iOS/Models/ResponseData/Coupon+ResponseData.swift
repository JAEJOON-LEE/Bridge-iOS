//
//  Coupon+ResponseData.swift
//  Bridge-iOS
//
//  Created by Park Gyurim on 2022/01/14.
//

import Foundation

struct ShopList : Codable {
    var shopList : [Shop]
}

struct Shop : Codable, Hashable {
    var shopId : Int
    var name : String
    var rate : Float
    var reviewCount : Int
    var benefit : String
    var image : String
}
