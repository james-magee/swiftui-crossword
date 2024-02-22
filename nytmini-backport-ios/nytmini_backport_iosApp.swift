//
//  nytmini_backport_iosApp.swift
//  nytmini-backport-ios
//
//  Created by James Magee on 2/3/24.
//

import SwiftUI
import SwiftData

@main
struct nytmini_backport_iosApp: App {
//    var sharedModelContainer: ModelContainer = {
//        let schema = Schema([
//            Item.self,
//        ])
//        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

//        do {
//            return try ModelContainer(for: schema, configurations: [modelConfiguration])
//        } catch {
//            fatalError("Could not create ModelContainer: \(error)")
//        }
//    }()

    var body: some Scene {
        WindowGroup {
          ContentView(board: buildTestBoard())
        }
//        .modelContainer(sharedModelContainer)
    }
}
