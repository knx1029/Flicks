//
//  MovieApiFetcher.swift
//  Flicks
//
//  Created by Nanxi Kang on 9/16/17.
//  Copyright © 2017 Nanxi Kang. All rights reserved.
//

import Foundation

class MovieApiFetcher {
    private let API_REQUEST_URL: String = "https://api.themoviedb.org/3"
    private let IMG_REQUEST_URL: String = "https://image.tmdb.org/t/p"
    private let API_KEY_PARAM = "api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"
    private let NOW_PLAYING_PATH: String = "movie/now_playing"
    
    private let POSTER_WIDTH_OPTIONS: [(Int, String)] = [
        (92, "w92"),
        (154, "w154"),
        (185, "w185"),
        (342, "w342"),
        (500, "w500"),
        (780, "w780"),
        (Int.max, "original")]
    
    func getPosterUrl(minimumWidth: Int, posterPath: String) -> URL {
        let widthStr = POSTER_WIDTH_OPTIONS.first(where: {
            (actualWidth, value) in actualWidth >= minimumWidth
        })!.1
        let posterUrlString: String = "\(IMG_REQUEST_URL)/\(widthStr)\(posterPath)"
        print(posterUrlString)
        return URL(string: posterUrlString)!
    }
    
    func fetchNowPlaying(
            pageNum: Int = 1,
            timeoutInSeconds: Double = 10,
            movieResponder: @escaping ([Movie]) -> (),
            errorResponder: @escaping () -> () = {}) {
        let urlString: String = "\(API_REQUEST_URL)/\(NOW_PLAYING_PATH)/?page=\(pageNum)&\(API_KEY_PARAM)"
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringCacheData
        
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate: nil,
            delegateQueue: OperationQueue.main)
        let task: URLSessionDataTask = session.dataTask(
            with: request as URLRequest,
            completionHandler: { (data, response, error) in
                if let data = data {
                    if let dataJson = try! JSONSerialization.jsonObject(
                        with: data, options:[]) as? NSDictionary {
                        let results = dataJson["results"] as! [NSDictionary]
                        let movies = results.map { (value: NSDictionary) -> Movie in
                            Movie(value: value)
                        }
                        movieResponder(movies)
                    }
                } else {
                    errorResponder()
                }
        });
        task.resume()
    }
}
