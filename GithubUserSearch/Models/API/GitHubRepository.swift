//
//  GitHubRepository.swift
//  GithubUserSearch
//
//  Created by Ankit on 06/08/25.
//

import Foundation

struct GitHubRepository: Codable, Identifiable, Equatable {
    let id: Int
    let repositoryName: String
    let fullRepoName: String
    let repoDescription: String?
    let starCount: Int
    let forkCount: Int
    let primaryLanguage: String?
    let repoURL: String
    let lastUpdate: String
    let isPrivateRepo: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case repositoryName = "name"
        case repoDescription = "description"
        case primaryLanguage = "language"
        case fullRepoName = "full_name"
        case starCount = "stargazers_count"
        case forkCount = "forks_count"
        case repoURL = "html_url"
        case lastUpdate = "updated_at"
        case isPrivateRepo = "private"
    }
    
    static func == (lhs: GitHubRepository, rhs: GitHubRepository) -> Bool {
        lhs.id == rhs.id
    }
}
