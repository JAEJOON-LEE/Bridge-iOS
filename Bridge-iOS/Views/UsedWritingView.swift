//
//  UsedWritingView.swift
//  Bridge-iOS
//
//  Created by Park Gyurim on 2021/10/10.
//

import SwiftUI
import PhotosUI

struct UsedWritingView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel : UsedWritingViewModel
    
    init(viewModel : UsedWritingViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            VStack {
                Spacer().frame(height: UIScreen.main.bounds.height * 0.02)
                if viewModel.selectedImages.isEmpty {
                    Button {
                        viewModel.selectedImages.removeAll()
                        viewModel.showImagePicker.toggle()
                    } label : {
                        VStack {
                            Image("uploadImage")
                                .resizable()
                                .frame(width: UIScreen.main.bounds.width * 0.25, height : UIScreen.main.bounds.height * 0.1)
                                .aspectRatio(contentMode: .fill)
                                
                            Text("Upload Pictures")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.gray)
                        }
                        .frame(width : UIScreen.main.bounds.width * 0.95, height : UIScreen.main.bounds.height * 0.3)
                        .background(Color.mainTheme.opacity(0.04))
                        .cornerRadius(15)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.gray, style: StrokeStyle(lineWidth: 1, dash: [8]))
                        )
                    }
                } else {
                    TabView {
                        ForEach(viewModel.selectedImages, id : \.self) {
                            Image(uiImage: $0)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                        }
                    }.tabViewStyle(PageTabViewStyle())
                    .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                    .frame(width : UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 3)
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
                
                HStack {
                    Spacer()
                    Button {
                        viewModel.selectedImages.removeAll()
                        viewModel.showImagePicker.toggle()
                    } label : {
                        HStack {
                            Text("\(viewModel.selectedImages.count) / 7").foregroundColor(.gray)
                            Image(systemName: "camera").foregroundColor(.mainTheme)
                        }
                    }
                }.padding(.horizontal, 20)
                
                VStack {
                    VStack(spacing : 0) {
                        TextField(" Title", text: $viewModel.title)
                            .font(.system(size : 18, weight : .semibold))
                            .autocapitalization(.none)
                            .frame(height : UIScreen.main.bounds.height * 0.05)
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.systemDefaultGray)
                            .frame(width : UIScreen.main.bounds.width * 0.95, height: 7)
                        
                        TextField(" Price ($)", text: $viewModel.price)
                            .keyboardType(.decimalPad)
                            .font(.system(size : 18, weight : .semibold))
                            .autocapitalization(.none)
                            .frame(height : UIScreen.main.bounds.height * 0.05)
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.systemDefaultGray)
                            .frame(width : UIScreen.main.bounds.width * 0.95, height: 7)
                    }.padding(.horizontal, 20)
                    HStack {
                        Button {
                            viewModel.showCampPicker = true
                        } label : {
                            VStack {
                                HStack {
                                    Text("Camp").fontWeight(.semibold)
                                    if !viewModel.selectedCamps.isEmpty {
                                        Image(systemName : "checkmark.circle.fill")
                                            .foregroundColor(.mainTheme)
                                    }
                                }
                                if viewModel.selectedCamps.isEmpty {
                                    Image(systemName: "arrowtriangle.down.fill")
                                        .font(.system(size : 12))
                                }
                                
                            }
                        }
                        .foregroundColor(.darkGray)
                        .frame(width: UIScreen.main.bounds.width * 0.45, height: UIScreen.main.bounds.height * 0.06)
                        .background(Color.systemDefaultGray)
                        .cornerRadius(10)
                        .shadow(radius: 1)
                        Spacer()
                        Button {
                            viewModel.showCategoryPicker = true
                        } label : {
                            VStack {
                                HStack {
                                    Text("Category").fontWeight(.semibold)
                                    if viewModel.selectedCategory != "" {
                                        Image(systemName : "checkmark.circle.fill")
                                            .foregroundColor(.mainTheme)
                                    }
                                }
                                if viewModel.selectedCategory == "" {
                                    Image(systemName: "arrowtriangle.down.fill")
                                        .font(.system(size : 12))
                                }
                            }
                        }
                        .foregroundColor(.darkGray)
                        .frame(width: UIScreen.main.bounds.width * 0.45, height: UIScreen.main.bounds.height * 0.06)
                        .background(Color.systemDefaultGray)
                        .cornerRadius(10)
                        .shadow(radius: 1)
                    }
                    .padding(10)
                    .padding(.horizontal, 10)
                    
                    TextEditor(text: $viewModel.description)
                        .onAppear() {
                            UITextView.appearance().backgroundColor = UIColor(.systemDefaultGray)
                        }.onDisappear() {
                            UITextView.appearance().backgroundColor = nil
                        }
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .frame(maxWidth : .infinity, minHeight : UIScreen.main.bounds.height * 0.2, maxHeight : .infinity)
                        .background(Color.systemDefaultGray)
                        .cornerRadius(10)
                        .shadow(radius: 1)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 5)
                        .onTapGesture {
                            if viewModel.description == "Please write the content of your Post" {
                                viewModel.description = ""
                            }
                        }
                        .foregroundColor(.darkGray)
                    
                    Button {
                        // API Call
                        viewModel.upload()
                        withAnimation { viewModel.isProgressShow = true }
                    } label : {
                        Text("DONE")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.06)
                            .background(Color.mainTheme)
                            .cornerRadius(30)
                    }
                }
            } // VStack
