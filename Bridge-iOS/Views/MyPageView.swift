//
//  MyPageView.swift
//  Bridge-iOS
//
//  Created by Park Gyurim on 2022/01/06.
//

import SwiftUI
import URLImage

struct MyPageView: View {
    @AppStorage("userPW") var userPW : String = ""
    
    @StateObject private var viewModel : MyPageViewModel
    
    init(viewModel : MyPageViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
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
                        viewModel.password = ""
                        viewModel.passwordConfirmation = ""
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
                URLImage(URL(string: viewModel.userInfo.profileImage)!) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
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
    var infoArea1 : some View {
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
    var infoArea2 : some View {
        VStack(alignment: .leading, spacing : 5) {
            if viewModel.isEditing {
                Text("Password")
                    .font(.system(.caption, design: .rounded))
                    .foregroundColor(.gray)
                HStack {
                    if viewModel.showPassword {
                        TextField("enter password", text: $viewModel.password)
                            .autocapitalization(.none)
                            .padding(.leading, 10)
                            .font(.system(.title2, design : .rounded))
                    } else {
                        SecureField("enter password", text: $viewModel.password)
                            .autocapitalization(.none)
                            .padding(.leading, 10)
                            .font(.system(.title2, design : .rounded))
                    }
                    Button {
                        viewModel.showPassword.toggle()
                    } label : {
                        Image(systemName: viewModel.showPassword ? "eye.slash" : "eye")
                            .foregroundColor(.darkGray)
                            .padding(.trailing, 10)
                    }
                }
                .frame(width: UIScreen.main.bounds.width * 0.8,
                       height: UIScreen.main.bounds.height * 0.05)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 1)
                
                Text("Password Confirmation")
                    .font(.system(.caption, design: .rounded))
                    .foregroundColor(.gray)
                HStack {
                    if viewModel.showPasswordConfirmation {
                        TextField("Re-enter password", text: $viewModel.passwordConfirmation)
                            .autocapitalization(.none)
                            .padding(.leading, 10)
                            .font(.system(.title2, design : .rounded))
                    } else {
                        SecureField("Re-enter password", text: $viewModel.passwordConfirmation)
                            .autocapitalization(.none)
                            .padding(.leading, 10)
                            .font(.system(.title2, design : .rounded))
                    }
                    Button {
                        viewModel.showPasswordConfirmation.toggle()
                    } label : {
                        Image(systemName: viewModel.showPasswordConfirmation ? "eye.slash" : "eye")
                            .foregroundColor(.darkGray)
                            .padding(.trailing, 10)
                    }
                }
                .frame(width: UIScreen.main.bounds.width * 0.8,
                       height: UIScreen.main.bounds.height * 0.05)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 1)
            } else {
                Spacer()
            }
        }.frame(height : UIScreen.main.bounds.height * 0.2)
    }
    var buttonArea : some View {
        Button {
            if viewModel.isEditing {
                withAnimation {
                    viewModel.updateProfile()
                    userPW = viewModel.password
                    viewModel.username = viewModel.usernameToEdit
                    viewModel.description = viewModel.descriptionToEdit
                    viewModel.password = ""
                    viewModel.passwordConfirmation = ""
                    viewModel.isEditing = false
                    viewModel.isEditDone = true
                }
            } else {
                withAnimation {
                    viewModel.isEditing = true
                }
            }
        } label : {
            Text(viewModel.isEditing ? "Done" : "Edit")
                .fontWeight(.semibold)
                .frame(width: UIScreen.main.bounds.width * 0.7, height: UIScreen.main.bounds.height * 0.07)
                .foregroundColor(.white)
                .background((viewModel.isEditing && (!viewModel.passwordCorrespondence || viewModel.isPasswordEmpty)) ? Color.mainTheme.opacity(0.2) : Color.mainTheme)
                .cornerRadius(30)
        }.disabled(viewModel.isEditing && (!viewModel.passwordCorrespondence || viewModel.isPasswordEmpty))
    }
    
    var body : some View {
        VStack(spacing : 40) {
            titleArea
            imageArea
            infoArea1
            infoArea2
            buttonArea
        }.padding()
        .alert(isPresented: $viewModel.isEditDone) {
            Alert(title: Text("Your Information is changed."),
                  dismissButton: .default(Text("OK")))
        }
        .sheet(isPresented: $viewModel.showImagePicker) { ImagePicker(image: $viewModel.selectedImage) }
    }
}
