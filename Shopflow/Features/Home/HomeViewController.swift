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
        case .idle:
            break
        case .loading:
            print("State -> Loading...")
        case .success(let products):
            print("State -> Success: Received \(products.count) products!")
        case .error(let message):
            print("State -> Error: \(message)")
        }
    }
}
