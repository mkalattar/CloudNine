//
//  Product.swift
//  CloudNine
//
//  Created by Mohamed Attar on 25/03/2025.
//

import Foundation

// MARK: - Product
struct Product: Codable {
    let id: Int?
    let title: String?
    let price: Double?
    let description, category: String?
    let image: String?
    let rating: Rating?
}

