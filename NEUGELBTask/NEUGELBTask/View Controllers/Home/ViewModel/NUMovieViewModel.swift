//
//  NUMovieViewModel.swift
//  NEUGELBTask
//
//  Created by Hussien Gamal Mohammed on 12/1/19.
//  Copyright © 2019 NEUGELB. All rights reserved.
//

import Foundation
struct NUMovieViewModel {


    let title: String?
    let description: String?
    let rate: Double?
    let posterURLSmall: URL?
    let posterURLMedium: URL?

    init(model: NUMovie) {
        let base = "https://image.tmdb.org/t/p"
        let posterEndPointSize = "/w200"
        let bannerEndPointSize = "/w500"
        title = model.title
        description = model.overview
        rate = model.popularity
        guard let urlForPoster = URL(string: base + posterEndPointSize + model.posterPath),
             let urlForBanner = URL(string: base + bannerEndPointSize + model.posterPath) else {
            posterURLMedium = nil
            posterURLSmall = nil
            return
        }
        posterURLMedium = urlForBanner
        posterURLSmall = urlForPoster
            }
}
