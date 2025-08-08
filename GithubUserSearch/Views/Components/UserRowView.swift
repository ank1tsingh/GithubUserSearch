//
//  UserRowView.swift
//  GithubUserSearch
//
//  Created by Ankit on 07/08/25.
//

import SwiftUI

struct UserRowView: View {
    let user: GitHubUser
    
    var body: some View {
        HStack(spacing: 14) {
            AsyncImageView(imageURL: URL(string: user.profileImageURL ?? ""))
                .frame(width: 56, height: 56)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 6) {
                Text(user.username)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                if let realName = user.displayName, !realName.isEmpty {
                    Text(realName)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                } else {
                    Text("Tap to view profile")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .italic()
                }
                
                if let repoCount = user.repositoryCount, let followerCount = user.followerCount {
                    HStack(spacing: 16) {
                        Label("\(repoCount)", systemImage: "folder.fill")
                        Label("\(followerCount)", systemImage: "heart.fill")
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)
                    
                } else {
                    HStack(spacing: 16) {
                        Label("•••", systemImage: "folder.fill")
                        Label("•••", systemImage: "heart.fill")
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
                .font(.caption)
        }
        .padding(.vertical, 6)
    }
}

//
//#Preview {
//    UserRowView()
//}
