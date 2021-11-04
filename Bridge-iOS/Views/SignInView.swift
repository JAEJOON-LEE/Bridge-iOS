//
//  SignInView.swift
//  Bridge-iOS
//
//  Created by Park Gyurim on 2021/09/16.
//

import SwiftUI

struct SignInView: View {
    @StateObject private var viewModel = SignInViewModel()
    
    var titleField : some View {
        Text("Log In")
            .font(.largeTitle)
            .fontWeight(.semibold)
            .padding(.vertical, 60)
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
            } else {
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
        }.modifier(SignViewTextFieldStyle())
    }
    var remeberButton : some View {
        HStack {
            Spacer()
            Toggle(isOn: $viewModel.checked) {
                Text("Remember Me")
            }.frame(width : UIScreen.main.bounds.width * 0.45)
        }.padding(.horizontal, 25)
    }
    var nextButton : some View {
        Button {
            viewModel.showPrgoressView = true
            viewModel.SignIn(email: viewModel.email, password: viewModel.password)
        } label : {
            Text("Next")
                .modifier(SubmitButtonStyle())
        }.background(
            NavigationLink(
                destination: TabContainer().environmentObject(viewModel),
                isActive : $viewModel.signInDone
            ) { }
        )
    }
    var findPassword : some View {
        NavigationLink(destination: FindPasswordView()){
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
            
            if viewModel.showPrgoressView {
                VStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .alert(isPresented: $viewModel.showSignInFailAlert) {
            Alert(title: Text("Sign-In Failed"),
                  message: Text("Incorrect Email or Password"),
                  dismissButton: .cancel(Text("Retry")))
        }
    }
}
