//
//  NetworkService.swift
//  Shopflow
//
//  Created by Rodrigo Cerqueira Reis on 02/10/25.
//

import Foundation

protocol NetworkServiceProtocol {
    func fetchProducts() async throws -> [Product]
}

final class NetworkService: NetworkServiceProtocol {
    
    private let session: URLSession
    private let decoder: JSONDecoder
    
    enum APIError: Error, LocalizedError {
        case invalidURL
        case requestFailed(Error)
        case invalidResponse
        case decodingError(Error)
        
        var errorDescription: String? {
            switch self {
            case .invalidURL: return "The URL provided was invalid."
            case .requestFailed(let error): return "The request failed: \(error.localizedDescription)"
            case .invalidResponse: return "Received an invalid response from the server."
            case .decodingError(let error): return "Failed to decode the response: \(error.localizedDescription)"
            }
        }
    }
    
    init(session: URLSession = .shared, decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
    }
    
    func fetchProducts() async throws -> [Product] {
        guard let url = URL(string: "https://fakestoreapi.com/products") else {
            throw APIError.invalidURL
        }
        
        do {
            let (data, response) = try await session.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw APIError.invalidResponse
            }
            
            let products = try decoder.decode([Product].self, from: data)
            return products
            
        } catch let error as APIError {
            throw error
        } catch {
            throw APIError.requestFailed(error)
        }
    }
}
