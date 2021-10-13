//
//  WritingViewModel.swift
//  Bridge-iOS
//
//  Created by 이재준 on 2021/09/29.
//

import Foundation
import Combine
import Alamofire
import SwiftUI

extension String{
    func toImage() -> UIImage? {
        if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters){
            return UIImage(data: data)
        }
        return nil
    }
}

class WritingViewModel : ObservableObject {
    var param: Dictionary<String, Any> = Dictionary<String, Any>()
    
    @Published var infoForModifying : TotalBoardPostDetail?
    @Published var title = ""
    @Published var description = ""
    @Published var anonymous = false
    @Published var files : Data?
    @Published var selectedImage: UIImage? // 일단 이미지 하나만
    @Published var isWant = false
    @Published var writing : WritingInfo?
    
    let postId : Int
    let isForModifying : Bool
    let token : String
        
    init(accessToken : String, postId : Int, isForModifying : Bool) {
        self.token = accessToken
        self.postId = postId
        self.isForModifying = isForModifying
        
        getBoardPostDetail()
        
    }
//    let url : String = "http://3.36.233.180:8080/board-posts"
    
    private var subscription = Set<AnyCancellable>()
    
    func loadImage() {
        guard let selectedImage = selectedImage else { return }
            files = selectedImage.jpegData(compressionQuality: 1)!
        }
    
    func post(title : String, description : String, anonymous : Bool, files : Data?) {
        let header: HTTPHeaders = [
            "X-AUTH-TOKEN": token,
            "Accept": "multipart/form-data",
            "Content-Type": "multipart/form-data"
        ]
        
        param = ["title" : title,
                 "description" : description,
                 "anonymous" : String(anonymous)]
        
        AF.upload(multipartFormData: { multipartFormData in
            
                        multipartFormData.append("{ \"title\" : \"\(title)\", \"description\" : \"\(description)\", \"anonymous\" : \"\(anonymous)\" }".data(using: .utf8)!, withName: "postInfo", mimeType: "application/json")
                        
                        if(files != nil){
                            multipartFormData.append(files!, withName: "files", fileName: "From_iOS", mimeType: "image/jpg")
                        }
                        
                    }, to:"http://3.36.233.180:8080/board-posts",
                    method: .post,
                    headers: header)
            .responseString{ (response) in
            
            guard let statusCode = response.response?.statusCode else { return }
            
            print(statusCode)
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
                print(recievedValue)
                self?.infoForModifying = recievedValue
//                print(self?.totalBoardPostDetail as Any)
            }.store(in: &subscription)
    }
    
    func modifyPost(title : String?, description : String?, anonymous : Bool, files : Data?) {
        let header: HTTPHeaders = [
            "X-AUTH-TOKEN": token,
            "Accept": "multipart/form-data",
            "Content-Type": "multipart/form-data"
        ]
//
//        param = ["title" : title,
//                 "description" : description,
//                 "anonymous" : String(anonymous)]
        
        var query : String = "{ "
        if(title != nil && title != ""){
            query.append("\"title\" : \"\(title!)\", ")
        }
        if(description != nil && description != ""){
            query.append("\"description\" : \"\(description!)\", ")
        }
        query.append(" \"anonymous\" : \"\(anonymous)\" }");
        
        print(query)
        AF.upload(multipartFormData: { multipartFormData in
            
                        multipartFormData.append(query.data(using: .utf8)!, withName: "postInfo", mimeType: "application/json")
                        
                        if(files != nil){
                            multipartFormData.append(files!, withName: "files", fileName: "From_iOS", mimeType: "image/jpg")
                        }
                        
                    }, to:"http://3.36.233.180:8080/board-posts/\(postId)",
                    method: .post,
                    headers: header)
            .responseString{ (response) in
            
            guard let statusCode = response.response?.statusCode else { return }
            
            print(statusCode)
        }
    }
    
    func wantPost(title : String, description : String, anonymous : Bool, files : Data?) {
        let header: HTTPHeaders = [
            "X-AUTH-TOKEN": token,
            "Accept": "multipart/form-data",
            "Content-Type": "multipart/form-data"
        ]
        
        param = ["title" : title,
                 "description" : description,
                 "anonymous" : String(anonymous)]
        
        AF.upload(multipartFormData: { multipartFormData in
            
                        multipartFormData.append("{ \"title\" : \"\(title)\", \"description\" : \"\(description)\", \"anonymous\" : \"\(anonymous)\" }".data(using: .utf8)!, withName: "postInfo", mimeType: "application/json")
                        
                        if(files != nil){
                            multipartFormData.append(files!, withName: "files", fileName: "From_iOS", mimeType: "image/jpg")
                        }
                        
                    }, to:"http://3.36.233.180:8080/want-posts",
                    method: .post,
                    headers: header)
            .responseString{ (response) in
            
            guard let statusCode = response.response?.statusCode else { return }
            
            print(statusCode)
        }
    }
    
    

}
