//
//  MoiveDetailsViewController.swift
//  Flicks
//
//  Created by Nanxi Kang on 9/16/17.
//  Copyright © 2017 Nanxi Kang. All rights reserved.
//

import AFNetworking
import UIKit

class MovieDetailsViewController: UIViewController {
    
    var movieOpt: Movie? = nil
    var backgroundUrlOpt: URL? = nil
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    @IBOutlet weak var voteLabel: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var overviewLabel: UILabel!
    func getMinimumImageWidth() -> Int {
        return Int(floor(backgroundImageView.frame.size.width))
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = false
        
        if (movieOpt != nil) {
            let movie = movieOpt!
            titleLabel.text = movie.title
            releaseDateLabel.text = "Release date: \(movie.releaseDate)"
            voteLabel.text = "Score: \(movie.voteAverage) (\(movie.voteCount) votes)"
            overviewLabel.text = movie.overview
            let originalHeight = overviewLabel.frame.height
            overviewLabel.sizeToFit()
            let newHeight = overviewLabel.frame.height
            
            let contentWidth = scrollView.bounds.width
            let contentHeight = scrollView.bounds.height + max(newHeight - originalHeight, 0)
            scrollView.contentSize = CGSize(width: contentWidth, height: contentHeight)
        } else {
            print("movieOpt == null")
        }
        
        // Do any additional setup after loading the view.
        if (backgroundUrlOpt != nil) {
          backgroundImageView.setImageWith(backgroundUrlOpt!)
        } else {
            print("backgroundUrl == null")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
