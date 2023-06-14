//
//  CoreDataManager.swift
//  MoneyGuard
//
//  Created by yury mid on 14.06.2023.
//

import Foundation
import CoreData

class CoreDataManager: ObservableObject {
    static let shared = CoreDataManager() // Singleton instance
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MoneyGuard")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print("Failed to load Core Data stack: \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // MARK: - Core Data Saving Support
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Failed to save Core Data context: \(error), \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - CRUD Operations
    
    // Create a new entity instance
    func createEntity<T: NSManagedObject>() -> T? {
        guard let entityName = NSStringFromClass(T.self).components(separatedBy: ".").last else {
            return nil
        }
        return NSEntityDescription.insertNewObject(forEntityName: entityName, into: context) as? T
    }
    
    // Fetch entities of a given type
    func fetchEntities<T: NSManagedObject>() -> [T] {
        let fetchRequest = NSFetchRequest<T>(entityName: NSStringFromClass(T.self))
        do {
            let entities = try context.fetch(fetchRequest)
            return entities
        } catch {
            print("Failed to fetch entities: \(error), \(error.localizedDescription)")
            return []
        }
    }
    
    // Update an entity
    func updateEntity() {
        saveContext()
    }
    
    // Delete an entity
    func deleteEntity(entity: NSManagedObject) {
        context.delete(entity)
        saveContext()
    }
}
