//
//  SettingsView.swift
//  Bridge-iOS
//
//  Created by Park Gyurim on 2022/01/06.
//

import SwiftUI

struct SettingsView: View {
    // Temporal Var.
    @State private var testToggleVar1 : Bool = false
    @State private var testToggleVar2 : Bool = false
    @State private var testToggleVar3 : Bool = false
    @State private var testToggleVar4 : Bool = false
    
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
                NavigationLink(destination: Text("1")) {
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
                NavigationLink(destination: Text("2")) {
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
                NavigationLink(destination: Text("3")) {
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
            HStack {
                Image(systemName: "arrow.right.square")
                Text("Log Out")
            }
        } //VStack
        .navigationBarTitle(Text("Settings"))
        .navigationBarTitleDisplayMode(.inline)
        .padding()
    }
}
