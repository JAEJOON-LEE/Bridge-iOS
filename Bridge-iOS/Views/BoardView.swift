//
//  BoardView.swift
//  Bridge-iOS
//
//  Created by Park Gyurim on 2021/09/16.
//

import SwiftUI
import Firebase
import SwiftUIPullToRefresh
import Kingfisher

struct BoardView : View {
    @StateObject private var viewModel : BoardViewModel
    
    init(viewModel : BoardViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body : some View {
        VStack {
            RefreshableScrollView(onRefresh: { done in
                viewModel.getBoardPosts(token: viewModel.token)
                done()
            }){
                LazyVStack {
                    //Hot Posts
                    
                    NavigationLink(
                        destination:
                            HotBoardView(viewModel: BoardViewModel(
                                accessToken: viewModel.token,
                                memberId : viewModel.memberId))
                    ) {
                        HStack{
                            Text("     Hot board 😎")
                                .fontWeight(.semibold)
                                .foregroundColor(.mainTheme)
                            Spacer()
                            Text("More            ")
                                .foregroundColor(.gray)
                                .font(.system(size: 13))
                                .fontWeight(.medium)
                                .padding()
                        }
                        .padding(.vertical, 10)
                        .frame(height: UIScreen.main.bounds.height * 0.06)
                    }
                    
                    //            List {
                    ForEach(viewModel.hotLists, id : \.self) { HotList in
                        NavigationLink(
                            destination:
                                PostInfoView(viewModel: PostInfoViewModel(
                                    token: viewModel.token,
                                    postId : HotList.postInfo.postId,
                                    memberId : viewModel.memberId,
                                    isMyPost : (viewModel.memberId == HotList.member?.memberId)))
                        ) {
                            HotPost(viewModel : GeneralPostViewModel(postList: HotList))
                        }
                    }
                    //            }
                    .foregroundColor(Color.mainTheme)
                    .listStyle(PlainListStyle()) // iOS 15 대응
                    .frame(height:UIScreen.main.bounds.height * 1/7 )
                    
                    //Secret Posts
                    
                    NavigationLink(
                        destination:
                            SecretBoardView(viewModel:
                                                BoardViewModel(
                                                    accessToken: viewModel.token,
                                                    memberId : viewModel.memberId
                                                )
                                           )
                    ){
                        
                        HStack{
                            Text("S-SPACE")
                                .padding()
                            Spacer()
                            Text("ALL ANONYMOUS!")
                                .padding()
                        }
                        .font(.system(size: 10, weight : .bold))
                        .frame(width : UIScreen.main.bounds.width * 0.83, height : UIScreen.main.bounds.height * 0.02)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.black)
                        .cornerRadius(20)
                        .shadow(radius: 3)
                    }
                    
                    //                Button {
                    //                } label : {
                    //                    HStack{
                    //                        Text("S-SPACE")
                    //                            .padding()
                    //                        Spacer()
                    //                        Text("ALL ANONYMOUS!")
                    //                            .padding()
                    //                    }
                    //                    .font(.system(size: 12, weight : .bold))
                    //                    .frame(width : UIScreen.main.bounds.width * 0.83, height : UIScreen.main.bounds.height * 0.02)
                    //                    .padding()
                    //                    .foregroundColor(.white)
                    //                    .background(Color.black)
                    //                    .cornerRadius(20)
                    //                    .shadow(radius: 3)
                    //
                    //                }.background(
                    //                    NavigationLink(
                    //                        destination:
                    //                            SecretBoardView(viewModel:
                    //                                        BoardViewModel(
                    //                                            accessToken: viewModel.token,
                    //                                            memberId : viewModel.memberId
                    //                                        )
                    //                            )
                    //                    ){ }
                    //                )
                    
                    ////            List {
                    //                ForEach(viewModel.secretLists, id : \.self) { SecretList in
                    //                    NavigationLink(
                    //                        destination:
                    //                            SecretInfoView(viewModel: SecretInfoViewModel(
                    //                                            token: viewModel.token,
                    //                                            postId : SecretList.postInfo.postId,
                    //                                            memberId : viewModel.memberId,
                    //                                            isMyPost : (viewModel.memberId == SecretList.member?.memberId)))
                    //                    ) {
                    //                        SecretPost(viewModel : SecretViewModel(postList: SecretList))
                    //                    }
                    //                }
                    ////            }
                    //            .foregroundColor(Color.mainTheme)
                    //            .listStyle(PlainListStyle()) // iOS 15 대응
                    //            .frame(height:UIScreen.main.bounds.height * 1/7 )
                    
                    //General Posts
                    //            List {
                    
                    if !viewModel.postFetchDone {
                        Spacer(minLength: UIScreen.main.bounds.height * 0.3)
                        ProgressView()
                            .padding()
                        Text("Loading..")
                            .foregroundColor(.gray)
                            .fontWeight(.semibold)
//                        Spacer()
                    }else{
                        ForEach(viewModel.postLists, id : \.self) { PostList in
                            NavigationLink(
                                destination:
                                    PostInfoView(viewModel: PostInfoViewModel(
                                        token: viewModel.token,
                                        postId : PostList.postInfo.postId,
                                        memberId : viewModel.memberId,
                                        isMyPost : (viewModel.memberId == PostList.member?.memberId)))
                            ){
                                GeneralPost(viewModel : GeneralPostViewModel(postList: PostList))
                            }
                        }
                        Spacer(minLength: UIScreen.main.bounds.height * 0.1)
                    }
                }
            }.listStyle(PlainListStyle()) // iOS 15 대응
                .padding(.top, 5)
        }.overlay(
            VStack(spacing : 0) {
                Spacer()
                LinearGradient(colors: [.white.opacity(0), .white], startPoint: .top, endPoint: .bottom)
                    .frame(height : UIScreen.main.bounds.height * 0.1)
                Color.white
                    .frame(height : UIScreen.main.bounds.height * 0.05)
            }.edgesIgnoringSafeArea(.bottom)
        ).onAppear {
            //            sleep(30000)
            //            self.setNotification() //test
            //            self.sendMessageTouser(to: ReceiverFCMToken, title: "test fcm", body: "test")
            //            usleep(200000)
            viewModel.getBoardPosts(token: viewModel.token)
        }
        //        .refreshable{ // only for ios15
        //            viewModel.getBoardPosts(token: viewModel.token)
        //        }
    }
    
