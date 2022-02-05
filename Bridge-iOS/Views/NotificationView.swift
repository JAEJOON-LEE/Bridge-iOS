//
//  NotificationView.swift
//  Bridge-iOS
//
//  Created by Park Gyurim on 2021/09/16.
//

import SwiftUI

struct NotificationView : View {
    @StateObject private var viewModel : NotificationViewModel
    
    init(viewModel : NotificationViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body : some View {
        
        VStack{
            Text("Notification Test")
            if(viewModel.notificationList.count == 0){
                Text("0")
            }else{
                ForEach(viewModel.notificationList, id : \.self) { Notification in
                    Text("A")
                }
            }
        }
        .onAppear{
            viewModel.getNotifications(token: viewModel.token)
            UIApplication.shared.applicationIconBadgeNumber = 0 // badge 초기화
        }

    }
}
