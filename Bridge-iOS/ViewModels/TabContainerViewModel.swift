//
//  TabContainerViewModel.swift
//  Bridge-iOS
//
//  Created by Park Gyurim on 2021/09/16.
//

import Foundation

final class TabContainerViewModel : ObservableObject {
    @Published var selectedTabIndex = 1 // Home ( Market )
    @Published var showUsedPostWriting : Bool = false
    
    func navigationBarTitleText() -> String {
        switch selectedTabIndex {
        case 1 : return "" // Home
        case 2 : return "Playground"
        case 3 : return "Write"
        case 4 : return "" // Coupons
        case 5 : return "Chatting"
        default:
            return ""
        }
    }
}
