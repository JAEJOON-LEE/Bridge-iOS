//
//  WanUInfoViewModel.swift
//  Bridge-iOS
//
//  Created by 이재준 on 2021/10/10.
//

import Foundation
import Combine
import Alamofire

final class WantUInfoViewModel : ObservableObject {
    @Published var totalWantPostDetail : TotalWantPostDetail?
    @Published var isLiked : Bool?
    @Published var likeCount : Int = 0
    @Published var commentCount : Int = 0
    @Published var isMemberInfoClicked : Bool = false
    @Published var isMenuClicked : Bool = false
    @Published var isImageTap : Bool = false
    @Published var showAction : Bool = false
    @Published var showConfirmDeletion : Bool = false
    @Published var showPostModify : Bool = false
    
//    @Published var comment : Comments?
    @Published var commentLists : [CommentList] = []
    @Published var commentInput : String = ""
    @Published var isAnonymous : Bool = false
    
    private var subscription = Set<AnyCancellable>()
    let token : String
    private let postId : Int
    let isMyPost : Bool
    
    init(token : String, postId : Int, isMyPost : Bool) {
        self.token = token
        self.postId = postId
        self.isMyPost = isMyPost
        getWantPostDetail()
        getWantComment()
    }
    
    func getWantPostDetail() {
        
        let url = "http://3.36.233.180:8080/want-posts/\(postId)"
        let header: HTTPHeaders = [ "X-AUTH-TOKEN" : token ]
        
        AF.request(url,
                   method: .get,
                   encoding: URLEncoding.default,
                   headers: header
        )
            .publishDecodable(type : TotalWantPostDetail.self)
            .compactMap { $0.value }
            .sink { completion in
                switch completion {
                case let .failure(error) :
                    print(error.localizedDescription)
                case .finished :
                    print("finished")
                }
            } receiveValue: { [weak self] recievedValue in
                print(recievedValue)
                self?.totalWantPostDetail = recievedValue
                self?.isLiked = recievedValue.wantPostDetail.like
//                print(self?.totalBoardPostDetail as Any)
            }.store(in: &subscription)
    }
    
    func likeWantPost(isliked : Bool) {
        let url = "http://3.36.233.180:8080/want-posts/\(postId)/likes"
        let header: HTTPHeaders = [ "X-AUTH-TOKEN" : token ]
        let method : HTTPMethod = isliked ? .delete : .post
        
        AF.request(url,
                   method: method,
                   encoding: URLEncoding.default,
                   headers: header
        ).response { json in
            print(json)
        }
    }
    
    func deleteWantPost() {
        let url = "http://3.36.233.180:8080/want-posts/\(postId)"
        let header: HTTPHeaders = [ "X-AUTH-TOKEN" : token ]
        
        AF.request(url,
                   method: .delete,
                   encoding: URLEncoding.default,
                   headers: header
        ).responseJSON { json in
//            print(json)
        }
    }
    
    func sendWantComment(content : String, anonymous : String) {
        
        let url = "http://3.36.233.180:8080/want-posts/\(postId)/comments"
        let header: HTTPHeaders = [ "X-AUTH-TOKEN" : token ]
        
        AF.request(url,
                   method: .post,
                   parameters: ["content" : content, "anonymous" : anonymous],
                   encoder: JSONParameterEncoder.prettyPrinted, // 500 error if using URLEncoding.default
                   headers: header
        ).responseString{ (response) in

            guard let statusCode = response.response?.statusCode else { return }

//            print("SendComment statuscode = " + String(statusCode))
        }
        
        //refresh
//        getBoardPostDetail()
//        getComment()
    }

    func getWantComment() {
        
        let url = "http://3.36.233.180:8080/want-posts/\(postId)/comments?"
        let header: HTTPHeaders = [ "X-AUTH-TOKEN" : token ]
        
        AF.request(url,
                   method: .get,
                   parameters: ["lastComment": 0],
                   encoding: URLEncoding.default,
                   headers: header
        )
            .publishDecodable(type : TotalCommentList.self)
            .compactMap { $0.value }
            .map { $0.commentList }
            .sink { completion in
                switch completion {
                case let .failure(error) :
                    print(error.localizedDescription)
                case .finished :
                    print("get comment finished")
//                    print("\(url)")
                }
            } receiveValue: { [weak self] (recievedValue : [CommentList]) in
                self?.commentLists = recievedValue
//                print(recievedValue)
            }.store(in: &subscription)
    }
    
}


