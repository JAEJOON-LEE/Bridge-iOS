//
//  TabContainer.swift
//  Bridge-iOS
//
//  Created by Park Gyurim on 2021/09/16.
//

import SwiftUI

struct TabContainer: View {
    @StateObject var viewModel = TabContainerViewModel()
    @State var selectedTab = "Market"
    @State var isNotificationShow : Bool = false
    
    var body: some View {
        VStack (spacing : 0) {
            TabView { 
                HomeView()
                    .tabItem {
                        Image(systemName : "house.fill")
                        Text("Market")
                    }
                BoardView()
                    .tabItem {
                        Image(systemName : "note.text")
                        Text("Board")
                    }
                WritingView()
                    .tabItem {
                        Image(systemName : "pencil")
                        Text("Write")
                    }
                Text("Seller")
                    .tabItem {
                        Image(systemName : "person.fill")
                        Text("Seller")
                    }
                Text("Message")
                    .tabItem {
                        Image(systemName : "envelope.open.fill")
                        Text("Message")
                    }
            } // TabView
            .accentColor(.mainTheme)
            .navigationBarItems(
                leading: Button {
                    print("leading button clicked")
                } label : {
                    Image(systemName: "text.justify")
                        .foregroundColor(.black)
                },
                trailing: Button {
                    print("trailing button clicked")
                    isNotificationShow.toggle()
                } label : {
                    Image(systemName: "bell.fill")                        .foregroundColor(.black)
                }
            )
            // temp navigation bar title 
            .navigationBarTitle("Placeholder : SelectedTab", displayMode: .inline)
            .navigationBarBackButtonHidden(true)
        } // VStack
        .sheet(isPresented: $isNotificationShow) {
            NotificationView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TabContainer()
    }
}
