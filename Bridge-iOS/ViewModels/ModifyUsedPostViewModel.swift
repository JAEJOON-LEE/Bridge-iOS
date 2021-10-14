//
//  ModifyUsedPostViewModel.swift
//  Bridge-iOS
//
//  Created by Park Gyurim on 2021/10/14.
//

import Foundation
import Alamofire

//- var camps : [String]
//- var category : String
//- var postImages : [postImages]
//- var price : Float
//- var title : String
//- var description : String

final class ModifyUsedPostViewModel : ObservableObject {
    @Published var title : String = ""
    @Published var price : String = ""
    @Published var description : String = ""
//    @Published var category : String = ""
//    @Published var camps : [String] = []
    @Published var postImages : [postImages] = []
    
    @Published var selectedCamps : [Int] = []
    @Published var selectedCategory = ""
    
    @Published var showImagePicker : Bool = false
    @Published var showCampPicker : Bool = false
    @Published var showCategoryPicker : Bool = false
    
    @Published var isUploadDone : Bool = false

    let camps = ["Camp Casey", "Camp Hovey", "USAG Yongsan", "K-16", "Suwon A/B", "Osan A/B", "Camp Humpreys", "Camp Carroll", "Camp Henry", "Camp Worker", "Gunsan A/B"]
    let categories = ["digital", "furniture", "food", "clothes", "beauty", "etc."]
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
    let campToInt : [Int : String] = [
        1 : "Camp Casey",
        2 : "Camp Hovey",
        3 : "USAG Yongsan",
        4 : "K-16",
        5 : "Suwon A/B",
        6 : "Osan A/B",
        7 : "Camp Humpreys",
        8 : "Camp Carroll",
        9 : "Camp Henry",
        10 : "Camp Worker",
        11 : "Gunsan A/B"
    ]
    private let token : String
    private let postId : Int

    init(accessToken : String, postId : Int, contents : UsedPostDetail) {
        self.token = accessToken
        self.postId = postId
        
        self.title = contents.title
        self.price = String(contents.price)
        self.description = contents.description
//        self.category = contents.category
//        self.camps = contents.camps
        self.postImages = contents.postImages
        self.selectedCategory = contents.category
        self.selectedCamps = contents.camps.map{
            self.campToNum[$0]!
        }
    }
    
    func upload() { //(with payload : PostPayload)
        let url = "http://3.36.233.180:8080/used-posts/\(postId)"

        let header : HTTPHeaders = [
            "Content-Type": "multipart/form-data",
            "X-AUTH-TOKEN": token
        ]
        
        let payload : [String : [String : Any]] = [
            "postInfo" : [
                "title" : title,
                "price" : Float(price) ?? Float(-1),
                "description" : description,
                "category" : selectedCategory,
                //"camps" : selectedCamps
            ]
        ]
        
        AF.upload(multipartFormData: { (multipartFormData) in
            //guard let self = self else { return }
            
            // images
//            for image in self.selectedImages {
//                multipartFormData.append(image.jpegData(compressionQuality: 1.0)!,
//                            withName : "files", fileName: "payloadImage.jpg", mimeType: "image/jpeg")
//            }
            
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
