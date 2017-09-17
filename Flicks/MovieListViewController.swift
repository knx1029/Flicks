//
//  MovieListViewController.swift
//  Flicks
//
//  Created by Nanxi Kang on 9/16/17.
//  Copyright © 2017 Nanxi Kang. All rights reserved.
//

import CircularSpinner
import UIKit

class MovieListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var movies: [Movie] = []
    let movieApiFetcher = MovieApiFetcher()
    
    var errorMsgView: UIView!
    
    @IBOutlet weak var moviesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        moviesTableView.delegate = self
        moviesTableView.dataSource = self
        
        self.navigationController?.isNavigationBarHidden = true
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        moviesTableView.insertSubview(refreshControl, at: 0)
        
        createNotificationBanner()
        
        CircularSpinner.show("Loading Movies...", animated: true, type: .indeterminate)
        movieApiFetcher.fetchNowPlaying(movieResponder: { (movies) -> () in
            self.saveMovies(movies)
            self.hideError()
            CircularSpinner.hide()
        }, errorResponder: {() -> () in
            self.displayError()
            CircularSpinner.hide()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Implementing UITableViewDataSource, UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieTableViewCell
        
        let movie = self.movies[indexPath.row]
        cell.setContent(movie: movie, getPosterUrl: movieApiFetcher.getPosterUrl)
        return cell
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        movieApiFetcher.fetchNowPlaying(movieResponder: { (movies) -> () in
            self.saveMovies(movies)
            self.hideError()
            refreshControl.endRefreshing()
        }, errorResponder: { () -> () in
            self.displayError()
            refreshControl.endRefreshing()
        })
    }
    
    func createNotificationBanner() {
        let viewRect = CGRect(x: 37, y: 15, width: 300, height: 50)
        errorMsgView = UIView(frame: viewRect)
        
        let labelRect = CGRect(x: 10, y: 5, width: 280, height: 40)
        let errorMsgLabel = UILabel(frame: labelRect)
        errorMsgLabel.text = "Network error. Please try again later."
        errorMsgView.addSubview(errorMsgLabel)
        errorMsgView.backgroundColor = UIColor.white
        errorMsgView.isHidden = true
        moviesTableView.addSubview(errorMsgView)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! MovieDetailsViewController
        let indexPath = moviesTableView.indexPath(for: sender as! MovieTableViewCell)!
        moviesTableView.deselectRow(at: indexPath, animated: true)
        let movie = movies[indexPath.row]
        let backgroundUrl = movieApiFetcher.getPosterUrl(
            minimumWidth: 1200,
            posterPath: movie.posterPath)
        print("URL \(backgroundUrl.absoluteURL)")
        vc.backgroundUrlOpt = backgroundUrl
        vc.movieOpt = Movie(copy: movie)
    }
    
    private func saveMovies(_ movies: [Movie]) {
        self.movies = movies
        self.moviesTableView.reloadData()
    }
    
    private func hideError() {
        self.errorMsgView.isHidden = true
    }
    
    private func displayError() {
        self.errorMsgView.isHidden = false
    }
}
