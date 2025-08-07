//
//  DependencyContainer.swift
//  GithubUserSearch
//
//  Created by Ankit on 07/08/25.
//

import Foundation

final class AppDependencyContainer {
    
    lazy var networkService: GitHubNetworkServiceProtocol = GitHubNetworkService()
    lazy var coreDataService: CoreDataService = CoreDataService()
    lazy var imageCacheService: ImageCacheServiceProtocol = ImageCacheService()
    
    @MainActor func makeUserSearchViewModel() -> UserSearchViewModel {
        UserSearchViewModel(
            networkService: networkService,
            persistenceService: coreDataService
        )
    }
    
    @MainActor func makeUserDetailViewModel(user: GitHubUser) -> UserDetailViewModel {
        UserDetailViewModel(
            user: user,
            networkService: networkService,
            persistenceService: coreDataService
        )
    }
}
