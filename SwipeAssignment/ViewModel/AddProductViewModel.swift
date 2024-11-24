//  AddProductViewModel.swift

import Foundation
import UIKit

// ViewModel for the add product screen
class AddProductViewModel: ObservableObject {
    
    /// Published properties that the view can observe
    @Published var productName: String = ""
    @Published var productType: ProductType = .product
    @Published var price: String = ""
    @Published var tax: String = ""
    @Published var selectedImage: UIImage?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var successMessage: String?
    
    init() {
        print("📱 AddProductViewModel initialized")
    }
    
    // Computed property to check if the form is valid
    var isFormValid: Bool {
        let valid = !productName.isEmpty &&
        !price.isEmpty &&
        !tax.isEmpty &&
        Double(price) != nil &&
        Double(tax) != nil
        
        print("🔍 Form validation status: \(valid)")
        if !valid {
            print("⚠️ Validation details:")
            if productName.isEmpty { print("- Product name is empty") }
            if price.isEmpty { print("- Price is empty") }
            if tax.isEmpty { print("- Tax is empty") }
            if Double(price) == nil && !price.isEmpty { print("- Invalid price format") }
            if Double(tax) == nil && !tax.isEmpty { print("- Invalid tax format") }
        }
        return valid
    }
    
    // Adds a new product to the server
    func addProduct() {
        print("🚀 Starting product addition process")
        
        // Validate form before submission
        guard isFormValid else {
            print("❌ Form validation failed")
            errorMessage = "Please fill all required fields with valid values"
            return
        }
        
        print("✅ Form validation passed")
        print("📝 Product Details:")
        print("- Name: \(productName)")
        print("- Type: \(productType.rawValue)")
        print("- Price: \(price)")
        print("- Tax: \(tax)")
        print("- Image included: \(selectedImage != nil ? "Yes" : "No")")
        
        isLoading = true
        print("⏳ Loading state activated")
        
        Task {
            do {
                // Convert image to JPEG data if available
                let imageData = selectedImage?.jpegData(compressionQuality: 0.8)
                print("🖼️ Image conversion completed - Size: \(imageData?.count ?? 0) bytes")
                
                // Call API to add product
                print("📡 Calling API to add product...")
                let response = try await NetworkingService.shared.addProduct(
                    name: productName,
                    type: productType.rawValue,
                    price: Double(price) ?? 0,
                    tax: Double(tax) ?? 0,
                    imageData: imageData,
                    id: UUID()
                )
                
                DispatchQueue.main.async {
                    print("✅ Product added successfully")
                    print("📬 Server response: \(response.message)")
                    self.successMessage = response.message
                    self.isLoading = false
                    self.resetForm()
                }
            } catch {
                print("❌ Error adding product: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
    
    // Resets the form to initial state
    private func resetForm() {
        print("🔄 Resetting form to initial state")
        productName = ""
        productType = .product
        price = ""
        tax = ""
        selectedImage = nil
        print("✨ Form reset completed")
    }
}
