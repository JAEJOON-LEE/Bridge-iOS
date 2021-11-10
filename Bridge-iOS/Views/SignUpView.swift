//
//  SignUpView.swift
//  Bridge-iOS
//
//  Created by Park Gyurim on 2021/09/16.
//

import SwiftUI

struct SignUpView: View {
    @State var isLinkActive : Bool = false
    @ObservedObject var viewModel = SignUpViewModel()
//    init(){
//        viewModel.isLinkActive = false
//    }
    
    var titleField : some View {
        Text("Create Account")
            .font(.largeTitle)
            .fontWeight(.semibold)
            .padding(.vertical, 60)
    }
    var nameField : some View {
        HStack {
            Image(systemName: "person")
            TextField("Full name", text: $viewModel.name)
                .autocapitalization(.none)
                .accentColor(.mainTheme)
        }.modifier(SignViewTextFieldStyle())
    }
    var emailField : some View {
        HStack {
            Image(systemName: "envelope")
            TextField("Email", text: $viewModel.email)
                .autocapitalization(.none)
                .accentColor(.mainTheme)
        }.modifier(SignViewTextFieldStyle())
    }
    var passwordField : some View {
        HStack {
            Image(systemName: "lock")
            if viewModel.showPassword {
                TextField("Password", text: $viewModel.password)
                    .autocapitalization(.none)
                    .accentColor(.mainTheme)
            }
            else {
                SecureField("Password", text: $viewModel.password)
                    .autocapitalization(.none)
                    .accentColor(.mainTheme)
            }
            Button {
                viewModel.showPassword.toggle()
            } label : {
                Image(systemName: viewModel.showPassword ? "eye.slash" : "eye")
                    .foregroundColor(.black)
            }
        }
        .modifier(SignViewTextFieldStyle())
    }
    
    var verifyPasswordField : some View {
            HStack {
                Image(systemName: "lock")
                if viewModel.showPassword {
                    TextField("Verify Password", text: $viewModel.password2)
                        .autocapitalization(.none)
                        .accentColor(.mainTheme)
                } else {
                    SecureField("Verify Password", text: $viewModel.password2)
                        .autocapitalization(.none)
                        .accentColor(.mainTheme)
                }
            }
            .modifier(SignViewTextFieldStyle())
    }
    
    var nextButton : some View {
        Button {
                    viewModel.SendEmail(email: viewModel.email)
                    if(viewModel.statusCode1 == 200 && viewModel.statusCode2 == 200){
                        viewModel.showSignUpFailAlert = false
                        isLinkActive = true
                    }
//                    else if(viewModel.check == 1){
//                        isLinkActive = false
//                        viewModel.showSignUpFailAlert = true
//                    }
                    else{
                        isLinkActive = false
                        viewModel.showSignUpFailAlert = true
                    }
                } label : {
                    Text("Next")
                        .modifier(SubmitButtonStyle())
                }.background(
                    NavigationLink(
                        destination: SignUpAppendixView(viewModel: viewModel)
                                        .environmentObject(viewModel),
                        isActive : $isLinkActive
                    ) {
                        // label
                    }
                )
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.mainTheme // background
            
            VStack(spacing : 30) {
                titleField
                nameField
                emailField
                passwordField
                verifyPasswordField
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
            .padding(.bottom)
            .background(Color.white)
            .cornerRadius(15)
            .shadow(radius: 15)
        }
        .edgesIgnoringSafeArea(.all)
        .alert(isPresented: $viewModel.showSignUpFailAlert) {
            Alert(title: Text("Failed to create your account"),
                  message: Text(viewModel.message),
                  dismissButton: .cancel(Text("Retry")
                                         ,
                                         action: {
                                            viewModel.showSignUpFailAlert = false
                                            isLinkActive = false
                                         }
                  )
            )
        }
    }
}
