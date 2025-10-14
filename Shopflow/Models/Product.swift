//
//  Product.swift
//  Shopflow
//
//  Created by Rodrigo Cerqueira Reis on 02/10/25.
//

import Foundation

struct Product: Codable, Hashable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let category: String
    let image: String
}
