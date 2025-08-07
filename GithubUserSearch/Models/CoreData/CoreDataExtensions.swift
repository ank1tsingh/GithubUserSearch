//
//  CoreDataExtensions.swift
//  GithubUserSearch
//
//  Created by Ankit on 07/08/25.
//

import Foundation

extension CachedUser: Identifiable {
    func toGitHubUser() -> GitHubUser {
        GitHubUser(
            id: Int(userID),
            username: username,
            profileImageURL: profileImageURL,
            githubURL: githubURL,
            displayName: displayName,
            userBio: userBio,
            repositoryCount: Int(repositoryCount),
            followerCount: Int(followerCount),
            followingCount: Int(followingCount),
            accountCreated: accountCreated
        )
    }
    
    func updateFrom(apiUser: GitHubUser) {
        userID = Int32(apiUser.id)
        username = apiUser.username
        displayName = apiUser.displayName
        userBio = apiUser.userBio
        profileImageURL = apiUser.profileImageURL
        githubURL = apiUser.githubURL
        repositoryCount = Int32(apiUser.repositoryCount)
        followerCount = Int32(apiUser.followerCount)
        followingCount = Int32(apiUser.followingCount)
        accountCreated = apiUser.accountCreated
        lastFetched = Date()
    }
}

extension CachedRepository: Identifiable {
    
    func toGitHubRepository() -> GitHubRepository {
        GitHubRepository(
            id: Int(repositoryID),
            repositoryName: repositoryName,
            fullRepoName: fullRepoName,
            repoDescription: repoDescription,
            starCount: Int(starCount),
            forkCount: Int(forkCount),
            primaryLanguage: primaryLanguage,
            repoURL: repoURL,
            lastUpdate: lastUpdate,
            isPrivateRepo: isPrivateRepo
        )
    }
    
    func updateFrom(apiRepo: GitHubRepository) {
        repositoryID = Int32(apiRepo.id)
        repositoryName = apiRepo.repositoryName
        fullRepoName = apiRepo.fullRepoName
        repoDescription = apiRepo.repoDescription
        starCount = Int32(apiRepo.starCount)
        forkCount = Int32(apiRepo.forkCount)
        primaryLanguage = apiRepo.primaryLanguage
        repoURL = apiRepo.repoURL
        lastUpdate = apiRepo.lastUpdate
        isPrivateRepo = apiRepo.isPrivateRepo
        lastFetched = Date()
    }
}
