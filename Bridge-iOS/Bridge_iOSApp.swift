//
//  Bridge_iOSApp.swift
//  Bridge-iOS
//
//  Created by Park Gyurim on 2021/09/16.
//

import SwiftUI
import URLImageStore
import URLImage

@main
struct Bridge_iOSApp: App {
    let urlImageService = URLImageService(fileStore: nil, inMemoryStore: URLImageInMemoryStore())

    var body: some Scene {
        WindowGroup {
            BaseView()
                .environment(\.urlImageService, urlImageService)
                .preferredColorScheme(.light)
        }
    }
}
