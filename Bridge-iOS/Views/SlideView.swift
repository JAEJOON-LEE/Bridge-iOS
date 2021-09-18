//
//  SlideView.swift
//  Bridge-iOS
//
//  Created by 이재준 on 2021/09/18.
//

import SwiftUI

struct TabList : View {
    var body : some View {
        HStack {
            Button {
                print("first button is clicked")
            } label : {
                VStack {
                    Image(systemName : "cart")
                        .font(.system(size : 25))
                    Text("Shelling list")
                        .font(.system(size : 7))
                }
                .padding()
                .foregroundColor(.gray)
            }
            
            Button {
                print("second button is clicked")
            } label : {
                VStack {
                    Image(systemName : "list.bullet.rectangle")
                        .font(.system(size : 25))
                    Text("Post list")
                        .font(.system(size : 7))
                }
                .padding()
                .foregroundColor(.gray)
            }
            
            Button {
                print("third button is clicked")
            } label : {
                VStack {
                    Image(systemName : "heart")
                        .font(.system(size : 25))
                    Text("Like item")
                        .font(.system(size : 7))
                }
                .padding()
                .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 7)
        .padding(.horizontal, 10)
        .background(Color.systemDefaultGray)
        .cornerRadius(20)
        .shadow(radius: 1)
    }
}

struct SlideView : View {
    
    @State var isSlideShow : Bool = true
    
    var body : some View {
        VStack {
            
            //개인정보 수정 버튼
            HStack {
                Spacer()
                Button{
                    print("edit button is clicked")
                } label : {
                    Image(systemName : "pencil.circle")
                        .font(.title2)
                }
                .foregroundColor(.black)
            }
            
            HStack(alignment: .bottom) {
                Image("LOGO")
                    .frame(width: 100, height: 100)
                    .aspectRatio(contentMode: .fit)
                
                VStack {
                    Text("name")
                        .padding()
                    Text("hello")
                        .padding()
                }
                .font(.title2)
            }
            .frame(height : UIScreen.main.bounds.height * 0.2)
                        
            //tab
            TabList()
            
            VStack(alignment: .leading, spacing: 0) {
            Group {
                HStack {
                    
                    Image(systemName: "house") //나중에 버튼으로 바꾸기
                    Text("Home")
                }
                .padding()
                
                HStack {
                    Image(systemName: "creditcard")
                    Text("Membership")
                }
                .padding()
                
                HStack {
                    Image(systemName: "person")
                    Text("Seller Page")
                }
                .padding()
                
                HStack {
                    Image(systemName: "person")
                    Text("Invite friends")
                }
                .padding()
                
                HStack {
                    Image(systemName: "info.circle")
                    Text("Customer Service")
                }
                .padding()
                
                HStack {
                    Image(systemName: "gearshape")
                    Text("setting")
                }
                .padding()
                
                Spacer()
                
                HStack {
                    Image(systemName: "x.circle")
                    Text("Logout")
                }
                .padding()
                }
            }
        }
        .padding()
        .background(Color.white)
    }
}
