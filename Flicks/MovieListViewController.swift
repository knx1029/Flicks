//
//  MovieListViewController.swift
//  Flicks
//
//  Created by Nanxi Kang on 9/16/17.
//  Copyright © 2017 Nanxi Kang. All rights reserved.
//

import UIKit

class MovieListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let API_REQUEST_URL: String = "https://api.themoviedb.org/3"
    let IMG_REQUEST_URL: String = "https://image.tmdb.org/t/p"
    let API_KEY_PARAM = "api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"
    let NOW_PLAYING_PATH: String = "movie/now_playing"
    
    var movies: [Movie] = []
    
    @IBOutlet weak var moviesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        moviesTableView.delegate = self
        moviesTableView.dataSource = self
        
        // Do any additional setup after loading the view.
        fetchNowPlaying()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Implementing UITableViewDataSource, UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("set count \(movies.count)")
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("Loading \(indexPath.row)")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieTableViewCell
        
        let movie = self.movies[indexPath.row]
        cell.setContent(movie: movie, getPosterUrl: getPosterUrl)
        return cell
    }
    
    private func fetchNowPlaying(pageNum: Int32 = 1) {
        let urlString: String = "\(API_REQUEST_URL)/\(NOW_PLAYING_PATH)/?page=\(pageNum)&\(API_KEY_PARAM)"
        fetchContent(urlString: urlString)
        
    }
    
    let POSTER_WIDTH_OPTIONS: [(Int, String)] = [
        (92, "w92"),
        (154, "w154"),
        (185, "w185"),
        (342, "w342"),
        (500, "w500"),
        (780, "w780"),
        (Int.max, "original")]
    
    private func getPosterUrl(minimumWidth: Int, posterPath: String) -> URL {
        let widthStr = POSTER_WIDTH_OPTIONS.first(where: {
            (actualWidth, value) in actualWidth >= minimumWidth
        })!.1
        let posterUrlString: String = "\(IMG_REQUEST_URL)/\(widthStr)\(posterPath)"
        print(posterUrlString)
        return URL(string: posterUrlString)!
    }
    
    private func fetchContent(urlString: String!) {
        let url = URL(string: urlString)
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        let task : URLSessionDataTask = session.dataTask(
            with: request as URLRequest,
            completionHandler: { (data, response, error) in
                if let data = data {
                    if let dataJson = try! JSONSerialization.jsonObject(
                        with: data, options:[]) as? NSDictionary {
                        print("dataJson: \(dataJson)")
                        
                        let results = dataJson["results"] as! [NSDictionary]
                        
                        self.movies = results.map { (value: NSDictionary) -> Movie in
                            Movie(value: value)
                        }
                        
                        self.moviesTableView.reloadData()
                    }
                }
        });
        task.resume()
    }

}
