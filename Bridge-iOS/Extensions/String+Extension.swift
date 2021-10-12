//
//  String+Extension.swift
//  Bridge-iOS
//
//  Created by Park Gyurim on 2021/10/12.
//

import Foundation

extension String {
    func toDate() -> Date? { //"yyyy-MM-dd HH:mm:ss"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        if let date = dateFormatter.date(from: self) { return date }
        else { return nil }
    }
}
