//
//  ViewController.swift
//  NEUGELBTask
//
//  Created by Hussien Gamal Mohammed on 11/30/19.
//  Copyright © 2019 NEUGELB. All rights reserved.
//

import UIKit

class NUHomeViewController: UIViewController {

    let viewModel = NUHomeViewModel()
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var contextTitleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    var dataSourceArray: [NUMovieViewModel] = []
    var searchMode: Bool = false {
        willSet(newValue) {
            if newValue {
                self.contextTitleLabel.text = "Search results"
            } else {
                self.contextTitleLabel.text = "Now playing"
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

    }

    func setupUI() {
        collectionView.dataSource = self
        collectionView.delegate = self
        searchTextField.delegate = self
        contextTitleLabel.text = "Now playing"
        loadingIndicator.startAnimating()
        viewModel.nowPlaying(pageIndex: 1) { (_, error) in
            DispatchQueue.main.async {[weak self] in
                guard let self = self else {
                    return
                }
                self.dataSourceArray = self.viewModel.movies
                self.loadingIndicator.stopAnimating()
                self.loadingIndicator.alpha = 0
                self.collectionView.reloadData()
            }
        }
    }

}

extension NUHomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NUMovieCell", for: indexPath) as? NUMovieCell else {
            return UICollectionViewCell()
        }
        cell.config(viewModel: dataSourceArray[indexPath.row])
        return cell
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSourceArray.count
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigateToDetails(movieModel: dataSourceArray[indexPath.row])
    }

    private func navigateToDetails(movieModel: NUMovieViewModel) {
        guard let detailsViewController = storyboard?.instantiateViewController(identifier: "NUMovieDetailsViewController") as? NUMovieDetailsViewController else {
            return
        }
        detailsViewController.viewModel = movieModel
        present(detailsViewController, animated: true, completion: nil)
    }
}


extension NUHomeViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        loadingIndicator.alpha = 1
        loadingIndicator.startAnimating()
        if textField.text?.isEmpty ?? true {
            viewModel.nowPlaying(pageIndex: 1, completion: { (_, error) in
                DispatchQueue.main.async {[weak self] in
                    guard let self = self else {
                        return
                    }
                    self.searchMode = false
                    self.dataSourceArray = self.viewModel.movies
                    self.loadingIndicator.stopAnimating()
                    self.collectionView.reloadData()
                }
            })
        } else {
            viewModel.search(keyword: textField.text ?? "") { (_, error) in
                DispatchQueue.main.async {[weak self] in
                    guard let self = self else {
                        return
                    }
                    self.searchMode = true
                    self.dataSourceArray = self.viewModel.searchResultMovies
                    if self.viewModel.searchResultMovies.count == 0 {
                        self.contextTitleLabel.text = "No results"
                    }
                    self.loadingIndicator.stopAnimating()
                    self.collectionView.reloadData()
                }
            }
        }
    }
}
