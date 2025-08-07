//
//  UserDetailViewModel.swift
//  GithubUserSearch
//
//  Created by Ankit on 07/08/25.
//

import Foundation

@MainActor
final class UserDetailViewModel: ObservableObject {
    @Published var userRepositories: [GitHubRepository] = []
    @Published var isLoadingRepositories = false
    @Published var lastErrorMessage: String?
    @Published var hasMoreRepositories = true
    
    let userProfile: GitHubUser
    
    private let networkService: GitHubNetworkServiceProtocol
    private let persistenceService: DataPersistenceServiceProtocol
    private var currentPageNumber = 1
    private let itemsPerPage = AppConstants.defaultPerPage
    
    init(user: GitHubUser,
         networkService: GitHubNetworkServiceProtocol,
         persistenceService: DataPersistenceServiceProtocol) {
        self.userProfile = user
        self.networkService = networkService
        self.persistenceService = persistenceService
        
        Task {
            await loadUserRepositories()
        }
    }
    
    func loadUserRepositories() async {
        isLoadingRepositories = true
        lastErrorMessage = nil
        currentPageNumber = 1
        
        let cachedRepositories = await persistenceService.getCachedRepositories(for: userProfile.username)
        if !cachedRepositories.isEmpty {
            userRepositories = cachedRepositories
            isLoadingRepositories = false
            return
        }
        
        do {
            let repositories = try await networkService.fetchUserRepositories(
                username: userProfile.username,
                page: currentPageNumber,
                perPage: itemsPerPage
            )
            userRepositories = repositories
            hasMoreRepositories = repositories.count == itemsPerPage
            
            // Cache the repositories for offline access
            await persistenceService.saveRepositories(repositories, for: userProfile.username)
        } catch {
            lastErrorMessage = (error as? GitHubAPIError)?.errorDescription ?? error.localizedDescription
        }
        
        isLoadingRepositories = false
    }
    
    func loadMoreRepositories() async {
        guard !isLoadingRepositories, hasMoreRepositories else { return }
        
        currentPageNumber += 1
        
        do {
            let moreRepositories = try await networkService.fetchUserRepositories(
                username: userProfile.username,
                page: currentPageNumber,
                perPage: itemsPerPage
            )
            userRepositories.append(contentsOf: moreRepositories)
            hasMoreRepositories = moreRepositories.count == itemsPerPage
        } catch {
            currentPageNumber -= 1 // Rollback on failure
            lastErrorMessage = (error as? GitHubAPIError)?.errorDescription ?? error.localizedDescription
        }
    }
    
    func refreshRepositories() async {
        await loadUserRepositories()
    }
}
