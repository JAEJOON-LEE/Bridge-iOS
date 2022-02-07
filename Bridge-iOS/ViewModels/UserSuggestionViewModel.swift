//
//  UserSuggestionViewModel.swift
//  Bridge-iOS
//
//  Created by Park Gyurim on 2022/02/04.
//

import SwiftUI
import Alamofire

final class UserSuggestionViewModel : ObservableObject {
    @Published var selectedCategory : Int = 1
    @Published var textToSend : String = ""
    
    @Published var payloadImage1 : UIImage? = nil
    @Published var payloadImage2 : UIImage? = nil
    @Published var payloadImage3 : UIImage? = nil
    
    @Published var showImagePicker1 : Bool = false
    @Published var showImagePicker2 : Bool = false
    @Published var showImagePicker3 : Bool = false
    
    @Published var isSendingDone : Bool = false
    
    func uploadUserSuggestion() {
        let url = "http://ALB-PRD-BRIDGE-BRIDGE-898468050.ap-northeast-2.elb.amazonaws.com/contacts"
        let header: HTTPHeaders = [ "Content-Type": "multipart/form-data", "X-AUTH-TOKEN" : SignInViewModel.accessToken ]
        var category : String {
            switch selectedCategory {
                case 1 : return "IDEA"
                case 2 : return "BUG"
                case 3 : return "OTHER"
                case 4 : return "FRAUD"
                default : return "OTHER"
            }
        }
        let payload = """
            {
                 "content": \"\(textToSend)\",
                 "category": \"\(category)\"
            }
        """.data(using: .nonLossyASCII)!
        let payloadEncoded = String(data : payload, encoding : .utf8) ?? ""
        
        AF.upload(multipartFormData: { [weak self] (multipartFormData) in
            guard let self = self else { return }
            
            // images
            if let image = self.payloadImage1 {
                multipartFormData.append(image.jpegData(compressionQuality: 1.0)!, withName : "files", fileName: "userSuggestionImage.jpg", mimeType: "image/jpeg")
            }
            if let image = self.payloadImage2 {
                multipartFormData.append(image.jpegData(compressionQuality: 1.0)!, withName : "files", fileName: "userSuggestionImage.jpg", mimeType: "image/jpeg")
            }
            if let image = self.payloadImage3 {
                multipartFormData.append(image.jpegData(compressionQuality: 1.0)!, withName : "files", fileName: "userSuggestionImage.jpg", mimeType: "image/jpeg")
            }
            
            multipartFormData.append(payloadEncoded.data(using: .utf8)!, withName: "contactInfo", mimeType: "application/json")
        }, to: URL(string : url)!, usingThreshold: UInt64.init(), method : .post, headers: header)
        .responseJSON { [weak self] response in
            print(response)
            self?.isSendingDone = true
        }
    }
}
