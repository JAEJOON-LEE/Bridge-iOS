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
                    }
                }.onDelete { indexOffset in
                    let index = indexOffset[indexOffset.startIndex]
                    let blockId = viewModel.blockList[index].blockId
                    viewModel.UnblockUser(blockId: blockId)
                    viewModel.blockList.remove(atOffsets: indexOffset)
                }
            }.toolbar { EditButton() }
        }.navigationBarTitleDisplayMode(.large)
        .navigationTitle(Text("Blocked Users"))   
    }
    
    var OpenSoureUsage : some View {
        VStack {
            Text("Open")
        }.navigationTitle(Text("Open Source"))
    }
    
    var body: some View {
        VStack {
            VStack(alignment : .leading) {
                Text("Alarm Settings")
                    .font(.headline)
                    .fontWeight(.bold)
                Divider()
                HStack {
                    Image(systemName: "bell.slash")
                    Text("Do not disturb mode")
                        .fontWeight(.bold)
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
            } // VStack : Alarm settings
            
            Color.systemDefaultGray
                .frame(width : UIScreen.main.bounds.width, height : 10)
            
            VStack(alignment : .leading) {
                Text("General Settings")
                    .font(.headline)
                    .fontWeight(.bold)
                    .padding(.vertical, 5)
                Divider()
                NavigationLink(destination: MyPageView(viewModel: MyPageViewModel(memberInformation: viewModel.userInfo, accessToken: viewModel.token))) {
                    HStack {
                        Image(systemName: "person.circle")
                        Text("Account Info")
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
            Divider()
            if rememberUser {
                Button {
                    print("Disable remember me")
                    viewModel.actionSheetType = 1
                    viewModel.showActionSheet = true
                } label : {
                    HStack {
                        Image(systemName: "switch.2")
                        Text("Disable Remeber Me")
                            .fontWeight(.semibold)
                    }
                }
                .foregroundColor(.mainTheme)
                .padding(7)
            }
            Button {
                viewModel.actionSheetType = 2
                viewModel.showActionSheet = true
            } label : {
                HStack {
                    Image(systemName: "arrow.right.square")
                    Text("Log Out")
                        .fontWeight(.semibold)
                }
                .foregroundColor(.mainTheme)
                .padding(7)
            }
        } //VStack
        .navigationBarTitle(Text("Settings"))
        .navigationBarTitleDisplayMode(.inline)
        .padding()
        .actionSheet(isPresented: $viewModel.showActionSheet) {
            if viewModel.actionSheetType == 1 {
                return ActionSheet(
                    title: Text("Do you want to disable Remeber Me?\nYour account will be logged out."),
                    buttons: [
                        .destructive(Text("Disable")) {
                            userEmail = ""
                            userPW = ""
                            rememberUser = false
                        },
                        .cancel()
                    ]
                )
            } else {
                return ActionSheet(
                    title: Text("Do you really want to logout?"),
                    buttons: [
                        .destructive(Text("Log Out")) {
                            userEmail = ""
                            userPW = ""
                            rememberUser = false
                            viewModel.signOut()
                            viewModel.signOutConfirm = true
                        },
                        .cancel()
                    ]
                )
            }
        } // actionSheet
        .background(
            NavigationLink(
                destination : LandingView().navigationBarHidden(true),
                isActive : $viewModel.signOutConfirm) { }
        )
    }
}
