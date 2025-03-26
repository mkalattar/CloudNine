//
//  Product.swift
//  CloudNine
//
//  Created by Mohamed Attar on 25/03/2025.
//

import Foundation

// MARK: - Product
struct ProductResponse: Codable, Hashable, Equatable {
    static func == (lhs: ProductResponse, rhs: ProductResponse) -> Bool {
        lhs.uniqueID == rhs.uniqueID
    }
    
    let uniqueID = UUID()
    func hash(into hasher: inout Hasher) {
        hasher.combine(uniqueID)
    }
    
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

