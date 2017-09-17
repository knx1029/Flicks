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
    
    @IBOutlet weak var moviesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        moviesTableView.delegate = self
        moviesTableView.dataSource = self
        
        self.navigationController?.isNavigationBarHidden = true
        
        CircularSpinner.show("Loading Movies...", animated: true, type: .indeterminate)
        movieApiFetcher.fetchNowPlaying(movieResponder: saveMovies)
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
    
    func didSelectRowAtIndexPath(_ tableView: UITableView, at: IndexPath) {
        print("aaaa")
        
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
        CircularSpinner.hide()
    }
}
