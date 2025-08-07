//
//  GitHubNetworkService.swift
//  GithubUserSearch
//
//  Created by Ankit on 07/08/25.
//

import Foundation

protocol GitHubNetworkServiceProtocol {
    func searchUsers(query: String, page: Int, perPage: Int) async throws -> UserSearchResponse
    func fetchUser(username: String) async throws -> GitHubUser
    func fetchUserRepositories(username: String, page: Int, perPage: Int) async throws -> [GitHubRepository]
}

final class GitHubNetworkService: GitHubNetworkServiceProtocol {
    private let githubBaseURL = AppConstants.githubBaseURL
    private let urlSession: URLSession
    private let jsonDecoder: JSONDecoder
    
    init(session: URLSession = .shared) {
        self.urlSession = session
        self.jsonDecoder = JSONDecoder()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
    }
    
    func searchUsers(query: String, page: Int = 1, perPage: Int = 30) async throws -> UserSearchResponse {
        var components = URLComponents(string: "\(githubBaseURL)/search/users")!
        components.queryItems = [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per_page", value: "\(perPage)")
        ]
        
        return try await performRequest(url: components.url!)
    }
    
    func fetchUser(username: String) async throws -> GitHubUser {
        let url = URL(string: "\(githubBaseURL)/users/\(username)")!
        return try await performRequest(url: url)
    }
    
    func fetchUserRepositories(username: String, page: Int = 1, perPage: Int = 30) async throws -> [GitHubRepository] {
        var components = URLComponents(string: "\(githubBaseURL)/users/\(username)/repos")!
        components.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per_page", value: "\(perPage)"),
            URLQueryItem(name: "sort", value: "updated"),
            URLQueryItem(name: "direction", value: "desc")
        ]
        
        return try await performRequest(url: components.url!)
    }
    
    private func performRequest<T: Decodable>(url: URL) async throws -> T {
        debugPrint("[Network] Request URL:", url.absoluteString)
        do {
            let (data, response) = try await urlSession.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw GitHubAPIError.networkTrouble("Invalid response")
            }
            
            switch httpResponse.statusCode {
            case 200...299:
                break
            case 404:
                throw GitHubAPIError.userNotFound
            case 401:
                throw GitHubAPIError.accessDenied
            case 403:
                throw GitHubAPIError.rateLimitHit
            default:
                throw GitHubAPIError.networkTrouble("HTTP \(httpResponse.statusCode)")
            }
            
            return try jsonDecoder.decode(T.self, from: data)
        } catch is DecodingError {
            throw GitHubAPIError.parsingFailed
        } catch let error as GitHubAPIError {
            throw error
        } catch {
            throw GitHubAPIError.networkTrouble(error.localizedDescription)
        }
    }
}
