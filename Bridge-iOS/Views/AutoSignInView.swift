//
//  AutoSignInView.swift
//  Bridge-iOS
//
//  Created by Park Gyurim on 2022/01/06.
//

import SwiftUI

struct AutoSignInView: View {
    @AppStorage("userEmail") var userEmail : String = ""
    @AppStorage("userPW") var userPW : String = ""
    
    @StateObject private var viewModel = SignInViewModel()
    
//    init() {
//        viewModel.SignIn(email: userEmail, password: userPW)
//    }
//
    var body: some View {
        if !viewModel.signInDone {
            VStack {
                Image("LOGO")
                    .resizable()
                    .frame(width: 140, height: 140)
                    .padding()
                ProgressView()
            }
            .background( Image("Background") )
            .onAppear { viewModel.SignIn(email: userEmail, password: userPW) }
        } else {
            NavigationView {
                TabContainer()
                    .environmentObject(viewModel)
            }.accentColor(.mainTheme)
        }
        
    }
}
