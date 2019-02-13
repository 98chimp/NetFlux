//
//  ShowTableViewCell.swift
//  NetFlux
//
//  Created by Shahin on 2019-02-03.
//  Copyright © 2019 98%Chimp. All rights reserved.
//

import UIKit

class ShowTableViewCell: UITableViewCell {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var favrouitedImageView: UIImageView?
    
    func configure(with show: Show?) {
        if let show = show {
            favrouitedImageView?.isHidden = !show.isFavourited
            posterImageView.load(show.medium)
            nameLabel.text = show.name
        }
        else {
            nameLabel.text = "Not Available"
            favrouitedImageView?.isHidden = true
        }
    }
}
