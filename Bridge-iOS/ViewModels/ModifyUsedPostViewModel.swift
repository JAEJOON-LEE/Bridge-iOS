//
//  ModifyUsedPostViewModel.swift
//  Bridge-iOS
//
//  Created by Park Gyurim on 2021/10/14.
//

import SwiftUI
import PhotosUI
import Alamofire

final class ModifyUsedPostViewModel : ObservableObject {
    @Published var title : String = ""
    @Published var price : String = ""
    @Published var description : String = ""
    @Published var postImages : [postImages] = []
    @Published var previousSelectedCamps : [String] = []
    @Published var selectedCamps : [String] = []
    @Published var selectedCategory = ""
    @Published var ImagesToAdd : [UIImage] = []

    @Published var showImagePicker : Bool = false
    @Published var showCampPicker : Bool = false
    @Published var showCategoryPicker : Bool = false
    @Published var showImageToAddPicker : Bool = false

    @Published var isUploadDone : Bool = false

    let camps = ["Casey/Hovey", "USAG Yongsan", "K-16", "Suwon A/B", "Osan A/B", "Camp Humperys", "Camp Carroll", "Henry/Walker", "Gunsan A/B"]
    //["Camp Casey", "Camp Hovey", "USAG Yongsan", "K-16", "Suwon A/B", "Osan A/B", "Camp Humperys", "Camp Carroll", "Camp Henry", "Camp Walker", "Gunsan A/B"]
    let categories = ["Digital", "Interior", "Fashion", "Life", "Beauty", "Etc"]
    //["digital", "furniture", "food", "clothes", "beauty", "etc."]
    
    private let postId : Int

    var configuration : PHPickerConfiguration {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.filter = .images
        configuration.selectionLimit = 7 - (postImages.count + ImagesToAdd.count) // max count of photo : 7
        
        return configuration
    }
    
    var addList : [String] = []
    var removeList : [String] = []
    var removeImage : [Int] = []
    
    init(postId : Int, contents : UsedPostDetail) {
        self.postId = postId
        
        self.title = contents.title
        self.price = String(Int(contents.price))
        self.description = contents.description
        self.postImages = contents.postImages
        self.selectedCategory = contents.category
        self.previousSelectedCamps = contents.camps.map{ CampEncoding[$0]! }
        self.selectedCamps = contents.camps.map{ CampEncoding[$0]! }
    }
    
    func upload() { //(with payload : PostPayload)
        let url = baseURL + "/used-posts/\(postId)"
        let header : HTTPHeaders = [
            "Content-Type": "multipart/form-data",
            "X-AUTH-TOKEN": SignInViewModel.accessToken
        ]
        for c in selectedCamps {
            if !previousSelectedCamps.contains(c) { addList.append(c) }
        }
        
        for c in previousSelectedCamps {
            if !selectedCamps.contains(c) { removeList.append(c) }
        }
        print(selectedCamps)
        print(addList)
        print(removeList)
        
//        let editedCamps : [String : [Int]] = [
//            "addList" : addList,
//            "removeList" : removeList
//        ]
        
//        let payload : [String : [String : Any]] = [
//            "postInfo" : [
//                "title" : title,
//                "price" : price,
//                "description" : description,
//                "category" : selectedCategory,
//                "camps" : editedCamps,
//                "removeImage" : removeImage
//            ]
//        ]
        let payload = """
            {
                "title" : \"\(title)\",
                "price" : \"\(price)\",
                "description" : \"\(description)\",
                "category" : \"\(selectedCategory)\",
                "camps" : {
                    "addList" : \(addList),
                    "removeList" : \(removeList)
                },
                "removeImage" : \(removeImage)
            }
        """.data(using: .nonLossyASCII)!
        
        let payloadEncoded = String(data : payload, encoding : .utf8) ?? ""
        print("""
            {
                "title" : \"\(title)\",
                "price" : \"\(price)\",
                "description" : \"\(description)\",
                "category" : \"\(selectedCategory)\",
                "camps" : {
                    "addList" : \(addList),
                    "removeList" : \(removeList)
                },
                "removeImage" : \(removeImage)
            }
        """)
        
        AF.upload(multipartFormData: { (multipartFormData) in
            //guard let self = self else { return }

            // images to Add
            for image in self.ImagesToAdd {
                multipartFormData.append(image.jpegData(compressionQuality: 1.0)!,
                            withName : "files", fileName: "payloadImage.jpg", mimeType: "image/jpeg")
            }

//            postInfo
//            multipartFormData.append(try! JSONSerialization.data(withJSONObject: payload["postInfo"]!), withName: "postInfo", mimeType: "application/json")
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
