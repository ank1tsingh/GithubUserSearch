//
//  CachedUser+Extensions.swift
//  GithubUserSearch
//
//  Created by Ankit on 07/08/25.
//

import Foundation
import CoreData

extension CachedUser {
    
    func toGitHubUser() -> GitHubUser {
        GitHubUser(
            id: Int(userID),
            username: username ?? "",
            profileImageURL: profileImageURL ?? "",
            githubURL: githubURL ?? "",
            displayName: displayName?.isEmpty == true ? nil : displayName ,
            userBio: userBio?.isEmpty == true ? nil : userBio,
            repositoryCount: repositoryCount > 0 ? Int(repositoryCount) : nil,
            followerCount: followerCount > 0 ? Int(followerCount) : nil,
            followingCount: followingCount >= 0 ? Int(followingCount) : nil,
            accountCreated: accountCreated?.isEmpty == true ? nil : accountCreated
        )
        
    }
    
    func updateFrom(_ user: GitHubUser) {
        userID = Int32(user.id)
        username = user.username
        displayName = user.displayName ?? ""
        userBio = user.userBio ?? ""
        profileImageURL = user.profileImageURL
        githubURL = user.githubURL
        repositoryCount = Int32(user.repositoryCount ?? 0)
        followerCount = Int32(user.followerCount ?? 0)
        followingCount = Int32(user.followingCount ?? 0)
        accountCreated = user.accountCreated
        lastFetched = Date()
    }
}
