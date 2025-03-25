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
    func updateProductEntity(with items: [Product])
}

struct CoreDataManager: CoreDataManagerProtocol {
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func fetchData<T: NSManagedObject>(of type: T.Type) -> [T] {
        let request = T.fetchRequest() as! NSFetchRequest<T>
        let dataReturned = try? context.fetch(request)
        
        return dataReturned ?? []
    }
}


extension CoreDataManager {
    func updateProductEntity(with items: [Product]) {
        context.perform {
            
            let fetchRequest = Product.fetchRequest()
            let ids = items.map { $0.id }
            
            fetchRequest.predicate = NSPredicate(format: "id IN %@", ids)
            let existingProducts = try? context.fetch(fetchRequest)
            
            var existingProductsDict = [String: Product]()
            existingProducts?.forEach { existingProductsDict["\($0.id)"] = $0 }
            
            for item in items {
                if let existingProduct = existingProductsDict["\(item.id)"] {
                    
                    existingProduct.title = item.title
                    existingProduct.price = item.price
                    existingProduct.category = item.category
                    existingProduct.desc = item.desc
                    existingProduct.id = item.id
                    existingProduct.imageURL = item.imageURL
                    existingProduct.orderNumber = item.orderNumber
                    existingProduct.rateCount = item.rateCount
                    existingProduct.rating = item.rating
                    
                } else {
                    let newProduct = Product(context: context)
                    
                    newProduct.price = item.price
                    newProduct.category = item.category
                    newProduct.desc = item.desc
                    newProduct.id = item.id
                    newProduct.imageURL = item.imageURL
                    newProduct.orderNumber = item.orderNumber
                    newProduct.rateCount = item.rateCount
                    newProduct.rating = item.rating
                    newProduct.price = item.price
                }
            }
            
            let fetchAllRequest: NSFetchRequest<Product> = Product.fetchRequest()
            if let allProducts = try? context.fetch(fetchAllRequest) {
                let productsToDelete = allProducts.filter { !ids.contains($0.id) }
                productsToDelete.forEach { context.delete($0) }
            }
            
            try? context.save()
        }
    }
}
