//
//  NetworkError.swift
//  ProductsApp
//
//  Created by Daler Xudoyarov on 13.12.2025.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case decodingFailed
    case badRequest        // 400
    case unauthorized      // 401
    case forbidden         // 403
    case notFound          // 404
    case serverError
}

