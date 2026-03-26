//
//  SearchingWithCombineApp.swift
//  SearchingWithCombine
//
//  Created by YoonieMac on 3/24/26.
//

import SwiftUI
import SwiftData

@main
struct SearchingWithCombineApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
                .modelContainer(for: Track.self)
        }
    }
}
