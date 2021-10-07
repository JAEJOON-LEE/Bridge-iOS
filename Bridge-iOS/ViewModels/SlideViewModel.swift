//
//  SlideViewModel.swift
//  Bridge-iOS
//
//  Created by Park Gyurim on 2021/10/07.
//

import Foundation

final class SlideViewModel : ObservableObject {
    var userInfo : SignInResponse
    
    init(userInfo : SignInResponse) {
        self.userInfo = userInfo
    }
    
}
