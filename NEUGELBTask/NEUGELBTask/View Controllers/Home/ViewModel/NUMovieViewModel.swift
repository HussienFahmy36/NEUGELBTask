//
//  NUMovieViewModel.swift
//  NEUGELBTask
//
//  Created by Hussien Gamal Mohammed on 12/1/19.
//  Copyright © 2019 NEUGELB. All rights reserved.
//

import Foundation
struct NUMovieViewModel {
    
    let posterURLSmall: URL?
    let posterURLMedium: URL?

    init(model: NUMovie) {
        let base = "https://image.tmdb.org/t/p"
        let posterEndPointSize = "/w200"
        let bannerEndPointSize = "/w500"
        guard let urlForPoster = URL(string: base + posterEndPointSize + model.posterPath),
             let urlForBanner = URL(string: base + bannerEndPointSize + model.posterPath) else {
            posterURLMedium = nil
            posterURLSmall = nil
            return
        }
        posterURLMedium = urlForPoster
        posterURLSmall = urlForBanner
    }
}
