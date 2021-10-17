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
                    isLinkActive = true
                    viewModel.SendEmail(email: viewModel.email)
                } label : {
                    Text("Next")
                        .modifier(SubmitButtonStyle())
                }.background(
                    NavigationLink(
                        destination: SignUpAppendixView(viewModel: viewModel)
                                        .environmentObject(viewModel),
                        isActive : $viewModel.signUpDone
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
                  message: Text("Please check your inputs again"),
                  dismissButton: .cancel(Text("Retry")))
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
