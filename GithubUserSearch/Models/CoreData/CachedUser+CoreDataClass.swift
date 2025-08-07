//
//  CachedUser+CoreDataClass.swift
//  GithubUserSearch
//
//  Created by Ankit on 07/08/25.
//

import Foundation
import CoreData

@objc(CachedUser)
public class CachedUser: NSManagedObject {
    @NSManaged public var userID: Int32
    @NSManaged public var username: String
    @NSManaged public var displayName: String?
    @NSManaged public var userBio: String?
    @NSManaged public var profileImageURL: String
    @NSManaged public var githubURL: String
    @NSManaged public var repositoryCount: Int32
    @NSManaged public var followerCount: Int32
    @NSManaged public var followingCount: Int32
    @NSManaged public var accountCreated: String
    @NSManaged public var lastFetched: Date
    @NSManaged public var repositories: NSSet?
}

extension CachedUser {
    @objc(addRepositoriesObject:)
    @NSManaged public func addToRepositories(_ value: CachedRepository)

    @objc(removeRepositoriesObject:)
    @NSManaged public func removeFromRepositories(_ value: CachedRepository)

    @objc(addRepositories:)
    @NSManaged public func addToRepositories(_ values: NSSet)

    @objc(removeRepositories:)
    @NSManaged public func removeFromRepositories(_ values: NSSet)
}
