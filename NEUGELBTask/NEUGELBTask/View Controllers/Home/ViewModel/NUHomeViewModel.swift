//
//  NUHomeViewModel.swift
//  NEUGELBTask
//
//  Created by Hussien Gamal Mohammed on 12/1/19.
//  Copyright © 2019 NEUGELB. All rights reserved.
//

import Foundation
typealias NUResponseBlock = ([NUMovieViewModel], _ errorMessage: String?) -> ()
class NUHomeViewModel {
    var movies: [NUMovieViewModel] = []
    var searchResultMovies: [NUMovieViewModel] = []
    let worker = NUMoviesDBDataWorker()
    let minimumSearchWordLength = 3
    var nextPageToFetch = 0


    func nowPlaying(pageIndex: Int, completion: @escaping NUResponseBlock) {
        worker.getNowPlaying(page: pageIndex) {[weak self] (response, error) in
            if error != nil {
                completion([], error!.rawValue)
            }
            guard let self = self else {
                return
            }
            guard let moviesArray = response?.results else {
                return
            }
            for movieModel in moviesArray {
                self.movies.append(NUMovieViewModel(model: movieModel))
            }
            completion(self.movies, nil)
        }
    }

    func search(keyword: String, completion: @escaping NUResponseBlock) {
        nextPageToFetch = 0
        if keyword.isEmpty {
            completion([], nil)
        }
        if keyword.count >= minimumSearchWordLength {
            worker.searchMovie(keyword: keyword) {[weak self] (response, error) in
                if error != nil {
                    self?.searchResultMovies = []
                    completion([], error!.rawValue)
                }
                guard let self = self else {
                    return
                }
                guard let moviesArray = response?.results else {
                    completion([], "No results")
                    return
                }
                self.searchResultMovies.removeAll()
                for movieModel in moviesArray {
                    self.searchResultMovies.append(NUMovieViewModel(model: movieModel))
                }
                completion(self.searchResultMovies, nil)
            }
        }
    }

    func fetchNextPage(completion: @escaping NUResponseBlock) {
        nextPageToFetch += 1
        nowPlaying(pageIndex: nextPageToFetch, completion: completion)
    }

    
}
