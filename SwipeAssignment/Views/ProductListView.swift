// ProductListView.swift
//
// This view represents the main product listing screen of the application.
// It displays a grid of products with search functionality and a floating action button to add new products.

import SwiftUI

struct ProductListView: View {
    // StateObject to manage the product list data and logic
    @StateObject var viewModel = ProductListViewModel()
    // State variable to control the presentation of the add product sheet
    @State private var showAddProduct = false

    // Define grid layout with two flexible columns
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    // Search bar component for filtering products
                    SearchBar(searchText: $viewModel.searchText)
                    
                    if viewModel.isLoading {
                        // Show loading indicator while fetching products
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                    } else {
                        // Product grid displaying all products in a scrollable layout
                        ScrollView {
                            LazyVGrid(columns: columns, spacing: 10) {
                                ForEach(viewModel.filteredProducts) { product in
                                    // Individual product card with favorite toggle functionality
                                    ProductCardView(product: product) {
                                        viewModel.toggleFavorite(product)
                                    }
                                }
                                .padding(2)
                            }
                            .padding(.horizontal, 8)
                        }
                        .padding(.top)
                    }
                }
                
                // Floating action button to add new products
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: { showAddProduct = true }) {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .frame(width: 60, height: 60)
                                .foregroundColor(.blue)
                                .background(Color.white)
                                .clipShape(Circle())
                                .shadow(radius: 4)
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Products")
            .fullScreenCover(isPresented: $showAddProduct) {
                AddProductView()
            }
        }
        .onAppear {
            // Fetch products when view appears
            viewModel.fetchProducts()
        }
    }
}

// Search bar component for filtering products
struct SearchBar: View {
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            // Search icon
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            // Search input field
            TextField("Search products", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            // Clear search button
            if !searchText.isEmpty {
                Button(action: { searchText = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    ProductListView()
}
