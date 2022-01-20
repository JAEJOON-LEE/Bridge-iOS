//
//  SignInViewModel.swift
//  Bridge-iOS
//
//  Created by Park Gyurim on 2021/09/28.
//

import Foundation
import Combine
import Alamofire

final class SignInViewModel : ObservableObject {
    static var accessToken : String = ""
    
    @Published var email = ""
    @Published var password = ""
    @Published var checked = false
    @Published var showPassword = false
    @Published var signInResponse : SignInResponse?
    @Published var signInDone : Bool = false
    @Published var showSignInFailAlert : Bool = false
    @Published var showPrgoressView : Bool = false
    
    private let signInUrl : String = "http://3.36.233.180:8080/sign-in"
    private let refreshUrl : String = "http://3.36.233.180:8080/token"
    
    private var subscription = Set<AnyCancellable>()
    
    func SignIn(email : String, password : String) {
        AF.request(signInUrl,
                   method: .post,
                   parameters: ["email" : email, "password" : password],
                   encoder: JSONParameterEncoder.prettyPrinted
        )
            .responseJSON { [weak self] (response) in
                guard let statusCode = response.response?.statusCode else { return }
                switch statusCode {
                case 200 :
                    print("SignIn Success : \(statusCode)")
                    self?.signInDone = true
                default :
                    print("SignIn Fail : \(statusCode)")
                    self?.showSignInFailAlert = true
                }
            }
            .publishDecodable(type: SignInResponse.self)
            .compactMap{ $0.value }
            //.map { $0 }
            .sink { [weak self] completion in
                switch completion {
                case let .failure(error) :
                    print(error.localizedDescription)
                case .finished :
                    print("Sign in Finished")
                    self?.showPrgoressView = false
                }
            } receiveValue: { [weak self] (receivedValue : SignInResponse) in
                print(receivedValue)
                self?.signInResponse = .init(
                    memberId: receivedValue.memberId,
                    name: receivedValue.name,
                    username: receivedValue.username,
                    token: receivedValue.token,
                    profileImage: receivedValue.profileImage,
                    description: receivedValue.description,
                    createdAt: receivedValue.createdAt
                )
                SignInViewModel.accessToken = receivedValue.token.accessToken
                //print(self?.signInResponse as Any)
            }.store(in: &subscription)
        
        DispatchQueue.main.asyncAfter(
            deadline: .now() + DispatchTimeInterval.seconds((self.signInResponse?.token.accessTokenExpiresIn ?? 1800) - 5)
        ) {
            print("Token refreshing request will call after token expired time.")
            self.refreshToken()
        }
    }
    
    func refreshToken() {
        AF.request(refreshUrl,
                   method: .post,
                   parameters: ["refreshToken" : signInResponse?.token.refreshToken,
                                "accessToken" : signInResponse?.token.accessToken],
                   encoder: JSONParameterEncoder.prettyPrinted
        )
            .responseJSON { [weak self] response in
                guard let self = self else { return }
                guard let statusCode = response.response?.statusCode else { return }
                switch statusCode {
                case 403 :
                    print("Refresh Fail : \(statusCode)")
                    self.SignIn(email : self.email, password : self.password)
                default :
                    print("Refresh status : \(statusCode)")
                }
            }
            .publishDecodable(type: Token.self)
            .compactMap{ $0.value }
            //.map { $0 }
            .sink { completion in
                switch completion {
                case let .failure(error) :
                    print(error.localizedDescription)
                case .finished :
                    print("Success refeshing token")
                }
            } receiveValue: { [weak self] (receivedValue : Token) in
                //print(receivedValue)
                self?.signInResponse?.token = receivedValue
                SignInViewModel.accessToken = receivedValue.accessToken
            }
            .store(in: &subscription)
        
        DispatchQueue.main.asyncAfter(
            deadline: .now() + DispatchTimeInterval.seconds((self.signInResponse?.token.accessTokenExpiresIn ?? 1800) - 5)
        ) {
            print("Token refreshing request will call after token expired time.")
            self.refreshToken()
        }
    }
}
