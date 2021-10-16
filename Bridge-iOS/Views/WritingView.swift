//
//  WritingView.swift
//  Bridge-iOS
//
//  Created by Park Gyurim on 2021/09/16.
//

import SwiftUI
import URLImage

struct WritingView : View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel : WritingViewModel
        
    init(viewModel : WritingViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    @State var isLinkActive : Bool = false
    @State var imagePickerPresented = false
    
    var uploadButton : some View {
        // temporary linked to TabContainer //
        Button {
            self.presentationMode.wrappedValue.dismiss()
            isLinkActive = true
//            print(viewModel.email)
//            print(viewModel.password)
            if(viewModel.isForModifying){
                if(viewModel.isForWantModifying!){
                    viewModel.modifyWantPost(title: viewModel.title, description: viewModel.description, anonymous: viewModel.anonymous, files: viewModel.files)
                }
                else {
                    viewModel.modifyPost(title: viewModel.title, description: viewModel.description, anonymous: viewModel.anonymous, files: viewModel.files)
                }
            }
            else{
                if(viewModel.isWant){
                    viewModel.wantPost(title: viewModel.title, description: viewModel.description, anonymous: viewModel.anonymous, files: viewModel.files)
                }
                else {
                    viewModel.post(title: viewModel.title, description: viewModel.description, anonymous: viewModel.anonymous, files: viewModel.files)
                }
            }
        } label : {
            Text("Upload")
                .modifier(SubmitButtonStyle())
//                .disabled(!viewModel.isValid())
//                .opacity(viewModel.isValid() ? 1.0 : 0.4)
        }
//        .background(
//            NavigationLink(
//                destination: TabContainer()
//                 .environmentObject(signInViewModel),
//                isActive : $isLinkActive
//            ) {
//                // label
//            }
//        )
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
            viewModel.files = selectedImage.jpegData(compressionQuality: 1)
        }
    
    var body: some View {
        VStack(spacing : 20) {
            if(!viewModel.isForModifying){
                HStack{
                    Spacer()
                }.padding()
            }else{
                HStack {
                    Text("Modify Post")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                }.padding(20)
            }
            
            if(viewModel.isForModifying){
                if(viewModel.isForWantModifying!){
                    TextField(viewModel.infoForWantUModifying?.wantPostDetail.title ?? "Title not found",
                              text:  $viewModel.title)
                        .modifier(SignViewTextFieldStyle())
                    TextField(viewModel.infoForWantUModifying?.wantPostDetail.description ?? "Contents not found",
                              text: $viewModel.description)
                        .frame(height : (viewModel.isForModifying) ? (UIScreen.main.bounds.height * 0.3) : (UIScreen.main.bounds.height * 0.18) )
                        .modifier(SignViewTextFieldStyle())
                }
                else {
                    TextField(viewModel.isForModifying ? (viewModel.infoForModifying?.boardPostDetail.title ?? "Title not found") : "title",
                              text:  $viewModel.title)
                        .modifier(SignViewTextFieldStyle())
                    TextField(viewModel.isForModifying ? (viewModel.infoForModifying?.boardPostDetail.description ?? "Contents not found") : "content", text: $viewModel.description)
                        .frame(height : (viewModel.isForModifying) ? (UIScreen.main.bounds.height * 0.3) : (UIScreen.main.bounds.height * 0.18) )
                        .modifier(SignViewTextFieldStyle())
                }
            }
            else {
                TextField("title", text:  $viewModel.title)
                    .modifier(SignViewTextFieldStyle())
                TextField("content", text: $viewModel.description)
                    .frame(height : UIScreen.main.bounds.height * 0.18 )
                    .modifier(SignViewTextFieldStyle())
            }
            
            if(viewModel.isForModifying){
                if(viewModel.infoForModifying?.boardPostDetail.postImages != nil){
                    HStack{
                    ForEach(viewModel.infoForModifying?.boardPostDetail.postImages ?? [], id : \.self) { imageInfo in
                        URLImage(
                            URL(string : imageInfo.image) ??
                            URL(string: "https://static.thenounproject.com/png/741653-200.png")!
                        ) { image in
                            image
                                .resizable()
                                .foregroundColor(.black)
                                .frame(width: 70, height: 70, alignment: .center)
                                .cornerRadius(10)
                        }
                    }
                    }
                }else{
                    Image(systemName: "photo")
                        .foregroundColor(.black)
                        .frame(width: 70, height: 70, alignment: .center)
                }

            }else{
                if(viewModel.selectedImage != nil){
                    Image(uiImage: viewModel.selectedImage!)
                        .resizable()
                        .foregroundColor(.black)
                        .frame(width: 70, height: 70, alignment: .center)
                        .cornerRadius(10)
                }else{
                    Image(systemName: "photo")
                        .foregroundColor(.black)
                        .frame(width: 70, height: 70, alignment: .center)
                }
            }
            
            HStack{
                Toggle("Anonymous", isOn: $viewModel.anonymous)
                
                if(!viewModel.isForModifying){
                    Spacer()
                    Toggle("Want U", isOn: $viewModel.isWant)
                }
                
                imageButton
            }
            .padding(.horizontal, 30)
            .font(.caption)
            
            if(!viewModel.isForModifying){
                Text("Policy Text Area : asdsbgaddasdsbgaddasdsbgaddasdsbgaddasdsbgaddasdsbgaddasdsbgaddasdsbgaddasdsbgaddasdsbgaddasdsbgaddasdsbgaddasdsbgaddasdsbgaddas")
                    .font(.caption2)
                    .padding(.horizontal, 30)
            }
            
            uploadButton
//                .modifier(SubmitButtonStyle())
            Spacer()
        }
    }
}
