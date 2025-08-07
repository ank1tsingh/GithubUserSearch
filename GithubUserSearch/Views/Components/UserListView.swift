//
//  UserListView.swift
//  GithubUserSearch
//
//  Created by Ankit on 07/08/25.
//

import SwiftUI

struct UserListView: View {
    let users: [GitHubUser]
    let isLoading: Bool
    let onUserTapped: (GitHubUser) -> Void
    let onLoadMore: () -> Void
    
    var body: some View {
        List {
            ForEach(users) { user in
                UserRowView(user: user)
                    .onTapGesture {
                        onUserTapped(user)
                    }
                    .onAppear {
                        if user.id == users.last?.id {
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
        .listStyle(PlainListStyle())
    }
}


//#Preview {
//    UserListView()
//}
