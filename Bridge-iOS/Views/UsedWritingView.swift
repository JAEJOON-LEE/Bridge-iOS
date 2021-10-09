//
//  UsedWritingView.swift
//  Bridge-iOS
//
//  Created by Park Gyurim on 2021/10/10.
//

import SwiftUI
import PhotosUI

struct UsedWritingView: View {
    @State var showImagePicker: Bool = false
    @State var Images : [UIImage] = []
    @State var title : String = ""
    @State var price : String = ""
    @State var description : String = ""


    var configuration : PHPickerConfiguration {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.filter = .images
        configuration.selectionLimit = 3
        
        return configuration
    }
    
    var body: some View {
        VStack {
            Spacer().frame(height : 25)
            Button {
                Images.removeAll()
                showImagePicker.toggle()
            } label : {
                VStack {
                    Image(systemName : "photo.on.rectangle.angled").font(.system(size : 70))
                    Text("Upload Pictures").font(.title)
                }.foregroundColor(.gray)
            }
            .frame(width : UIScreen.main.bounds.width * 0.95, height : UIScreen.main.bounds.height * 0.3)
            .background(
                ZStack {
                    Color.mainTheme.opacity(0.05).cornerRadius(15)
                    RoundedRectangle(cornerRadius: 15).stroke(style: StrokeStyle(lineWidth: 1, dash: [8]))
                }
            )
            
            HStack {
                Spacer()
                Text("\(Images.count) / 3").foregroundColor(.gray)
                Image(systemName: "camera").foregroundColor(.mainTheme)
            }.padding(.horizontal, 5)
            
            VStack {
                VStack(spacing : 0) {
                    TextField("Title", text: $title)
                        .frame(height : UIScreen.main.bounds.height * 0.05)
                    Divider()
                     .frame(height: 1)
                     .background(Color.systemDefaultGray)
                    
                    TextField("Price ($)", text: $price)
                        .frame(height : UIScreen.main.bounds.height * 0.05)
                    Divider()
                     .frame(height: 1)
                     .background(Color.systemDefaultGray)
                }.padding(.horizontal, 10)
                HStack {
                    Button {
                        
                    } label : {
                        Text("Categories")
                            .foregroundColor(.black)
                            .frame(width: UIScreen.main.bounds.width * 0.45, height: UIScreen.main.bounds.height * 0.05)
                            .background(Color.systemDefaultGray)
                            .cornerRadius(10)
                            .shadow(radius: 1)
                    }
                    Spacer()
                    Button {
                        
                    } label : {
                        Text("Camp")
                            .foregroundColor(.black)
                            .frame(width: UIScreen.main.bounds.width * 0.45, height: UIScreen.main.bounds.height * 0.05)
                            .background(Color.systemDefaultGray)
                            .cornerRadius(10)
                            .shadow(radius: 1)
                    }
                }.padding(10)
                
                TextField("Please write the content of your Post", text: $description)
                    .frame(maxWidth : .infinity, maxHeight : .infinity)
                    .background(Color.systemDefaultGray)
                    .cornerRadius(10)
                    .shadow(radius: 1)
                    .padding(.horizontal, 10)
                
                Button {
                    
                } label : {
                    Text("DONE")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.05)
                        .background(Color.mainTheme)
                        .cornerRadius(30)
                }
            }
        } // VStack
        .navigationBarTitle(Text("Sell your stuff"), displayMode: .inline)
        .sheet(isPresented: $showImagePicker) {
            PhotoPicker(configuration: configuration, isPresented: $showImagePicker, pickerResult: $Images)
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

struct UsedWritingView_Previews: PreviewProvider {
    static var previews: some View {
        UsedWritingView()
    }
}

