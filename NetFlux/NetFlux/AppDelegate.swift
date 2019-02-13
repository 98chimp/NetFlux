//
//  AppDelegate.swift
//  NetFlux
//
//  Created by Shahin on 2019-02-01.
//  Copyright © 2019 98%Chimp. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        configureExtendedNavBar()
        fetchData()
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        PersistenceService.shared.saveContext()
    }

    private func fetchData() {
        if let shows = PersistenceService.shared.shows, shows.isEmpty {
            NetworkService.fetchAllTVShows()
        }
    }
    
    private func configureExtendedNavBar() {
        UINavigationBar.appearance().barTintColor = .violet
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
}

