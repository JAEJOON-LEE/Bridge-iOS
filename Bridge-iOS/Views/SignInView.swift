//
//  SignInView.swift
//  Bridge-iOS
//
//  Created by Park Gyurim on 2021/09/16.
//

import SwiftUI

struct SignInView: View {
    @AppStorage("userEmail") var userEmail : String = ""
    @AppStorage("userPW") var userPW : String = ""
    @AppStorage("rememberUser") var rememberUser : Bool = false
    
    @StateObject private var viewModel = SignInViewModel()
    
    var titleField : some View {
        Text("Log In")
            .font(.largeTitle)
            .fontWeight(.semibold)
            .foregroundColor(.mainTheme)
            .padding(.vertical, 60)
    }
    var emailField : some View {
        HStack {
            Image(systemName: "envelope")
            TextField("Email", text: $viewModel.email)
                .autocapitalization(.none)
                .accentColor(.mainTheme)
                .keyboardType(.emailAddress)
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
            Button {
                viewModel.checked.toggle()
            } label : {
                Image(systemName: !viewModel.checked ? "square" : "checkmark.square.fill")
                    .foregroundColor(!viewModel.checked ? .gray : .mainTheme)
            }
            Text("Remember Me").foregroundColor(.gray)
        }.padding(.horizontal, 30)
    }
    var nextButton : some View {
        Button {
            viewModel.showPrgoressView = true
            viewModel.SignIn(email: viewModel.email, password: viewModel.password)
        } label : {
            Text("Login")
                .fontWeight(.semibold)
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
                .fontWeight(.semibold)
                .foregroundColor(.mainTheme)
                .padding(10)
        }.padding(.bottom, UIDevice.current.hasNotch ? 0 : 30)
    }
    var otherSignInMethod : some View {
        HStack(spacing : 20) {
            Image("facebook")
                .resizable()
                .frame(width: 50, height: 50)
            Text("or").foregroundColor(.gray)
            Image("google")
                .resizable()
                .frame(width: 50, height: 50)
        }
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.systemDefaultGray
            
            VStack(spacing : 30) {
                titleField
                emailField
                passwordField
                remeberButton
                nextButton
                Spacer()
                //otherSignInMethod
                findPassword
                Spacer()
            }
            .frame(width : UIScreen.main.bounds.width, height : UIScreen.main.bounds.height * 0.8)
            .background(Color.white)
            .cornerRadius(15)
            .shadow(radius: 15)
            .offset(y : 10)
            
            if viewModel.showPrgoressView {
                VStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
            }
        }
        .onAppear {
            viewModel.checked = rememberUser
            viewModel.email = userEmail
            viewModel.password = userPW
        }
        .onDisappear{
            rememberUser = viewModel.checked
            if viewModel.checked {
                userEmail = viewModel.email
                userPW = viewModel.password
            } else {
                userEmail = ""
                userPW = ""
            }
        }
        .edgesIgnoringSafeArea(.vertical)
        .navigationTitle(Text(""))
        .alert(isPresented: $viewModel.showSignInFailAlert) {
            Alert(title: Text("Sign-In Failed"),
                  message: Text("Incorrect Email or Password"),
                  dismissButton: .cancel(Text("Retry")))
        }
    }
}
