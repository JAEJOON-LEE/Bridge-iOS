//
//  SecretInfoViewModel.swift
//  Bridge-iOS
//
//  Created by 이재준 on 2021/10/10.
//

import Foundation
import Combine
import Alamofire

final class SecretInfoViewModel : ObservableObject {
    @Published var totalSecretPostDetail : TotalSecretPostDetail?
    @Published var commentLists : [CommentList] = []
    
    @Published var isLiked : Bool?
    
    @Published var likeCount : Int = 0
    @Published var commentCount : Int = 0
    @Published var isMemberInfoClicked : Bool = false
    @Published var isMenuClicked : Bool = false
    @Published var isImageTap : Bool = false
    @Published var showAction : Bool = false
    @Published var showConfirmDeletion : Bool = false
    @Published var showPostModify : Bool = false
    @Published var showCommentModify : Bool = false
    @Published var commentSended : Bool = false
    @Published var isProgressShow : Bool = false
    
    @Published var commentInput : String = ""
    @Published var isAnonymous : Bool = false
    @Published var commentId : Int?
    
    private var subscription = Set<AnyCancellable>()
    let token : String
    let postId : Int
    let isMyPost : Bool?
    @Published var isMyComment : Bool = false
    let memberId : Int
    var isSecret : Bool = false
    
    var isCocCliked : Bool = false
    var cocMenuClicked = false
    var cocShowAction = false
    var contentForViewing : String = "Say something..."
    var contentForPatch : String = ""
    
    init(token : String, postId : Int, memberId : Int) {
        self.contentForViewing = "Say something..."
        self.token = token
        self.postId = postId
        self.memberId = memberId
//        self.memberId = memberId
//        self.isMyPost = isMyPost
        self.isMyPost = nil
        self.isSecret = true
        getSecretPostDetail()
        getSecretComment()
    }
    
