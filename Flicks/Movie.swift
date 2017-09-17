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
    var posterPath: String?
    
    var releaseDate: String
    var popularity: Double
    var voteAverage: Double
    var voteCount: Int
    
    init(value: NSDictionary) {
        self.title = value["title"] as! String
        self.overview = value["overview"] as! String
        self.posterPath = value["poster_path"] as? String
        self.releaseDate = value["release_date"] as! String
        self.popularity = value["popularity"] as! Double
        self.voteAverage = value["vote_average"] as! Double
        self.voteCount = value["vote_count"] as! Int
    }
    
    init(copy: Movie) {
        self.title = copy.title
        self.overview = copy.overview
        self.posterPath = copy.posterPath
        self.releaseDate = copy.releaseDate
        self.popularity = copy.popularity
        self.voteAverage = copy.voteAverage
        self.voteCount = copy.voteCount
    }
}
