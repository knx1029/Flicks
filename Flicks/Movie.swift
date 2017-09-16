//
//  Movie.swift
//  Flicks
//
//  Created by Nanxi Kang on 9/16/17.
//  Copyright © 2017 Nanxi Kang. All rights reserved.
//

import Foundation

struct Movie {
    
    var title: String
    var overview: String
    var posterPath: String
    
    init(title: String, overview: String, posterPath: String) {
        self.title = title
        self.overview = overview
        self.posterPath = posterPath
    }
    
    init(value: NSDictionary) {
        self.title = value["title"] as! String
        self.overview = value["overview"] as! String
        self.posterPath = value["poster_path"] as! String
    }
}
