//
//  SlideView.swift
//  Bridge-iOS
//
//  Created by 이재준 on 2021/09/18.
//

import SwiftUI
import URLImage

struct SlideItem : View {
    var ImageName : String
    var text : String
    
    var body : some View {
        HStack{
            Image(systemName: ImageName)
                .foregroundColor(.mainTheme)
            Text(text)
                .foregroundColor(.gray)
                .fontWeight(.semibold)
        }
    }
}

struct SlideView : View {
    @AppStorage("remeberUser") var remeberUser : Bool = false

    @StateObject private var viewModel : SlideViewModel
    
    init(viewModel : SlideViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body : some View {
        HStack {
            Spacer()
            VStack(alignment: .leading, spacing : 15) {
                HStack {
                    Spacer()
                    Button{
                        // user info edit api call!
                    } label : {
                        HStack {
                            Text("Edit")
                            Image(systemName: "pencil.circle")
                        }
                        .foregroundColor(.gray)
                        .font(.system(size : 12, weight: .semibold))
                    }
                }
                
                HStack(spacing : 20) {
                    URLImage(URL(string: viewModel.userInfo.profileImage)!) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    }
                    .frame(width : UIScreen.main.bounds.width * 0.2, height : UIScreen.main.bounds.width * 0.2)
                    .clipShape(Circle())
                    .shadow(radius: 5)
                    
                    VStack(alignment: .leading, spacing : 15) {
                        Text(viewModel.userInfo.username)
                            .font(.system(size : 20, weight : .bold))
                            //.fontWeight(.bold)
                        Text("\"" + viewModel.userInfo.description + "\"")
                    }
                }
                .padding(.leading, 10)
                
                HStack {
                    Button {
                        print("first button is clicked")
                    } label : {
                        VStack {
                            Image(systemName : "cart")
                                .font(.system(size : 30))
                            Text("Selling list")
                                .font(.system(size : 10))
                        }
                        .padding()
                        .foregroundColor(.gray)
                    }
                    
                    Button {
                        print("second button is clicked")
                    } label : {
                        VStack {
                            Image(systemName : "list.bullet.rectangle")
                                .font(.system(size : 30))
                            Text("Post list")
                                .font(.system(size : 10))
                        }
                        .padding()
                        .foregroundColor(.gray)
                    }
                    
                    Button {
                        print("third button is clicked")
                    } label : {
                        VStack {
                            Image(systemName : "heart")
                                .font(.system(size : 30))
                            Text("Like item")
                                .font(.system(size : 10))
                        }
                        .padding()
                        .foregroundColor(.gray)
                    }
                }
                .frame(width : UIScreen.main.bounds.width * 0.7, height : UIScreen.main.bounds.height * 0.1)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 1)
                .padding(.vertical, 10)
                
                
                VStack(alignment : .leading,spacing : 30) {
                    Button{
                        print("home is clicked")
                    } label : {
                        SlideItem(ImageName: "house", text: "Home")
                    }
                    
                    Button{
                        print("Membership is clicked")
                    } label : {
                        SlideItem(ImageName: "creditcard", text: "Membership")
                    }
                    
                    Button{
                        print("Seller Page is clicked")
                    } label : {
                        SlideItem(ImageName: "person", text: "Seller page")
                    }
                    
                    Button{
                        print("Invite friends is clicked")
                    } label : {
                        SlideItem(ImageName: "person", text: "Invite friends")
                    }
                    
                    Button{
                        print("Customer Service is clicked")
                    } label : {
                        SlideItem(ImageName: "info.circle", text: "Customer Service")
                    }
                    
                    Spacer()
                    if remeberUser {
                        Button("Disable Auto SignIn") {
                            remeberUser = false
                        }
                    }
                    Spacer()
                    
                    Button{
                        print("setting is clicked")
                    } label : {
                        SlideItem(ImageName: "gearshape", text: "Setting")
                    }.padding(.bottom, 20)
                }
                .padding(.leading, 10)
            }
            .padding(20)
            .frame(width: UIScreen.main.bounds.width * 0.75)
            .background(
                Image("myPage_bg")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width * 0.75)
            )
        }
    }
}

//struct SlideView_Previews: PreviewProvider {
//    static var previews: some View {
//        SlideView(viewModel: SlideViewModel())
//    }
//}
