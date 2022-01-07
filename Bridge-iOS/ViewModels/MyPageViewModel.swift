//
//  MyPageViewModel.swift
//  Bridge-iOS
//
//  Created by Park Gyurim on 2022/01/06.
//

import Foundation


final class MyPageViewModel : ObservableObject {
    let userInfo : SignInResponse
    
    init(signInResponse : SignInResponse) {
        userInfo = signInResponse
    }
}
