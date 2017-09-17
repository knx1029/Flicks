//
//  NowPlayingViewController.swift
//  Flicks
//
//  Created by Nanxi Kang on 9/17/17.
//  Copyright © 2017 Nanxi Kang. All rights reserved.
//

import UIKit

class NowPlayingViewController: MovieListViewController {

    override func viewDidLoad() {
        super.movieFetchType = MovieFetchType.NOW_PLAYING
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
