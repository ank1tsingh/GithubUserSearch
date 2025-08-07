//
//  File.swift
//  GithubUserSearch
//
//  Created by Ankit on 08/08/25.
//

import Foundation


enum AppConstants {
    static let githubBaseURL = "https://api.github.com"
    static let defaultPerPage = 30
    static let searchDebounceTime = 600
    static let imageCacheLimit = 150
    static let imageCacheSizeLimit = 75 * 1024 * 1024 // 75MB
    static let cacheValidityDuration: TimeInterval = 3600 // 1 hour
}
