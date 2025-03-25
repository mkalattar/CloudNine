//
//  HomeRepo.swift
//  CloudNine
//
//  Created by Mohamed Attar on 24/03/2025.
//

import Foundation

struct HomeRepo: HomeRepoProtocol {
    
    var coreDataManager: CoreDataManagerProtocol
    var networkManager: NetworkManagerProtocol
    
    func fetchProducts(limit: Int) async throws -> [Product] {
        
        let products = try await networkManager.performRequest(
            with: NetworkRequestBuilder()
                .set(urlPath: .products)
                .set(httpMethod: .get)
                .addQueryParameters(["limit": "\(limit)"]),
            dataType: [ProductResponse].self
        )
        
        coreDataManager.updateProductEntity(with: products)
        
        return coreDataManager.fetchData(of: Product.self)
    }
}
