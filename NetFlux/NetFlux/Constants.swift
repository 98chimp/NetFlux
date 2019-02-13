//
//  Constants.swift
//  NetFlux
//
//  Created by Shahin on 2019-02-02.
//  Copyright © 2019 98%Chimp. All rights reserved.
//

import UIKit

struct Constants
{
    struct Alerts {
        struct Titles {
            static let oops = "Oops, something went wrong"
        }
        
        struct Messages {
            static let saving = "There was a problem saving this TV Show. Do you want to try again?"
            static let deleting = "There was a problem deleting this TV Show. Do you want to try again?"
            static let connectionError = "An error occurred while fetching data. Do you want to try again?"
        }
        
        struct ActionTitles {
            static let cancel = "Cancel"
            static let retry = "Retry"
        }
    }
    
    struct Identifiers {
        struct Cells
        {
            static let showCell = "show cell"
        }
        
        struct Segues
        {
            static let toShowDetail = "show detail segue"
        }
    }
    
    struct ButtonTitles {
        static let delete = "Delete"
        static let favourite = "Favourite"
    }
    
    struct Persistence {
        struct EntityNames {
            static let show = "Show"
        }
        struct ContainerNames {
            static let netFlux = "NetFlux"
        }
        struct SortDescriptors {
            static let name = "name"
            static let type = "type"
        }
    }
    
    struct Web {
        struct Paths {
            static let allShows = "http://api.tvmaze.com/shows"
            static func imdb(_ imdb: String) -> String { return "https://www.imdb.com/title/\(imdb)"}
        }
    }
}
