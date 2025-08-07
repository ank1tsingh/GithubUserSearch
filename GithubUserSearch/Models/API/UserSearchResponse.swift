//
//  UserSearchResponse.swift
//  GithubUserSearch
//
//  Created by Ankit on 06/08/25.
//

import Foundation

struct UserSearchResponse: Codable {
    let totalMatches: Int
    let searchIncomplete: Bool
    let foundUsers: [GitHubUser]
    
    enum CodingKeys: String, CodingKey {
        case totalMatches = "total_count"
        case searchIncomplete = "incomplete_results"
        case foundUsers = "items"
    }
}
