//
//  MyPageView.swift
//  Bridge-iOS
//
//  Created by Park Gyurim on 2022/01/06.
//

import SwiftUI
import URLImage

struct MyPageView: View {
    @StateObject private var viewModel : MyPageViewModel
    
    init(viewModel : MyPageViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body : some View {
        VStack(spacing : 40) {
            // Title
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
            }.padding(.top, 10)
            
            // Image
            ZStack {
                URLImage(URL(string: viewModel.userInfo.profileImage)!) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
                .frame(
                    width : UIScreen.main.bounds.width * 0.4,
                    height : UIScreen.main.bounds.width * 0.4
                )
                .clipShape(Circle())
                .shadow(radius: 5)
                
                Button {
                    print("show Image picker")
                } label : {
                    Image(systemName : "camera")
                        .foregroundColor(.white.opacity(viewModel.isEditing ? 0.5 : 0))
                        .font(.system(size : 30))
                        .frame(
                            width : UIScreen.main.bounds.width * 0.4,
                            height : UIScreen.main.bounds.width * 0.4
                        )
                        .background(
                            Color.black.opacity(viewModel.isEditing ? 0.5 : 0)
                        )
                        .clipShape(Circle())
                }
            }
            // Info
            VStack(alignment: .leading, spacing : 5){
                Text("Name")
                    .font(.system(.caption, design: .rounded))
                    .foregroundColor(.gray)
                if viewModel.isEditing {
                    TextField(viewModel.username, text : $viewModel.usernameToEdit)
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
                
                Spacer().frame(height: 20)
                
                if viewModel.isEditing {
                    Text("Password")
                        .font(.system(.caption, design: .rounded))
                        .foregroundColor(.gray)
                    TextField("enter password", text: $viewModel.password)
                        .padding()
                        .font(.system(.title2, design : .rounded))
                        .frame(width: UIScreen.main.bounds.width * 0.8,
                               height: UIScreen.main.bounds.height * 0.05)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 1)
                    Text("Password Confirmation")
                        .font(.system(.caption, design: .rounded))
                        .foregroundColor(.gray)
                    TextField("Re-enter password", text: $viewModel.passwordConfirmation)
                        .padding()
                        .font(.system(.title2, design : .rounded))
                        .frame(width: UIScreen.main.bounds.width * 0.8,
                               height: UIScreen.main.bounds.height * 0.05)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 1)
                }
            }.padding(.vertical, 20)
            
            // Button
            Button {
                if viewModel.isEditing {
                    withAnimation {
                        print(viewModel.usernameToEdit)
                        print(viewModel.descriptionToEdit)
                        print(viewModel.password)
                        print(viewModel.passwordConfirmation)
                        print("User info edit reqeust send")
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
                    .frame(
                        width: UIScreen.main.bounds.width * 0.7,
                        height: UIScreen.main.bounds.height * 0.07)
                    .foregroundColor(.white)
                    //.background(Color.mainTheme)
                    .background((viewModel.isEditing && (!viewModel.passwordCorrespondence || viewModel.isPasswordEmpty)) ? Color.mainTheme.opacity(0.2) : Color.mainTheme)
                    .cornerRadius(30)
            }.padding(20)
                .disabled(viewModel.isEditing && (!viewModel.passwordCorrespondence || viewModel.isPasswordEmpty))
        }
        .padding()
        .alert(isPresented: $viewModel.isEditDone) {
            Alert(title: Text("Your Information is changed."),
                  dismissButton: .default(Text("OK"))
            )
        }
    }
}
