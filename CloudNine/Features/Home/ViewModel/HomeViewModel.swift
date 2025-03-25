//
//  HomeViewModel.swift
//  CloudNine
//
//  Created by Mohamed Attar on 24/03/2025.
//

import Combine

protocol HomeViewModelProtocol {
    
    // Actions
    func fetchProducts() async
    
    // Outputs
    var productsPublisher: Published<[Product]?>.Publisher { get }
    var isLoadingPublisher: Published<Bool?>.Publisher { get }
    var errorMessagePublisher: Published<String?>.Publisher { get }
}

class HomeViewModel: HomeViewModelProtocol {
    var homeRepo: HomeRepoProtocol
    var paginationNumber: Int = 7
    
    @Published var products: [Product]?
    @Published var isLoading: Bool?
    @Published var errorMessage: String?
    
    var productsPublisher: Published<[Product]?>.Publisher { $products }
    var isLoadingPublisher: Published<Bool?>.Publisher { $isLoading }
    var errorMessagePublisher: Published<String?>.Publisher { $errorMessage }
    
    init(homeRepo: HomeRepoProtocol) {
        self.homeRepo = homeRepo
    }
    
    func fetchProducts() async {
        isLoading = true
        errorMessage = nil
        
        do {
            products = try await homeRepo.fetchProducts(limit: paginationNumber)
            self.isLoading = false
        } catch {
            self.errorMessage = error.localizedDescription
            self.isLoading = false
        }
        
    }
}
