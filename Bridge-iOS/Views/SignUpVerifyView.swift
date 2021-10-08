//
//  SignUpVerifyView.swift
//  Bridge-iOS
//
//  Created by 이재준 on 2021/10/07.
//

import SwiftUI

struct SignUpVerifyView: View {
    @State var isLinkActive : Bool = false
    @ObservedObject var viewModel : SignUpViewModel
    
    var titleField : some View {
        Text("Check your e-mail")
            .font(.largeTitle)
            .fontWeight(.semibold)
            .padding(.vertical, 60)
    }
    
    var noticeView : some View {
        Text("We sent a code to your e-mail. Please check your e-mail and type the code below.")
            .fontWeight(.semibold)
            .padding(40)
    }
    
    
    var codeField : some View {
        HStack {
            TextField("Enter your code", text: $viewModel.verifyCode)
                .autocapitalization(.none)
                .accentColor(.mainTheme)
        }.modifier(SignViewTextFieldStyle())
    }
    
    
    var doneButton : some View {
        Button {
            isLinkActive = true
//            print(viewModelData.email)
//            print(viewModelData.verifyCode)
            viewModel.VerifyEmail(email : viewModel.email, verifyCode : viewModel.verifyCode)
//
            
//            print(viewModel.name)
//            print(viewModel.email)
//            print(viewModel.password)
//            print(viewModel.role)
//            print(viewModel.nickname)
//            print(viewModel.description)
//            print(viewModel.verifyCode)
            
            viewModel.SignUp(name : viewModel.name, email : viewModel.email, password : viewModel.password, role : viewModel.role, nickname : viewModel.nickname, description : viewModel.description, profileImage : viewModel.profileImage, verifyCode : viewModel.verifyCode)
        } label : {
            Text("Done")
                .modifier(SubmitButtonStyle())
        }.background(
            NavigationLink(
                destination: SignInView()
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
                noticeView
                codeField
                Divider()
                doneButton
                Spacer()
            }
            .frame(width : UIScreen.main.bounds.width, height : UIScreen.main.bounds.height * 0.8)
            .padding(.bottom)
            .background(Color.white)
            .cornerRadius(15)
            .shadow(radius: 15)
        }.edgesIgnoringSafeArea(.all)
    }
}

struct SignUpVerifyView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
