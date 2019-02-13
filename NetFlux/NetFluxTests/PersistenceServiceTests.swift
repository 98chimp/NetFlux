//
//  PersistenceServiceTests.swift
//  NetFluxTests
//
//  Created by Shahin on 2019-02-03.
//  Copyright © 2019 98%Chimp. All rights reserved.
//

import XCTest
import CoreData
import OHHTTPStubs

@testable import NetFlux

class PersistenceServiceTests: XCTestCase {
    private static let defaultWait = 5.0
    private static let entityName = "Show"

    var coreDataCodableTestingHelper = CoreDataCodableTestingHelper()

    override func setUp() {
        super.setUp()

        coreDataCodableTestingHelper.clearStorage(for: PersistenceServiceTests.entityName)

        OHHTTPStubs.stubRequests(passingTest: { request in
            return request.url!.path.contains("shows")
        }, withStubResponse: { _ in
            return self.coreDataCodableTestingHelper.stubResponse(for: "shows.json", statusCode: 200)
        })
    }

    func testFetchItemsMatch() {
        let expectedShows: [Show]
        let jsonData = coreDataCodableTestingHelper.jsonData(for: "shows.json")
        do {
            let managedObjectContext = coreDataCodableTestingHelper.mockPersistentContainer.viewContext
            let decoder = JSONDecoder()
            decoder.userInfo[CodingUserInfoKey.managedObjectContext!] = managedObjectContext
            let shows = try decoder.decode([Show].self, from: jsonData!)
            let sortDescriptor1 = NSSortDescriptor(key: "name", ascending: true)
            let sortDescriptor2 = NSSortDescriptor(key: "type", ascending: true)
            let sortedShows = (shows as NSArray).sortedArray(using: [sortDescriptor1, sortDescriptor2])
            expectedShows = sortedShows.map { (show) in
                XCTAssertNotNil(show)
                return show as! Show
            }

            // We need to clean the storage to remove the Show instances we inserted in the decoding phase!
            coreDataCodableTestingHelper.clearStorage(for: PersistenceServiceTests.entityName)
        } catch let error {
            fatalError(error.localizedDescription)
        }

        let expectation = XCTNSNotificationExpectation(name: NSNotification.Name(rawValue: Notification.Name.NSManagedObjectContextDidSave.rawValue))

        guard let shows = PersistenceService.shared.shows else { return }
        XCTAssertNotEqual(shows.count, coreDataCodableTestingHelper.numberOfItemsInPersistentStore(for: PersistenceServiceTests.entityName))
        for index in 0..<shows.count {
            let actualShow = shows[index]
            XCTAssertNotNil(actualShow)
            XCTAssertNotEqual(expectedShows[index], actualShow)
        }
        expectation.fulfill()

        wait(for: [expectation], timeout: PersistenceServiceTests.defaultWait)
    }
}
