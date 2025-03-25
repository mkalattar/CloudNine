//
//  CoreDataManager.swift
//  CloudNine
//
//  Created by Mohamed Attar on 25/03/2025.
//

import CoreData
import UIKit

protocol CoreDataManagerProtocol {
    var context: NSManagedObjectContext { get }
    func fetchData<T: NSManagedObject>(of type: T.Type) -> [T]
    
    func updateProductEntity(with items: [ProductResponse])
    func saveProducts(_ products: [ProductResponse])
}

struct CoreDataManager: CoreDataManagerProtocol {
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func fetchData<T: NSManagedObject>(of type: T.Type) -> [T] {
        let request = T.fetchRequest() as! NSFetchRequest<T>
        let dataReturned = try? context.fetch(request)
        
        return dataReturned ?? []
    }
}

// MARK: - Product Methods
extension CoreDataManager {
    
    func saveProducts(_ products: [ProductResponse]) {
        context.perform {
            for (index, productResponse) in products.enumerated() {
                let product = Product(context: self.context)
                product.title           = productResponse.title
                product.price           = productResponse.price ?? 0.0
                product.category        = productResponse.category
                product.desc            = productResponse.description
                product.id              = Int64(productResponse.id ?? 0)
                product.imageURL        = productResponse.image
                product.orderNumber     = Int64(index) // to make sure ordering is correct.
                product.rateCount       = Int64(productResponse.rating?.count ?? 0)
                product.rating          = productResponse.rating?.rate ?? 0.0
            }
            
            do {
                try self.context.save()
            } catch {
                print("Failed to save products: \(error)")
            }
        }
    }
    
    func updateProductEntity(with items: [ProductResponse]) {
        context.perform {
            
            let fetchRequest = Product.fetchRequest()
            let ids = items.map { $0.id }
            
            fetchRequest.predicate = NSPredicate(format: "id IN %@", ids)
            let existingProducts = try? context.fetch(fetchRequest)
            
            var existingProductsDict = [String: Product]()
            existingProducts?.forEach { existingProductsDict["\($0.id)"] = $0 }
            
            for (index, item) in items.enumerated() {
                if let existingProduct = existingProductsDict["\(item.id ?? 0)"] {
                    
                    existingProduct.title = item.title
                    existingProduct.price = item.price ?? 0.0
                    existingProduct.category = item.category
                    existingProduct.desc = item.description
                    existingProduct.id = Int64(item.id ?? 0)
                    existingProduct.imageURL = item.image
                    existingProduct.orderNumber = Int64(index)
                    existingProduct.rateCount = Int64(item.rating?.count ?? 0)
                    existingProduct.rating = item.rating?.rate ?? 0.0
                    
                } else {
                    let newProduct = Product(context: context)
                    
                    newProduct.title = item.title
                    newProduct.price = item.price ?? 0.0
                    newProduct.category = item.category
                    newProduct.desc = item.description
                    newProduct.id = Int64(item.id ?? 0)
                    newProduct.imageURL = item.image
                    newProduct.orderNumber = Int64(index)
                    newProduct.rateCount = Int64(item.rating?.count ?? 0)
                    newProduct.rating = item.rating?.rate ?? 0.0
                }
            }
            
            let fetchAllRequest: NSFetchRequest<Product> = Product.fetchRequest()
            
            if let allProducts = try? context.fetch(fetchAllRequest) {
                let productsToDelete = allProducts.filter { !ids.contains(Int($0.id)) }
                productsToDelete.forEach { context.delete($0) }
            }
            
            try? context.save()
        }
    }
}
