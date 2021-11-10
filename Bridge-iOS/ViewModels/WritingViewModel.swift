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
import PhotosUI

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
    @Published var infoForSecretModifying : TotalSecretPostDetail?
    @Published var title = ""
    @Published var description = ""
    @Published var anonymous = false
    @Published var files : Data? = nil
    @Published var selectedImages : [UIImage] = []
    @Published var showImagePicker : Bool = false
    @Published var isSecret = false
    @Published var writing : WritingInfo?
    
    let postId : Int
    let isForModifying : Bool
    let token : String
    let isForSecretModifying : Bool?
    
    var configuration : PHPickerConfiguration {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.filter = .images
        configuration.selectionLimit = 3
        
        return configuration
    }
        
    init(accessToken : String, postId : Int, isForModifying : Bool, isForSecretModifying : Bool?) {
        self.token = accessToken
        self.postId = postId
        self.isForModifying = isForModifying
        self.isForSecretModifying = isForSecretModifying
        
        if(self.isForSecretModifying != nil){
            if(self.isForSecretModifying!){
                getSecretPostDetail()
            }else{
                getBoardPostDetail()
            }
        }
    }
//    let url : String = "http://3.36.233.180:8080/board-posts"
    
    private var subscription = Set<AnyCancellable>()
    
//    func loadImage() {
//        for image in self.selectedImages {
//            multipartFormData.append(image.jpegData(compressionQuality: 1.0)!,
//                        withName : "files", fileName: "payloadImage.jpg", mimeType: "image/jpeg")
//        }
//    }
//
    func post(title : String, description : String, anonymous : Bool, files : Data?) {
        let header: HTTPHeaders = [
            "X-AUTH-TOKEN": token,
            "Accept": "multipart/form-data",
            "Content-Type": "multipart/form-data"
        ]
        
        param = ["title" : title,
                 "description" : description,
                 "anonymous" : String(anonymous)]
        
        //anonymous이면 나중에 수정할 때 참조 못하는 에러 생김 ==> anonymous일때 프로필사진 nil, 이름 anonymous로 강제로 보낼까..?
        AF.upload(multipartFormData: { multipartFormData in
            
                        multipartFormData.append("{ \"title\" : \"\(title)\", \"description\" : \"\(description)\", \"anonymous\" : \"\(anonymous)\" }".data(using: .utf8)!, withName: "postInfo", mimeType: "application/json")
                        
                        for image in self.selectedImages {
                            multipartFormData.append(image.jpegData(compressionQuality: 1.0)!,
                                        withName : "files", fileName: "payloadImage.jpg", mimeType: "image/jpeg")
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
                print(recievedValue)
                self?.infoForSecretModifying = recievedValue
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
    
    func modifySecretPost(title : String?, description : String?, anonymous : Bool, files : Data?) {
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
                        
                    }, to:"http://3.36.233.180:8080/secret-posts/\(postId)",
                    method: .post,
                    headers: header)
            .responseString{ (response) in
            
            guard let statusCode = response.response?.statusCode else { return }
            
            print(statusCode)
        }
    }
    
    func secretPost(title : String, description : String, anonymous : Bool, files : Data?) {
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
                        
                    }, to:"http://3.36.233.180:8080/secret-posts",
                    method: .post,
                    headers: header)
            .responseString{ (response) in
            
            guard let statusCode = response.response?.statusCode else { return }
            
            print(statusCode)
        }
    }
    
    

}
