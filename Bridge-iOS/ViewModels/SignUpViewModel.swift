//
//  SignUpViewModel.swift
//  Bridge-iOS
//
//  Created by 이재준 on 2021/10/06.
//

import Foundation
import Combine
import Alamofire
import SwiftUI

final class SignUpViewModel : ObservableObject {
    var param: Dictionary<String, Any> = Dictionary<String, Any>()
    
    @Published var name = ""
    @Published var email = ""
    @Published var password = ""
    @Published var password2 = ""
    @Published var role = "user"
    @Published var nickname = "" //username
    @Published var description = ""
    @Published var profileImage : UIImage? = nil
    @Published var verifyCode = ""
    @Published var showPassword = false
    @Published var signUpInfo : SignUpInfo?
    
    private var subscription = Set<AnyCancellable>()
    
    // need validating method in view model
    func isValid() -> Bool {
        return password.count > 2
    }
    
    //statusCode 맞춰서 핸들링 필요 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    /* ------------------------------------------------------------------------------------------------*/
    func SendEmail(email : String){ //회원가입 이메일 전송 (API number 43)
        AF.request("http://3.36.233.180:8080/email-auth/sign-up",
                   method: .post,
                   parameters: ["email" : email],
                   encoder: JSONParameterEncoder.prettyPrinted
        )
        .responseString{ (response) in
        
            guard let statusCode = response.response?.statusCode else { return }
        
            print("email check = " + String(statusCode))
            print(self.email)
        }
    }
    /* ------------------------------------------------------------------------------------------------*/
    
    /* ------------------------------------------------------------------------------------------------*/
    func VerifyEmail(email : String, verifyCode : String){ //회원가입 이메일 인증 코드 확인 (API number 44)
        AF.request("http://3.36.233.180:8080/email-auth/sign-up/confirm",
                   method: .post,
                   parameters: ["email" : email, "key" : verifyCode],
                   encoder: JSONParameterEncoder.prettyPrinted
        )
        .responseString{ (response) in
        
            guard let statusCode = response.response?.statusCode else { return }
        
            print("email verify = " + String(statusCode))
            print(self.email)
            print(self.verifyCode)
        }
    }
    /* ------------------------------------------------------------------------------------------------*/
    
    /* ------------------------------------------------------------------------------------------------*/
    func SignUp(name : String, email : String, password : String, role : String, nickname : String, description : String, profileImage : UIImage?, verifyCode : String) {
        
        let header: HTTPHeaders = [
            "Accept": "multipart/form-data",
            "Content-Type": "multipart/form-data"
        ]
        
        param = ["name" : name,
                 "email" : email,
                 "password" : password,
                 "role" : role,
                 "description" : description,
                 "username" : nickname]
        
        AF.upload(multipartFormData: { multipartFormData in
            
                        multipartFormData.append("{ \"name\" : \"\(name)\", \"email\" : \"\(email)\", \"password\" : \"\(password)\", \"role\" : \"\(role)\", \"description\" : \"\(description)\", \"username\" : \"\(nickname)\"}".data(using: .utf8)!, withName: "memberInfo", mimeType: "application/json")
                        
                        if(profileImage != nil){
                            multipartFormData.append(profileImage!.jpegData(compressionQuality: 1)!, withName: "profileImage", fileName: "From_iOS", mimeType: "image/jpg")
                        }
                        
                    }, to:"http://3.36.233.180:8080/sign-up",
                    method: .post,
                    headers: header)
            .responseString{ (response) in
            
            guard let statusCode = response.response?.statusCode else { return }
            
            print("sign up status = " + String(statusCode))
        }
    }
    /* ------------------------------------------------------------------------------------------------*/
}
