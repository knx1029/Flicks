//
//  MovieTableViewCell.swift
//  Flicks
//
//  Created by Nanxi Kang on 9/16/17.
//  Copyright © 2017 Nanxi Kang. All rights reserved.
//

import AFNetworking
import UIKit

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var overviewTextView: UITextView!
    
    @IBOutlet weak var posterImageView: UIImageView!
    
    func setContent(movie: Movie, getPosterUrl: (_ width: Int, _ posterPath: String) -> URL) {
        self.titleLabel.text = movie.title
        self.overviewTextView.text = movie.overview
        self.overviewTextView.isEditable = false
        self.overviewTextView.isScrollEnabled = true
        self.overviewTextView.adjustsFontForContentSizeCategory = true
        let posterWidth = posterImageView.frame.size.width
        let posterWidthInt = Int(floor(posterWidth))
        if (movie.posterPath != nil) {
            let posterUrl: URL = getPosterUrl(posterWidthInt, movie.posterPath!)
            self.posterImageView.setImageWith(posterUrl)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
