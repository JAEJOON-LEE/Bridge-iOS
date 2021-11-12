//
//  SignUpGreetingSellerView.swift
//  Bridge-iOS
//
//  Created by 이재준 on 2021/11/04.
//

import SwiftUI

struct SignUpGreetingView: View {
//    @Environment(\.presentationMode) var presentationMode
    @State var isLinkActive : Bool = false
    @ObservedObject var viewModel : SignUpViewModel
    
    var titleField : some View {
        VStack{
            Text("Thanks for using")
                .font(.largeTitle)
                .fontWeight(.semibold)
            Text("Bridge")
                .font(.largeTitle)
                .fontWeight(.semibold)
        }
        .frame(alignment: .center)
        .foregroundColor(.mainTheme)
    }
    
    
    var doneButton : some View {
        Button {
            isLinkActive = true
            
        } label : {
                Text("Done")
                    .modifier(SubmitButtonStyle())
                    .background(
                        NavigationLink(
                            destination: SignInView()
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
            Color.systemDefaultGray // background
            
            VStack(spacing : 30) {
                Image("Check")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .padding(20)
                titleField
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
