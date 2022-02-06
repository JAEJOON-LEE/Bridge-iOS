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
        Text("Sign Up")
            .font(.largeTitle)
            .fontWeight(.semibold)
            .padding(.vertical, 30)
            .foregroundColor(Color.mainTheme)
    }
    var nameField : some View {
        HStack {
            Image(systemName: "person")
                .foregroundColor(Color.mainTheme)
            TextField("Full name", text: $viewModel.name)
                .autocapitalization(.none)
                .accentColor(.mainTheme)
        }.modifier(SignViewTextFieldStyle())
    }
    var emailField : some View {
        HStack {
            Image(systemName: "envelope")
                .foregroundColor(Color.mainTheme)
            TextField("Email", text: $viewModel.email)
                .autocapitalization(.none)
                .accentColor(.mainTheme)
                .keyboardType(.emailAddress)
        }.modifier(SignViewTextFieldStyle())
    }
    var passwordField : some View {
        HStack {
            Image(systemName: "lock")
                .foregroundColor(Color.mainTheme)
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
                if viewModel.showPassword2 {
                    TextField("Verify Password", text: $viewModel.password2)
                        .autocapitalization(.none)
                        .accentColor(.mainTheme)
                } else {
                    SecureField("Verify Password", text: $viewModel.password2)
                        .autocapitalization(.none)
                        .accentColor(.mainTheme)
                }
                Button {
                    viewModel.showPassword2.toggle()
                } label : {
                    Image(systemName: viewModel.showPassword2 ? "eye.slash" : "eye")
                        .foregroundColor(.black)
                }
            }
            .modifier(SignViewTextFieldStyle())
    }
    
    var nextButton : some View {
        Button {
            _ = viewModel.CheckValidation()
            if(viewModel.signUpDone == true) {
                viewModel.CheckDuplication(email: viewModel.email)
                usleep(300)
//                if(viewModel.statusCode1 == 200 && viewModel.statusCode2 == 200){
//                    viewModel.SendEmail(email: viewModel.email)
//                }
                
            //                    else if(viewModel.check == 1){
            //                        isLinkActive = false
            //                        viewModel.showSignUpFailAlert = true
            //                    }
//            else{
//                //                        viewModel.showSignUpFailAlert = true
//            }
            }} label : {
            Text("Next")
                .modifier(SubmitButtonStyle())
        }.background(
            NavigationLink(
                destination: SignUpVerifyView(viewModel: viewModel)
                    .environmentObject(viewModel),
                isActive : $viewModel.isFirstLinkActive
            ) {
                // label
            }
        )
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.systemDefaultGray // background
            
            VStack(spacing : 30) {
                Spacer()
                titleField
                nameField
                emailField
                passwordField
                verifyPasswordField
                Text("Password should be 8~15 digits and contain at least one uppercase.")
                    .foregroundColor(Color.gray)
                    .font(.system(size: 9))
                    .padding(-20)
                nextButton
                Divider()
                HStack {
                    Text("Already have an account?")
                    NavigationLink(destination: SignInView()) {
                        Text("Sign in")
                            .foregroundColor(.mainTheme)
                    }
                }
            }
            .frame(width : UIScreen.main.bounds.width, height : UIScreen.main.bounds.height * 0.8)
            .padding(.bottom)
            .background(Color.white.edgesIgnoringSafeArea(.all))
            .cornerRadius(15)
            .shadow(radius: 15)
        }.overlay(
            VStack(spacing : 0) {
                Spacer()
                Color.white
                    .frame(height : UIScreen.main.bounds.height * 0.03)
            }.edgesIgnoringSafeArea(.bottom)
        )
        .edgesIgnoringSafeArea(.all)
        .alert(isPresented: $viewModel.showSignUpFailAlert) {
            Alert(title: Text("Failed to create your account"),
                  message: Text(viewModel.message),
                  dismissButton: .cancel(Text("Retry")
                                         ,
                                         action: {
                                            viewModel.showSignUpFailAlert = false
                                         }
                  )
            )
        }
    }
}

