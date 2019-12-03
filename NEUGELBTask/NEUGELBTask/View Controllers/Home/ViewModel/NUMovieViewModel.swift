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
    let posterURLOriginal: URL?

    init(model: NUMovie) {
        let base = NUStringsConstants.baseURLForImage
        let posterEndPointSize = "/w200"
        let bannerEndPointSize = "/original"
        title = model.title
        description = model.overview
        rate = model.voteAverage
        guard let posterPath = model.posterPath,
            let urlForPoster = URL(string: base + posterEndPointSize + posterPath),
             let urlForBanner = URL(string: base + bannerEndPointSize + posterPath) else {
            posterURLOriginal = nil
            posterURLSmall = nil
            return
        }
        posterURLOriginal = urlForBanner
        posterURLSmall = urlForPoster
            }
}
