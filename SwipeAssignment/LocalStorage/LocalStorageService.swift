//  LocalStorageService.swift

import Foundation
import CoreData

// class responsible for managing local storage operations using CoreData
// This service handles CRUD operations for product data persistence
class LocalStorageService {
    /// Shared instance for singleton implementation
    static let shared = LocalStorageService()
    
    /// CoreData persistent container
    private let container: NSPersistentContainer
    /// Name of the CoreData model file
    private let containerName = "ProductStore"
    /// Name of the entity in CoreData model
    private let entityName = "LocalProduct"
    
    /// Private initializer to ensure singleton pattern
    private init() {
        print("LocalStorageService: Initializing Core Data stack")
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { description, error in
            if let error = error {
                print("❌ Error loading Core Data: \(error)")
            } else {
                print("Core Data stack successfully initialized")
            }
        }
    }
    
    /// Creates a new product entry in CoreData
    /// - Parameters:
    ///   - name: Name of the product
    ///   - type: Type/category of the product
    ///   - price: Price of the product
    ///   - tax: Tax amount for the product
    ///   - imageData: Optional image data associated with the product
    func createLocalProduct(name: String, type: String, price: Double, tax: Double, imageData: Data?) {
        let product = NSEntityDescription.insertNewObject(forEntityName: entityName, into: container.viewContext)
        product.setValue(name, forKey: "productName")
        product.setValue(type, forKey: "productType")
        product.setValue(price, forKey: "price")
        product.setValue(tax, forKey: "tax")
        product.setValue(imageData, forKey: "imageData")
        
        save()
        print("Successfully created product: \(name)")
    }
    
    /// Retrieves all stored products from CoreData
    /// - Returns: Array of LocalProduct objects
    func getLocalProducts() -> [LocalProduct] {
        let request = NSFetchRequest<LocalProduct>(entityName: entityName)
        
        do {
            let products = try container.viewContext.fetch(request)
            print("Successfully fetched \(products.count) products")
            return products
        } catch {
            print("Error fetching products: \(error)")
            return []
        }
    }
    
    /// Deletes a specific product from CoreData
    /// - Parameter product: The LocalProduct object to be deleted
    func deleteLocalProduct(_ product: LocalProduct) {
        print("🗑️ Deleting product")
        container.viewContext.delete(product)
        save()
        print("✅ Product successfully deleted")
    }
    
    /// Private helper method to save changes to CoreData context
    private func save() {
        do {
            try container.viewContext.save()
            print("✅ Changes saved successfully")
        } catch {
            print("❌ Error saving to Core Data: \(error)")
        }
    }
}
