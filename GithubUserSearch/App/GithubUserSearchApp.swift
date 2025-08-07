//
//  GithubUserSearchApp.swift
//  GithubUserSearch
//
//  Created by Ankit on 06/08/25.
//

import SwiftUI

@main
struct GithubUserSearchApp: App {
    let dependencyContainer = AppDependencyContainer()
    
    var body: some Scene {
        WindowGroup {
           UserSearchView()
                .environmentObject(dependencyContainer.makeUserSearchViewModel())
                .environment(\.managedObjectContext, dependencyContainer.coreDataService.viewContext)
        }
    }
}
