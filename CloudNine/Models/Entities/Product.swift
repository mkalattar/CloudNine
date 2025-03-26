//
//  Product.swift
//  CloudNine
//
//  Created by Mohamed Attar on 25/03/2025.
//

import Foundation

// MARK: - Product
struct ProductResponse: Codable {
    let uuid = UUID()
    let id: Int?
    let title: String?
    let price: Double?
    let description, category: String?
    let image: String?
    let rating: Rating?
    
    enum CodingKeys: CodingKey {
        case id
        case title
        case price
        case description
        case category
        case image
        case rating
    }
}

extension ProductResponse: Hashable, Equatable {
    static func ==(lhs: ProductResponse, rhs: ProductResponse) -> Bool {
        return lhs.uuid == rhs.uuid
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}
