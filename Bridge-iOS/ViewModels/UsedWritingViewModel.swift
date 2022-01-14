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
    @Published var keyboardHideButtonShow : Bool = false
    
    @Published var showImagePicker : Bool = false
    @Published var showCampPicker : Bool = false
    @Published var showCategoryPicker : Bool = false
    @Published var showMessage : Bool = false
    
    @Published var selectedCamps : [Int] = []
    @Published var selectedCategory = ""
    
    @Published var isUploadDone : Bool = false
    @Published var isProgressShow : Bool = false
    
    @Published var isImageTap : Bool = false
    
    private let url = "http://3.36.233.180:8080/used-posts"

    let message = "Please fill all field!"
    
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
    
    func isFilledPost() -> Bool {
        if selectedImages.count == 0 || title == "" || description == "" || price == "" || selectedCamps.isEmpty || selectedCategory == "" {
            return false
        }
        return true
    }
    
    func incodingHTML(_ data: Data) -> String? {
        var html = String(data: data, encoding: .utf8)
        guard html == nil else { return html }
        
        let encoding = String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(0x0422))
        html = String(data: data, encoding: encoding)
        
        guard html == nil else { return html }
        html = String(decoding: data, as: UTF8.self)
        
        return html
    }

    func upload() { //(with payload : PostPayload)
        let header : HTTPHeaders = [
            "Content-Type": "multipart/form-data",
            "X-AUTH-TOKEN": SignInViewModel.accessToken
        ]
        
//        let payload : [String : [String : Any]] = [
//            "postInfo" : [
//                "title" : title,
//                "price" : price,
//                "description" : description,
//                "category" : selectedCategory,
//                "camps" : selectedCamps
//            ]
//        ]
        
        let payload = """
            {
                "title" : \"\(title)\",
                "price" : \"\(price)\",
                "description" : \"\(description)\",
                "category" : \"\(selectedCategory)\",
                "camps" : \(selectedCamps)
            }
        """.data(using: .nonLossyASCII)!
        let payloadEncoded = String(data : payload, encoding : .utf8) ?? ""
        
        AF.upload(multipartFormData: { [weak self] (multipartFormData) in
            guard let self = self else { return }

            // images
            for image in self.selectedImages {
                multipartFormData.append(image.jpegData(compressionQuality: 1.0)!,
                            withName : "files", fileName: "payloadImage.jpg", mimeType: "image/jpeg")
            }
            
//            postInfo
//            multipartFormData.append(
//                try! JSONSerialization.data(withJSONObject: payload["postInfo"]!),
//                withName: "postInfo",
//                mimeType: "application/json"
//            )
            multipartFormData.append(payloadEncoded.data(using: .utf8)!, withName: "postInfo", mimeType: "application/json")
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
