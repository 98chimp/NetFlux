//
//  AlertService.swift
//  NetFlux
//
//  Created by Shahin on 2019-02-04.
//  Copyright © 2019 98%Chimp. All rights reserved.
//

import UIKit

struct AlertService {
    static func createNetworkErrorAlert() -> UIAlertController
    {
        let alert = UIAlertController(title: Constants.Alerts.Titles.oops, message: Constants.Alerts.Messages.connectionError, preferredStyle: .alert)
        alert.addCancelAction()
        alert.view.tintColor = .violet
        
        return alert
    }
    
    static func createPersistenceErrorAlert(_ isSaving: Bool = true) -> UIAlertController
    {
        let message = isSaving ? Constants.Alerts.Messages.saving : Constants.Alerts.Messages.deleting
        let alert = UIAlertController(title: Constants.Alerts.Titles.oops, message: message, preferredStyle: .alert)
        alert.addCancelAction()
        alert.view.tintColor = .violet
        
        return alert
    }
}
