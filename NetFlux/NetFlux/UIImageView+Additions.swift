//
//  UIImageView+Additions.swift
//  NetFlux
//
//  Created by Shahin on 2019-02-04.
//  Copyright © 2019 98%Chimp. All rights reserved.
//

import UIKit
import SDWebImage

extension UIImageView {
    func load(_ url: String, with contentMode: UIView.ContentMode = .scaleAspectFill) {
        clipsToBounds = true
        self.contentMode = contentMode
        sd_imageTransition = .curlDown
        sd_setShowActivityIndicatorView(true)
        sd_setIndicatorStyle(.gray)
        sd_setImage(with: URL(string: url), placeholderImage: #imageLiteral(resourceName: "placeholder_image"), completed: nil)
    }
}
