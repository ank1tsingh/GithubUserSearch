//
//  GitHubAPIError.swift
//  GithubUserSearch
//
//  Created by Ankit on 06/08/25.
//

import Foundation

enum GitHubAPIError: LocalizedError, Equatable {
    case userNotFound
    case networkTrouble(String)
    case parsingFailed
    case rateLimitHit
    case accessDenied
    case somethingWentWrong(String)
    
    var errorDescription: String? {
        switch self {
        case .userNotFound:
            return "user doesn't exist on GitHub"
        case .networkTrouble(let details):
            return "Connection issue: \(details)"
        case .parsingFailed:
            return "Somethings wrong with the response format"
        case .rateLimitHit:
            return "Too many requests!"
        case .accessDenied:
            return "Cant access that resource"
        case .somethingWentWrong(let details):
            return "Unexpected error: \(details)"
        }
    }
}
