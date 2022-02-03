//
//  SettingsView.swift
//  Bridge-iOS
//
//  Created by Park Gyurim on 2022/01/06.
//

import SwiftUI
import URLImage

struct SettingsView: View {
    @AppStorage("rememberUser") var rememberUser : Bool = false
    @AppStorage("userEmail") var userEmail : String = ""
    @AppStorage("userPW") var userPW : String = ""
    
    @StateObject private var viewModel : SettingsViewModel
    
    init(viewModel : SettingsViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var AccountSettingsView : some View {
        VStack(spacing : 0) {
            Divider()
            VStack(alignment : .leading, spacing : 20) {
                NavigationLink (destination : ChangePasswordView) {
                    Text("Change your password")
                        .fontWeight(.semibold)
                }
                Divider()
                Button {
                    viewModel.isDeleteMemeberClicked = true
                } label : {
                    Text("Delete Account")
                        .foregroundColor(.red)
                        .fontWeight(.semibold)
                }
                Divider()
                Spacer()
            }.padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(Text("Account Settings"))
    }
    
    var ChangePasswordView : some View {
        VStack {
            Divider()
            VStack(alignment : .leading, spacing : 5) {
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

                Spacer().frame(height : 10)

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
            }.padding()
            .onAppear {
                viewModel.password = ""
                viewModel.passwordConfirmation = ""
            }
            Spacer()
            Button {
                viewModel.changePassword()
            } label : {
                Text("Done")
                    .fontWeight(.semibold)
                    .frame(width: UIScreen.main.bounds.width * 0.7, height: UIScreen.main.bounds.height * 0.07)
                    .foregroundColor(.white)
                    .background(Color.mainTheme)
                    .cornerRadius(30)
                    .opacity(viewModel.disableButton() ? 0.5 : 1)
            }.disabled(viewModel.disableButton())
        }.navigationTitle(Text("Change your password"))
        .navigationBarTitleDisplayMode(.inline)
        .alert(isPresented: $viewModel.passwordChangeDone) {
            Alert(title: Text("Your password is changed."),
                  dismissButton: .default(Text("OK")) {
                                    userPW = viewModel.password
                                    viewModel.password = ""
                                    viewModel.passwordConfirmation = ""
                                }
            )
        }
    }
    
    var BlockedUsersView : some View {
        VStack {
            List {
                ForEach(viewModel.blockList, id : \.self) { blockInfo in
                    HStack(spacing : 15) {
                        URLImage(URL(string: blockInfo.blockedMember.profileImage)!) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        }
                        .frame(width : UIScreen.main.bounds.width * 0.15, height : UIScreen.main.bounds.width * 0.15)
                        .clipShape(Circle())
                        Text(blockInfo.blockedMember.username)
                            .fontWeight(.semibold)
                        Spacer()
                    }.padding(.vertical, 3)
                }.onDelete { indexOffset in
                    let index = indexOffset[indexOffset.startIndex]
                    let blockId = viewModel.blockList[index].blockId
                    viewModel.UnblockUser(blockId: blockId)
                    viewModel.blockList.remove(atOffsets: indexOffset)
                }
            }.toolbar { EditButton() }
        }.navigationBarTitleDisplayMode(.inline)
        .navigationTitle(Text("Blocked Users"))   
    }
    
    var OpenSoureUsage : some View {
        VStack {
            Text("Open Source")
        }.navigationBarTitleDisplayMode(.inline)
        .navigationTitle(Text("Open Source"))
    }
    
    var body: some View {
        VStack { //(spacing : 0) {
            HStack(spacing : 5) {
                Image(systemName: "gearshape")
                    .font(.system(size : 22))
                Text("Settings")
                    .font(.title2)
                    .fontWeight(.semibold)
            }.padding()
            .frame(maxWidth : .infinity)
            .padding(.top, UIDevice.current.hasNotch ? UIScreen.main.bounds.height * 0.05 : UIScreen.main.bounds.height * 0.02)
            
            VStack(alignment : .leading) {
                Text("Alarm Settings")
                    .font(.headline)
                    .fontWeight(.bold)
                Divider()
                HStack {
                    Image(systemName: "bell.slash")
                    Text("Do not disturb mode")
                        .fontWeight(.semibold)
                        .minimumScaleFactor(0.4)
                        .lineLimit(1)
                    Spacer()
                    Toggle("", isOn : $viewModel.entireAlarm)
                        .toggleStyle(SwitchToggleStyle(tint: .mainTheme))
                }
                VStack {
                    HStack {
                        Text("Chat alarm")
                        Spacer()
                        Toggle("", isOn : $viewModel.chatAlarm)
                            .toggleStyle(SwitchToggleStyle(tint: .mainTheme))
                    }
                    HStack {
                        Text("Board alarm")
                        Spacer()
                        Toggle("", isOn : $viewModel.boardAlarm)
                            .toggleStyle(SwitchToggleStyle(tint: .mainTheme))
                    }
                    HStack {
                        Text("Selling list alarm")
                        Spacer()
                        Toggle("", isOn : $viewModel.sellingAlarm)
                            .toggleStyle(SwitchToggleStyle(tint: .mainTheme))
                    }
                }.padding(.leading, 20)
            }
            // VStack - Alarm settings
            
            Color.systemDefaultGray
                .frame(width : UIScreen.main.bounds.width, height : 10)
            
            VStack(alignment : .leading) {
                Text("General Settings")
                    .font(.headline)
                    .fontWeight(.bold)
                    .padding(.vertical, 5)
                Divider()
                NavigationLink(destination: AccountSettingsView) {
                    HStack {
                        Image(systemName: "person.circle")
                        Text("Account Settings")
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .padding(.vertical, 5)
                    .foregroundColor(.black)
                }
                Divider()
                NavigationLink(destination: BlockedUsersView) {
                    HStack {
                        Image(systemName: "person.fill.xmark")
                        Text("Blocked Users")
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .padding(.vertical, 5)
                    .foregroundColor(.black)
                }
                Divider()
                NavigationLink(destination: OpenSoureUsage) {
                    HStack {
                        Image(systemName: "chevron.left.forwardslash.chevron.right")
                        Text("Opensource code")
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .padding(.vertical, 5)
                    .foregroundColor(.black)
                }
                Divider()
            }
            Spacer()
        } //VStack
        .padding()
        .edgesIgnoringSafeArea(.top)
        .navigationBarTitle(Text(""))
        .actionSheet(isPresented: $viewModel.isDeleteMemeberClicked) {
            ActionSheet(
                title: Text("Do you really want to delete your account?"),
                //message: <#T##SwiftUI.Text?#>,
                buttons: [
                    .destructive(Text("Yes")) {
                        userEmail = ""
                        userPW = ""
                        rememberUser = false
                        viewModel.deleteAccount()
                        viewModel.deleteMemeberConfirmation = true
                    },
                    .cancel()
                ]
            )
        }
        .background(
            NavigationLink(
                destination : LandingView().navigationBarHidden(true),
                isActive : $viewModel.deleteMemeberConfirmation
            ) { }
        )
    }
}
