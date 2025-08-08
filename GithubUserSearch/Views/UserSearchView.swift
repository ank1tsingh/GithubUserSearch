//
//  UserSearchView.swift
//  GithubUserSearch
//
//  Created by Ankit on 07/08/25.
//
import SwiftUI


struct UserSearchView: View {
    @EnvironmentObject private var searchViewModel: UserSearchViewModel
    @State private var showingUserDetails = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                SearchBar(searchText: $searchViewModel.currentSearchQuery)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                
                if searchViewModel.isCurrentlySearching && searchViewModel.discoveredUsers.isEmpty {
                    LoadingView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if searchViewModel.discoveredUsers.isEmpty && !searchViewModel.currentSearchQuery.isEmpty {
                    EmptyStateView(
                        title: "No GitHub users found",
                        subtitle: "Try a different username or check your spelling"
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    UserListView(
                        users: searchViewModel.discoveredUsers,
                        isLoading: searchViewModel.isCurrentlySearching,
                        onUserTapped: { user in
                            Task {
                                await searchViewModel.userWasSelected(user)
                                showingUserDetails = true
                            }
                        },
                        onLoadMore: {
                            Task {
                                await searchViewModel.loadMoreUsers()
                            }
                        }
                    )
                }
            }
            .navigationTitle("GitHub Explorer")
            .alert("Oops!", isPresented: .constant(searchViewModel.lastErrorMessage != nil)) {
                Button("Got it") {
                    searchViewModel.dismissError()
                }
            } message: {
                Text(searchViewModel.lastErrorMessage ?? "")
            }
            .sheet(isPresented: $showingUserDetails) {
                if let selectedUser = searchViewModel.selectedUserProfile {
                    if searchViewModel.isLoadingUserDetails {
                        VStack {
                            ProgressView()
                            Text("Loading user details...")
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        UserDetailView(userProfile: selectedUser)
                            .environmentObject(AppDependencyContainer().makeUserDetailViewModel(user: selectedUser))
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
