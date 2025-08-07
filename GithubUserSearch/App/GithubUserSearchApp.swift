//
//  GithubUserSearchApp.swift
//  GithubUserSearch
//
//  Created by Ankit on 06/08/25.
//

import SwiftUI

@main
struct GithubUserSearchApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
