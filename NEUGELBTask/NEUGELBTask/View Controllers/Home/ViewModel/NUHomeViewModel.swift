//
//  NUHomeViewModel.swift
//  NEUGELBTask
//
//  Created by Hussien Gamal Mohammed on 12/1/19.
//  Copyright © 2019 NEUGELB. All rights reserved.
//

import Foundation
class NUHomeViewModel {
    var movies: [NUMovieViewModel] = []
    let worker = NUMoviesDBDataWorker()

    func nowPlaying(pageIndex: Int, completion: @escaping ([NUMovieViewModel], _ errorMessage: String?) -> ()) {
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

    
}
