//
//   CachedRepository+CoreDataClass.swift
//  GithubUserSearch
//
//  Created by Ankit on 07/08/25.
//

import Foundation
import CoreData

@objc(CachedRepository)
public class CachedRepository: NSManagedObject {
    @NSManaged public var repositoryID: Int32
    @NSManaged public var repositoryName: String
    @NSManaged public var fullRepoName: String
    @NSManaged public var repoDescription: String?
    @NSManaged public var starCount: Int32
    @NSManaged public var forkCount: Int32
    @NSManaged public var primaryLanguage: String?
    @NSManaged public var repoURL: String
    @NSManaged public var lastUpdate: String
    @NSManaged public var isPrivateRepo: Bool
    @NSManaged public var lastFetched: Date
    @NSManaged public var owner: CachedUser?
}
