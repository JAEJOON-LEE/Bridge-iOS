//
//  Data+Extension.swift
//  Bridge-iOS
//
//  Created by Park Gyurim on 2022/02/12.
//

import Foundation

// Data to Byte array
extension Data {
    var bytes: [UInt8] {
        return [UInt8](self)
    }
}
