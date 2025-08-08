//
//  CachedRepository+Extensions.swift
//  GithubUserSearch
//
//  Created by Ankit on 07/08/25.
//

import Foundation
import CoreData

extension CachedRepository {
    
    func toGitHubRepository() -> GitHubRepository {
        GitHubRepository(
            id: Int(repositoryID),
            repositoryName: repositoryName ?? "",
            fullRepoName: fullRepoName ?? "",
            repoDescription: repoDescription?.isEmpty == true ? nil : repoDescription,
            starCount: Int(starCount),
            forkCount: Int(forkCount),
            primaryLanguage: primaryLanguage,
            repoURL: repoURL ?? "",
            lastUpdate: lastUpdate ?? "",
            isPrivateRepo: isPrivateRepo
        )
    }
    
    func updateFrom(_ repository: GitHubRepository) {
        repositoryID = Int32(repository.id)
        repositoryName = repository.repositoryName
        fullRepoName = repository.fullRepoName
        repoDescription = repository.repoDescription
        starCount = Int32(repository.starCount)
        forkCount = Int32(repository.forkCount)
        primaryLanguage = repository.primaryLanguage
        repoURL = repository.repoURL
        lastUpdate = repository.lastUpdate
        isPrivateRepo = repository.isPrivateRepo
        lastFetched = Date() 
    }
}
