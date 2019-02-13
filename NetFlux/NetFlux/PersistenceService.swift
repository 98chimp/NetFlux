//
//  PersistenceService.swift
//  NetFlux
//
//  Created by Shahin on 2019-02-02.
//  Copyright © 2019 98%Chimp. All rights reserved.
//

import Foundation
import CoreData

class PersistenceService {
    static let shared = PersistenceService()
    private let entityName = Constants.Persistence.EntityNames.show
    var shows: [Show]? {
        return fetchFromStorage()
    }
    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: Constants.Persistence.ContainerNames.netFlux)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
}

extension PersistenceService {
    func parse(_ jsonData: Data) {
        do {
            guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext else {
                fatalError("Failed to retrieve context")
            }
        
            // Parse JSON data
            let managedObjectContext = persistentContainer.viewContext
            let decoder = JSONDecoder()
            decoder.userInfo[codingUserInfoKeyManagedObjectContext] = managedObjectContext
            _ = try decoder.decode([Show].self, from: jsonData)
            try managedObjectContext.save()
        }
        catch let error {
            print(error)
        }
    }
    
    func clearStorage() {
        let managedObjectContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try managedObjectContext.execute(batchDeleteRequest)
        }
        catch let error as NSError {
            print(error)
        }
    }

    private func fetchFromStorage() -> [Show]? {
        let managedObjectContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Show>(entityName: entityName)
        let sortDescriptor1 = NSSortDescriptor(key: Constants.Persistence.SortDescriptors.name, ascending: true)
        let sortDescriptor2 = NSSortDescriptor(key: Constants.Persistence.SortDescriptors.type, ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor1, sortDescriptor2]
        
        do {
            let shows = try managedObjectContext.fetch(fetchRequest)
            return shows
        }
        catch let error {
            print(error)
            return nil
        }
    }
    
    // MARK: - Core Data Saving support
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
                let alert = AlertService.createPersistenceErrorAlert()
                alert.addAction(withTitle: Constants.Alerts.ActionTitles.retry, style: .default) { [weak self] in
                    self?.saveContext()
                }
                alert.present(animated: true, completion: nil)
            }
        }
    }
}
