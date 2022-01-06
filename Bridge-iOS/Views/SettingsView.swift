//
//  SettingsView.swift
//  Bridge-iOS
//
//  Created by Park Gyurim on 2022/01/06.
//

import SwiftUI
import URLImage

struct SettingsView: View {
    @StateObject private var viewModel : SettingsViewModel
    
    // Temporal Var.
    @State private var testToggleVar1 : Bool = false
    @State private var testToggleVar2 : Bool = false
    @State private var testToggleVar3 : Bool = false
    @State private var testToggleVar4 : Bool = false
    
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
                        .frame(
                            width : UIScreen.main.bounds.width * 0.15,
                            height : UIScreen.main.bounds.width * 0.15
                        )
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
        }.navigationTitle(Text("Blocked Users"))
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
                    Toggle("", isOn : $testToggleVar4)
                        .toggleStyle(SwitchToggleStyle(tint: .mainTheme))
                }
                VStack {
                    HStack {
                        Text("Chat alarm")
                        Spacer()
                        Toggle("", isOn : $testToggleVar1)
                            .toggleStyle(SwitchToggleStyle(tint: .mainTheme))
                    }
                    HStack {
                        Text("Board alarm")
                        Spacer()
                        Toggle("", isOn : $testToggleVar2)
                            .toggleStyle(SwitchToggleStyle(tint: .mainTheme))
                    }
                    HStack {
                        Text("Selling list alarm")
                        Spacer()
                        Toggle("", isOn : $testToggleVar3)
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
                NavigationLink(destination: MyPageView(viewModel: MyPageViewModel(signInResponse: viewModel.userInfo))) {
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
            Button {
                
            } label : {
                HStack {
                    Image(systemName: "arrow.right.square")
                    Text("Log Out")
                        .fontWeight(.bold)
                }
            }.padding()
        } //VStack
        .navigationBarTitle(Text("Settings"))
        .navigationBarTitleDisplayMode(.inline)
        .padding()
    }
}
