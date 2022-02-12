//
//  NotificationViewModel.swift
//  Bridge-iOS
//
//  Created by 이재준 on 2022/02/02.
//

import Foundation
import Combine
import Alamofire

final class NotificationViewModel : ObservableObject {
    @Published var notificationList : [Notification] = []
    
    private var subscription = Set<AnyCancellable>()
    let token : String
    let memberId : Int
    
    init(accessToken : String, memberId : Int) {
        self.token = accessToken
        self.memberId = memberId
        getNotifications(token : accessToken)
    }
    
    func getNotifications(token : String) {
        let url = baseURL + "/members/\(memberId)/alarms?lastAlarmId=0"
        let header: HTTPHeaders = [ "X-AUTH-TOKEN": token ]
        
        AF.request(url,
                   method: .get,
                   encoding: URLEncoding.default,
                   headers: header)
            .responseString{ (response) in
                guard let statusCode = response.response?.statusCode else { return }
                switch statusCode {
                case 200 :
                    print("getting notifications Success : \(statusCode)")
                default :
                    print("getting notifications Fail : \(statusCode)")
                }
            }
            .publishDecodable(type : NotificationList.self)
            .compactMap { $0.value }
            .map { $0.notifications }
            .sink { completion in
                switch completion {
                case let .failure(error) :
                    print(error.localizedDescription)
                case .finished :
                    print("finished getting notifications")
                }
            } receiveValue: { [weak self] (recievedValue : [Notification]) in
                self?.notificationList = recievedValue
                print("notifications = ")
                print(recievedValue)
                
            }.store(in: &subscription)
    }
}
