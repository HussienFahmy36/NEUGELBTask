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
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!


    override func awakeFromNib() {
        super.awakeFromNib()
        movieBannerImage.layer.cornerRadius = 4
        movieBannerImage.clipsToBounds = true
    }
    func config(viewModel: NUMovieViewModel) {
        loadingIndicator.alpha = 1
        loadingIndicator.startAnimating()
        movieBannerImage.sd_setImage(with: viewModel.posterURLSmall) {[weak self](_, error, _, _) in
            guard let self = self else {return}
            self.loadingIndicator.stopAnimating()
            self.loadingIndicator.alpha = 0
        }
    }
}
