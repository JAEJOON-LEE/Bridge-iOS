//
//  SignUpView.swift
//  Bridge-iOS
//
//  Created by Park Gyurim on 2021/09/16.
//

import SwiftUI

struct SignUpView: View {
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    
    var titleField : some View {
        Text("Create Account")
            .font(.largeTitle)
            .fontWeight(.semibold)
            .padding(.vertical, 60)
    }
    var nameField : some View {
        HStack {
            Image(systemName: "person")
            TextField("Full name", text: $name)
        }.modifier(SignViewTextFieldStyle())
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
    var nextButton : some View {
        Button("Next") {
            
        }
        .frame(width : UIScreen.main.bounds.width * 0.8)
        .padding()
        .foregroundColor(.white)
        .background(Color.mainTheme)
        .cornerRadius(20)
        .shadow(radius: 3)
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.mainTheme // background
            VStack(spacing : 30) {
                titleField
                nameField
                emailField
                passwordField
                nextButton
                Divider()
                HStack {
                    Text("Already have an account?")
                    NavigationLink(destination: SignInView()) {
                        Text("Sign in")
                            .foregroundColor(.mainTheme)
                    }
                }
                Spacer()
            }
            .frame(
                width : UIScreen.main.bounds.width,
                height : UIScreen.main.bounds.height * 0.8
            )
            .background(Color.white)
            .cornerRadius(15)
            .shadow(radius: 15)
        }.edgesIgnoringSafeArea(.all)
        
    
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
