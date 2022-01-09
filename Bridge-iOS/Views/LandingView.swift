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
                // Logo
                Image("LOGO")
                    .resizable()
                    .frame(width: 140, height: 140)
                    .padding()
                
                // Text Area
                VStack(alignment : .leading, spacing : 20) {
                    Text("Welcome !")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Text("Thanks for using our app, Here you can sell your own items, or participate in various activities led by your partner.")
                        .kerning(1) // 자간
                        .lineSpacing(5) // 행간
                        .fixedSize(horizontal: false, vertical: true)
                }
                .foregroundColor(.mainTheme)
                .padding(30)
                
                // Sign in and Sing up link
                VStack (spacing : 20) {
                    NavigationLink(destination : SignInView()) {
                        Text("Sign In")
                            .font(.system(size : 20))
                            .foregroundColor(.white)
                            .frame(
                                width : UIScreen.main.bounds.width * 0.8,
                                height : UIScreen.main.bounds.height * 0.07)
                            .background(Color.mainTheme)
                            .cornerRadius(30)
                    }
                    NavigationLink(destination : SignUpView()) {
                        Text("Sign Up")
                            .font(.system(size : 20))
                            .foregroundColor(.black)
                            .frame(
                                width : UIScreen.main.bounds.width * 0.8,
                                height : UIScreen.main.bounds.height * 0.07)
                            .background(Color.systemDefaultGray)
                            .cornerRadius(30)
                    }
                }
                .shadow(radius : 3)
                .padding(.vertical, 50)
            
            
                .frame(maxWidth : UIScreen.main.bounds.width)
            }.edgesIgnoringSafeArea(.bottom)
        } // NavigationView
        .accentColor(.black)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct LandingView_Previews: PreviewProvider {
    static var previews: some View {
        LandingView()
    }
}
