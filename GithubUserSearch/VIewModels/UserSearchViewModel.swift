//
//  UserSearchViewModel.swift
//  GithubUserSearch
//
//  Created by Ankit on 07/08/25.
//

import SwiftUI
import Combine

@MainActor
final class UserSearchViewModel: ObservableObject {
    @Published var discoveredUsers: [GitHubUser] = []
    @Published var isCurrentlySearching = false
    @Published var lastErrorMessage: String?
    @Published var selectedUserProfile: GitHubUser?
    @Published var currentSearchQuery = ""
    
    
    private let networkService: GitHubNetworkServiceProtocol
    private let persistenceService: DataPersistenceServiceProtocol
    private var searchSubscription = Set<AnyCancellable>()
    private var currentPageNumber = 1
    private let itemsPerPage = AppConstants.defaultPerPage
    private var canLoadMoreUsers = true
    
    init(networkService: GitHubNetworkServiceProtocol,
         persistenceService: DataPersistenceServiceProtocol) {
        self.networkService = networkService
        self.persistenceService = persistenceService
        setupSearchBehavior()
    }
    
    private func setupSearchBehavior() {
        $currentSearchQuery
            .debounce(for: .milliseconds(AppConstants.searchDebounceTime), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] searchText in
                if !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    Task {
                        await self?.searchForUsers(query: searchText)
                    }
                } else {
                    self?.discoveredUsers = []
                }
            }
            .store(in: &searchSubscription)
    }
    
    func searchForUsers(query: String) async {
        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            discoveredUsers = []
            return
        }
        
        isCurrentlySearching = true
        lastErrorMessage = nil
        currentPageNumber = 1
        
        let cachedUsers = await persistenceService.searchCachedUsers(query: query)
        if !cachedUsers.isEmpty {
            discoveredUsers = cachedUsers
            isCurrentlySearching = false
            return
        }
        
        do {
            let searchResponse = try await networkService.searchUsers(
                query: query,
                page: currentPageNumber,
                perPage: itemsPerPage
            )
            discoveredUsers = searchResponse.foundUsers
            canLoadMoreUsers = searchResponse.foundUsers.count == itemsPerPage
            
            for user in searchResponse.foundUsers {
                await persistenceService.saveUser(user)
            }
        } catch {
            lastErrorMessage = (error as? GitHubAPIError)?.errorDescription ?? error.localizedDescription
            discoveredUsers = []
        }
        
        isCurrentlySearching = false
    }
    
    func loadMoreUsers() async {
        guard !isCurrentlySearching, canLoadMoreUsers, !currentSearchQuery.isEmpty else { return }
        
        currentPageNumber += 1
        
        do {
            let searchResponse = try await networkService.searchUsers(
                query: currentSearchQuery,
                page: currentPageNumber,
                perPage: itemsPerPage
            )
            discoveredUsers.append(contentsOf: searchResponse.foundUsers)
            canLoadMoreUsers = searchResponse.foundUsers.count == itemsPerPage
            
            // new user -> cache
            for user in searchResponse.foundUsers {
                await persistenceService.saveUser(user)
            }
        } catch {
            currentPageNumber -= 1
            lastErrorMessage = (error as? GitHubAPIError)?.errorDescription ?? error.localizedDescription
        }
    }
    
    func userWasSelected(_ user: GitHubUser) {
        selectedUserProfile = user
    }
    
    func dismissError() {
        lastErrorMessage = nil
    }
}
