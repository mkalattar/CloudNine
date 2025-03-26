//
//  HomeRepo.swift
//  CloudNine
//
//  Created by Mohamed Attar on 24/03/2025.
//

import Foundation

protocol HomeRepoProtocol {
    func fetchProducts(limit: Int) async throws -> [ProductResponse]
    func fetchCache() -> [ProductResponse]?
}

struct HomeRepo: HomeRepoProtocol {
    
    var coreDataManager: CoreDataManagerProtocol
    var networkManager: NetworkManagerProtocol
    
    func fetchProducts(limit: Int) async throws -> [ProductResponse] { // to return both cached data and errors together
        
        do {
            let products = try await networkManager.performRequest(
                with: NetworkRequestBuilder()
                    .set(urlPath: .products)
                    .set(httpMethod: .get)
                    .addQueryParameters(["limit": "\(limit)"]),
                dataType: [ProductResponse].self
            )
            
            try? await coreDataManager.saveProducts(from: products ?? [])
            
            return products ?? []
        } catch {
            throw error as! CloudNineError
        }
    }
    
    func fetchCache() -> [ProductResponse]? {
        let productModels = coreDataManager.fetchProducts()
        return productModels.map { product in
            return ProductResponse(id: Int(product.id),
                                   title: product.title,
                                   price: product.price,
                                   description: product.description,
                                   category: product.category,
                                   image: product.imageURL,
                                   rating: Rating(rate: product.rating, count: Int(product.rateCount)))
        }
    }
}
