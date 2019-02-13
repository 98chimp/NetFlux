//
//  NetworkService.swift
//  NetFlux
//
//  Created by Shahin on 2019-02-02.
//  Copyright © 2019 98%Chimp. All rights reserved.
//

import Foundation

class NetworkService {
    
    private static let showsURL = URL(string: Constants.Web.Paths.allShows)
    
    static func fetchAllTVShows() {
        
        guard let url = showsURL else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                showRetryAlert()
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Error: invalid HTTP response code")
                showRetryAlert()
                return
            }
            
            guard let data = data else {
                print("Error: missing data")
                showRetryAlert()
                return
            }
            
            PersistenceService.shared.parse(data)
        }.resume()
    }
    
    private static func showRetryAlert() {
        let alert = AlertService.createNetworkErrorAlert()
        alert.addAction(withTitle: Constants.Alerts.ActionTitles.retry, style: .default) {
            fetchAllTVShows()
        }
        alert.present(animated: true, completion: nil)
    }
}
