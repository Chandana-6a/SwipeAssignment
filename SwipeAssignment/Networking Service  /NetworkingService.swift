//  NetworkError.swift

import Foundation

/// Custom error types for network operations
enum NetworkError: Error {
    case invalidURL        // URL formation failed
    case noData           // No data received from server
    case decodingError    // JSON parsing failed
    case serverError(String)  // Server returned an error
}

/// Service class handling all network operations
class NetworkingService {
    /// Shared instance for singleton pattern
    static let shared = NetworkingService()
    /// Base URL for the API endpoints
    private let baseURL = "https://app.getswipe.in/api/public"
    
    /// Private initializer to enforce singleton pattern
    private init() {}
    
    /// Fetches all products from the server
    /// - Returns: Array of Product objects
    /// - Throws: NetworkError if the request fails
    func fetchProducts() async throws -> [Product] {
        guard let url = URL(string: "\(baseURL)/get") else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        // Verify HTTP response is successful
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError("Server Error")
        }
        
        do {
            let products = try JSONDecoder().decode([Product].self, from: data)
            return products
        } catch {
            throw NetworkError.decodingError
        }
    }
    
    /// Adds a new product to the server
    /// - Parameters:
    ///   - name: Product name
    ///   - type: Product type
    ///   - price: Product price
    ///   - tax: Product tax rate
    ///   - imageData: Optional image data for the product
    ///   - id: UUID for the product
    /// - Returns: AddProductResponse containing server response
    /// - Throws: NetworkError if the request fails
    func addProduct(name: String, type: String, price: Double, tax: Double, imageData: Data?, id: UUID) async throws -> AddProductResponse {
        guard let url = URL(string: "\(baseURL)/add") else {
            throw NetworkError.invalidURL
        }
        
        // Setup multipart form data request
        let boundary = "Boundary-\(UUID().uuidString)"
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var bodyData = Data()
        
        // Add text fields to form data
        let textFields: [String: String] = [
            "product_name": name,
            "product_type": type,
            "price": String(price),
            "tax": String(tax),
            "id": id.uuidString  // Include the UUID in the request
        ]
        
        // Append text fields to body
        for (key, value) in textFields {
            bodyData.append("--\(boundary)\r\n".data(using: .utf8)!)
            bodyData.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            bodyData.append("\(value)\r\n".data(using: .utf8)!)
        }
        
        // Append image data if available
        if let imageData = imageData {
            bodyData.append("--\(boundary)\r\n".data(using: .utf8)!)
            bodyData.append("Content-Disposition: form-data; name=\"files[]\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
            bodyData.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            bodyData.append(imageData)
            bodyData.append("\r\n".data(using: .utf8)!)
        }
        
        bodyData.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = bodyData
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Verify HTTP response is successful
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError("Server Error")
        }
        
        return try JSONDecoder().decode(AddProductResponse.self, from: data)
    }
}
