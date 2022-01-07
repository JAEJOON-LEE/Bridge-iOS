//
//  BaseView.swift
//  Bridge-iOS
//
//  Created by Park Gyurim on 2022/01/06.
//

import SwiftUI

struct BaseView: View {
    @AppStorage("rememberUser") var rememberUser : Bool = false
    
    var body: some View {
        if rememberUser {
            AutoSignInView()
        } else { // rememberUser == false
            LandingView()
        }
    }
}
