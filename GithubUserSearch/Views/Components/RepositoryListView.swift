//
//  RepositoryListView.swift
//  GithubUserSearch
//
//  Created by Ankit on 07/08/25.
//

import SwiftUI

struct RepositoryListView: View {
    let repositories: [GitHubRepository]
    let isLoading: Bool
    let onLoadMore: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Repositories")
                .font(.title2)
                .fontWeight(.bold)
            
            if repositories.isEmpty && !isLoading {
                EmptyRepositoryView()
                    .frame(height: 180)
            } else {
                LazyVStack(spacing: 14) {
                    ForEach(repositories) { repo in
                        RepositoryRowView(repository: repo)
                            .onAppear {
                                if repo.id == repositories.last?.id {
                                    onLoadMore()
                                }
                            }
                    }
                    
                    if isLoading {
                        HStack {
                            Spacer()
                            ProgressView()
                                .padding()
                            Spacer()
                        }
                    }
                }
            }
        }
    }
}

//#Preview {
//    RepositoryListView()
//}
