//
//  SignUpAppendixView.swift
//  Bridge-iOS
//
//  Created by 이재준 on 2021/10/07.
//

import SwiftUI

struct SignUpAppendixView: View {
    @State var isLinkActive : Bool = false
    @State private var imagePickerPresented = false
    @State private var imageSelected = false
    
    @ObservedObject var viewModel : SignUpViewModel
    
    var titleField : some View {
        Text("Your Profile")
            .font(.largeTitle)
            .fontWeight(.semibold)
            .padding(.top, 60)
            .foregroundColor(Color.mainTheme)
    }
    
    var profileImageField : some View {
        Button(action: {
            imagePickerPresented.toggle()
        }, label: {
            
            if(imageSelected){
                Image(uiImage: viewModel.profileImage!)
                    .resizable()
                    .shadow(radius: 1, x: 0, y: -1)
            }
            else{
                ZStack(alignment: .bottom){
                    Circle()
                        .stroke(lineWidth : 3)
                        .foregroundColor(Color.white)
                        .shadow(radius: 1, x: 0, y: -1)
                    
                    Image(systemName: "camera.fill")
                        .frame(width : UIScreen.main.bounds.width * 0.25, height : UIScreen.main.bounds.width * 0.25, alignment: .center)
                }
            }
        })
        .foregroundColor(Color.mainTheme)
        .frame(width : UIScreen.main.bounds.width * 0.25, height : UIScreen.main.bounds.width * 0.25, alignment: .center)
        .clipShape(Circle())
        .sheet(isPresented: $imagePickerPresented,
               onDismiss: loadImage,
               content: { ImagePicker(image: $viewModel.profileImage) })
    }
    
    func loadImage() {
        guard let profileImage = viewModel.profileImage else { return }
            imageSelected = true
        }
    
    var nicknameField : some View {
        HStack {
            TextField("Nickname", text: $viewModel.nickname)
                .autocapitalization(.none)
                .accentColor(.mainTheme)
        }
        .modifier(SignViewTextFieldStyle())
        .shadow(radius: 1, x: 0, y: 1)
    }
    
    var descField : some View {
        HStack {
            TextField("About me (Option)", text: $viewModel.description)
                .autocapitalization(.none)
                .accentColor(.mainTheme)
        }
        .frame(width: 200, height: 150)
        .modifier(SignViewTextFieldStyle())
        .shadow(radius: 1, x: 0, y: 1)
    }
    
    var doneButton : some View {
        
        Button {
            if(viewModel.nickname.count == 0){
                viewModel.showSignUpFailAlert = true
                isLinkActive = false
            }else{
                isLinkActive = true
                viewModel.showSignUpFailAlert = false
            }
        } label : {
            Text("Done")
                .modifier(SubmitButtonStyle())
        }
        .background(
            NavigationLink(
                destination: SignUpCheckUserTypeView(viewModel: viewModel)
                    .environmentObject(viewModel),
                isActive : $isLinkActive
            ) {
                // label
            }
        )

    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.systemDefaultGray // background
            
            VStack(spacing : 10) {
                titleField
                profileImageField
                    .padding()
                nicknameField
                    .padding(.bottom)
                descField
                doneButton
                    .padding(.top, 40)
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
                  message: Text("Please check your nickname"),
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
