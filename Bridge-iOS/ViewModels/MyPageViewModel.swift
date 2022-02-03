//
//  MyPageViewModel.swift
//  Bridge-iOS
//
//  Created by Park Gyurim on 2022/01/06.
//

import SwiftUI
import Alamofire

final class MyPageViewModel : ObservableObject {
    @Published var username : String = ""
    @Published var usernameToEdit : String = ""
    @Published var description : String = ""
    @Published var descriptionToEdit : String = ""
    @Published var isEditing : Bool = false
    @Published var isEditDone : Bool = false
    @Published var showImagePicker : Bool = false
    @Published var selectedImage : UIImage? = nil
    
    let userInfo : MemeberInformation //SignInResponse
    
    init(memberInformation : MemeberInformation) {
        userInfo = memberInformation
        username = userInfo.username
        usernameToEdit = userInfo.username
        description = userInfo.description
        descriptionToEdit = userInfo.description
    }
    
    func updateProfile() {
        let url = "http://3.36.233.180:8080/members/\(userInfo.memberId)"
        let header : HTTPHeaders = [
            "Content-Type": "multipart/form-data",
            "X-AUTH-TOKEN": SignInViewModel.accessToken
        ]
        let payload = """
            {
                "username" : \"\(usernameToEdit)\",
                "description" : \"\(descriptionToEdit)\"
            }
        """.data(using: .nonLossyASCII)!
        //"removeProfile" : \"false\",
        
        let payloadEncoded = String(data : payload, encoding : .utf8) ?? ""
        
        AF.upload(multipartFormData: { [weak self] (multipartFormData) in
            // image
            if let image = self?.selectedImage { // optional binding : 이미지가 있을때만 실행
                multipartFormData.append(
                    image.jpegData(compressionQuality: 1.0)!,
                    withName : "profileImage",
                    fileName: "profileImage.jpg",
                    mimeType: "image/jpeg"
                )
            }
            
            // payload
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
