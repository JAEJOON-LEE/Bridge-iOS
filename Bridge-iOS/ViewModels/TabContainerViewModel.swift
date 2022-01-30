//
//  TabContainerViewModel.swift
//  Bridge-iOS
//
//  Created by Park Gyurim on 2021/09/16.
//

import Foundation

final class TabContainerViewModel : ObservableObject {
    @Published var selectedTabIndex = 1 // Home
    @Published var showUsedPostWriting : Bool = false
    
    @Published var isLocationBtnClicked : Bool = false
    @Published var selectedDistrict : String = "Casey/Hovey"
    
    let locations = ["Casey/Hovey", "USAG Yongsan", "K-16", "Suwon A/B", "Osan A/B", "Camp Humperys", "Camp Carroll", "Henry/Walker", "Gunsan A/B"]

    func navigationBarTitleText() -> String {
        switch selectedTabIndex {
        case 1 : return "" // Home
        case 2 : return "Playground"
        case 3 : return "Write"
        case 4 : return "" // Coupons
        case 5 : return "Chat"
        default:
            return ""
        }
    }
}
