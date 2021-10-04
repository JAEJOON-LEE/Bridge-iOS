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
    @Published var email = ""
    @Published var password = ""
    @Published var checked = false
    @Published var showPassword = false
    @Published var signInResponse : SignInResponse?
    
    private let signInUrl : String = "http://3.36.233.180:8080/sign-in"
    
    private var subscription = Set<AnyCancellable>()
    
    // need validating method in view model
    func isValid() -> Bool {
        return password.count > 2
    }
    
    func SignIn(email : String, password : String) {
        AF.request(signInUrl,
                   method: .post,
                   parameters: ["email" : email, "password" : password],
                   encoder: JSONParameterEncoder.prettyPrinted
        )
            .publishDecodable(type: SignInResponse.self)
            .compactMap{ $0.value }
            //.map { $0 }
            .sink { completion in
                switch completion {
                case let .failure(error) :
                    print(error.localizedDescription)
                case .finished :
                    print("finished sign in")
                }
            } receiveValue: { [weak self] (receivedValue : SignInResponse) in
                //print(receivedValue)
                self?.signInResponse = .init(
                    memberId: receivedValue.memberId,
                    name: receivedValue.name,
                    username: receivedValue.username,
                    token: receivedValue.token,
                    profileImage: receivedValue.profileImage,
                    description: receivedValue.description,
                    createdAt: receivedValue.createdAt
                )
//                print(self?.signInResponse)
            }
            .store(in: &subscription)
    }
}
