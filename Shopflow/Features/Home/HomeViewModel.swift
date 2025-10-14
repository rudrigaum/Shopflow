//
//  HomeViewModel.swift
//  Shopflow
//
//  Created by Rodrigo Cerqueira Reis on 02/10/25.
//

import Foundation

protocol HomeViewModelDelegate: AnyObject {
    func didUpdateState(to state: HomeViewModel.State)
}

final class HomeViewModel {
    
    // MARK: - State
    enum State {
        case idle
        case loading
        case success(products: [Product])
        case error(message: String)
    }
    
    // MARK: - Properties
    weak var delegate: HomeViewModelDelegate?
    private let networkService: NetworkServiceProtocol
    
    private(set) var state: State = .idle {
        didSet {
            self.delegate?.didUpdateState(to: state)
        }
    }
    
    // MARK: - Initializer
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    // MARK: - Public Methods
    func fetchProducts() {
        self.state = .loading
        
        Task {
            do {
                let products = try await networkService.fetchProducts()
                await MainActor.run {
                    self.state = .success(products: products)
                }
            } catch {
                await MainActor.run {
                    self.state = .error(message: error.localizedDescription)
                }
            }
        }
    }
}
