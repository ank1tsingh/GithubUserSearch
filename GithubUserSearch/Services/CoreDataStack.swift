//
//  CoreDataStack.swift
//  GithubUserSearch
//
//  Created by Ankit on 07/08/25.
//

import Foundation
import CoreData

final class CoreDataStack {
    static let shared = CoreDataStack()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "GitHubUserModel")
        container.loadPersistentStores { [weak self] _, error in
            if let error = error {
                fatalError("Core Data failed to load: \(error)")
            }
            container.viewContext.automaticallyMergesChangesFromParent = true
        }
        
        return container
    }()
    
    var mainContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    var backgroundContext: NSManagedObjectContext {
        persistentContainer.newBackgroundContext()
    }
    
    func saveMainContext() throws {
        let context = mainContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Failed to save main context: \(error)")
                throw error
            }
        }
    }
    
    func saveContext(_ context: NSManagedObjectContext) throws {
        if context.hasChanges {
            try context.save()
        }
    }
}
