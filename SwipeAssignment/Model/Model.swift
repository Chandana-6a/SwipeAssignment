//  Model.swift

import Foundation

// This model conforms to Identifiable for SwiftUI list rendering and Codable for JSON parsing
struct Product: Identifiable, Codable {
    /// Unique identifier for the product
    let id: UUID
    /// Optional URL string for the product image
    let image: String?
    /// Price of the product
    let price: Double
    /// Name of the product
    let product_name: String
    /// Type/category of the product
    let product_type: String
    /// Tax rate applicable to the product
    let tax: Double
    /// Whether the product is marked as favorite by the user
    var isFavorite: Bool = false
    
    // CodingKeys enum to map JSON keys to struct properties
    enum CodingKeys: String, CodingKey {
        case image, price, product_name, product_type, tax
        case id
        case isFavorite
    }
    
    // Custom decoder implementation to handle optional fields and set default values
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        image = try container.decodeIfPresent(String.self, forKey: .image)
        price = try container.decode(Double.self, forKey: .price)
        product_name = try container.decode(String.self, forKey: .product_name)
        product_type = try container.decode(String.self, forKey: .product_type)
        tax = try container.decode(Double.self, forKey: .tax)
        id = UUID()
        isFavorite = false
    }
}

// Response model for the add product API
struct AddProductResponse: Codable {
    /// Success/failure message from the server
    let message: String
    /// Details of the added product (optional)
    let product_details: Product?
    /// ID assigned to the new product
    let product_id: Int
    /// Indicates if the operation was successful
    let success: Bool
}

// Enumeration of available product types in the application
enum ProductType: String, CaseIterable {
    case product = "Product"
    case service = "Book"
    case electronics = "Electronics"
    case grocery = "Grocery"
    case other = "Other"
}
