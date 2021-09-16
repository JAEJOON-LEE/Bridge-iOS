//
//  TabContainer.swift
//  Bridge-iOS
//
//  Created by Park Gyurim on 2021/09/16.
//

import SwiftUI

struct TabContainer: View {
    @StateObject var viewModel = TabContainerViewModel()
    
    @State var isNotificationShow : Bool = false
    
    var body: some View {
        ZStack(alignment : .bottom) {
            switch viewModel.selectedTabIndex {
            case 1 :
                HomeView()
            case 2 :
                BoardView()
            case 3 :
                WritingView()
            case 4 :
                VStack {
                    Spacer()
                    Text("Seller View").font(.largeTitle)
                    Spacer()
                }
            case 5 :
                VStack {
                    Spacer()
                    Text("Message View").font(.largeTitle)
                    Spacer()
                }
            default:
                HomeView()
            }
            
            TabSelector
        }
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
                Image(systemName: "bell.fill")
                    .foregroundColor(.black)
            }
        )
        // temp navigation bar title
        .navigationBarTitle(viewModel.navigationBarTitleText(), displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $isNotificationShow) {
            NotificationView()
                .preferredColorScheme(.light)
        }
    }
}

extension TabContainer {
    var TabSelector : some View {
        HStack(spacing : 25) {
            Button {
                viewModel.selectedTabIndex = 1
            } label : {
                VStack {
                    Image(systemName : "house.fill")
                        .font(.system(size : 25))
                    Text("Market")
                        .font(.system(size : 15))
                }
                .foregroundColor(viewModel.selectedTabIndex == 1 ? .mainTheme : .gray)
            }
            Button {
                viewModel.selectedTabIndex = 2
            } label : {
                VStack {
                    Image(systemName : "note.text")
                        .font(.system(size : 25))

                    Text("Board")
                        .font(.system(size : 15))

                }.foregroundColor(viewModel.selectedTabIndex == 2 ? .mainTheme : .gray)
            }
            Button {
                viewModel.selectedTabIndex = 3
            } label : {
                VStack {
                    Image(systemName : "pencil")
                        .font(.system(size : 25))

                    Text("Write")
                        .font(.system(size : 15))

                }.foregroundColor(viewModel.selectedTabIndex == 3 ? .mainTheme : .gray)
            }
            Button {
                viewModel.selectedTabIndex = 4
            } label : {
                VStack {
                    Image(systemName : "person.fill")
                        .font(.system(size : 25))

                    Text("Seller")
                        .font(.system(size : 15))

                }.foregroundColor(viewModel.selectedTabIndex == 4 ? .mainTheme : .gray)
            }
            Button {
                viewModel.selectedTabIndex = 5
            } label : {
                VStack {
                    Image(systemName : "envelope.open.fill")
                        .font(.system(size : 25))

                    Text("Message")
                        .font(.system(size : 15))

                }.foregroundColor(viewModel.selectedTabIndex == 5 ? .mainTheme : .gray)
            }
        } // HStack
        .padding(.vertical, 7)
        .padding(.horizontal, 10)
        .background(Color.systemDefaultGray)
        .cornerRadius(20)
        .shadow(radius: 1)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TabContainer()
    }
}
