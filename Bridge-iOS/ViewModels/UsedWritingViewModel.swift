//
//  UsedWritingViewModel.swift
//  Bridge-iOS
//
//  Created by Park Gyurim on 2021/10/10.
//

import SwiftUI
import PhotosUI
import Alamofire

final class UsedWritingViewModel : ObservableObject {
    @Published var selectedImages : [UIImage] = []
    @Published var title : String = ""
    @Published var price : String = ""
    @Published var description : String = "Please write the content of your Post"
    
    @Published var showImagePicker : Bool = false
    @Published var showCampPicker : Bool = false
    @Published var showCategoryPicker : Bool = false
    
    @Published var selectedCamps : [Int] = []
    @Published var selectedCategory = ""
    
    @Published var isUploadDone : Bool = false
    @Published var isProgressShow : Bool = false
    
    @Published var isImageTap : Bool = false
    
    private let token : String
    init(accessToken : String) {
        self.token = accessToken
    }
    
    private let url = "http://3.36.233.180:8080/used-posts"

    let campToNum : [String : Int] = [
        //"Camp Casey" : 1,
        //"Camp Hovey" : 2,
        "Casey/Hovey" : 1,
        "USAG Yongsan" : 3,
        "K-16" : 4,
        "Suwon A/B" : 5,
        "Osan A/B" : 6,
        "Camp Humperys" : 7,
        "Camp Carroll" : 8,
        //"Camp Henry" : 9,
        //"Camp Walker" : 10,
        "Henry/Walker" : 9,
        "Gunsan A/B" : 11
    ]
    
    let camps = ["Casey/Hovey", "USAG Yongsan", "K-16", "Suwon A/B", "Osan A/B", "Camp Humperys", "Camp Carroll", "Henry/Walker", "Gunsan A/B"]
    //["Camp Casey", "Camp Hovey", "USAG Yongsan", "K-16", "Suwon A/B", "Osan A/B", "Camp Humperys", "Camp Carroll", "Camp Henry", "Camp Walker", "Gunsan A/B"]
    
    let categories = ["Digital", "Interior", "Fashion", "Life", "Beauty", "Etc"]
    //["digital", "furniture", "food", "clothes", "beauty", "etc."]
    
    var configuration : PHPickerConfiguration {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.filter = .images
        configuration.selectionLimit = 7
        
        return configuration
    }
    
    func upload() { //(with payload : PostPayload)
        let header : HTTPHeaders = [
            "Content-Type": "multipart/form-data",
            "X-AUTH-TOKEN": token
        ]
        
        let payload : [String : [String : Any]] = [
            "postInfo" : [
                "title" : title,
                "price" : price,
                "description" : description,
                "category" : selectedCategory,
                "camps" : selectedCamps
            ]
        ]
//        let payload2 = """
//            {
//                "title" : \"\(title)\",
//                "price" : \"\(price)\",
//                "description" : \"\(description)\",
//                "category" : \"\(selectedCategory)\",
//                "camps" : \(selectedCamps)
//            }
//        """.data(using: .utf8)!
        
        AF.upload(multipartFormData: { [weak self] (multipartFormData) in
            guard let self = self else { return }

            // images
            for image in self.selectedImages {
                multipartFormData.append(image.jpegData(compressionQuality: 1.0)!,
                            withName : "files", fileName: "payloadImage.jpg", mimeType: "image/jpeg")
            }

            // postInfo
            multipartFormData.append(
                try! JSONSerialization.data(withJSONObject: payload["postInfo"]!),
                withName: "postInfo",
                mimeType: "application/json"
            )
            //multipartFormData.append(payload2, withName: "postInfo", mimeType: "application/json")
        }, to: URL(string : url)!, usingThreshold: UInt64.init(), method : .post, headers: header)
            .responseJSON { [weak self] (response) in
                guard let statusCode = response.response?.statusCode else { return }
                switch statusCode {
                case 200 :
                    print("Post Upload Success : \(statusCode)")
                    self?.isUploadDone = true
                default :
                    print("Post Upload Fail : \(statusCode)")
                }
            }
    }
}
