//
//  SignUpVerifyView.swift
//  Bridge-iOS
//
//  Created by 이재준 on 2021/10/07.
//

import SwiftUI

struct SignUpVerifyView: View {
//    @Environment(\.presentationMode) var presentationMode
    @State var isLinkActive : Bool = false
    @ObservedObject var viewModel : SignUpViewModel
    
    var titleField : some View {
        Text("Check your mail box")
            .font(.largeTitle)
            .fontWeight(.semibold)
            .padding(.vertical, 60)
            .foregroundColor(Color.mainTheme)
    }
    
    var noticeView : some View {
        Text("We sent a code to your e-mail. Please check your e-mail and type the code below.")
            .fontWeight(.semibold)
            .padding(40)
    }
    
    
    var codeField : some View {
        HStack {
            TextField("Enter your code", text: $viewModel.verifyCode)
                .autocapitalization(.allCharacters)
                .accentColor(.mainTheme)
        }.modifier(SignViewTextFieldStyle())
    }
    
    
    var doneButton : some View {
        Button {
            
            viewModel.VerifyEmail(email : viewModel.email, verifyCode : viewModel.verifyCode)
            
            if(viewModel.statusCode3 == 200 || viewModel.statusCode3 == 201){
                viewModel.showSignUpFailAlert = false
                isLinkActive = true
            }else{
                viewModel.showSignUpFailAlert = true
                isLinkActive = false
            }
//            viewModel.SignUp(name : viewModel.name, email : viewModel.email, password : viewModel.password, role : viewModel.role, nickname : viewModel.nickname, description : viewModel.description, profileImage : viewModel.profileImage, verifyCode : viewModel.verifyCode)
        } label : {
            if(viewModel.verifyCode.count != 8){
                Text("Done")
                    .modifier(DisabledButtonStyle())
                
            }else{
                Text("Done")
                    .modifier(SubmitButtonStyle())
                    .background(
                        NavigationLink(
                            destination: SignUpAppendixView(viewModel: viewModel)
                                .environmentObject(viewModel),
                            isActive : $isLinkActive
                        ) {
                            // label
                        }
                    )
            }
        }
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.systemDefaultGray // background
            
            VStack(spacing : 30) {
                titleField
                noticeView
                codeField
                Divider()
                doneButton
                HStack(alignment: .lastTextBaseline) {
                    Button(action: {
//                            self.presentationMode.wrappedValue.dismiss()
                            }) {
                        Text("Did not receive?")
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
                  message: Text("Please input the code sent to your email"),
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

struct SignUpVerifyView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