    //test
    //    func setNotification() -> Void {
    //        let manager = LocalNotificationManager()
    //        manager.requestPermission()
    //        manager.addNotification(title: "Bridge")
    //        manager.schedule()
    //    }
    
    //    func sendMessageTouser(to token: String, title: String, body: String) {
    //            print("sendMessageTouser()")
    //            let urlString = "https://fcm.googleapis.com/fcm/send"
    //            let url = NSURL(string: urlString)!
    //            let paramString: [String : Any] = ["to" : token,
    //                                               "notification" : ["title" : title, "body" : body],
    //                                               "data" : ["user" : "test_id"]
    //            ]
    //            let request = NSMutableURLRequest(url: url as URL)
    //            request.httpMethod = "POST"
    //            request.httpBody = try? JSONSerialization.data(withJSONObject:paramString, options: [.prettyPrinted])
    //            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    //            request.setValue("key=\(legacyServerKey)", forHTTPHeaderField: "Authorization")
    //            let task =  URLSession.shared.dataTask(with: request as URLRequest)  { (data, response, error) in
    //                do {
    //                    if let jsonData = data {
    //                        if let jsonDataDict  = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] {
    //                            NSLog("Received data:\n\(jsonDataDict))")
    //                        }
    //                    }
    //                } catch let err as NSError {
    //                    print(err.debugDescription)
    //                }
    //            }
    //            task.resume()
    //        }
    
    //        func handleLogTokenTouch() {
    //            // [START log_fcm_reg_token]
    //            let token = Messaging.messaging().fcmToken
    //            print("FCM token: \(token ?? "")")
    //            // [END log_fcm_reg_token]
    //            self.fcmTokenMessage  = "Logged FCM token: \(token ?? "")"
    //
    //            // [START log_iid_reg_token]
    //            InstanceID.instanceID().instanceID { (result, error) in
    //              if let error = error {
    //                print("Error fetching remote instance ID: \(error)")
    //              } else if let result = result {
    //                print("Remote instance ID token: \(result.token)")
    //                self.instanceIDTokenMessage  = "Remote InstanceID token: \(result.token)"
    //              }
    //            }
    //            // [END log_iid_reg_token]
    //        }
}


