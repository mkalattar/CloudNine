//
//  HomeViewModel.swift
//  CloudNine
//
//  Created by Mohamed Attar on 24/03/2025.
//

import Combine

protocol HomeViewModelProtocol {
    
    // Actions
    func fetchProducts(incrementPagination: Bool) async
    func viewDidLoad()
    func changeLayoutStyle()
    func getCurrentLayoutStyle() -> LayoutStyle
    
    // Outputs
    var productsPublisher: Published<[ProductResponse]?>.Publisher { get }
    var isLoadingPublisher: Published<Bool?>.Publisher { get }
    var isShimmeringPublisher: Published<Bool?>.Publisher { get }
    var errorMessagePublisher: Published<String?>.Publisher { get }
}

class HomeViewModel: HomeViewModelProtocol {
    var homeRepo: HomeRepoProtocol
    var userDefaultManager: UserDefaultsManagerProtocol
    var paginationNumber: Int = 7
    
    @Published var products: [ProductResponse]?
    @Published var isLoading: Bool?
    @Published var isShimmering: Bool?
    @Published var errorMessage: String?
    
    var productsPublisher: Published<[ProductResponse]?>.Publisher { $products }
    var isLoadingPublisher: Published<Bool?>.Publisher { $isLoading }
    var isShimmeringPublisher: Published<Bool?>.Publisher { $isShimmering }
    var errorMessagePublisher: Published<String?>.Publisher { $errorMessage }
    
    init(homeRepo: HomeRepoProtocol, userDefaultManager: UserDefaultsManagerProtocol) {
        self.homeRepo = homeRepo
        self.userDefaultManager = userDefaultManager
    }
    
    func viewDidLoad() {
        Task {
            isShimmering = true
            await fetchProducts()
        }
    }
    
    func changeLayoutStyle() {
        if userDefaultManager.value(forKey: "isLayoutStyleGrid") == true {
            userDefaultManager.save(false, forKey: "isLayoutStyleGrid")
        } else {
            userDefaultManager.save(true, forKey: "isLayoutStyleGrid")
        }
    }
    
    func getCurrentLayoutStyle() -> LayoutStyle {
        return (userDefaultManager.value(forKey: "isLayoutStyleGrid") == true ? .grid : .list)
    }
    
    func fetchProducts(incrementPagination: Bool = false) async {
        if isShimmering == false {
            isLoading = true
        }
        
        do {
            self.isShimmering = false
            self.isLoading = false
            
            products = try await homeRepo.fetchProducts(limit: paginationNumber)
            
            if incrementPagination {
                paginationNumber+=7
            }
            
        } catch {
            products = homeRepo.fetchCache()
            self.errorMessage = error.localizedDescription
            self.isLoading = false
        }
    }
}
