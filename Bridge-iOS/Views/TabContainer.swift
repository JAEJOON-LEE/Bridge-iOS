//
//  TabContainer.swift
//  Bridge-iOS
//
//  Created by Park Gyurim on 2021/09/16.
//

import SwiftUI

struct TabContainer: View {
    @EnvironmentObject var signInViewModel : SignInViewModel

    @StateObject var viewModel = TabContainerViewModel()
    
    @State var isNotificationShow : Bool = false
    @State var isSlideShow : Bool = false
    
    var body: some View {
        ZStack {
            ZStack(alignment : .bottom) {
                switch viewModel.selectedTabIndex {
                case 1 :
                    HomeView(viewModel : HomeViewModel(memberId : signInViewModel.signInResponse?.memberId ?? -1),
                             isSlideShow : $isSlideShow,
                             isLocationPickerShow : $viewModel.isLocationBtnClicked,
                             selectedDistrict : $viewModel.selectedDistrict
                    ).navigationBarHidden(true)
                case 2 :
                    BoardView(viewModel:
                                BoardViewModel(
                                    accessToken: signInViewModel.signInResponse?.token.accessToken ?? "",
                                    memberId : signInViewModel.signInResponse?.memberId ?? -1
                                )
                    )
//                case 3 :
//                    WritingView(viewModel: WritingViewModel(
//                                    accessToken: signInViewModel.signInResponse?.token.accessToken ?? "",
//                                    postId : -1,
//                                    isForModifying : false,
//                                    isForWantModifying : nil
//                        )
//                    )
                case 4 :
                    CouponView(
                        viewModel : CouponViewModel(member:
                            Member(
                                description: signInViewModel.signInResponse?.description ?? "",
                                memberId: signInViewModel.signInResponse?.memberId ?? -1,
                                profileImage: signInViewModel.signInResponse?.profileImage ?? "",
                                username: signInViewModel.signInResponse?.username ?? "")
                        ),
                        isSlideShow : $isSlideShow,
                        isLocationPickerShow : $viewModel.isLocationBtnClicked,
                        selectedDistrict : $viewModel.selectedDistrict
                    ).navigationBarHidden(true)
                case 5 :
                    ChatView(viewModel: ChatViewModel(userInfo: signInViewModel.signInResponse!))
                default:
                    BoardView(viewModel:
                                BoardViewModel(
                                    accessToken: signInViewModel.signInResponse?.token.accessToken ?? "",
                                    memberId : signInViewModel.signInResponse?.memberId ?? -1
                                )
                    )
                }
                
                TabSelector
                    .padding(.bottom, UIDevice.current.hasNotch ? 0 : 20)
            }.accentColor(.black)
            .navigationBarItems(
                leading:
                Button {
                    print("leading button clicked")
                    withAnimation {
                        if(viewModel.selectedTabIndex == 2){
                            //
                        }
                        else{
                            isSlideShow.toggle()
                        }
                    }
                } label : {
                    if(viewModel.selectedTabIndex == 2){
                            NavigationLink(
                                destination:
                                        PostSearchView(viewModel:
                                                       BoardViewModel(
                                                           accessToken: signInViewModel.signInResponse?.token.accessToken ?? "",
                                                           memberId : signInViewModel.signInResponse?.memberId ?? -1)
                                                       )
                            ) {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.black)
                            }
                    }else{
                        Image(systemName: "text.justify")
                            .foregroundColor(.black)
                    }
                },
                trailing:
                Button {
                    print("trailing button clicked")
                    isNotificationShow.toggle()
                } label : {
                    Image(systemName: "bell.fill")
                        .foregroundColor(.black)
                }
            )
            .navigationBarTitle(viewModel.navigationBarTitleText(), displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .sheet(isPresented: $isNotificationShow) {
                NotificationView(viewModel: NotificationViewModel(
                    accessToken: signInViewModel.signInResponse?.token.accessToken ?? "",
                    memberId : signInViewModel.signInResponse?.memberId ?? -1)
                    )
                    .preferredColorScheme(.light)
            }
            .background(
                NavigationLink(
                    destination : UsedWritingView(viewModel : UsedWritingViewModel()),
                    isActive : $viewModel.showUsedPostWriting) { }
            )
            .overlay(
                Color.black.opacity(isSlideShow || viewModel.isLocationBtnClicked ? 0.5 : 0)
                    .edgesIgnoringSafeArea(isSlideShow ? .bottom : .vertical)
                    .onTapGesture {
                        withAnimation {
                            isSlideShow = false
                            viewModel.isLocationBtnClicked = false
                        }
                    }
            )
            
            if viewModel.isLocationBtnClicked {
                VStack {
                    HStack {
                        Text("Select district : ")
                            .font(.headline)
                        Text(viewModel.selectedDistrict)
                            .fontWeight(.light)
                        Spacer()
                        Button {
                            withAnimation { viewModel.isLocationBtnClicked = false }
                        } label : {
                            Text("??? OK")
                                .font(.footnote)
                                .fontWeight(.semibold)
                                .foregroundColor(.black)
                        }
                    }
                    Divider()
                    Picker("District", selection: $viewModel.selectedDistrict) {
                        ForEach(viewModel.locations, id: \.self) {
                            Text($0)
                        }
                    }.pickerStyle(.wheel)
                }.padding()
                .frame(height : UIScreen.main.bounds.height * 0.35)
                .background(Color.systemDefaultGray)
                .cornerRadius(20)
                .transition(.move(edge: .bottom))
                .offset(y: UIScreen.main.bounds.width * 0.7)
                .zIndex(5)
            }
            
            if isSlideShow {
                SlideView(viewModel : SlideViewModel(userInfo: signInViewModel.signInResponse!))
                    .transition(.move(edge: .leading))
                    .offset(x: -UIScreen.main.bounds.width * 0.25)
                    .edgesIgnoringSafeArea(.bottom)
                    .zIndex(5)
            }
        }
    }
}

