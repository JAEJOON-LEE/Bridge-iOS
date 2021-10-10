//
//  WritingView.swift
//  Bridge-iOS
//
//  Created by Park Gyurim on 2021/09/16.
//

import SwiftUI

struct WritingView : View {
//    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel : WritingViewModel
    @EnvironmentObject private var signInViewModel : SignInViewModel
        
        init(viewModel : WritingViewModel) {
            self._viewModel = StateObject(wrappedValue: viewModel)
        }
    
    @State var isLinkActive : Bool = false
    @State var imagePickerPresented = false
    
    var uploadButton : some View {
        // temporary linked to TabContainer //
        Button {
//            self.presentationMode.wrappedValue.dismiss()
            isLinkActive = true
//            print(viewModel.email)
//            print(viewModel.password)
            viewModel.isWant ?
                viewModel.wantPost(title: viewModel.title, description: viewModel.description, anonymous: viewModel.anonymous, files: viewModel.files)
             :
                viewModel.post(title: viewModel.title, description: viewModel.description, anonymous: viewModel.anonymous, files: viewModel.files)
            
        } label : {
            Text("Upload")
                .modifier(SubmitButtonStyle())
//                .disabled(!viewModel.isValid())
//                .opacity(viewModel.isValid() ? 1.0 : 0.4)
        }
        .background(
            NavigationLink(
                destination: TabContainer()
                                .environmentObject(signInViewModel),
                isActive : $isLinkActive
            ) {
                // label
            }
        )
    }
    
    var imageButton : some View {
        Button(action: {
            imagePickerPresented.toggle()
        }, label: {
            Image(systemName: "camera").padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
        })
        .sheet(isPresented: $imagePickerPresented,
               onDismiss: loadImage,
               content: { ImagePicker(image: $viewModel.selectedImage) })
    }
    
    func loadImage() {
        guard let selectedImage = viewModel.selectedImage else { return }
            viewModel.files = selectedImage.jpegData(compressionQuality: 1)!
        }
    
    var body: some View {
        VStack(spacing : 20) {
            //LocationPicker()
            HStack {
                Text("Board Writing")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
            }.padding(20)
            TextField("title", text: $viewModel.title)
                .modifier(SignViewTextFieldStyle())
            TextField("titleContent", text: $viewModel.description)
                .frame(height : UIScreen.main.bounds.height * 0.3)
                .modifier(SignViewTextFieldStyle())
            HStack{
                Toggle("Anonymous", isOn: $viewModel.anonymous)
                Spacer()
                Toggle("Want U", isOn: $viewModel.isWant)
                
                imageButton
            }
            .padding(.horizontal, 30)
            .font(.caption)
                        
            uploadButton
//                .modifier(SubmitButtonStyle())
                
            Text("Policy Text Area : asdsbgaddasdsbgaddasdsbgaddasdsbgaddasdsbgaddasdsbgaddasdsbgaddasdsbgaddasdsbgaddasdsbgaddasdsbgaddasdsbgaddasdsbgaddasdsbgaddas")
                .font(.caption2)
                .padding(.horizontal, 30)
            
            Spacer()
        }
    }
}

