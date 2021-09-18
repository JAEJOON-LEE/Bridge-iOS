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
        .padding(.horizontal, 5)
        .background(Color.systemDefaultGray)
        .cornerRadius(20)
        .shadow(radius: 1)
        .frame(width: UIScreen.main.bounds.width * 0.6)
    }
}

struct SlideView : View {
    
    @State var isSlideShow : Bool = true
    
    var body : some View {
        VStack(alignment: .trailing) {
            
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
            
            HStack {
                Image("LOGO")
                    .resizable()
                    .frame(width: 70, height: 70)
                
                VStack {
                    Text("name")
                        .padding()
                        .font(.body)
                    Text("hello")
                        .padding()
                        .font(.caption)
                }
            }
            .frame(width: UIScreen.main.bounds.width * 0.75,
                   height : UIScreen.main.bounds.height * 0.2)
                        //너무 끼워맞추기,,?
            //tab
            TabList()
            
            VStack(alignment: .leading) {
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
            .frame(width: UIScreen.main.bounds.width * 0.75)
        }
        .padding()
        .background(Color.white)
    }
}
