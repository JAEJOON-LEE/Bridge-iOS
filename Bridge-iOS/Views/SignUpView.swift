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
    @State private var showPassword = false
    @State private var secureFieldFocused = false
    
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
                .autocapitalization(.none)
                .accentColor(.mainTheme)
        }.modifier(SignViewTextFieldStyle())
    }
    var emailField : some View {
        HStack {
            Image(systemName: "envelope")
            TextField("Email", text: $email)
                .autocapitalization(.none)
                .accentColor(.mainTheme)
        }.modifier(SignViewTextFieldStyle())
    }
    var passwordField : some View {
        HStack {
            Image(systemName: "lock")
            if showPassword {
                TextField("Password", text: $password, onCommit : { withAnimation { secureFieldFocused = false } })
                    .autocapitalization(.none)
                    .accentColor(.mainTheme)
            } else {
                SecureField("Password", text: $password, onCommit : { withAnimation { secureFieldFocused = false } })
                    .autocapitalization(.none)
                    .accentColor(.mainTheme)
            }
            Button {
                showPassword.toggle()
            } label : {
                Image(systemName: showPassword ? "eye.slash" : "eye")
                    .foregroundColor(.black)
            }
        }
        .modifier(SignViewTextFieldStyle())
        .onTapGesture {
            withAnimation {
                secureFieldFocused = true
            }
        }
    }
    var nextButton : some View {
        Button("Next") { }
        .modifier(SubmitButtonStyle())
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
            .frame(width : UIScreen.main.bounds.width, height : UIScreen.main.bounds.height * 0.8)
            .padding(.bottom, secureFieldFocused ? 70 : 0)
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
