//
//  PostInfoViewModel.swift
//  Bridge-iOS
//
//  Created by 이재준 on 2021/10/08.
//

import Foundation
import Combine
import Alamofire

final class PostInfoViewModel : ObservableObject {
    //fcm  test
    
    @Published var totalBoardPostDetail : TotalBoardPostDetail?
    @Published var totalSecretPostDetail : TotalSecretPostDetail?
    @Published var commentLists : [CommentList] = []
    @Published var commentItem : CommentList?
    
    @Published var isLiked : Bool = false
    @Published var isCommentLiked : Bool = false
    @Published var isCocLiked : Bool = false
    
    @Published var likeCount : Int = 0
    @Published var commentCount : Int = 0
    @Published var isMemberInfoClicked : Bool = false
    @Published var isMenuClicked : Bool = false
    @Published var isImageTap : Bool = false
    @Published var currentImageIndex : Int = 0
    @Published var showAction : Bool = false
    @Published var showAction2 : Bool = false
    @Published var showAction3 : Bool = false
    @Published var showConfirmDeletion : Bool = false
    @Published var showPostModify : Bool = false
    @Published var showCommentModify : Bool = false
    @Published var showCommentAlert : Bool = false
    @Published var commentSended : Bool = false
    @Published var isProgressShow : Bool = false
    @Published var isPostReport : Bool = false
    @Published var isReportDone : Bool = false
    @Published var isAlertShow : Bool = false
    @Published var isNotMyComment : Bool = false
    
    
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
    
    init(token : String, postId : Int, memberId : Int, isMyPost : Bool?) {
        self.contentForViewing = "Say something..."
        self.token = token
        self.postId = postId
        self.memberId = memberId
        if(isMyPost != nil){
            self.isMyPost = isMyPost!
            getBoardPostDetail()
            getComment()
        }else{
            self.isMyPost = nil
            self.isSecret = true
            getSecretPostDetail()
            getSecretComment()
        }
    }
    
    func getBoardPostDetail() {
        
        let url = "http://3.36.233.180:8080/board-posts/\(postId)"
        let header: HTTPHeaders = [ "X-AUTH-TOKEN" : token ]
        
        AF.request(url,
                   method: .get,
                   encoding: URLEncoding.default,
                   headers: header
        )
            .publishDecodable(type : TotalBoardPostDetail.self)
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
                self?.totalBoardPostDetail = recievedValue
                self?.isLiked = recievedValue.boardPostDetail.like
//                print(self?.totalBoardPostDetail as Any)ㅇㅇㅇㅇㅇ
            }.store(in: &subscription)
    }
    
    func likePost(isliked : Bool) {
        let url = "http://3.36.233.180:8080/board-posts/\(postId)/likes"
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
    
    func deletePost() {
        let url = "http://3.36.233.180:8080/board-posts/\(postId)"
        let header: HTTPHeaders = [ "X-AUTH-TOKEN" : token ]
        
        AF.request(url,
                   method: .delete,
                   encoding: URLEncoding.default,
                   headers: header
        ).responseJSON { json in
//            print(json)
        }
    }
    
    func sendComment(content : String, anonymous : String) {
        
        let url = "http://3.36.233.180:8080/board-posts/\(postId)/comments"
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
                case 200, 201 :
                    print("Post Upload Success : \(statusCode)")
                    self.commentSended = true
//                    self.isProgressShow = false
                default :
                    print("Post Upload Fail : \(statusCode)")
                }
        }
    }
    
    func sendCommentOfComment(content : String, anonymous : String, cocId : Int) {
        
        let url = "http://3.36.233.180:8080/board-posts/\(postId)/comments"
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

    func getComment() {
        
        let url = "http://3.36.233.180:8080/board-posts/\(postId)/comments?"
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
    
    func deleteComment() {
        let url = "http://3.36.233.180:8080/board-posts/\(postId)/comments/\(commentId!)"
        let header: HTTPHeaders = [ "X-AUTH-TOKEN" : token ]
        
        AF.request(url,
                   method: .delete,
                   encoding: URLEncoding.default,
                   headers: header
        ).responseJSON { json in
//            print(json)
        }
    }
    
    func patchComment(content : String) {
        
        let url = "http://3.36.233.180:8080/board-posts/\(postId)/comments/\(commentId!)"
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
    
    //Secret Post
    
    func getSecretPostDetail() {
        
        let url = "http://3.36.233.180:8080/secret-posts/\(postId)"
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
        let url = "http://3.36.233.180:8080/secret-posts/\(postId)/likes"
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
        let url = "http://3.36.233.180:8080/secret-posts/\(postId)"
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
        
        let url = "http://3.36.233.180:8080/secret-posts/\(postId)/comments"
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
        
        let url = "http://3.36.233.180:8080/secret-posts/\(postId)/comments"
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
        
        let url = "http://3.36.233.180:8080/secret-posts/\(postId)/comments?"
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
//                self?.isCommentLiked = recievedValue.boardPostDetail.like
//                print(recievedValue)
            }.store(in: &subscription)
    }
    
    func deleteSecretComment() {
        let url = "http://3.36.233.180:8080/secret-posts/\(postId)/comments/\(commentId!)"
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
        
        let url = "http://3.36.233.180:8080/secret-posts/\(postId)/comments/\(commentId!)"
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
    
    func likeComment(isCommentliked : Bool) {
        let url = "http://3.36.233.180:8080/comments/\(commentId!)/likes"
        let header: HTTPHeaders = [ "X-AUTH-TOKEN" : token ]
        let method : HTTPMethod = isCommentliked ? .delete : .post
        
        AF.request(url,
                   method: method,
                   encoding: URLEncoding.default,
                   headers: header
        ).response { json in
            print(self.commentId!)
            print(json)
        }
    }
    
    func likeCommentOfComment(isliked : Bool, cocId : Int) {
        let url = "http://3.36.233.180:8080/comments/\(cocId)/likes"
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
    
    func reportPost() {
        let url = "http://3.36.233.180:8080/posts/\(postId)/postReports"
        let header: HTTPHeaders = [ "X-AUTH-TOKEN" : token ]
        let method : HTTPMethod = .post
        
        AF.request(url,
                   method: method,
                   encoding: URLEncoding.default,
                   headers: header
        ).response { json in
            print(json)
            print("post report")
        }
    }
    
    func reportComment() {
        let url = "http://3.36.233.180:8080/comments/\(commentId!)/commentReports"
        let header: HTTPHeaders = [ "X-AUTH-TOKEN" : token ]
        let method : HTTPMethod = .post
        
        AF.request(url,
                   method: method,
                   encoding: URLEncoding.default,
                   headers: header
        ).response { json in
            print(json)
            print("comment report")
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
    
//    func anonymousComment(isAnonymous : Bool) {
//        let url = "http://3.36.233.180:8080/board-posts/\(postId)/likes"
//        let header: HTTPHeaders = [ "X-AUTH-TOKEN" : token ]
//        let method : HTTPMethod = isAnonymous ? .delete : .post
//
//        AF.request(url,
//                   method: method,
//                   encoding: URLEncoding.default,
//                   headers: header
//        ).response { json in
//            print(json)
//        }
//    }
}
