//
//  SafariService.swift
//  NetFlux
//
//  Created by Shahin on 2019-02-04.
//  Copyright © 2019 98%Chimp. All rights reserved.
//

import SafariServices

class SafariService {
    static func loadSafari(with urlString: String, for viewController: UIViewController) {
        if let url = URL(string: Constants.Web.Paths.imdb(urlString)) {
            let safariVC = SFSafariViewController(url: url)
            safariVC.preferredBarTintColor = .violet
            safariVC.preferredControlTintColor = .white
            viewController.present(safariVC, animated: true, completion: nil)
        }
    }
}
