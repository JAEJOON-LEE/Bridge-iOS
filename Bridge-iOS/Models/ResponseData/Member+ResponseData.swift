//
//  Member+ResponseData.swift
//  Bridge-iOS
//
//  Created by Park Gyurim on 2022/01/10.
//

import Foundation

struct MemeberInformation : Codable {
    var memberId : Int
    var username : String
    var description : String
    var profileImage : String
    var chatAlarm : Bool
    var playgroundAlarm : Bool
    var usedAlarm : Bool
}
