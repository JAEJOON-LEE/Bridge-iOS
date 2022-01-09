//
//  NotificationView.swift
//  Bridge-iOS
//
//  Created by Park Gyurim on 2021/09/16.
//

import SwiftUI

struct NotificationView : View {
    var body : some View {
        VStack {
            Text("Notification View")
                .font(.largeTitle)
        }
        .onAppear{
            UIApplication.shared.applicationIconBadgeNumber = 0 // badge 초기화
        }

    }
}