extension TabContainer {
    var TabSelector : some View {
        HStack(spacing : 20) {
            Button {
                viewModel.selectedTabIndex = 1
            } label : {
                VStack(spacing : 3) {
                    //Image(systemName : "house.fill")
                    Image(viewModel.selectedTabIndex == 1 ? "tab1_1" : "tab1_0")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width : UIScreen.main.bounds.width * 0.08)
                    Text("Home")
                        .font(.system(size : 12))
                        .foregroundColor(viewModel.selectedTabIndex == 1 ? .mainTheme : .gray)
                }
            }
            Button {
                viewModel.selectedTabIndex = 2
            } label : {
                VStack(spacing : -5) {
                    //Image(systemName : "note.text")
                    Image(viewModel.selectedTabIndex == 2 ? "tab2_1" : "tab2_0")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width : UIScreen.main.bounds.width * 0.1)
                    Text("Playground")
                        .font(.system(size : 12))
                        .foregroundColor(viewModel.selectedTabIndex == 2 ? .mainTheme : .gray)
                }
            }
            if viewModel.selectedTabIndex == 1 {
                Button {
                    viewModel.showUsedPostWriting = true
                } label : {
                    //Image(systemName : "pencil")
                    Image("tab3").resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width : UIScreen.main.bounds.width * 0.12)
                        .padding(10)
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(radius: 3)
                        .foregroundColor(.mainTheme)
                }
            } else {
                Button { // ???????????? ??? ??????????????? -> writing view?????? ??? ???????????? ??? Parent??? ????????? ??? ??????
                    viewModel.selectedTabIndex = 3
                } label : {
                    NavigationLink(
                        destination:
                                WritingView(viewModel: WritingViewModel(
                                                accessToken: signInViewModel.signInResponse?.token.accessToken ?? "",
                                                postId : -1,
                                                isForModifying : false,
                                                isForSecretModifying : false
                                    )
                                )
                    ) {
                        //Image(systemName : "pencil")
                        Image("tab3")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width : UIScreen.main.bounds.width * 0.12)
                            .padding(10)
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(radius: 3)
                            .foregroundColor(viewModel.selectedTabIndex == 3 ? .mainTheme : .gray)
                    }
                }
            }
            Button {
                viewModel.selectedTabIndex = 4
            } label : {
                VStack(spacing : 0) {
                    //Image(systemName : "person.fill")
                    Image(viewModel.selectedTabIndex == 4 ? "tab4_1" : "tab4_0")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width : UIScreen.main.bounds.width * 0.1)
                    Text("Coupon")
                        .font(.system(size : 12))
                        .foregroundColor(viewModel.selectedTabIndex == 4 ? .mainTheme : .gray)
                }
            }
            Button {
                viewModel.selectedTabIndex = 5
            } label : {
                VStack(spacing : 0) {
                    //Image(systemName : "envelope.open.fill")
                    Image(viewModel.selectedTabIndex == 5 ? "tab5_1" : "tab5_0")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width : UIScreen.main.bounds.width * 0.1)
                    Text("Chat")
                        .font(.system(size : 12))
                        .foregroundColor(viewModel.selectedTabIndex == 5 ? .mainTheme : .gray)
                }
            }
        } // HStack
        .padding(.vertical, 5)
        .padding(.horizontal, 15)
        .background(Color.systemDefaultGray)
        .cornerRadius(25)
        .shadow(radius: 1)
    }
}
