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
//    @Published var role = "user"
    @Published var nickname = "" //username
    @Published var description = ""
    @Published var profileImage : UIImage? = nil
    @Published var verifyCode = ""
    @Published var showPassword = false
    @Published var showPassword2 = false
    @Published var signUpInfo : SignUpInfo?
    @Published var showSignUpFailAlert : Bool = false
    @Published var signUpDone : Bool = false
    @Published var message = ""
    @Published var check = 0
    @Published var statusCode1 = 0
    @Published var statusCode2 = 0
    @Published var statusCode3 = 0
    
    private var subscription = Set<AnyCancellable>()
    
    // need validating method in view model
//    func isValid() -> Bool {
//        message = "password should be longer"
//        return password.count > 2
//    }
    /* ------------------------------------------------------------------------------------------------*/
    
    /* ------------------------------------------------------------------------------------------------*/
//    func checkDuplicatedEmail() -> Bool {
//        var check : Int = 0
//        let url = "http://3.36.233.180:8080/members/emails/\(email)"
//
//        AF.request(url,
//                   method: .get,
//                   encoding: URLEncoding.default)
//            .responseString{ (response) in
//
//            guard let statusCode = response.response?.statusCode else { return }
//
//            print("email check = " + String(statusCode))
//
//            if(statusCode == 409){
//                check = 1
//            }
//        }
//        if(check == 1){
//            return true
//        }
//        else{
//            return false
//        }
//    }
    /* ------------------------------------------------------------------------------------------------*/
    
    /* ------------------------------------------------------------------------------------------------*/
//    func checkDuplicatedUserName() -> Bool {
//        var check : Int = 0
//        let url = "http://3.36.233.180:8080/members/usernames/\(name)"
//
//        AF.request(url,
//                   method: .get,
//                   encoding: URLEncoding.default)
//            .responseString{ (response) in
//
//            guard let statusCode = response.response?.statusCode else { return }
//
//            print("email check = " + String(statusCode))
//
//            if(statusCode == 409){
//                check = 1
//            }
//        }
//        if(check == 1){
//            return true
//        }
//        else{
////            self.showSignUpFailAlert = true
////            message = "the username is already enlisted"
////            print("duplicated user name")
////
////            checkDuplicatedEmail()
//            return false
//        }
//    }
    /* ------------------------------------------------------------------------------------------------*/
    
    /* ------------------------------------------------------------------------------------------------*/
    func SendEmail(email : String){ //회원가입 이메일 전송 (API number 43)
        
//        self.signUpDone = false
//        self.showSignUpFailAlert = false
        
        
//        if(checkDuplicatedUserName() == true){
//            self.showSignUpFailAlert = true
//            message = "the username is already enlisted"
//            print("duplicated user name")
//            return
//        }
//        else
//        if(self.checkDuplicatedEmail() == true){
//            self.showSignUpFailAlert = true
//            message = "the email is already enlisted"
//            print("duplicated user name")
//            return
//        }
        
        
        if(self.name.count == 0 || self.email.count == 0 || !self.email.contains("@") || !self.email.contains(".")){
//            self.check = 1
            self.showSignUpFailAlert = true
            message = "please check your inputs"
            print("please check your inputs")
            return
            
        }else if(self.password != self.password2 || self.password.count < 8 || self.password.count > 15 || self.password.isLowercased ){
//            self.check = 1
            self.showSignUpFailAlert = true
            message = "please check the passwords"
            print("please check the passwords")
            return
        }
        else{
//            self.showSignUpFailAlert = false
//            self.check = 0
            self.signUpDone = true
        }
        
        //유저네임 중복 확인
        AF.request("http://3.36.233.180:8080/members/usernames/\(name)",
                   method: .get,
                   encoding: URLEncoding.default)
            .responseString{ (response) in
                
                self.statusCode1 = response.response?.statusCode ?? 200
                
                print("username check = " + String(self.statusCode1))
                
            if(self.statusCode1 == 409){
                self.showSignUpFailAlert = true
                self.message = "the username is already enlisted"
                print("duplicated user name")
//                self.check = 1
                return
            }else{
                self.showSignUpFailAlert = false
//                self.check = 0
            }
        }
//        if(self.check == 1){
////            self.showSignUpFailAlert = true
//            self.check = 0
//            return
//        }
        
        //이메일 중복 확인
        AF.request("http://3.36.233.180:8080/members/emails/\(email)",
                   method: .get,
                   encoding: URLEncoding.default)
            .responseString{ (response) in
                
            self.statusCode2 = response.response?.statusCode ?? 200
        
            print("email check = " + String(self.statusCode2))
            
            if(self.statusCode2 == 409){
                self.showSignUpFailAlert = true
                self.message = "the email is already enlisted"
                print("duplicated email")
//                self.check = 1
                return
            }else{
                self.showSignUpFailAlert = false
//                self.check = 0
            }
        }
//        if(self.check == 1){
////            self.showSignUpFailAlert = true
//            self.check = 0
//            return
//        }
        
        
        AF.request("http://3.36.233.180:8080/email-auth/sign-up",
                   method: .post,
                   parameters: ["email" : email],
                   encoder: JSONParameterEncoder.prettyPrinted
        )
        .responseString{ (response) in
        
            guard let statusCode = response.response?.statusCode else { return }
        
            print("sign up check = " + String(statusCode))
//            print(self.email)
        }
    }
    /* ------------------------------------------------------------------------------------------------*/
    
    /* ------------------------------------------------------------------------------------------------*/
    func VerifyEmail(email : String, verifyCode : String){ //회원가입 이메일 인증 코드 확인 (API number 44)
        
//        self.signUpDone = false
//        self.showSignUpFailAlert = false
        
        AF.request("http://3.36.233.180:8080/email-auth/sign-up/confirm",
                   method: .post,
                   parameters: ["email" : email, "key" : verifyCode],
                   encoder: JSONParameterEncoder.prettyPrinted
        )
        .responseString{ (response) in
        
            self.statusCode3 = response.response?.statusCode ?? 200
        
//            print(self.email)
//            print(self.verifyCode)
//
//            if(self.nickname.count == 0){
//                self.showSignUpFailAlert = true
//            }
            switch self.statusCode3 {
                case 200, 201 :
                    print("email verify =  \(self.statusCode3)")
//                    self.showSignUpFailAlert = false
//                    self.signUpDone = true
                default :
                    print("email verify =  \(self.statusCode3)")
                    self.showSignUpFailAlert = true
            }
        }
    }
    /* ------------------------------------------------------------------------------------------------*/
    
    /* ------------------------------------------------------------------------------------------------*/
    func SignUp(name : String, email : String, password : String, role : String, nickname : String, description : String, profileImage : UIImage?, verifyCode : String) {
        
//        self.signUpDone = false
//        self.showSignUpFailAlert = false
//
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
                
                
                switch statusCode {
                    case 200, 201 :
                        print("sign up status =  \(statusCode)")
//                        self.showSignUpFailAlert = false
//                        self.signUpDone = true
                    default :
                        print("sign up status =  \(statusCode)")
//                        self.showSignUpFailAlert = false
                }
        }
    }
    /* ------------------------------------------------------------------------------------------------*/
    
    /* ------------------------------------------------------------------------------------------------*/
}

extension String {
    var isLowercased: Bool {
        for c in utf8 where (65...90) ~= c { return false }
        return true
    }
    var isUppercased: Bool {
        for c in utf8 where (97...122) ~= c { return false }
        return true
    }
}
