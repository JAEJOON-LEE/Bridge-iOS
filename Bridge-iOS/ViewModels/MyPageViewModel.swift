//
//  MyPageViewModel.swift
//  Bridge-iOS
//
//  Created by Park Gyurim on 2022/01/06.
//

import SwiftUI
//import PhotosUI
import Alamofire

final class MyPageViewModel : ObservableObject {
    @Published var username : String = ""
    @Published var usernameToEdit : String = ""
    @Published var description : String = ""
    @Published var descriptionToEdit : String = ""
    @Published var password : String = ""
    @Published var passwordConfirmation : String = ""
    @Published var isEditing : Bool = false
    @Published var isEditDone : Bool = false
    
    @Published var showImagePicker : Bool = false
    @Published var selectedImage : UIImage?
    
    var passwordCorrespondence : Bool { password == passwordConfirmation }
                                        // 두개 일치하면 트루
    var isPasswordEmpty : Bool { password.isEmpty || passwordConfirmation.isEmpty }
                                        // 둘 중 하나 비어있으면 트루
    let userInfo : SignInResponse
    
    init(signInResponse : SignInResponse) {
        userInfo = signInResponse
        username = userInfo.username
        usernameToEdit = userInfo.username
        description = userInfo.description
        descriptionToEdit = userInfo.description
    }
    
    func disableButton() -> Bool {
        if !passwordCorrespondence || isPasswordEmpty {
            return true
        } else {
            return false
        }
    }
    
    func updateProfile() {
        let url = "http://3.36.233.180:8080/members/\(userInfo.memberId)"
        let header : HTTPHeaders = [
            "Content-Type": "multipart/form-data",
            "X-AUTH-TOKEN": userInfo.token.accessToken
        ]
        let payload = """
            {
                "username" : \"\(usernameToEdit)\",
                "password" : \"\(password)\",
                "description" : \"\(descriptionToEdit)\",
                "removeProfile" : \"False\",
            }
        """.data(using: .nonLossyASCII)!
        let payloadEncoded = String(data : payload, encoding : .utf8) ?? ""
        
        AF.upload(multipartFormData: { [weak self] (multipartFormData) in
            guard let self = self else { return }

            // images
            //for image in self.selectedImages {
            //    multipartFormData.append(image.jpegData(compressionQuality: 1.0)!,
            //                withName : "files", fileName: "payloadImage.jpg", mimeType: "image/jpeg")
            //}
            
            multipartFormData.append(payloadEncoded.data(using: .utf8)!, withName: "memberInfo", mimeType: "application/json")
        }, to: URL(string : url)!, usingThreshold: UInt64.init(), method : .post, headers: header)
            .responseJSON { response in
                guard let statusCode = response.response?.statusCode else { return }
                switch statusCode {
                case 200 :
                    print("Update Profile Success : \(statusCode)")
                default :
                    print("Update Profile Fail : \(statusCode)")
                }
            }
    }
    
}
