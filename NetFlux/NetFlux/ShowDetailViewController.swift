//
//  ShowDetailViewController.swift
//  NetFlux
//
//  Created by Shahin on 2019-02-01.
//  Copyright © 2019 98%Chimp. All rights reserved.
//

import UIKit

class ShowDetailViewController: UIViewController {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var imdbButton: UIButton!
    @IBOutlet weak var showSummaryTextView: UITextView!
    
    var show: Show?
    private var saveButton = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureNavBarButton()
    }

    func configureView() {
        if let imageURLString = show?.original {
            posterImageView.load(imageURLString, with: .scaleAspectFit)
        }
        showSummaryTextView.contentMode = .topLeft
        showSummaryTextView.attributedText = show?.summary.htmlToAttibutedString()
        navigationItem.largeTitleDisplayMode = .never
        title = show?.name
    }
    
    @objc private func configureNavBarButton() {
        if let show = self.show {
            let buttonTitle = show.isFavourited ? Constants.ButtonTitles.delete : Constants.ButtonTitles.favourite
            saveButton = UIBarButtonItem(title: buttonTitle, style: .plain, target: self, action: #selector(navBarButtonTapped))
            navigationItem.rightBarButtonItem = saveButton
        }
    }
    
    @objc private func navBarButtonTapped() {
        if let show = self.show {
            show.isFavourited = !show.isFavourited
            PersistenceService.shared.saveContext()
            saveButton.title = show.isFavourited ? Constants.ButtonTitles.delete : Constants.ButtonTitles.favourite
        }
    }
    
    @IBAction func imdbButtonTapped(_ sender: UIButton) {
        if let imdb = show?.imdb {
            SafariService.loadSafari(with: imdb, for: self)
        }
    }
}
