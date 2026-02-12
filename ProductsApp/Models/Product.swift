//
//  Product.swift
//  ProductsApp
//
//  Created by Daler Xudoyarov on 13.12.2025.
//

import Foundation

struct Product: Codable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let image: String
}
