//
//  BaseView.swift
//  Bridge-iOS
//
//  Created by Park Gyurim on 2022/01/06.
//

import SwiftUI

struct BaseView: View {
    @AppStorage("remeberUser") var remeberUser : Bool = false
    
    var body: some View {
        if remeberUser {
            AutoSignInView()
        } else {
            LandingView()
        }
    }
}
