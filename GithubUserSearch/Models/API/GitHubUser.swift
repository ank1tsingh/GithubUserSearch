//
//  GitHubUser.swift
//  GithubUserSearch
//
//  Created by Ankit on 06/08/25.
//

import Foundation

struct GitHubUser: Codable, Identifiable, Equatable {
    let id: Int
    let username: String
    let profileImageURL: String
    let githubURL: String
    let displayName: String?
    let userBio: String?
    let repositoryCount: Int
    let followerCount: Int
    let followingCount: Int
    let accountCreated: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case username = "login"
        case displayName = "name"
        case userBio = "bio"
        case followerCount = "followers"
        case followingCount = "following"
        case profileImageURL = "avatar_url"
        case githubURL = "html_url"
        case repositoryCount = "public_repos"
        case accountCreated = "created_at"
    }
    
    static func == (lhs: GitHubUser, rhs: GitHubUser) -> Bool {
        lhs.id == rhs.id
    }
}
