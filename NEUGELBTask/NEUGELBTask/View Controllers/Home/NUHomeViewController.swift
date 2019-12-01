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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

    }

    func setupUI() {
        collectionView.register(NUMovieCell.self, forCellWithReuseIdentifier: "NUMovieCell")
    }

}

extension NUHomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NUMovieCell", for: indexPath)
        return cell
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.movies.count
    }
}
