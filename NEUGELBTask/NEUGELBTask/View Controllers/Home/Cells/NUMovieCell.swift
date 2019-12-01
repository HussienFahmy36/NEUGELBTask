//
//  NUMovieCell.swift
//  NEUGELBTask
//
//  Created by Hussien Gamal Mohammed on 12/1/19.
//  Copyright © 2019 NEUGELB. All rights reserved.
//

import UIKit
import SDWebImage

class NUMovieCell: UICollectionViewCell {
    @IBOutlet weak var movieBannerImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        movieBannerImage.layer.cornerRadius = 4
        movieBannerImage.layer.masksToBounds = true
    }
    func config(viewModel: NUMovieViewModel) {
        movieBannerImage.sd_setImage(with: viewModel.posterURLSmall, completed: nil)
//        movieBannerImage.sd_setImage(with: viewModel.movieBannerImageURL) { (imageData, error, cache, url) in
//        }
    }
}
