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
    @Published var description : String = ""
    @Published var anonymous = false
    @Published var files : Data? = nil
    @Published var selectedImages : [UIImage] = []
    @Published var showImagePicker : Bool = false
    @Published var isSecret = false
    @Published var writing : WritingInfo?
    @Published var isImageTap : Bool = false
    @Published var anonymousChecked : Bool = false
    @Published var secretChecked : Bool = false
    @Published var isUploadDone : Bool = false
    @Published var isProgressShow : Bool = false
    @Published var showAlert : Bool = false
    @Published var currentImageIndex : Int = 0
    
    
    let postId : Int
    let isForModifying : Bool
    let token : String
    let isForSecretModifying : Bool
    
    var configuration : PHPickerConfiguration {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.filter = .images
        configuration.selectionLimit = 3
        
        return configuration
    }
        
    init(accessToken : String, postId : Int, isForModifying : Bool, isForSecretModifying : Bool) {
        self.token = accessToken
        self.postId = postId
        self.isForModifying = isForModifying
        self.isForSecretModifying = isForSecretModifying
        
//        if(self.isForSecretModifying != nil){
            if(isForSecretModifying == true){
                getSecretPostDetail()
            }else if(isForModifying == true){
                getBoardPostDetail()
            }
//        }
    }
//    let url : String = "http://ALB-PRD-BRIDGE-BRIDGE-898468050.ap-northeast-2.elb.amazonaws.com/board-posts"
    
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
        
        let payloadEncoded = String(data : "{ \"title\" : \"\(title)\", \"description\" : \"\(description)\", \"anonymous\" : \"\(anonymous)\" }".data(using: .nonLossyASCII)!, encoding : .utf8) ?? ""
        AF.upload(multipartFormData: { multipartFormData in
            
                        multipartFormData.append(payloadEncoded.data(using: .utf8)!, withName: "postInfo", mimeType: "application/json")
                        
                        for image in self.selectedImages {
                            multipartFormData.append(image.jpegData(compressionQuality: 1.0)!,
                                        withName : "files", fileName: "payloadImage.jpg", mimeType: "image/jpeg")
                        }
                        
                    }, to: baseURL + "/board-posts",
                    method: .post,
                    headers: header)
            .responseString{ (response) in
            
                guard let statusCode = response.response?.statusCode else { return }
                switch statusCode {
                case 200, 201 :
                    print("Post Upload Success : \(statusCode)")
                    self.isUploadDone = true
                default :
                    print("Post Upload Fail : \(statusCode)")
                }
        }
    }
    
    func secretPost(title : String, description : String, anonymous : Bool, files : Data?) {
        let header: HTTPHeaders = [
            "X-AUTH-TOKEN": token,
            "Accept": "multipart/form-data",
            "Content-Type": "multipart/form-data"
        ]
        
        param = ["title" : title,
                 "description" : description]
        
        let payloadEncoded = String(data : "{ \"title\" : \"\(title)\", \"description\" : \"\(description)\"}".data(using: .nonLossyASCII)!, encoding : .utf8) ?? ""
        AF.upload(multipartFormData: { multipartFormData in
            
                        multipartFormData.append(payloadEncoded.data(using: .utf8)!, withName: "postInfo", mimeType: "application/json")
                        
                        for image in self.selectedImages {
                            multipartFormData.append(image.jpegData(compressionQuality: 1.0)!,
                                        withName : "files", fileName: "payloadImage.jpg", mimeType: "image/jpeg")
                        }
                        
                    }, to: baseURL + "/secret-posts",
                    method: .post,
                    headers: header)
            .responseString{ (response) in
                
                    guard let statusCode = response.response?.statusCode else { return }
                    switch statusCode {
                    case 200, 201 :
                        print("Secret Post Upload Success : \(statusCode)")
                        self.isUploadDone = true
                    default :
                        print("Post Upload Fail : \(statusCode)")
                    }
            print(statusCode)
        }
    }
    
    
    func getBoardPostDetail() {
        
        let url = baseURL + "/board-posts/\(postId)"
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
        
        var removeImage : [Int] = []
        var query : String = "{ "
        if(title != nil && title != ""){
            query.append("\"title\" : \"\(title!)\" ")
            
            if(description != nil && description != ""){
                query.append(", \"description\" : \"\(description!)\"")
            }
        }
        else if (description != nil && description != ""){
            query.append("\"description\" : \"\(description!)\"")
        }
        
        if(selectedImages.count != 0){
            
            var cnt = 0
            
            infoForModifying?.boardPostDetail.postImages!.forEach{ image in
                removeImage.append(image.imageId)
            }
            if(query.count > 3){
                query.append(", ")
            }
            query.append("\"removeImage\" : [ ")
            for imageId in removeImage {
                if(cnt == removeImage.count - 1){
                    query.append(String(imageId))
                }else{
                    query.append(String(imageId) + ", ")
                }
                
                cnt += 1
            }
            
            query.append("] }")
        }
        else{
            query.append("}")
        }
        
        let payloadEncoded = String(data : query.data(using: .nonLossyASCII)!, encoding : .utf8) ?? ""
        AF.upload(multipartFormData: { multipartFormData in
            
                        multipartFormData.append(payloadEncoded.data(using: .utf8)!, withName: "postInfo", mimeType: "application/json")
//
//                        if(files != nil){
//                            multipartFormData.append(files!, withName: "files", fileName: "From_iOS", mimeType: "image/jpg")
//                        }
            
            if(query.count > 3){
                query.append(", ")
            }
            for image in self.selectedImages {
                multipartFormData.append(image.jpegData(compressionQuality: 1.0)!,
                            withName : "files", fileName: "payloadImage.jpg", mimeType: "image/jpeg")
            }
            
                        
                    }, to: baseURL + "/board-posts/\(postId)",
                    method: .post,
                    headers: header)
            .responseString{ (response) in
                
                    guard let statusCode = response.response?.statusCode else { return }
                    switch statusCode {
                    case 200, 201 :
                        print("Post Modify Success : \(statusCode)")
                        self.isUploadDone = true
                    default :
                        print("Post Upload Fail : \(statusCode)")
                    }
            print(statusCode)
                print(query)
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
        
        var removeImage : [Int] = []
        var query : String = "{ "
        if(title != nil && title != ""){
            query.append("\"title\" : \"\(title!)\" ")
            
            if(description != nil && description != ""){
                query.append(", \"description\" : \"\(description!)\"")
            }
        }
        else if (description != nil && description != ""){
            query.append("\"description\" : \"\(description!)\"")
        }
        
        if(selectedImages.count != 0){
            
            var cnt = 0
            
            infoForSecretModifying?.secretPostDetail.postImages!.forEach{ image in
                removeImage.append(image.imageId)
            }
            if(query.count > 3){
                query.append(", ")
            }
            query.append("\"removeImage\" : [ ")
            for imageId in removeImage {
                if(cnt == removeImage.count - 1){
                    query.append(String(imageId))
                }else{
                    query.append(String(imageId) + ", ")
                }
                
                cnt += 1
            }
            
            query.append("] }")
        }
        else{
            query.append("}")
        }
        
        let payloadEncoded = String(data : query.data(using: .nonLossyASCII)!, encoding : .utf8) ?? ""
        AF.upload(multipartFormData: { multipartFormData in
            
                        multipartFormData.append(payloadEncoded.data(using: .utf8)!, withName: "postInfo", mimeType: "application/json")
//
//                        if(files != nil){
//                            multipartFormData.append(files!, withName: "files", fileName: "From_iOS", mimeType: "image/jpg")
//                        }
            
            if(query.count > 3){
                query.append(", ")
            }
            for image in self.selectedImages {
                multipartFormData.append(image.jpegData(compressionQuality: 1.0)!,
                            withName : "files", fileName: "payloadImage.jpg", mimeType: "image/jpeg")
            }
                        
                    }, to: baseURL + "/secret-posts/\(postId)",
                    method: .post,
                    headers: header)
            .responseString{ (response) in
                
                    guard let statusCode = response.response?.statusCode else { return }
                    switch statusCode {
                    case 200, 201 :
                        print("Post Upload Success : \(statusCode)")
                        self.isUploadDone = true
                    default :
                        print("Post Upload Fail : \(statusCode)")
                    }
            print(statusCode)
        }
    }
//    extension String {
//        func toImage() -> UIImage? {
//            if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters){
//                return UIImage(data: data)
//            }
//            return nil
//        }
//    }
}
