//
//  ItemInfoViewModel.swift
//  Bridge-iOS
//
//  Created by Park Gyurim on 2021/10/05.
//

import Foundation
import Combine
import Alamofire

final class ItemInfoViewModel : ObservableObject {
    //fcm  test
    let ReceiverFCMToken =  ""   //개인 기기 token -> 각 사용자마다 값 받아와야함
    let legacyServerKey = "" //서버 token (변경 x)
    var badgeCnt = 0

    @Published var itemInfo : ItemInfo?
    @Published var isMemberInfoClicked : Bool = false
    @Published var isLiked : Bool?
    @Published var isImageTap : Bool = false
    @Published var showAction : Bool = false
    @Published var showConfirmDeletion : Bool = false
    @Published var showPostModify : Bool = false
    @Published var currentImageIndex : Int = 0
    @Published var chatCreation : Bool = false
    @Published var createdChatId : Int = 0
    
    private var subscription = Set<AnyCancellable>()
    
    var previousLikeStatus : Bool = false
    
    let token : String
    let postId : Int
    let isMyPost : Bool
    
    init(token : String, postId : Int, isMyPost : Bool) {
        self.token = token
        self.postId = postId
        self.isMyPost = isMyPost
        getItemInfo()
    }
    
    var formattedPrice : String {
        guard let numToCal = itemInfo?.usedPostDetail.price else { return "" }
        var src = String(Int(numToCal))
        let len = src.count
        var count = 1

        while (len > (4 * count - 1)) { //
            src.insert(",", at: src.index(src.endIndex, offsetBy: (4 * count - 1) * -1))
            count += 1
        }
        
        return src
    }
    
    func getItemInfo() {
        let url = "http://3.36.233.180:8080/used-posts/\(postId)"
        let header: HTTPHeaders = [ "X-AUTH-TOKEN" : token ]
        
        AF.request(url,
                   method: .get,
                   encoding: URLEncoding.default,
                   headers: header
        )
            .publishDecodable(type : ItemInfo.self)
            .compactMap { $0.value }
            .sink { completion in
                switch completion {
                case let .failure(error) :
                    print(error.localizedDescription)
                case .finished :
                    print("Get Item Info Finished")
                }
            } receiveValue: { [weak self] recievedValue in
                //print(recievedValue)
                self?.itemInfo = recievedValue
                self?.isLiked = recievedValue.usedPostDetail.like
                self?.previousLikeStatus = recievedValue.usedPostDetail.like
                //print(self?.itemInfo as Any)
            }.store(in: &subscription)
    }
    
    func likePost(isliked : Bool) {
        let url = "http://3.36.233.180:8080/used-posts/\(postId)/likes"
        let header: HTTPHeaders = [ "X-AUTH-TOKEN" : token ]
        let method : HTTPMethod = isliked ? .delete : .post
        
        AF.request(url,
                   method: method,
                   encoding: URLEncoding.default,
                   headers: header
        ).response { json in
//            print(json)
        }
    }
    
    func deletePost() {
        let url = "http://3.36.233.180:8080/used-posts/\(postId)"
        let header: HTTPHeaders = [ "X-AUTH-TOKEN" : token ]
        
        AF.request(url,
                   method: .delete,
                   encoding: URLEncoding.default,
                   headers: header
        ).responseJSON { json in
//            print(json)
        }
    }

    func createChat() {
        let url = "http://3.36.233.180:8080/chats"
        let header: HTTPHeaders = [ "X-AUTH-TOKEN" : token ]

        AF.request(url,
                   method: .post,
                   parameters: [ "postId" : postId ],
                   encoder: JSONParameterEncoder.prettyPrinted,
                   headers: header
        ).responseJSON { json in print(json) }
        .publishDecodable(type : CreateChat.self)
        .compactMap { $0.value }
        .map { $0.chatId }
        .sink { completion in
            switch completion {
            case let .failure(error) :
                print(error.localizedDescription)
            case .finished :
                print("Create Chat Finished")
            }
        } receiveValue: { [weak self] recievedValue in
            self?.createdChatId =  recievedValue //.chatId
        }.store(in: &subscription)
    }
    
    func sendMessageTouser(to token: String, title: String, body: String) {
            print("sendMessageTouser()")
            badgeCnt = badgeCnt + 1
        
            let urlString = "https://fcm.googleapis.com/fcm/send"
            let url = NSURL(string: urlString)!
            let paramString: [String : Any] = ["to" : token,
                                               "notification" : ["title" : title, "body" : body, "badge" : badgeCnt],
                                               "data" : ["user" : "test_id"]
            ]
            let request = NSMutableURLRequest(url: url as URL)
            request.httpMethod = "POST"
            request.httpBody = try? JSONSerialization.data(withJSONObject:paramString, options: [.prettyPrinted])
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("key=\(legacyServerKey)", forHTTPHeaderField: "Authorization")
            let task =  URLSession.shared.dataTask(with: request as URLRequest)  { (data, response, error) in
                do {
                    if let jsonData = data {
                        if let jsonDataDict  = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] {
                            NSLog("Received data:\n\(jsonDataDict))")
                        }
                    }
                } catch let err as NSError {
                    print(err.debugDescription)
                }
            }
            task.resume()
        }
}
