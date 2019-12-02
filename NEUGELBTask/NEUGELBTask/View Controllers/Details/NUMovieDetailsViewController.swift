//
//  NUMovieDetailsViewController.swift
//  NEUGELBTask
//
//  Created by Hussien Gamal Mohammed on 12/2/19.
//  Copyright © 2019 NEUGELB. All rights reserved.
//

import UIKit
import SDWebImage

class NUMovieDetailsViewController: UIViewController {

    @IBOutlet weak var moviePosterImage: UIImageView!
    @IBOutlet weak var movieDetailsView: UIView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieDescriptionLabel: UILabel!

    var viewModel: NUMovieViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }

    private func config() {
        moviePosterImage.sd_setImage(with: viewModel?.posterURLMedium) {[weak self](_, error, _, _) in
        }
        guard let titleLabel = viewModel?.title, let descriptionLabel = viewModel?.description else {
            return
        }
        movieTitleLabel.text = titleLabel
        movieDescriptionLabel.text = descriptionLabel
        
    }


}
