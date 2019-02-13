//
//  CoreDataCodableTestingHelper.swift
//  NetFluxTests
//
//  Created by Shahin on 2019-02-03.
//  Copyright © 2019 98%Chimp. All rights reserved.
//

import XCTest
import CoreData
import OHHTTPStubs

class CoreDataCodableTestingHelper {
    lazy var managedObjectModel: NSManagedObjectModel = {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!
        return managedObjectModel
    }()

    lazy var mockPersistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "NetFlux", managedObjectModel: managedObjectModel)
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false

        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (description, error) in
            precondition(description.type == NSInMemoryStoreType)
            if let error = error {
                XCTFail("Error creating the in-memory NSPersistentContainer mock: \(error)")
            }
        }

        return container
    }()

    func stubResponse(for fileName: String, statusCode: Int32 = 200) -> OHHTTPStubsResponse {
        let bundle = Bundle(for: type(of: self))
        let path = OHPathForFileInBundle(fileName, bundle)
        let result = OHHTTPStubsResponse(fileAtPath: path!,
                                         statusCode: statusCode,
                                         headers: ["Content-Type": "application/json"])
        return result
    }

    func jsonData(for fileName: String) -> Data? {
        let bundle = Bundle(for: type(of: self))
        if let path = OHPathForFileInBundle(fileName, bundle) {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                return data
            } catch let error {
                XCTFail(error.localizedDescription)
            }
        }
        return nil
    }

    func numberOfItemsInPersistentStore(for entityName: String) -> Int {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let results = try! mockPersistentContainer.viewContext.fetch(request)
        return results.count
    }

    func clearStorage(for entityName: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let context = mockPersistentContainer.viewContext
        let objs = try! context.fetch(fetchRequest)
        for case let obj as NSManagedObject in objs {
            context.delete(obj)
        }
        try! context.save()
    }
}
