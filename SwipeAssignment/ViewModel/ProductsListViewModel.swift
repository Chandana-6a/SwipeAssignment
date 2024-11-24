
//  ProductsListViewModel.swift

import Foundation
import Combine

// ViewModel for the products list screen
class ProductListViewModel: ObservableObject {
    /// Published properties that the view can observe
    @Published var products: [Product] = []
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    /// Holds all products before filtering
    private var allProducts: [Product] = []
    
    init() {
        
    }
    
    /// Computed property that filters products based on search text
    var filteredProducts: [Product] {
        if searchText.isEmpty {
            return allProducts
        }
        let filtered = allProducts.filter { $0.product_name.lowercased().contains(searchText.lowercased()) }
        print(" Search filter applied: '\(searchText)'")
        return filtered
    }
    
    /// Fetches products from the server
    func fetchProducts() {
        isLoading = true
        
        Task {
            do {
                let fetchedProducts = try await NetworkingService.shared.fetchProducts()
                
                DispatchQueue.main.async {
                    print("✅ Successfully fetched \(fetchedProducts.count) products")
                    
                    self.allProducts = fetchedProducts
                    self.products = fetchedProducts
                    self.isLoading = false
                    
                }
            } catch {
                print("❌ Error fetching products: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
    
    /// Toggles the favorite status of a product
    /// - Parameter product: The product to toggle favorite status for
    func toggleFavorite(_ product: Product) {
        
        if let index = allProducts.firstIndex(where: { $0.id == product.id }) {
            let newStatus = !allProducts[index].isFavorite
            allProducts[index].isFavorite = newStatus
            sortProducts()
        } else {
        }
    }
    
    /// Sorts products to show favorites at the top
    private func sortProducts() {
        let favoriteCount = allProducts.filter { $0.isFavorite }.count
        products = allProducts.sorted { $0.isFavorite && !$1.isFavorite }
    }
}
