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
    @Published var description : String = ""
    
    @Published var showImagePicker : Bool = false
    @Published var showCampPicker : Bool = false
    @Published var showCategoryPicker : Bool = false
    
    @Published var selectedCamps : [Int] = []
    @Published var selectedCategory = ""
    
    @Published var isUploadDone : Bool = false
    @Published var isProgressShow : Bool = false
    
    private let token : String
    init(accessToken : String) {
        self.token = accessToken
    }
    
    private let url = "http://3.36.233.180:8080/used-posts"

    let campToNum : [String : Int] = [
        "Camp Casey" : 1,
        "Camp Hovey" : 2,
        "USAG Yongsan" : 3,
        "K-16" : 4,
        "Suwon A/B" : 5,
        "Osan A/B" : 6,
        "Camp Humpreys" : 7,
        "Camp Carroll" : 8,
        "Camp Henry" : 9,
        "Camp Worker" : 10,
        "Gunsan A/B" : 11
    ]
    
    let camps = ["Camp Casey", "Camp Hovey", "USAG Yongsan", "K-16", "Suwon A/B", "Osan A/B", "Camp Humpreys", "Camp Carroll", "Camp Henry", "Camp Worker", "Gunsan A/B"]
    let categories = ["digital", "furniture", "food", "clothes", "beauty", "etc."]
    
    var configuration : PHPickerConfiguration {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.filter = .images
        configuration.selectionLimit = 3
        
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
                "camp" : selectedCamps
            ]
        ]
        
        AF.upload(multipartFormData: { [weak self] (multipartFormData) in
            guard let self = self else { return }
            
            // images
            for image in self.selectedImages {
                multipartFormData.append(image.jpegData(compressionQuality: 1.0)!,
                            withName : "files", fileName: "payloadImage.jpg", mimeType: "image/jpeg")
            }
            //multipartFormData.append(self.file2, withName: "files", fileName : "testImg.png", mimeType: "image/jpeg")
            
            // postInfo
            multipartFormData.append(
                try! JSONSerialization
                    .data(withJSONObject: payload["postInfo"]!), withName: "postInfo", mimeType: "application/json"
            )
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
