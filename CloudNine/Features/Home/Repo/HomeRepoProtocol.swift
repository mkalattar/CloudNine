//
//  HomeRepoProtocol.swift
//  CloudNine
//
//  Created by Mohamed Attar on 24/03/2025.
//

protocol HomeRepoProtocol {
    func fetchProducts(limit: Int) async throws -> [Product]
}
