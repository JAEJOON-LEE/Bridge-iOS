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
            //            print(viewModel.email)
            //            print(viewModel.password)
            //            if(viewModel.isForModifying){
            
            if(viewModel.isForSecretModifying){
                viewModel.modifySecretPost(title: viewModel.title, description: viewModel.description, anonymous: viewModel.anonymous, files: viewModel.files)
                //                    withAnimation { viewModel.isProgressShow = true }
            }
            else if(viewModel.isForModifying){
                viewModel.modifyPost(title: viewModel.title, description: viewModel.description, anonymous: viewModel.anonymous, files: viewModel.files)
                //                    withAnimation { viewModel.isProgressShow = true }
            }
            else{
                if(viewModel.description != "Please write the content of your post." && viewModel.description.count != 0 && viewModel.title.count != 0){
                    
                    
                    if(viewModel.isSecret){
                        viewModel.secretPost(title: viewModel.title, description: viewModel.description, anonymous: viewModel.anonymous, files: viewModel.files)
                        //                    withAnimation { viewModel.isProgressShow = true }
                    }
                    else {
                        viewModel.post(title: viewModel.title, description: viewModel.description, anonymous: viewModel.anonymous, files: viewModel.files)
                        //                    withAnimation { viewModel.isProgressShow = true }
                    }
                    withAnimation { viewModel.isProgressShow = true }
                }
                else{
                    viewModel.showAlert = true
                }
            }
        } label : {
            Text("Upload")
                .modifier(SubmitButtonStyle())
//                .disabled(!viewModel.isValid())
//                .opacity(viewModel.isValid() ? 1.0 : 0.4)
        }.alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Alert"),
                  message: Text("Please fill the title and contents"),
                  dismissButton: .default(Text("Close")))
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
            viewModel.selectedImages.removeAll()
            viewModel.showImagePicker.toggle()
        }, label: {
            HStack {
                Spacer()
//                Text("\(viewModel.selectedImages.count) / 3").foregroundColor(.gray)
                Image("cam").padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                    .foregroundColor(Color.mainTheme)
                    .font(.system(size : 20))
            }.padding(.horizontal, 5)
        })
        .sheet(isPresented: $viewModel.showImagePicker) {
                        WritingPhotoPicker(configuration: viewModel.configuration, isPresented: $viewModel.showImagePicker, pickerResult: $viewModel.selectedImages)
                    }
    }
    
    var body: some View {
        ZStack{
            ScrollView {
                ScrollViewReader { value in
                    VStack(spacing : 20) {
                        //            if(!viewModel.isForModifying){
                        //                HStack{
                        //                    Text("Board Writing")
                        //                        .font(.largeTitle)
                        //                        .fontWeight(.bold)
                        //                    Spacer()
                        //                }.padding(20)
                        //            }else{
                        //                HStack {
                        //                    Text("Board Modifying")
                        //                        .font(.largeTitle)
                        //                        .fontWeight(.bold)
                        //                    Spacer()
                        //                }.padding(20)
                        //            }
                        
                        if(viewModel.isForSecretModifying){
                            TextField(viewModel.infoForSecretModifying?.secretPostDetail.title ?? "Title not found",
                                      text:  $viewModel.title)
                            //                        .modifier(SignViewTextFieldStyle())
                                .font(.system(size : 25))
                                .border(Color.white)
                                .padding()
                            
                            TextField(viewModel.infoForSecretModifying?.secretPostDetail.description ?? "Contents not found",
                                      text: $viewModel.description)
                                .frame(width :UIScreen.main.bounds.width * 0.85,height : UIScreen.main.bounds.height * 0.3 )
                                .padding()
                            //                        .modifier(SignViewTextFieldStyle())
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(Color.gray, style: StrokeStyle(lineWidth: 1, dash: [8]))
                                )
                        }
                        else if(viewModel.isForModifying){
                            TextField(viewModel.isForModifying ? (viewModel.infoForModifying?.boardPostDetail.title ?? "Title not found") : "title",
                                      text:  $viewModel.title)
                            //                        .modifier(SignViewTextFieldStyle())
                                .font(.system(size : 25))
                                .border(Color.white)
                                .padding()
                            
                            TextField(viewModel.isForModifying ? (viewModel.infoForModifying?.boardPostDetail.description ?? "Contents not found") : "content", text: $viewModel.description)
                                .frame(width :UIScreen.main.bounds.width * 0.85, height : UIScreen.main.bounds.height * 0.3 )
                            //                        .modifier(SignViewTextFieldStyle())
                                .padding()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(Color.gray, style: StrokeStyle(lineWidth: 1, dash: [8]))
                                )
                        }
                        else {
                            TextField("Title", text:  $viewModel.title)
                            //                    .modifier(SignViewTextFieldStyle())
                                .font(.system(size : 25))
                                .border(Color.white)
                                .padding()
                            
                            TextEditor(text: $viewModel.description)
                                .foregroundColor(viewModel.description == "Please write the content of your post." ? Color.gray : Color.black)
                                .frame(width :UIScreen.main.bounds.width * 0.85, height : UIScreen.main.bounds.height * 0.3 )
                                .padding()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(Color.gray, style: StrokeStyle(lineWidth: 1, dash: [8]))
                                )
                                .onTapGesture{
                                    if viewModel.description == "Please write the content of your post." {
                                        viewModel.description = ""
                                    }
                                }
                                .onChange(of: viewModel.description) { _ in
                                    withAnimation {
                                        value.scrollTo(1, anchor: .bottom)
                                    }
                                }
                        }
                        
                        HStack{
                            //                Toggle("Anonymous", isOn: $viewModel.anonymous)
                            Spacer()
                            
                            Text("Anonymous").foregroundColor(.gray)
                            Button {
                                viewModel.anonymous.toggle()
                            } label : {
                                Image(systemName: !viewModel.anonymous ? "square" : "checkmark.square.fill")
                                    .foregroundColor(!viewModel.anonymous ? .gray : .mainTheme)
                            }
                            
                            if(!viewModel.isForModifying){
                                Spacer()
                                
                                Text("S-SPACE").foregroundColor(.gray)
                                Button {
                                    viewModel.isSecret.toggle()
                                } label : {
                                    Image(systemName: !viewModel.isSecret ? "square" : "checkmark.square.fill")
                                        .foregroundColor(!viewModel.isSecret ? .gray : .mainTheme)
                                }
                            }
                            
                            Spacer()
                            
                            imageButton
                        }
                        .padding(.horizontal, 30)
                        .font(.caption)
                        .font(.system(size : 20))
                        
                        
                        if(viewModel.isForModifying){
                            if !viewModel.selectedImages.isEmpty {
                                HStack {
                                    ForEach(viewModel.selectedImages, id : \.self) {
                                        Image(uiImage: $0)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width : UIScreen.main.bounds.width * 0.2, height: UIScreen.main.bounds.width * 0.2)
                                            .cornerRadius(10)
                                            .padding()
                                    }
                                }
                                .tabViewStyle(PageTabViewStyle())
                                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                                .frame(width : UIScreen.main.bounds.width * 0.95)
                                .cornerRadius(10)
                                .onTapGesture {
                                    viewModel.isImageTap.toggle() // 이미지 확대 보기 기능
                                }
                                .fullScreenCover(isPresented: $viewModel.isImageTap, content: {
                                    ZStack(alignment : .topTrailing) {
                                        TabView {
                                            ForEach(viewModel.selectedImages, id : \.self) {
                                                Image(uiImage: $0)
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                            }
                                        }.tabViewStyle(PageTabViewStyle())
                                            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                                            .frame(width : UIScreen.main.bounds.width)
                                        
                                        Button {
                                            viewModel.isImageTap.toggle()
                                        } label : {
                                            Image(systemName : "xmark")
                                                .foregroundColor(.mainTheme)
                                                .font(.system(size : 20))
                                                .padding()
                                        }
                                    }
                                })
                            }
                            else if(viewModel.infoForModifying?.boardPostDetail.postImages != nil){
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
                                                .padding()
                                        }
                                    }
                                }
                            }else{
                                //                    Button {
                                //                        viewModel.selectedImages.removeAll()
                                //                        viewModel.showImagePicker.toggle()
                                //                    } label : {
                                //                        VStack {
                                //                            Image("uploadImage")
                                //                                .resizable()
                                //                                .frame(width: UIScreen.main.bounds.width * 0.2, height : UIScreen.main.bounds.height * 0.05)
                                //                                .aspectRatio(contentMode: .fill)
                                //
                                //                            Text("Upload Pictures")
                                //                                .font(.title3)
                                //                                .fontWeight(.semibold)
                                //                                .foregroundColor(.gray)
                                //                        }
                                //                        .frame(width : UIScreen.main.bounds.width * 0.95, height : UIScreen.main.bounds.width * 0.2)
                                //                        .background(Color.mainTheme.opacity(0.04))
                                //                        .cornerRadius(15)
                                //                        .overlay(
                                //                            RoundedRectangle(cornerRadius: 15)
                                //                                .stroke(Color.gray, style: StrokeStyle(lineWidth: 1, dash: [8]))
                                //                        )
                                //                    }
                            }
                        }else{
                            if viewModel.selectedImages.isEmpty {
                                //                    Button {
                                //                        viewModel.selectedImages.removeAll()
                                //                        viewModel.showImagePicker.toggle()
                                //                    } label : {
                                //                        VStack {
                                //                            Image("uploadImage")
                                //                                .resizable()
                                //                                .frame(width: UIScreen.main.bounds.width * 0.2, height : UIScreen.main.bounds.height * 0.05)
                                //                                .aspectRatio(contentMode: .fill)
                                //
                                //                            Text("Upload Pictures")
                                //                                .font(.title3)
                                //                                .fontWeight(.semibold)
                                //                                .foregroundColor(.gray)
                                //                        }
                                //                        .frame(width : UIScreen.main.bounds.width * 0.95, height : UIScreen.main.bounds.width * 0.2)
                                //                        .background(Color.mainTheme.opacity(0.04))
                                //                        .cornerRadius(15)
                                //                        .overlay(
                                //                            RoundedRectangle(cornerRadius: 15)
                                //                                .stroke(Color.gray, style: StrokeStyle(lineWidth: 1, dash: [8]))
                                //                        )
                                //                    }
                            } else {
                                HStack {
                                    ForEach(viewModel.selectedImages, id : \.self) {
                                        Image(uiImage: $0)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width : UIScreen.main.bounds.width * 0.2, height: UIScreen.main.bounds.width * 0.2)
                                            .cornerRadius(10)
                                            .padding()
                                    }
                                }
                                .tabViewStyle(PageTabViewStyle())
                                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                                .frame(width : UIScreen.main.bounds.width * 0.95)
                                .cornerRadius(10)
                                .onTapGesture {
                                    viewModel.isImageTap.toggle() // 이미지 확대 보기 기능
                                }
                                .fullScreenCover(isPresented: $viewModel.isImageTap, content: {
                                    ZStack(alignment : .topTrailing) {
                                        TabView {
                                            ForEach(viewModel.selectedImages, id : \.self) {
                                                Image(uiImage: $0)
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                            }
                                        }.tabViewStyle(PageTabViewStyle())
                                            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                                            .frame(width : UIScreen.main.bounds.width)
                                        
                                        Button {
                                            viewModel.isImageTap.toggle()
                                        } label : {
                                            Image(systemName : "xmark")
                                                .foregroundColor(.mainTheme)
                                                .font(.system(size : 20))
                                                .padding()
                                        }
                                    }
                                })
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
                        
                        
                        //            if(!viewModel.isForModifying){
                        
                        if(viewModel.selectedImages.isEmpty){
                            Spacer()
                                .frame(height: UIScreen.main.bounds.width * 0.2)
                        }
                        VStack(alignment: .leading){
                            Text("Terms of Use")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundColor(Color.gray)
                            
                            Text("For the better community and communication, we are establishing some rules for the playground. Violation of the rules below may result in the deletion of posts and restriction of service use by the monitoring team.  1. We are forbidding acts for criminal purposes or infringing on the rights of others. Examples: - Acts that can cause or aid any possible crimes - Acts that cause discomfort or displeasure to other users. - Acts that insult another person or spread lies 1. We are forbidding discrimination based on gender, religion, sexual orienation,  disability, age, and social status. Examples:  - Acts that insult specific gender or sexual orientation - Acts that contains hate speach for specific group 1. We are forbidding acts that violate the constitution or threaten national security. Examples: - Acts that may significantly harm international peace and international order, such as terrorism. - Acts that leaking secrets which is prescribed by law. 1. We are forbidding uploading content with serious violence, cruelty and disgust. Examples: - Acts that belittle life or describing serious damage to the body. - Acts that describe murder, assault, intimidation and abuse against a specific person. 1. We are forbidding any abnormal use or abuse of Playground Examples: - Acts that manipulate public opinion using anonymity - Acts that cause traffic or make error intentionally")
                                .foregroundColor(Color.gray)
                                .font(.system(size : 11))
                        }
                        .padding()
                        
                        
                        //            }
                        
                        uploadButton
                        //                .modifier(SubmitButtonStyle())
                        Spacer()
                    }
                    .onAppear{
                        viewModel.description = ""
                        if(!viewModel.isForModifying){
                            viewModel.description = "Please write the content of your post."
                        }
                        viewModel.selectedImages.removeAll()
                        viewModel.title = ""
                        viewModel.isSecret = false
                    }
                    .onTapGesture {
                        hideKeyboard()
                    }
                    .onChange(of: viewModel.isUploadDone, perform: { _ in
                        self.presentationMode.wrappedValue.dismiss()
                    })
                    .navigationBarTitle(viewModel.isForModifying ? Text("Board Modifying") : Text("Board Writing"), displayMode: .inline)
                    .navigationBarBackButtonHidden(true)
                    .navigationBarItems(
                        leading : Button {
                            self.presentationMode.wrappedValue.dismiss()
                        } label : {
                            Image(systemName : "chevron.backward")
                                .foregroundColor(.black)
                                .font(.system(size : 15, weight : .bold))
                        }
                    )
                    
                    //            if viewModel.isProgressShow {
                    //                HStack (spacing : 20) {
                    //                    ProgressView()
                    //                        .progressViewStyle(CircularProgressViewStyle(tint: Color.mainTheme))
                    //                    Text("Loading...")
                    //                        .foregroundColor(.darkGray)
                    //                }
                    //                .frame(width : UIScreen.main.bounds.width * 0.6, height : UIScreen.main.bounds.height * 0.15)
                    //                .cornerRadius(30)
                    //                .background(Color.white.shadow(radius: 3))
                    //            }
                }
                .edgesIgnoringSafeArea(.bottom)
            }
            //    .sheet(isPresented: $viewModel.showImagePicker) {
            //        WritingPhotoPicker(configuration: viewModel.configuration, isPresented: $viewModel.showImagePicker, pickerResult: $viewModel.selectedImages)
            //    }
        }
        .onAppear {
            viewModel.anonymous = false
        }
    }
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
