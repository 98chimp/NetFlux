//
//  String+Additions.swift
//  NetFlux
//
//  Created by Shahin on 2019-02-04.
//  Copyright © 2019 98%Chimp. All rights reserved.
//

import UIKit

extension String {
    func htmlToAttibutedString() -> NSAttributedString
    {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        guard let attributedString = try? NSAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html,
                                                                                   NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
            else { return NSAttributedString() }

        return attributedString
    }
}
