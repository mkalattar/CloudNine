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
    func getProducts() -> [ProductResponse]
    
    // Outputs
    var productsPublisher: Published<[ProductResponse]?>.Publisher { get }
    var isShimmeringPublisher: Published<Bool?>.Publisher { get }
    var errorMessagePublisher: Published<String?>.Publisher { get }
}

class HomeViewModel: HomeViewModelProtocol {
    var homeRepo: HomeRepoProtocol
    var nwPathManager: NetworkPathManager
    
    var paginationNumber: Int = 7
    
    @Published var products: [ProductResponse]?
    @Published var isShimmering: Bool?
    @Published var errorMessage: String?
    
    var productsPublisher: Published<[ProductResponse]?>.Publisher { $products }
    var isShimmeringPublisher: Published<Bool?>.Publisher { $isShimmering }
    var errorMessagePublisher: Published<String?>.Publisher { $errorMessage }
    
    var layoutStyle = LayoutStyle.grid
    
    init(homeRepo: HomeRepoProtocol, nwPathManager: NetworkPathManager) {
        self.homeRepo = homeRepo
        self.nwPathManager = nwPathManager
    }
    
    func viewDidLoad() {
        isShimmering = true
        nwPathManager.noConnectivityAction = {
            self.errorMessage = CloudNineError.poorOrNoConnection.localizedDescription
        }
        nwPathManager.startMonitoring()
        Task {
            await fetchProducts()
        }
    }
    
    func changeLayoutStyle() {
        if layoutStyle == .grid {
            layoutStyle = .list
        } else {
            layoutStyle = .grid
        }
        
//        if userDefaultManager.value(forKey: "isLayoutStyleGrid") == true {
//            userDefaultManager.save(false, forKey: "isLayoutStyleGrid")
//        } else {
//            userDefaultManager.save(true, forKey: "isLayoutStyleGrid")
//        }
    }
    
    func getCurrentLayoutStyle() -> LayoutStyle {
        return self.layoutStyle
//        return (userDefaultManager.value(forKey: "isLayoutStyleGrid") == true ? .grid : .list)
    }
    
    func fetchProducts(incrementPagination: Bool = false) async {
        
        do {
            self.isShimmering = false
            
            products = try await homeRepo.fetchProducts(limit: paginationNumber)
            
            if incrementPagination {
                paginationNumber+=7
            }
            
        } catch {
            self.isShimmering = false
            products = homeRepo.fetchCache()
            self.errorMessage = error.localizedDescription
        }
    }
    
    func getProducts() -> [ProductResponse] {
        return self.products ?? []
    }
}
