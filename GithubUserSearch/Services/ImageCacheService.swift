//
//  ImageCacheService.swift
//  GithubUserSearch
//
//  Created by Ankit on 07/08/25.
//

import Foundation
import UIKit

protocol ImageCacheServiceProtocol {
    func loadImage(from url: URL) async throws -> UIImage
}

final class ImageCacheService: ImageCacheServiceProtocol {
    private let imageCache = NSCache<NSURL, UIImage>()
    private let urlSession: URLSession
    
    init(session: URLSession = .shared) {
        self.urlSession = session
        imageCache.countLimit = AppConstants.imageCacheLimit
        imageCache.totalCostLimit = AppConstants.imageCacheSizeLimit
    }
    
    func loadImage(from url: URL) async throws -> UIImage {
        if let cachedImage = imageCache.object(forKey: url as NSURL) {
            return cachedImage
        }
        
        let (data, _) = try await urlSession.data(from: url)
        guard let image = UIImage(data: data) else {
            throw GitHubAPIError.parsingFailed
        }

        
        imageCache.setObject(image, forKey: url as NSURL)
        return image
    }
}
