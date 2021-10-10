//
//  TabContainerViewModel.swift
//  Bridge-iOS
//
//  Created by Park Gyurim on 2021/09/16.
//

import Foundation

final class TabContainerViewModel : ObservableObject {
    @Published var selectedTabIndex = 2 // Home ( Market )
    @Published var showUsedPostWriting : Bool = false
    
    func navigationBarTitleText() -> String {
        switch selectedTabIndex {
        case 1 : return "Home"
        case 2 : return "Board"
        case 3 : return "Write"
        case 4 : return "Seller"
        case 5 : return "Message"
        default:
            return ""
        }
    }
}