struct GeneralPost : View {
    private let viewModel : GeneralPostViewModel
    
    init(viewModel : GeneralPostViewModel) {
        self.viewModel = viewModel
    }
    
    var body : some View {
        VStack(alignment : .leading){
            HStack{
                KFImage(URL(string : viewModel.profileImage) ??
                        URL(string: "https://static.thenounproject.com/png/741653-200.png")!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width : 30, height: 30)
                    .cornerRadius(15)
                
                VStack(alignment : .leading){
                    Text(viewModel.userName)
                        .font(.system(size: 15, weight : .bold))
                        .foregroundColor(Color.gray)
                    
                    //Text(viewModel.convertReturnedDateString(viewModel.createdAt ?? "2021-10-01 00:00:00"))
                    Text(convertReturnedDateString(viewModel.createdAt))
                        .font(.system(size: 7))
                        .foregroundColor(Color.gray)
                }
                
            }
            .foregroundColor(.black)
            .padding(.bottom, 2)
            
            if(viewModel.imageUrl != "null"){
                KFImage(URL(string : viewModel.imageUrl!) ??
                        URL(string: "https://static.thenounproject.com/png/741653-200.png")!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width : UIScreen.main.bounds.width * 0.83, height: UIScreen.main.bounds.height * 0.22)
                    .cornerRadius(10)
            }
            
            HStack(alignment: .bottom){
                VStack(alignment: .leading){
                    Text(viewModel.postTitle)
                        .font(.system(size: 13, weight : .medium))
                        .foregroundColor(Color.black)
                    
                    if(viewModel.imageUrl == "null"){
                        Text(viewModel.description)
                            .font(.system(size: 10))
                            .foregroundColor(Color.gray)
                    }
                }
                
                Spacer()
                
                
                Image(systemName: "message.fill")
                    .font(.system(size: 10, weight : .medium))
                Text(String(viewModel.commentCount))
                    .font(.system(size: 10, weight : .medium))
                
                Image("like")
                    .font(.system(size: 10, weight : .medium))
                    .foregroundColor(.mainTheme)
                Text(String(viewModel.likeCount))
                    .font(.system(size: 10, weight : .medium))
            }.foregroundColor(.black)
        }
        .modifier(GeneralPostStyle())
        //        .frame(height: viewModel.imageUrl != "null" ? UIScreen.main.bounds.height * 0.27 : UIScreen.main.bounds.height * 0.18)
    }
}

//struct SecretPost : View {
//    private let viewModel : SecretViewModel
//
//    init(viewModel : SecretViewModel) {
//        self.viewModel = viewModel
//    }
//
//    var body : some View {
//        VStack{
//                Text(viewModel.postTitle)
//                    .font(.system(size: 15, weight : .medium))
//
//                HStack{
//                    Group{
//                        Image(systemName: "hand.thumbsup.fill")
//                            .font(.system(size: 10))
//                            .foregroundColor(.mainTheme)
//                        Text(String(viewModel.likeCount))
//                            .font(.system(size: 10, weight : .medium))
//                            .foregroundColor(.black)
//                    }
//
//                    Group{
//                        Image(systemName: "message.fill")
//                            .font(.system(size: 10))
//                        Text(String(viewModel.commentCount))
//                            .font(.system(size: 10, weight : .medium))
//                    }.foregroundColor(.black)
//                }
//            }
//        .modifier(SpecialPostStyle())
//    }
//}

struct HotPost : View {
    private let viewModel : GeneralPostViewModel
    
    init(viewModel : GeneralPostViewModel) {
        self.viewModel = viewModel
    }
    
    var body : some View {
        VStack{
            Text(viewModel.postTitle)
                .font(.system(size: 15, weight : .medium))
            
            HStack{
                Group{
                    Image("like")
                        .font(.system(size: 10))
                        .foregroundColor(.mainTheme)
                    Text(String(viewModel.likeCount))
                        .font(.system(size: 10, weight : .medium))
                        .foregroundColor(.black)
                }
                
                Group{
                    Image(systemName: "message.fill")
                        .font(.system(size: 10))
                    Text(String(viewModel.commentCount))
                        .font(.system(size: 10, weight : .medium))
                }.foregroundColor(.black)
            }
        }
        .modifier(SpecialPostStyle())
    }
}

