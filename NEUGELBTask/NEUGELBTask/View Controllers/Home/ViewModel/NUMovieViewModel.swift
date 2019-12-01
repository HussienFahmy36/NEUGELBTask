//
//  NUMovieViewModel.swift
//  NEUGELBTask
//
//  Created by Hussien Gamal Mohammed on 12/1/19.
//  Copyright © 2019 NEUGELB. All rights reserved.
//

import Foundation
struct NUMovieViewModel {
    let movieBannerImageURL: URL?

    init(model: NUMovie) {
        guard let url = URL(string: model.posterPath) else {
            movieBannerImageURL = nil
            return
        }
        movieBannerImageURL = url
    }
}
