//
//  SignUpGreetingSellerView.swift
//  Bridge-iOS
//
//  Created by 이재준 on 2021/11/08.
//

import SwiftUI

struct SignUpSellerInfoView: View {
//    @Environment(\.presentationMode) var presentationMode
    @State var isLinkActive : Bool = false
    @ObservedObject var viewModel : SignUpViewModel
    
    var titleField : some View {
        Text("Hello! Seller")
            .font(.largeTitle)
            .fontWeight(.semibold)
            .padding(.vertical, 60)
    }
    
    var noticeView : some View {
        Text("메일로 서류 제출")
            .fontWeight(.semibold)
            .padding(40)
    }
    
    
    var doneButton : some View {
        Button {
            isLinkActive = true
            
        } label : {
                Text("Done")
                    .modifier(SubmitButtonStyle())
                    .background(
                        NavigationLink(
                            destination: SignUpGreetingView(viewModel: viewModel)
                                .environmentObject(viewModel),
                            isActive : $isLinkActive
                        ) {
                            // label
                        }
                    )
        }
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.mainTheme // background
            
            VStack(spacing : 30) {
                titleField
                noticeView
                Spacer()
                doneButton
                Spacer()
            }
            .frame(width : UIScreen.main.bounds.width, height : UIScreen.main.bounds.height * 0.8)
            .padding(.bottom)
            .background(Color.white)
            .cornerRadius(15)
            .shadow(radius: 15)
        }
        .edgesIgnoringSafeArea(.all)
    }
}

