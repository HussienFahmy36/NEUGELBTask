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
    var isSearching : Bool{
        return !(searchTextField.text?.isEmpty ?? true)
    }
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
        fetchNextPage()
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

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if shouldFetchNextPage(cellIndex: indexPath.row) {
            fetchNextPage()
        }
    }
}

// Pagination methods
extension NUHomeViewController {
    private func shouldFetchNextPage(cellIndex: Int) -> Bool {
        return ((cellIndex == 0) && !isSearching) ? true : ((cellIndex == (dataSourceArray.count - 1)) && !isSearching)
    }

    private func fetchNextPage() {
        viewModel.fetchNextPage {[weak self] (movies, error) in
            guard let self = self else {return}
            self.renderMoviesList(moviesViewModels: movies)
        }
    }

    private func renderMoviesList(moviesViewModels: [NUMovieViewModel] ) {
        dataSourceArray = moviesViewModels
        DispatchQueue.main.async {[weak self] in
            guard let self = self else {return}
            var indexPaths: [IndexPath] = []
            for (index, _) in moviesViewModels.enumerated() {
                indexPaths.append(IndexPath(row: index, section: 0))
            }
            self.collectionView.insertItems(at: indexPaths)
        }
    }
}

//search
extension NUHomeViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
    
    }
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let keyword = textField.text else {
            return
        }
        viewModel.search(keyword: keyword) { [weak self](movies, error) in
            guard let self = self else {return}
            self.renderMoviesList(moviesViewModels: movies)
        }
    }
}
