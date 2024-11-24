// ProductCardView.swift
//
// This view represents an individual product card in the grid.
// It displays product details including image, name, type, price, and favorite status.

import SwiftUI

struct ProductCardView: View {
    // Product model to display
    var product: Product
    // Closure to handle favorite button tap
    let onFavorite: () -> Void
    
    var body: some View {
        VStack(spacing: 5) {
            // Asynchronously load and display product image
            AsyncImage(url: URL(string: product.image ?? "" )) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 170, height: 170)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            } placeholder: {
                // Placeholder image while loading
                Image(systemName: "photo")
                    .resizable()
                    .foregroundColor(.gray)
                    .frame(width: 40, height: 30)
            }
            .frame(width: 170, height: 170)
            
            // Product details section
            VStack(alignment: .leading) {
                // Product name
                Text(product.product_name)
                    .font(.headline)
                // Product type
                Text(product.product_type)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                HStack{
                    // Price and tax information
                    VStack(alignment: .leading){
                        Text("Price: ₹\(String(format: "%.2f", product.price))")
                            .font(.subheadline)
                        
                        Text("Tax: \(String(format: "%.1f", product.tax))%")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    // Favorite toggle button
                    Button(action: onFavorite) {
                        Image(systemName: product.isFavorite ? "heart.fill" : "heart")
                            .foregroundColor(product.isFavorite ? .red : .gray)
                            .font(.title2)
                    }
                }
                .frame(width: UIScreen.main.bounds.width / 2.45, alignment: .leading)
            }
        }
        // Card styling
        .frame(width: UIScreen.main.bounds.width / 2.2, height: UIScreen.main.bounds.height / 3.15)
        .background(.ultraThickMaterial)
        .cornerRadius(10)
        .overlay(RoundedRectangle(cornerRadius: 10)
            .stroke(Color.black.opacity(0.4)))
    }
}
