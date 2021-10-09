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
    }
    
    var profileImageField : some View {
        Button(action: {
            imagePickerPresented.toggle()
        }, label: {
            
            if(imageSelected){
                Image(uiImage: viewModel.profileImage!)
                    .resizable()
            }
            else{
                Image(systemName: "camera.fill")
            }
        })
        .foregroundColor(.black)
        .frame(width : UIScreen.main.bounds.width * 0.35, height : UIScreen.main.bounds.width * 0.35, alignment: .center)
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
            Image(systemName: "person")
            TextField("Nickname", text: $viewModel.nickname)
                .autocapitalization(.none)
                .accentColor(.mainTheme)
        }.modifier(SignViewTextFieldStyle())
    }
    
    var descField : some View {
        HStack {
            Image(systemName: "doc.plaintext")
            TextEditor(text: $viewModel.description)
                .autocapitalization(.none)
                .accentColor(.mainTheme)
        }
        .frame(width: 200, height: 150)
        .modifier(SignViewTextFieldStyle())
    }
    
    var doneButton : some View {
        Button {
            isLinkActive = true
        } label : {
            Text("Done")
                .modifier(SubmitButtonStyle())
        }.background(
            NavigationLink(
                destination: SignUpVerifyView(viewModel: viewModel)
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
            
            VStack(spacing : 10) {
                titleField
                profileImageField
                nicknameField
                descField
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

struct SignUpAppendixView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
