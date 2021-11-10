//
//  WritingView.swift
//  Bridge-iOS
//
//  Created by Park Gyurim on 2021/09/16.
//

import SwiftUI
import URLImage
import PhotosUI

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
                if(viewModel.isForSecretModifying!){
                    viewModel.modifySecretPost(title: viewModel.title, description: viewModel.description, anonymous: viewModel.anonymous, files: viewModel.files)
                }
                else {
                    viewModel.modifyPost(title: viewModel.title, description: viewModel.description, anonymous: viewModel.anonymous, files: viewModel.files)
                }
            }
            else{
                if(viewModel.isSecret){
                    viewModel.secretPost(title: viewModel.title, description: viewModel.description, anonymous: viewModel.anonymous, files: viewModel.files)
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
            if(viewModel.selectedImages.count != 3){
                viewModel.showImagePicker.toggle()
            }
        }, label: {
            HStack {
                Spacer()
                Text("\(viewModel.selectedImages.count) / 3").foregroundColor(.gray)
                Image(systemName: "camera").padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
            }.padding(.horizontal, 5)
        })
        .sheet(isPresented: $viewModel.showImagePicker) {
                        WritingPhotoPicker(configuration: viewModel.configuration, isPresented: $viewModel.showImagePicker, pickerResult: $viewModel.selectedImages)
                    }
//        .sheet(isPresented: $imagePickerPresented,
//               onDismiss: loadImage,
//               content: { ImagePicker(image: $viewModel.selectedImage) })
    }
    
//    func loadImage() {
//        guard let selectedImage = viewModel.selectedImage else { return }
//            viewModel.files = selectedImage.jpegData(compressionQuality: 1)
//        }
    
    var body: some View {
        VStack(spacing : 20) {
            if(!viewModel.isForModifying){
                HStack{
                    Text("Writing Post")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                }.padding(20)
            }else{
                HStack {
                    Text("Modify Post")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                }.padding(20)
            }
            
            if(viewModel.isForModifying){
                if(viewModel.isForSecretModifying!){
                    TextField(viewModel.infoForSecretModifying?.secretPostDetail.title ?? "Title not found",
                              text:  $viewModel.title)
                        .modifier(SignViewTextFieldStyle())
                    TextField(viewModel.infoForSecretModifying?.secretPostDetail.description ?? "Contents not found",
                              text: $viewModel.description)
                        .frame(height : UIScreen.main.bounds.height * 0.18 )
                        .modifier(SignViewTextFieldStyle())
                }
                else {
                    TextField(viewModel.isForModifying ? (viewModel.infoForModifying?.boardPostDetail.title ?? "Title not found") : "title",
                              text:  $viewModel.title)
                        .modifier(SignViewTextFieldStyle())
                    TextField(viewModel.isForModifying ? (viewModel.infoForModifying?.boardPostDetail.description ?? "Contents not found") : "content", text: $viewModel.description)
                        .frame(height : UIScreen.main.bounds.height * 0.18 )
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
                                .frame(width : UIScreen.main.bounds.width * 0.2, height : UIScreen.main.bounds.width * 0.2, alignment: .center)
                                .cornerRadius(10)
                            }
                        }
                    }
                }else{
                    Image(systemName: "photo")
                        .foregroundColor(.black)
                        .frame(width: 40, height: 40, alignment: .center)
                }

            }else{
                if viewModel.selectedImages.isEmpty {
                    VStack {
                        Image(systemName : "photo.on.rectangle.angled").font(.system(size : 40))
                        Text("Upload Pictures").font(.title)
                    }.foregroundColor(.gray)
                } else {
                    LazyVGrid(columns: [
//                                Button(action : {
//
//                                }, label : {
//                                    GridItem(.flexible())
//                                }),
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ]) {
                        ForEach(viewModel.selectedImages, id : \.self) {
                                Image(uiImage: $0)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width : UIScreen.main.bounds.width * 0.2, height : UIScreen.main.bounds.width * 0.2, alignment: .center)
                                    .clipped()
                                    .cornerRadius(10)
                        }
                    }.padding()
                }
            }
//            {
//                if(viewModel.selectedImage != nil){
//                    Image(uiImage: viewModel.selectedImage!)
//                        .resizable()
//                        .foregroundColor(.black)
//                        .frame(width: 70, height: 70, alignment: .center)
//                        .cornerRadius(10)
//                }else{
//                    Image(systemName: "photo")
//                        .foregroundColor(.black)
//                        .frame(width: 70, height: 70, alignment: .center)
//                }
//            }
            
            HStack{
                Toggle("Anonymous", isOn: $viewModel.anonymous)
                    .font(.system(size : 8))
                
                if(!viewModel.isForModifying){
//                    Spacer()
                    Toggle("Secret", isOn: $viewModel.isSecret)
                }
                
                imageButton
            }
            .padding(.horizontal, 30)
            .font(.caption)
            
//            if(!viewModel.isForModifying){
                Text("Policy Text Area : asdsbgaddasdsbgaddasdsbgaddasdsbgaddasdsbgaddasdsbgaddasdsbgaddasdsbgaddasdsbgaddasdsbgaddasdsbgaddasdsbgaddasdsbgaddasdsbgaddas")
                    .font(.caption2)
                    .padding(.horizontal, 30)
//            }
            
            uploadButton
//                .modifier(SubmitButtonStyle())
            Spacer()
        }
    }
//    .sheet(isPresented: $viewModel.showImagePicker) {
//        WritingPhotoPicker(configuration: viewModel.configuration, isPresented: $viewModel.showImagePicker, pickerResult: $viewModel.selectedImages)
//    }
}

struct WritingPhotoPicker: UIViewControllerRepresentable {
    let configuration: PHPickerConfiguration
    @Binding var isPresented: Bool
    @Binding var pickerResult : [UIImage]
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        let controller = PHPickerViewController(configuration: configuration)
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    // Use a Coordinator to act as your PHPickerViewControllerDelegate
    class Coordinator: PHPickerViewControllerDelegate {
        private let parent: WritingPhotoPicker
        
        init(_ parent: WritingPhotoPicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            for image in results {
                if image.itemProvider.canLoadObject(ofClass: UIImage.self)  {
                    image.itemProvider.loadObject(ofClass: UIImage.self) { (newImage, error) in
                        if let error = error {
                            print(error.localizedDescription)
                        } else {
                            self.parent.pickerResult.append(newImage as! UIImage)
                        }
                    }
                } else {
                    print("Loaded Assest is not a Image")
                }
            }
            // dissmiss the picker
            parent.isPresented = false
        }
    }
}

