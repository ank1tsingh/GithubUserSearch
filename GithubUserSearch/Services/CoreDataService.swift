//
//  CoreDataService.swift
//  GithubUserSearch
//
//  Created by Ankit on 07/08/25.
//

import Foundation
import CoreData


protocol DataPersistenceServiceProtocol {
    func saveUser(_ user: GitHubUser) async
    func saveRepositories(_ repositories: [GitHubRepository], for username: String) async
    func getCachedUser(username: String) async -> GitHubUser?
    func getCachedRepositories(for username: String) async -> [GitHubRepository]
    func searchCachedUsers(query: String) async -> [GitHubUser]
}

final class CoreDataService: DataPersistenceServiceProtocol {
    private let cacheValidityDuration: TimeInterval = AppConstants.cacheValidityDuration
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "GitHubUserModel")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core Data error: \(error)")
            }
            container.viewContext.automaticallyMergesChangesFromParent = true
        }
        return container
    }()
    
    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    private var backgroundContext: NSManagedObjectContext {
        persistentContainer.newBackgroundContext()
    }
    
    private func saveContext(_ context: NSManagedObjectContext) {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Failed to save context: \(error)")
            }
        }
    }
    
    func saveUser(_ user: GitHubUser) async {
        let context = backgroundContext
        
        await context.perform { [weak self] in
            let request: NSFetchRequest<CachedUser> = CachedUser.fetchRequest()
            request.predicate = NSPredicate(format: "userID == %d", user.id)
            
            let existingUsers = try? context.fetch(request) ?? []
            let cachedUser = existingUsers?.first ?? CachedUser(context: context)
            
            cachedUser.updateFrom(user)
            self?.saveContext(context)
        }
    }
    
    func saveRepositories(_ repositories: [GitHubRepository], for username: String) async {
        let context = backgroundContext
        
        await context.perform { [weak self] in
            let userRequest: NSFetchRequest<CachedUser> = CachedUser.fetchRequest()
            userRequest.predicate = NSPredicate(format: "username == %@", username)
            
            guard let cachedUser = try? context.fetch(userRequest).first else { return }
            
            if let existingRepos = cachedUser.repositories {
                cachedUser.removeFromRepositories(existingRepos)
            }
            
            for repository in repositories {
                let cachedRepo = CachedRepository(context: context)
                cachedRepo.updateFrom(repository)
                cachedRepo.owner = cachedUser
                cachedUser.addToRepositories(cachedRepo)
            }
            
            self?.saveContext(context)
        }
    }
    
    func getCachedUser(username: String) async -> GitHubUser? {
        let context = backgroundContext
        
        return await context.perform { [weak self] in
            let request: NSFetchRequest<CachedUser> = CachedUser.fetchRequest()
            request.predicate = NSPredicate(
                format: "username == %@ AND lastFetched > %@",
                username,
                Date().addingTimeInterval(-(self?.cacheValidityDuration ?? AppConstants.cacheValidityDuration)) as NSDate
            )
            
            return try? context.fetch(request).first?.toGitHubUser()
        }
    }
    
    func getCachedRepositories(for username: String) async -> [GitHubRepository] {
        let context = backgroundContext
        
        return await context.perform { [weak self] in
            let request: NSFetchRequest<CachedRepository> = CachedRepository.fetchRequest()
            request.predicate = NSPredicate(
                format: "owner.username == %@ AND lastFetched > %@",
                username,
                Date().addingTimeInterval(-(self?.cacheValidityDuration ?? AppConstants.cacheValidityDuration)) as NSDate
            )
            request.sortDescriptors = [NSSortDescriptor(keyPath: \CachedRepository.starCount, ascending: false)]
            
            let cachedRepos = (try? context.fetch(request)) ?? []
            return cachedRepos.map { $0.toGitHubRepository() }
        }
    }
    
    func searchCachedUsers(query: String) async -> [GitHubUser] {
        let context = backgroundContext
        
        return await context.perform { [weak self] in
            let request: NSFetchRequest<CachedUser> = CachedUser.fetchRequest()
            request.predicate = NSPredicate(
                format: "username CONTAINS[c] %@ AND lastFetched > %@",
                query,
                Date().addingTimeInterval(-(self?.cacheValidityDuration ?? AppConstants.cacheValidityDuration)) as NSDate
            )
            
            let cachedUsers = (try? context.fetch(request)) ?? []
            return cachedUsers.map { $0.toGitHubUser() }
        }
    }
}
