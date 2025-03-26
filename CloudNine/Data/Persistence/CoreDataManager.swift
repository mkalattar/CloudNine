//
//  CoreDataManager.swift
//  CloudNine
//
//  Created by Mohamed Attar on 25/03/2025.
//

import CoreData
import UIKit

protocol CoreDataManagerProtocol {
    var mainContext: NSManagedObjectContext { get }
    
    func fetchProducts() -> [Product]
    func saveProducts(from response: [ProductResponse]) async throws 
}

final class CoreDataManager: CoreDataManagerProtocol {
    
    private let persistentContainer: NSPersistentContainer
    var mainContext: NSManagedObjectContext { persistentContainer.viewContext }
    
    init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Could not retrieve AppDelegate")
        }
        self.persistentContainer = appDelegate.persistentContainer
    }
}

// MARK: - Product Methods
extension CoreDataManager {
    
    func saveProducts(from response: [ProductResponse]) async throws {
        let context = persistentContainer.newBackgroundContext()
        
        try await context.perform {
            
            let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
            let existingProducts = try context.fetch(fetchRequest)
            existingProducts.forEach { context.delete($0) }
            
            for (index, productResponse) in response.enumerated() {
                let storageProduct = Product(context: context)
                storageProduct.title       = productResponse.title
                storageProduct.price       = productResponse.price ?? 0.0
                storageProduct.category    = productResponse.category
                storageProduct.desc        = productResponse.description
                storageProduct.imageURL    = productResponse.image
                storageProduct.orderNumber = Int64(index)
                storageProduct.rateCount   = Int64(productResponse.rating?.count ?? 0)
                storageProduct.rating      = productResponse.rating?.rate ?? 0.0
            }
        
            try context.save()
        }
    }
    
    
    func fetchProducts() -> [Product] {
        let request = Product.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(Product.orderNumber), ascending: true)]
        
        return (try? mainContext.fetch(request)) ?? []
    }
    
    private func updateStorageProduct(_ storageProduct: Product, with productResponse: ProductResponse, index: Int) {
        storageProduct.title       = productResponse.title
        storageProduct.price       = productResponse.price ?? 0.0
        storageProduct.category    = productResponse.category
        storageProduct.desc        = productResponse.description
        storageProduct.imageURL    = productResponse.image
        storageProduct.orderNumber = Int64(index)
        storageProduct.rateCount   = Int64(productResponse.rating?.count ?? 0)
        storageProduct.rating      = productResponse.rating?.rate ?? 0.0
    }
}
