//
//  HomeViewController.swift
//  Shopflow
//
//  Created by Rodrigo Cerqueira Reis on 26/09/25.
//

import Foundation
import UIKit

final class HomeViewController: UIViewController {
    
    // MARK: - Properties
    private var homeView: HomeView? {
        return self.view as? HomeView
    }
    
    private let viewModel: HomeViewModel
    private var products: [Product] = []
    
    // MARK: - Initializer
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    override func loadView() {
        self.view = HomeView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupViewModel()
    }
    
    // MARK: - Private Methods
    private func setupView() {
        title = "Shopflow"
        homeView?.collectionView.dataSource = self
        homeView?.collectionView.delegate = self
    }
    
    private func setupViewModel() {
        viewModel.delegate = self
        viewModel.fetchProducts()
    }
}

// MARK: - HomeViewModelDelegate
extension HomeViewController: HomeViewModelDelegate {
    func didUpdateState(to state: HomeViewModel.State) {
        switch state {
        case .idle, .loading:
            break
        case .success(let products):
            self.products = products
            self.homeView?.collectionView.reloadData()
        case .error:
            self.products = []
            self.homeView?.collectionView.reloadData()
        }
    }
}

// MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.identifier, for: indexPath) as? ProductCell else {
            return UICollectionViewCell()
        }
        let product = products[indexPath.item]
        cell.configure(with: product)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 16
        let collectionViewSize = collectionView.frame.size.width - padding * 3
        let width = collectionViewSize / 2
        let height = width * 1.5
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}
