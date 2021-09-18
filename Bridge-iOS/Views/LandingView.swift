//
//  LandingView.swift
//  Bridge-iOS
//
//  Created by Park Gyurim on 2021/09/16.
//

import SwiftUI

struct LandingView: View {
    var body: some View {
        NavigationView {
            VStack {
                Image("LOGO")
                    .resizable()
                    .frame(width: 150, height: 150)
                
                Spacer()
                    .frame(height : UIScreen.main.bounds.height * 0.1)
                
                VStack {
                    VStack(alignment : .leading, spacing : 20) {
                        Text("Welcome!")
                            .font(.largeTitle)
                        Text("Thanks for using our app, Here you can sell your own items, or participate in various activities led by your partner")
                    }
                    .foregroundColor(.white)
                    .padding(20)
                    .padding(.vertical, 40)
                    
                    HStack(spacing : 50) {
                        NavigationLink(destination : SignUpView()) {
                            Text("Sign Up")
                                .font(.system(size : 20, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width : UIScreen.main.bounds.width * 0.35, height : UIScreen.main.bounds.height * 0.07)
                                .background(Color.gray)
                                .cornerRadius(20)
                        }
                        NavigationLink(destination : SignInView()) {
                            Text("Sign In")
                                .font(.system(size : 20, weight: .bold))
                                .foregroundColor(.black)
                                .frame(width : UIScreen.main.bounds.width * 0.35, height : UIScreen.main.bounds.height * 0.07)
                                .background(Color.white)
                                .cornerRadius(20)
                        }
                    }
                    .shadow(radius : 10)
                    .padding(.top, 30)
                    Spacer()
                }.frame(maxWidth : UIScreen.main.bounds.width)
                .background(Color.mainTheme)
                .cornerRadius(15)
                .shadow(radius: 10)
            }.edgesIgnoringSafeArea(.bottom)
        } // NavigationView
        .accentColor(.white)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct LandingView_Previews: PreviewProvider {
    static var previews: some View {
        LandingView()
    }
}