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
        let context = persistentContainer.viewContext
        
        try await context.perform {
            
            self.delete(entityName: "Product")
            
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
    
    func delete(entityName: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try persistentContainer.viewContext.execute(deleteRequest)
        } catch let error as NSError {
            debugPrint(error)
        }
    }
}
