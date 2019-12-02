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
    let indicator = UIActivityIndicatorView(style: .large)

    var viewModel: NUMovieViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        initalizeView()
    }

    private func initalizeView() {
        setupBackgroundViewColor()
        addLoadingIndicator()
        initDetailsLabels()
        initMovieDetailsView()
        loadPosterImage()
    }

    private func initMovieDetailsView() {
        initailDetailsYPos = movieDetailsView.frame.origin.y
        movieDetailsView.transform = CGAffineTransform(translationX: 0, y: view.frame.height + movieDetailsView.frame.height)
    }

    private func loadPosterImage() {
        indicator.startAnimating()
        moviePosterImage.sd_setImage(with: viewModel?.posterURLOriginal) {[weak self] (_, _, _, _) in
            guard let self = self else {
                return
            }
            self.animatePosterImage {[weak self] in
                guard let self = self else {return}
                self.moveUpDetailsView()
                self.indicator.stopAnimating()
            }
        }
    }

    private func initDetailsLabels() {
        guard let titleLabel = viewModel?.title, let descriptionLabel = viewModel?.description,
            let rateValue = viewModel?.rate else {
            return
        }
        movieTitleLabel.text = titleLabel
        movieDescriptionLabel.text = descriptionLabel
        rateLabel.text = "Rate: \(rateValue)"
        movieTitleLabel.alpha = 0
        movieDescriptionLabel.alpha = 0
        rateLabel.alpha = 0
    }

    private func addLoadingIndicator() {
        indicator.color = .white
        view.addSubview(indicator)
        indicator.center = view.center
    }

    private func setupBackgroundViewColor() {
        view.backgroundColor = UIColor(white: 0, alpha: 0.7)
    }

    private func animatePosterImage(completion: @escaping () -> ()) {
        moviePosterImage.alpha = 0
        self.moviePosterImage.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        UIView.animate(withDuration: 0.5) {[weak self] in
            guard let self = self else {
                return
            }
            self.moviePosterImage.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.moviePosterImage.alpha = 1
            completion()
        }
    }

    private func moveUpDetailsView() {
        UIView.animate(withDuration: 0.7, animations: {[weak self] in
            guard let self = self else {return}
            self.movieDetailsView.transform = CGAffineTransform(translationX: 0, y: 0)

        }, completion: {(finished) in
            if finished {
                UIView.animate(withDuration: 0.3) {[weak self] in
                    guard let self = self else {return}
                    self.movieTitleLabel.alpha = 1
                    self.movieDescriptionLabel.alpha = 1
                    self.rateLabel.alpha = 1
                }
            }
        })
    }

}
