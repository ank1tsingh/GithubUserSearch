//
//  UserProfileView.swift
//  GithubUserSearch
//
//  Created by Ankit on 07/08/25.
//

import SwiftUI

struct UserProfileView: View {
    let user: GitHubUser
    
    var body: some View {
        VStack(spacing: 18) {
            AsyncImageView(imageURL: URL(string: user.profileImageURL ?? ""))
                .frame(width: 110, height: 110)
                .clipShape(Circle())
            
            VStack(spacing: 10) {
                Text(user.username)
                    .font(.title2)
                    .fontWeight(.bold)
                
                if let displayName = user.displayName, !displayName.isEmpty {
                    Text(displayName)
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
                
                if let biography = user.userBio, !biography.isEmpty {
                    Text(biography)
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 8)
                }
            }
            
            
            VStack(spacing: 8) {
                HStack(spacing: 40) {
                    StatView(title: "Repos", value: user.repositoryCount ?? 0)
                    StatView(title: "Followers", value: user.followerCount ?? 0)
                    StatView(title: "Following", value: user.followingCount ?? 0)
                }
                
                Text("Member since \(formatDate(user.accountCreated ?? ""))")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(20)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(16)
    }
    
    private func formatDate(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        
        if let date = formatter.date(from: dateString) {
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            return formatter.string(from: date)
        }
        return dateString
    }
}

//#Preview {
//    UserProfileView()
//}
