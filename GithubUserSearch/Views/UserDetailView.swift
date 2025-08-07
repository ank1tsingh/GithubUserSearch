//
//  UserDetailView.swift
//  GithubUserSearch
//
//  Created by Ankit on 07/08/25.
//

import SwiftUI

struct UserDetailView: View {
    @EnvironmentObject private var detailViewModel: UserDetailViewModel
    @Environment(\.presentationMode) var presentationMode
    
    let userProfile: GitHubUser
    
    init(userProfile: GitHubUser) {
        self.userProfile = userProfile
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 20) {
                    UserProfileView(user: detailViewModel.userProfile)
                    
                    RepositoryListView(
                        repositories: detailViewModel.userRepositories,
                        isLoading: detailViewModel.isLoadingRepositories,
                        onLoadMore: {
                            Task {
                                await detailViewModel.loadMoreRepositories()
                            }
                        }
                    )
                }
                .padding(16)
            }
            .navigationTitle(detailViewModel.userProfile.username)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .refreshable {
                await detailViewModel.refreshRepositories()
            }
            .alert("Something went wrong", isPresented: .constant(detailViewModel.lastErrorMessage != nil)) {
                Button("OK") {
                    detailViewModel.lastErrorMessage = nil
                }
            } message: {
                Text(detailViewModel.lastErrorMessage ?? "")
            }
        }
    }
}

//#Preview {
//    UserDetailView()
//}
