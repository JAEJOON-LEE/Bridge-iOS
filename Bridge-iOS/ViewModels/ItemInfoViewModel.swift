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

    var itemInfo : ItemInfo?
    var isItemInfoFetchDone : Bool = false
    @Published var isMemberInfoClicked : Bool = false
    @Published var isLiked : Bool?
    @Published var isImageTap : Bool = false
    
    @Published var actionSheetType : Int = 0 // 1 : Post Action, 2 : Block Action
    @Published var showAction : Bool = false
    @Published var showConfirmDeletion : Bool = false
    @Published var showPostModify : Bool = false
    @Published var blockConfirmation : Bool = false
    
    @Published var currentImageIndex : Int = 0
    @Published var chatCreation : Bool = false
    var createdChatId : Int = 0
    
    
    private var subscription = Set<AnyCancellable>()
    
    var previousLikeStatus : Bool = false
    
    let postId : Int
    let userInfo : MemeberInformation
    let isMyPost : Bool
    
    init(postId : Int, isMyPost : Bool, userInfo : MemeberInformation) {
        self.postId = postId
        self.isMyPost = isMyPost
        self.userInfo = userInfo
        //getItemInfo()
    }
    
    var formattedPrice : String {
        guard let numToCal = itemInfo?.usedPostDetail.price else { return "" }
        var src = String(Int(numToCal))
        var len = src.count
        var count = 1

        while (len > (4 * count - 1)) { //
            src.insert(",", at: src.index(src.endIndex, offsetBy: (4 * count - 1) * -1))
            count += 1
            len += 1
        }

        return src
    }
    
    func getItemInfo() {
        let url = baseURL + "/used-posts/\(postId)"
        let header: HTTPHeaders = [ "X-AUTH-TOKEN" : SignInViewModel.accessToken ]
        
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
                
                self?.isItemInfoFetchDone = true
                //print(self?.itemInfo as Any)
            }.store(in: &subscription)
    }
    
    func likePost(isliked : Bool) {
        let url = baseURL + "/used-posts/\(postId)/likes"
        let header: HTTPHeaders = [ "X-AUTH-TOKEN" : SignInViewModel.accessToken ]
        let method : HTTPMethod = isliked ? .delete : .post
        
        AF.request(url,
                   method: method,
                   encoding: URLEncoding.default,
                   headers: header
        ).response { json in print(json) }
    }
    
    func deletePost() {
        let url = baseURL + "/used-posts/\(postId)"
        let header: HTTPHeaders = [ "X-AUTH-TOKEN" : SignInViewModel.accessToken ]
        
        AF.request(url,
                   method: .delete,
                   encoding: URLEncoding.default,
                   headers: header
        ).responseJSON { json in print(json) }
    }

    func createChat() {
        let url = baseURL + "/chats"
        let header: HTTPHeaders = [ "X-AUTH-TOKEN" : SignInViewModel.accessToken ]

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
            self?.chatCreation = true
        }.store(in: &subscription)
    }
    
    func blockUser() {
        let url = baseURL + "/members/\(userInfo.memberId)/blocks"
        let header: HTTPHeaders = [ "X-AUTH-TOKEN" : SignInViewModel.accessToken ]

        guard let memberToBlock = itemInfo?.member.memberId else { return }
        
        AF.request(url,
                   method: .post,
                   parameters: [ "memberId" : memberToBlock ],
                   encoder: JSONParameterEncoder.prettyPrinted,
                   headers: header
        ).responseJSON { json in print(json) }
    }
}
