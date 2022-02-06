//
//  MyPageView.swift
//  Bridge-iOS
//
//  Created by Park Gyurim on 2022/01/06.
//

import SwiftUI
import Kingfisher

struct MyPageView: View {
    @StateObject private var viewModel : MyPageViewModel
    
    init(viewModel : MyPageViewModel) { self._viewModel = StateObject(wrappedValue: viewModel) }
    
    var titleArea : some View {
        HStack {
            Text("My Profile")
                .font(.system(.largeTitle, design : .rounded))
                .fontWeight(.bold)
            Spacer()
            if viewModel.isEditing {
                Button {
                    withAnimation {
                        viewModel.isEditing = false
                        // Initializing
                        viewModel.selectedImage = nil
                        viewModel.usernameToEdit = viewModel.username
                        viewModel.descriptionToEdit = viewModel.description
                    }
                } label : {
                    Text("Cancel")
                        .foregroundColor(.red)
                        .fontWeight(.semibold)
                }.padding(.horizontal, 10)
            }
        }
    }
    var imageArea : some View {
        ZStack {
            if viewModel.selectedImage != nil {
                Image(uiImage: viewModel.selectedImage!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width : UIScreen.main.bounds.width * 0.4, height : UIScreen.main.bounds.width * 0.4)
                    .clipShape(Circle())
                    .shadow(radius: 5)
            } else {
                KFImage(URL(string: viewModel.userInfo.profileImage)!)
                    .resizable()
                    .fade(duration: 0.5)
                    .aspectRatio(contentMode: .fill)
                    .frame(width : UIScreen.main.bounds.width * 0.4, height : UIScreen.main.bounds.width * 0.4)
                    .clipShape(Circle())
                    .shadow(radius: 5)
            }
            
            Button {
                viewModel.showImagePicker = true
            } label : {
                Image(systemName : "camera")
                    .foregroundColor(.white.opacity(viewModel.isEditing ? 0.5 : 0))
                    .font(.system(size : 30))
                    .frame(width : UIScreen.main.bounds.width * 0.4, height : UIScreen.main.bounds.width * 0.4)
                    .background(Color.black.opacity(viewModel.isEditing ? 0.5 : 0))
                    .clipShape(Circle())
            }.disabled(!viewModel.isEditing)
        }
    }
    var infoArea : some View {
        VStack(alignment: .leading, spacing : 5) {
            Text("Name")
                .font(.system(.caption, design: .rounded))
                .foregroundColor(.gray)
            if viewModel.isEditing {
                TextField(viewModel.username, text : $viewModel.usernameToEdit)
                    .autocapitalization(.none)
                    .padding(.horizontal, 10)
                    .font(.system(.title2, design : .rounded))
                    .frame(width: UIScreen.main.bounds.width * 0.8,
                           height: UIScreen.main.bounds.height * 0.05)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 1)
            } else {
                Text(viewModel.username)
                    .padding(.horizontal, 10)
                    .font(.system(.title2, design : .rounded))
                    .frame(width: UIScreen.main.bounds.width * 0.8,
                           height: UIScreen.main.bounds.height * 0.05,
                           alignment: .leading)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 1)
            }
            
            Spacer().frame(height : 10)
            
            Text("Description")
                .font(.system(.caption, design: .rounded))
                .foregroundColor(.gray)
            if viewModel.isEditing {
                TextField(viewModel.description, text : $viewModel.descriptionToEdit)
                    .autocapitalization(.none)
                    .padding(.horizontal, 10)
                    .font(.system(.title2, design : .rounded))
                    .frame(width: UIScreen.main.bounds.width * 0.8,
                           height: UIScreen.main.bounds.height * 0.05)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 1)
            } else {
                Text(viewModel.description)
                    .padding(.horizontal, 10)
                    .font(.system(.title2, design : .rounded))
                    .frame(width: UIScreen.main.bounds.width * 0.8,
                           height: UIScreen.main.bounds.height * 0.05,
                           alignment: .leading)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 1)
            }
        }
    }
    var buttonArea : some View {
        Button {
            if viewModel.isEditing {
                withAnimation {
                    viewModel.updateProfile()
                    viewModel.username = viewModel.usernameToEdit
                    viewModel.description = viewModel.descriptionToEdit
                    viewModel.isEditing = false
                    viewModel.isEditDone = true
                }
            } else {
                withAnimation { viewModel.isEditing = true }
            }
        } label : {
            Text(viewModel.isEditing ? "Done" : "Edit")
                .fontWeight(.semibold)
                .frame(width: UIScreen.main.bounds.width * 0.7, height: UIScreen.main.bounds.height * 0.07)
                .foregroundColor(.white)
                .background(Color.mainTheme)
                .cornerRadius(30)
        }
    }
    
    var body : some View {
        VStack(spacing : 40) {
            titleArea
            imageArea
            infoArea
            Spacer()
            buttonArea
        }.padding()
        .alert(isPresented: $viewModel.isEditDone) {
            Alert(title: Text("Your Information is changed."), dismissButton: .default(Text("OK")))
        }
        .sheet(isPresented: $viewModel.showImagePicker) { ImagePicker(image: $viewModel.selectedImage) }
    }
}
