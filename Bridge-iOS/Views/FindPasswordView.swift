//
//  FindPasswordView.swift
//  Bridge-iOS
//
//  Created by Park Gyurim on 2021/11/04.
//

import SwiftUI

struct FindPasswordView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = FindPasswordViewModel()
    
    var titleField : some View {
        Text(viewModel.titleText)
            .font(.largeTitle)
            .fontWeight(.semibold)
            .padding(.vertical, 60)
            .foregroundColor(.mainTheme)
            .padding(.bottom, 50)
    }
    var submitButton : some View {
        Button {
            viewModel.buttonAction += 1
        } label : {
            Text("Next").modifier(SubmitButtonStyle())
        }
    }
    var dissmissButton : some View {
        HStack {
            Text("Already have an account?")
                .foregroundColor(.gray)
            Button { self.presentationMode.wrappedValue.dismiss() } label : {
                Text("Sign in")
                    .foregroundColor(.mainTheme)
            }
        }
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.systemDefaultGray
            VStack(spacing : 40) {
                titleField
                switch viewModel.buttonAction {
                case 0 :
                    HStack {
                        Image(systemName: "envelope")
                        TextField("Email", text: $viewModel.email)
                            .autocapitalization(.none)
                            .accentColor(.mainTheme)
                    }.modifier(SignViewTextFieldStyle())
                case 1 :
                    HStack {
                        TextField("Enter your code", text: $viewModel.email)
                            .autocapitalization(.none)
                            .accentColor(.mainTheme)
                    }.modifier(SignViewTextFieldStyle())
                case 2 :
                    VStack {
                        HStack {
                            Image(systemName: "lock.fill")
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
                        HStack {
                            Image(systemName: "lock.fill")
                            if viewModel.showPasswordConfirmation {
                                TextField("Password", text: $viewModel.passwordConfirmation)
                                    .autocapitalization(.none)
                                    .accentColor(.mainTheme)
                            } else {
                                SecureField("Password", text: $viewModel.passwordConfirmation)
                                    .autocapitalization(.none)
                                    .accentColor(.mainTheme)
                            }
                            Button {
                                viewModel.showPasswordConfirmation.toggle()
                            } label : {
                                Image(systemName: viewModel.showPasswordConfirmation ? "eye.slash" : "eye")
                                    .foregroundColor(.black)
                            }
                        }.modifier(SignViewTextFieldStyle())
                    }
                case 3 :
                    HStack {
                        
                    }
                default:
                    HStack {
                        
                    }
                }
                submitButton
                if (viewModel.buttonAction == 0 || viewModel.buttonAction == 1) {
                    dissmissButton
                }
            } // VStack
            .frame(
                width : UIScreen.main.bounds.width,
                height : UIScreen.main.bounds.height * 0.8
            )
            .background(Color.white)
            .cornerRadius(15)
            .shadow(radius: 15)
        } // ZStack
        .edgesIgnoringSafeArea(.vertical)
    }
}

struct FindPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        FindPasswordView()
    }
}
