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
    @IBOutlet weak var rateLabel: UILabel!
    var initailDetailsYPos: CGFloat = 0.0


    var viewModel: NUMovieViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }

    private func config() {
        moviePosterImage.sd_setImage(with: viewModel?.posterURLOriginal)
        guard let titleLabel = viewModel?.title, let descriptionLabel = viewModel?.description,
            let rateValue = viewModel?.rate else {
            return
        }
        movieTitleLabel.text = titleLabel
        movieDescriptionLabel.text = descriptionLabel
        rateLabel.text = "Rate: \(rateValue)"
        initailDetailsYPos = movieDetailsView.frame.origin.y
        movieDetailsView.transform = CGAffineTransform(translationX: 0, y: view.frame.height + movieDetailsView.frame.height)
    }


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.7, animations: {[weak self] in
            guard let self = self else {return}
            self.movieDetailsView.transform = CGAffineTransform(translationX: 0, y: 0)

        }, completion: nil)

    }
    

}
