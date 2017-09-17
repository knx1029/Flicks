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
    // Define what types of movie list to fetch
    var movieFetchType: MovieFetchType? = nil

    // Metadata for infinite scrolling
    let loadingMovies = DispatchSemaphore(value: 1)
    var pageNum: Int = 1
    var totalPageNum: Int = Int.max
    
    var loadingView: UIActivityIndicatorView!
    
    var errorMsgView: UIView!
    
    @IBOutlet weak var moviesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        moviesTableView.delegate = self
        moviesTableView.dataSource = self
        
        self.navigationController?.isNavigationBarHidden = true
        
        // Add top refresher
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        moviesTableView.insertSubview(refreshControl, at: 0)
        
        // Add bottom refreshed
        createLoadingFooter()
        
        // Add error banner
        createErrorBanner()
        
        // Initialize movies movies
        self.loadingMovies.wait()
        CircularSpinner.show("Loading Movies...", animated: true, type: .indeterminate)
        movieApiFetcher.fetch(
            type: movieFetchType!,
            movieResponder: { (movies) -> () in
            self.saveMovies(movies)
            self.hideError()
            CircularSpinner.hide()
            self.loadingMovies.signal()
        }, errorResponder: {() -> () in
            self.displayError()
            CircularSpinner.hide()
            self.loadingMovies.signal()
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
    
    // Create a cell to display
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieTableViewCell
        
        let movie = self.movies[indexPath.row]
        cell.setContent(movie: movie, getPosterUrl: movieApiFetcher.getPosterUrl)
        
        // Load more if reaching the end of table
        if (indexPath.row == movies.count - 1 && pageNum < totalPageNum) {
            print("Loading more")
            self.loadingMovies.wait()
            refreshLoadingFooter()
            movieApiFetcher.fetch(
                type: movieFetchType!,
                pageNum: pageNum + 1,
                movieResponder: { (movies) -> () in
                    self.appendMovies(movies)
                    self.hideError()
                    self.stopRefreshLoadingFooter()
                    self.loadingMovies.signal()
            }, errorResponder: {() -> () in
                self.displayError()
                self.stopRefreshLoadingFooter()
                self.loadingMovies.signal()
            })
            
        }
        
        return cell
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        self.loadingMovies.wait()
        movieApiFetcher.fetch(
            type: movieFetchType!,
            movieResponder: { (movies) -> () in
            self.saveMovies(movies)
            self.hideError()
            refreshControl.endRefreshing()
            self.loadingMovies.signal()
        }, errorResponder: { () -> () in
            self.displayError()
            refreshControl.endRefreshing()
            self.loadingMovies.signal()
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! MovieDetailsViewController
        let indexPath = moviesTableView.indexPath(for: sender as! MovieTableViewCell)!
        moviesTableView.deselectRow(at: indexPath, animated: true)
        let movie = movies[indexPath.row]
        if (movie.posterPath != nil) {
            let backgroundUrl = movieApiFetcher.getPosterUrl(
                minimumWidth: 1200,
                posterPath: movie.posterPath!)
            print("URL \(backgroundUrl.absoluteURL)")
            vc.backgroundUrlOpt = backgroundUrl
        }
        vc.movieOpt = Movie(copy: movie)
    }
    
    private func saveMovies(_ movies: [Movie]) {
        self.pageNum = 1
        self.movies = movies
        self.moviesTableView.reloadData()
    }
    
    private func appendMovies(_ movies: [Movie]) {
        print("append \(movies.count) movies")
        if (movies.count == 0) {
            totalPageNum = self.pageNum
        } else {
            self.pageNum = self.pageNum + 1
            self.movies.append(contentsOf: movies)
            self.moviesTableView.reloadData()
        }
    }
    
    private func createErrorBanner() {
        errorMsgView = UIView(frame: CGRect(x: 37, y: 15, width: 300, height: 50))
        let errorMsgLabel = UILabel(frame: CGRect(x: 10, y: 5, width: 280, height: 40))
        errorMsgLabel.text = "Network error. Please try again later."
        errorMsgView.addSubview(errorMsgLabel)
        errorMsgView.backgroundColor = UIColor.white
        errorMsgView.isHidden = true
        moviesTableView.addSubview(errorMsgView)
    }
    
    private func hideError() {
        self.errorMsgView.isHidden = true
    }
    
    private func displayError() {
        self.errorMsgView.isHidden = false
    }
    
    private func createLoadingFooter() {
        let tableFooterView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        loadingView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        loadingView.center = tableFooterView.center
        tableFooterView.addSubview(loadingView)
        self.moviesTableView.tableFooterView = tableFooterView
    }
    
    private func refreshLoadingFooter() {
        loadingView.startAnimating()
    }
    
    private func stopRefreshLoadingFooter() {
        loadingView.stopAnimating()
    }
}
