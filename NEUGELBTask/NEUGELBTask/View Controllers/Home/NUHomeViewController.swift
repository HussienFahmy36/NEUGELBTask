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
        get {
            let searchTextNotEmpty = !(searchTextField.text?.isEmpty ?? true)
            if searchTextNotEmpty {
                self.contextTitleLabel.text = NUStringsConstants.searchResults
            } else {
                self.contextTitleLabel.text = NUStringsConstants.nowPlaying
            }
            return searchTextNotEmpty
        }
    }

    var dataSourceArray: [NUMovieViewModel] = []
    var searchMode: Bool = false {
        willSet(newValue) {
            if newValue {
                self.contextTitleLabel.text = NUStringsConstants.searchResults
            } else {
                self.contextTitleLabel.text = NUStringsConstants.nowPlaying
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
        return !isSearching && (cellIndex == (dataSourceArray.count - 1))
    }

    private func fetchNextPage() {
        viewModel.fetchNextPage {[weak self] (movies, error) in
            guard let self = self else {return}
            self.display(moviesViewModels: movies)
        }
    }

    private func display(moviesViewModels: [NUMovieViewModel] ) {
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
    func textFieldDidChangeSelection(_ textField: UITextField) {
        collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        guard let keyword = textField.text else {
            return
        }
        viewModel.search(keyword: keyword) { [weak self](movies, error) in
            guard let self = self else {return}
            self.display(moviesViewModels: movies)
        }
    }
}
