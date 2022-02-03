//
//  SettingsViewModel.swift
//  Bridge-iOS
//
//  Created by Park Gyurim on 2022/01/06.
//

import Foundation
import Alamofire
import Combine

final class SettingsViewModel : ObservableObject {
    // May have to change this var to AppStorage var.
    //@Published var entireAlarm : Bool = false
    @Published var chatAlarm : Bool = false
    @Published var boardAlarm : Bool = false
    @Published var sellingAlarm : Bool = false
    
    @Published var blockList : [BlockInfo] = []
    
    @Published var isDeleteMemeberClicked : Bool = false
    @Published var deleteMemeberConfirmation : Bool = false
    
    @Published var password : String = ""
    @Published var passwordConfirmation : String = ""
    @Published var showPassword : Bool = false
    @Published var showPasswordConfirmation : Bool = false
    @Published var passwordChangeDone : Bool = false
    
    var passwordCorrespondence : Bool { password == passwordConfirmation }
    var isPasswordEmpty : Bool { password.isEmpty || passwordConfirmation.isEmpty }

    func disableButton() -> Bool {
        if !passwordCorrespondence || isPasswordEmpty { return true }
        else { return false }
    }
    
    private var subscription = Set<AnyCancellable>()
    
    var entireAlarm : Bool {
        get {
            return (chatAlarm && boardAlarm) && (chatAlarm && sellingAlarm) && (boardAlarm && sellingAlarm)
        }
        set(value) {
            chatAlarm = value
            boardAlarm = value
            sellingAlarm = value
        }
    }
    
    let userInfo : MemeberInformation
    
    init(memberInformation : MemeberInformation) {
        userInfo = memberInformation
        chatAlarm = userInfo.chatAlarm
        boardAlarm = userInfo.playgroundAlarm
        sellingAlarm = userInfo.usedAlarm
        getBlockedUsers()
    }
    
    func getBlockedUsers() {
        let header: HTTPHeaders = [ "X-AUTH-TOKEN": SignInViewModel.accessToken ]
        let requestURL : String = "http://3.36.233.180:8080/members/\(userInfo.memberId)/blocks"
        
        AF.request(requestURL,
                   method: .get,
                   encoding: URLEncoding.default,
                   headers: header)
            .publishDecodable(type : BlockList.self)
            .compactMap { $0.value }
            .map { $0.blockList }
            .sink { completion in
                switch completion {
                case let .failure(error) :
                    print(error.localizedDescription)
                case .finished :
                    print("Get Blocked User Finished")
                }
            } receiveValue: { [weak self] (recievedValue : [BlockInfo]) in
                //print(recievedValue)
                self?.blockList = recievedValue
            }.store(in: &subscription)
    }
    
    func UnblockUser(blockId : Int) {
        let header: HTTPHeaders = [ "X-AUTH-TOKEN": SignInViewModel.accessToken ]
        let requestURL : String = "http://3.36.233.180:8080/members/\(userInfo.memberId)/blocks/\(blockId)"
        
        AF.request(requestURL,
                   method: .patch,
                   encoding: URLEncoding.default,
                   headers: header)
            .responseJSON { json in print(json)}
    }
    
    func changePassword() {
        let url = "http://3.36.233.180:8080/password"
        let header: HTTPHeaders = [ "X-AUTH-TOKEN" : SignInViewModel.accessToken ]
        
        AF.request(url,
                   method: .patch,
                   parameters: ["password" : password],
                   encoder: JSONParameterEncoder.prettyPrinted,
                   headers: header
        ).responseJSON { [weak self] json in
            guard let statusCode = json.response?.statusCode else { return }
            switch statusCode {
                case 200 :
                    print("Password change done")
                    self?.passwordChangeDone = true
                default :
                    print("Password change fail")
            }
            
        }
    }
    
    func deleteAccount() {
        let url = "http://3.36.233.180:8080/members/\(userInfo.memberId)"
        let header: HTTPHeaders = [ "X-AUTH-TOKEN" : SignInViewModel.accessToken ]
        
        AF.request(url,
                   method: .delete,
                   encoding: URLEncoding.default,
                   headers: header
        ).responseJSON { json in print(json) }
    }
}
