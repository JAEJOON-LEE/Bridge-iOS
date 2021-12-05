////
////  SignUpCheckUserTypeView.swift
////  Bridge-iOS
////
////  Created by 이재준 on 2021/11/04.
////
//
//import SwiftUI
//
//struct SignUpCheckUserTypeView: View {
////    @Environment(\.presentationMode) var presentationMode
//    @State var isLinkActive1 : Bool = false
//    @State var isLinkActive2 : Bool = false
//    @ObservedObject var viewModel : SignUpViewModel
//    
//    var titleField : some View {
//        Text("Who are you?")
//            .font(.largeTitle)
//            .fontWeight(.semibold)
//            .padding(.vertical, 60)
//            .foregroundColor(.mainTheme)
//    }
//    
//    var noticeView : some View {
//        Text("(메일 인증 확인 요망)")
//            .fontWeight(.semibold)
//            .padding(40)
//    }
//    
//    var sellerButton : some View {
//        Button {
//            isLinkActive1 = true
//            
//            viewModel.SignUp(name : viewModel.name, email : viewModel.email, password : viewModel.password, role : "seller", nickname : viewModel.nickname, description : viewModel.description, profileImage : viewModel.profileImage, verifyCode : viewModel.verifyCode)
//        } label : {
//                Text("I'm Seller")
//                    .modifier(DisabledButtonStyle())
//                    .background(
//                        NavigationLink(
//                            destination: SignUpSellerInfoView(viewModel: viewModel)
//                                .environmentObject(viewModel),
//                            isActive : $isLinkActive1
//                        ) {
//                            // label
//                        }
//                    )
//        }
//    }
//    
//    var userButton : some View {
//        Button {
//            isLinkActive2 = true
//            
//            viewModel.VerifyEmail(email : viewModel.email, verifyCode : viewModel.verifyCode)
//            
//            viewModel.SignUp(name : viewModel.name, email : viewModel.email, password : viewModel.password, role : "user", nickname : viewModel.nickname, description : viewModel.description, profileImage : viewModel.profileImage, verifyCode : viewModel.verifyCode)
//        } label : {
//            Text("I'm normal user")
//                .modifier(SubmitButtonStyle())
//                .background(
//                    NavigationLink(
//                        destination: SignUpGreetingView(viewModel: viewModel)
//                            .environmentObject(viewModel),
//                        isActive : $isLinkActive2
//                    ) {
//                        // label
//                    }
//                )
//    }
//    }
//    
//    var body: some View {
//        ZStack(alignment: .bottom) {
//            Color.systemDefaultGray // background
//            
//            VStack(spacing : 30) {
//                titleField
//                noticeView
//                Divider()
//                userButton
//                sellerButton
//                Spacer()
//            }
//            .frame(width : UIScreen.main.bounds.width, height : UIScreen.main.bounds.height * 0.8)
//            .padding(.bottom)
//            .background(Color.white)
//            .cornerRadius(15)
//            .shadow(radius: 15)
//        }
//        .edgesIgnoringSafeArea(.all)
//    }
//}
//
//
