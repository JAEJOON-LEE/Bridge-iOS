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

struct SlideItem : View {
    @State var ImageName : String
    @State var text : String
    
    var body : some View {
        HStack{
            Image(systemName: ImageName)
            Text(text)
        }
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
                    SlideItem(ImageName: "pencil.circle", text: "")
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
                Button{
                    print("home is clicked")
                } label : {
                    SlideItem(ImageName: "house", text: "Home")
                }
                .foregroundColor(Color.black)
                .padding()
                
                Button{
                    print("Membership is clicked")
                } label : {
                    SlideItem(ImageName: "creditcard", text: "Membership")
                }
                .foregroundColor(Color.black)
                .padding()
                
                Button{
                    print("Seller Page is clicked")
                } label : {
                    SlideItem(ImageName: "person", text: "Seller page")
                }
                .foregroundColor(Color.black)
                .padding()
                
                Button{
                    print("Invite friends is clicked")
                } label : {
                    SlideItem(ImageName: "person", text: "Invite friends")
                }
                .foregroundColor(Color.black)
                .padding()
                
                Button{
                    print("Customer Service is clicked")
                } label : {
                    SlideItem(ImageName: "info.circle", text: "Customer Service")
                }
                .foregroundColor(Color.black)
                .padding()
                
                Button{
                    print("setting is clicked")
                } label : {
                    SlideItem(ImageName: "gearshape", text: "setting")
                }
                .foregroundColor(Color.black)
                .padding()
                
                Spacer()
                
                Button{
                    print("Logout is clicked")
                } label : {
                    SlideItem(ImageName: "x.circle", text: "Logout")
                }
                .foregroundColor(Color.black)
                .padding()
                
                }
            }
            .frame(width: UIScreen.main.bounds.width * 0.64)
        }
        .padding()
        .background(Color.white)
    }
}
