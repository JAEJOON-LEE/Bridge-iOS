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
    @Published var entireAlarm : Bool = false
    @Published var chatAlarm : Bool = false
    @Published var boardAlarm : Bool = false
    @Published var sellingAlarm : Bool = false
    //
    @Published var blockList : [BlockInfo] = []
    @Published var showActionSheet : Bool = false
    @Published var actionSheetType : Int = 0
    @Published var signOutConfirm : Bool = false
    
    private var subscription = Set<AnyCancellable>()

    let userInfo : SignInResponse
    
    init(signInResponse : SignInResponse) {
        userInfo = signInResponse
        getBlockedUsers()
    }
    
    func getBlockedUsers() {
        let header: HTTPHeaders = [ "X-AUTH-TOKEN": userInfo.token.accessToken ]
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
        let header: HTTPHeaders = [ "X-AUTH-TOKEN": userInfo.token.accessToken ]
        let requestURL : String = "http://3.36.233.180:8080/members/\(userInfo.memberId)/blocks/\(blockId)"
        
        AF.request(requestURL,
                   method: .delete,
                   encoding: URLEncoding.default,
                   headers: header)
            .responseJSON { json in print(json)}
    }
    
    func signOut() {
        let header: HTTPHeaders = [ "X-AUTH-TOKEN": userInfo.token.accessToken ]
        let requestURL : String = "http://3.36.233.180:8080/sign-out"
        
        AF.request(requestURL,
                   method: .post,
                   encoding: URLEncoding.default,
                   headers: header)
            .responseJSON { json in print(json)}
    }
}
