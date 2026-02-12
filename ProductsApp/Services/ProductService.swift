//
//  ProductService.swift
//  ProductsApp
//
//  Created by Daler Xudoyarov on 13.12.2025.
//

import Foundation

final class ProductService {

    static let shared = ProductService()
    private init() {}

    func fetchProducts() async throws -> [Product] {
        guard let url = URL(string: "https://fakestoreapi.com/products") else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.serverError
        }
        switch httpResponse.statusCode {
        case 200...299:
            break
        case 400:
            throw NetworkError.badRequest
        case 401:
            throw NetworkError.unauthorized
        case 403:
            throw NetworkError.forbidden
        case 404:
            throw NetworkError.notFound
        case 500:
            throw NetworkError.serverError
        default:
            throw NetworkError.serverError
        }

        return try JSONDecoder().decode([Product].self, from: data)
    }
}