    func likeComment(isliked : Bool) {
        guard let commentId = commentId else { return }
        
        let url = baseURL + "/comments/\(commentId)/likes"
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
    
    //Secret Post
    
    func getSecretPostDetail() {
        
        let url = baseURL + "/secret-posts/\(postId)"
        let header: HTTPHeaders = [ "X-AUTH-TOKEN" : token ]
        
        AF.request(url,
                   method: .get,
                   encoding: URLEncoding.default,
                   headers: header
        )
            .publishDecodable(type : TotalSecretPostDetail.self)
            .compactMap { $0.value }
            .sink { completion in
                switch completion {
                case let .failure(error) :
                    print(error.localizedDescription)
                case .finished :
                    print("finished")
                }
            } receiveValue: { [weak self] recievedValue in
//                print(recievedValue)
                self?.totalSecretPostDetail = recievedValue
                self?.isLiked = recievedValue.secretPostDetail.like
//                print(self?.totalBoardPostDetail as Any)
            }.store(in: &subscription)
    }
    
    func likeSecretPost(isliked : Bool) {
        let url = baseURL + "/secret-posts/\(postId)/likes"
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
    
    func deleteSecretPost() {
        let url = baseURL + "/secret-posts/\(postId)"
        let header: HTTPHeaders = [ "X-AUTH-TOKEN" : token ]
        
        AF.request(url,
                   method: .delete,
                   encoding: URLEncoding.default,
                   headers: header
        ).responseJSON { json in
            print(json)
        }
    }
    
    func sendSecretComment(content : String, anonymous : String) {
        
        let url = baseURL + "/secret-posts/\(postId)/comments"
        let header: HTTPHeaders = [ "X-AUTH-TOKEN" : token ]
        
        AF.request(url,
                   method: .post,
                   parameters: ["content" : content, "anonymous" : anonymous],
                   encoder: JSONParameterEncoder.prettyPrinted, // 500 error if using URLEncoding.default
                   headers: header
        ).responseString{ (response) in
            //guard let statusCode = response.response?.statusCode else { return }
            
                guard let statusCode = response.response?.statusCode else { return }
                switch statusCode {
                case 200 :
                    print("Post Upload Success : \(statusCode)")
                    self.commentSended = true
                default :
                    print("Post Upload Fail : \(statusCode)")
                }
        }
    }
    
    func sendSecretCommentOfComment(content : String, anonymous : String, cocId : Int) {
        
        let url = baseURL + "/secret-posts/\(postId)/comments"
        let header: HTTPHeaders = [ "X-AUTH-TOKEN" : token ]
        
        AF.request(url,
                   method: .post,
                   parameters: ["content" : content, "rootComment" : String(cocId), "anonymous" : anonymous],
                   encoder: JSONParameterEncoder.prettyPrinted, // 500 error if using URLEncoding.default
                   headers: header
        ).responseString{ (response) in
            //guard let statusCode = response.response?.statusCode else { return }
            
                guard let statusCode = response.response?.statusCode else { return }
                switch statusCode {
                case 200 :
                    print("Post Upload Success : \(statusCode)")
                    self.commentSended = true
                default :
                    print("Post Upload Fail : \(statusCode)")
                }
        }
    }

    func getSecretComment() {
        
        let url = baseURL + "/secret-posts/\(postId)/comments?"
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
    
    func deleteSecretComment() {
        let url = baseURL + "/secret-posts/\(postId)/comments/\(commentId!)"
        let header: HTTPHeaders = [ "X-AUTH-TOKEN" : token ]
        
        AF.request(url,
                   method: .delete,
                   encoding: URLEncoding.default,
                   headers: header
        ).responseJSON { json in
//            print(json)
            
//                guard let statusCode = response.response?.statusCode else { return }
//                switch statusCode {
//                case 200 :
//                    print("Post Upload Success : \(statusCode)")
//                    self.commentSended = true
//                default :
//                    print("Post Upload Fail : \(statusCode)")
//                }
        }
    }
    
    func patchSecretComment(content : String) {
        
        let url = baseURL + "/secret-posts/\(postId)/comments/\(commentId!)"
        let header: HTTPHeaders = [ "X-AUTH-TOKEN" : token ]
        
        AF.request(url,
                   method: .patch,
                   parameters: ["content" : content],
                   encoder: JSONParameterEncoder.prettyPrinted, // 500 error if using URLEncoding.default
                   headers: header
        ).responseString{ (response) in
            
                guard let statusCode = response.response?.statusCode else { return }
                switch statusCode {
                case 200 :
                    print("Post Upload Success : \(statusCode)")
                    self.commentSended = true
                default :
                    print("Post Upload Fail : \(statusCode)")
                }
            print("patch + " + String(statusCode))
        }
    }

    func convertReturnedDateString(_ timeString : String) -> String {
        var str = timeString
        str.removeSubrange(str.index(str.endIndex, offsetBy: -7)..<str.endIndex)
        str.remove(at: str.index(str.startIndex, offsetBy: 10))
        str.insert(" ", at: str.index(str.startIndex, offsetBy: 10))
        
        let korNow = Date(timeIntervalSinceNow: 32400) // UTC + 9H
        let timetravel = korNow.timeIntervalSince(str.toDate() ?? Date())
        
        if Int(timetravel) < 60 {
            return "\(Int(timetravel)) Seconds ago"
        } else if (60 <= Int(timetravel)) && (Int(timetravel) < 3600) {
            return "\(Int(timetravel) / 60) Minutes ago"
        } else if (3600 <= Int(timetravel)) && (Int(timetravel) < 86400) {
            return "\(Int(timetravel) / 3600) Hours ago"
        } else if (86400 <= Int(timetravel)) && (Int(timetravel) < (86400 * 7)) { // 7일까지
            return "\(Int(timetravel) / 86400) Days ago"
        } else {
            str.removeSubrange(str.index(str.endIndex, offsetBy: -9)..<str.endIndex)
            return str
        }
    }
}