//            .onTapGesture {
//                    hideKeyboard()
//            }
            .onChange(of: viewModel.isUploadDone, perform: { _ in
                self.presentationMode.wrappedValue.dismiss()
            })
            .navigationBarTitle(Text("Sell your stuff"), displayMode: .inline)
            .sheet(isPresented: $viewModel.showImagePicker) {
                PhotoPicker(configuration: viewModel.configuration, isPresented: $viewModel.showImagePicker, pickerResult: $viewModel.selectedImages)
            }
            .sheet(isPresented: $viewModel.showCampPicker) {
                NavigationView {
                    List {
                        ForEach(viewModel.camps, id: \.self) { camp in
                            HStack {
                                Text(camp)
                                Spacer()
                                if viewModel.selectedCamps.contains(viewModel.campToNum[camp]!) {
                                    Image(systemName : "checkmark.circle.fill")
                                        .foregroundColor(.mainTheme)
                                }
                            }
                            .onTapGesture {
                                if viewModel.selectedCamps.contains(viewModel.campToNum[camp]!) {
                                    viewModel.selectedCamps
                                        .remove(at: viewModel.selectedCamps.firstIndex(of: viewModel.campToNum[camp]!)!)
                                } else {
                                    viewModel.selectedCamps.append(viewModel.campToNum[camp]!)
                                }
                                print(viewModel.selectedCamps)
                            }
                        }
                    }.listStyle(GroupedListStyle())
                    .navigationBarTitle(Text("Select Camps"), displayMode: .inline)
                    .navigationBarItems(trailing: Button { viewModel.showCampPicker = false } label : { Text("Done").foregroundColor(.mainTheme) } )
                }
            }
            .sheet(isPresented: $viewModel.showCategoryPicker) {
                NavigationView {
                    List {
                        ForEach(viewModel.categories, id: \.self) { category in
                            HStack {
                                Text(category)
                                Spacer()
                                if viewModel.selectedCategory == category {
                                    Image(systemName : "checkmark.circle.fill")
                                        .foregroundColor(.mainTheme)
                                }
                            }.onTapGesture {
                                viewModel.selectedCategory = category
                            }
                        }
                    }.listStyle(GroupedListStyle())
                    .navigationBarTitle(Text("Select Category"), displayMode: .inline)
                    .navigationBarItems(trailing: Button { viewModel.showCategoryPicker = false } label : { Text("Done").foregroundColor(.mainTheme) } )
                }
            }
            
            if viewModel.isProgressShow {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .frame(width : UIScreen.main.bounds.width * 0.7,
                           height : UIScreen.main.bounds.height * 0.35)
                    .background(Color.black.opacity(0.6))
                    .cornerRadius(20)
            }
        }
    }
}

struct PhotoPicker: UIViewControllerRepresentable {
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
        private let parent: PhotoPicker
        
        init(_ parent: PhotoPicker) {
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
