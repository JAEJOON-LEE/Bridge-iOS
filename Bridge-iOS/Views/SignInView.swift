//
//  SignInView.swift
//  Bridge-iOS
//
//  Created by Park Gyurim on 2021/09/16.
//

import SwiftUI

struct SignInView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var checked = false

    var titleField : some View {
        Text("Log In")
            .font(.largeTitle)
            .fontWeight(.semibold)
            .padding(.vertical, 60)
    }
    var emailField : some View {
        HStack {
            Image(systemName: "envelope")
            TextField("Email", text: $email)
        }.modifier(SignViewTextFieldStyle())
    }
    var passwordField : some View {
        HStack {
            Image(systemName: "lock")
            SecureField("Password", text: $password)
        }.modifier(SignViewTextFieldStyle())
    }
    var remeberButton : some View {
        HStack {
            Spacer()
            Toggle(isOn: $checked) {
                Text("Remember Me")
            }.frame(width : UIScreen.main.bounds.width * 0.45)
        }.padding(.horizontal, 25)
    }
    var nextButton : some View {
        // temporary linked to TabContainer
        NavigationLink(destination : TabContainer()) {
            Text("Next")
                .frame(width : UIScreen.main.bounds.width * 0.8)
                .padding()
                .foregroundColor(.white)
                .background(Color.mainTheme)
                .cornerRadius(20)
                .shadow(radius: 3)
        }
    }
    var findPassword : some View {
        NavigationLink(destination:
                        Color.mainTheme
                        .ignoresSafeArea(.all)
                        .overlay(
                            Text("Find password")
                        )
        ){
            Text("Forgot Password?")
                .foregroundColor(.mainTheme)
                .padding(10)
        }
    }
    var otherSignInMethod : some View {
        HStack(spacing : 50) {
            Image("facebook")
                .resizable()
                .frame(width: 50, height: 50)
            Image("google")
                .resizable()
                .frame(width: 50, height: 50)
        }
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.mainTheme
            VStack(spacing : 30) {
                titleField
                emailField
                passwordField
                remeberButton
                nextButton
                findPassword
                Divider()
                otherSignInMethod
                Spacer()
            }
            .frame(width : UIScreen.main.bounds.width, height : UIScreen.main.bounds.height * 0.8)
            .background(Color.white)
            .cornerRadius(15)
            .shadow(radius: 15)
        }.edgesIgnoringSafeArea(.all)
    }
}


struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
