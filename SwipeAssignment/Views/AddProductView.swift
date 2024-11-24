// AddProductView.swift
//
// This view handles the creation of new products.
// It provides a form interface for users to input product details and upload an image.

import SwiftUI

struct AddProductView: View {
    // ViewModel to handle product creation logic
    @StateObject private var viewModel = AddProductViewModel()
    // Environment variable to handle view dismissal
    @Environment(\.presentationMode) var presentationMode
    // State variable to control image picker presentation
    @State private var showingImagePicker = false
    
    var body: some View {
        NavigationView {
            Form {
                // Product details section
                Section(header: Text("Product Details")) {
                    // Product name input
                    TextField("Product Name", text: $viewModel.productName)
                    
                    // Product type picker
                    Picker("Product Type", selection: $viewModel.productType) {
                        ForEach(ProductType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    
                    // Price input with currency symbol
                    TextField("Selling Price ₹", text: $viewModel.price)
                        .keyboardType(.decimalPad)
                    
                    // Tax rate input as percentage
                    TextField("Tax Rate (%)", text: $viewModel.tax)
                        .keyboardType(.decimalPad)
                }
                
                // Product image section
                Section(header: Text("Product Image")) {
                    HStack {
                        Spacer()
                        // Display selected image or placeholder
                        if let image = viewModel.selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 200)
                        } else {
                            Image(systemName: "photo")
                                .font(.system(size: 60))
                                .foregroundColor(.gray)
                                .frame(height: 200)
                        }
                        Spacer()
                    }
                    
                    // Image selection button
                    Button(action: { showingImagePicker = true }) {
                        HStack {
                            Image(systemName: "photo.fill")
                            Text(viewModel.selectedImage == nil ? "Select Image" : "Change Image")
                        }
                    }
                }
                
                // Submit section with loading state
                Section {
                    Button(action: {
                        viewModel.addProduct()
                    }) {
                        HStack {
                            Spacer()
                            if viewModel.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                            } else {
                                Text("Add Product")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                                    .bold()
                            }
                            Spacer()
                        }
                    }
                    .disabled(!viewModel.isFormValid || viewModel.isLoading)
                }
            }
            .navigationTitle("Add Product")
            // Navigation bar with dismiss button
            .navigationBarItems(
                trailing: Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark.circle")
                        .font(.title2)
                        .foregroundColor(.blue)
                        .padding()
                }
            )
            // Present image picker sheet
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $viewModel.selectedImage)
            }
            // Error alert
            .alert(item: $viewModel.errorMessage) { error in
                Alert(
                    title: Text("Error"),
                    
                    message: Text(error),
                    
                    dismissButton: .default(Text("OK"))
                )
            }
            // Success alert
            .alert(item: $viewModel.successMessage) { message in
                Alert(
                    title: Text("Success"),
                    message: Text(message),
                    dismissButton: .default(Text("OK")) {
                        presentationMode.wrappedValue.dismiss()
                    }
                )
            }
        }
    }
}

#Preview {
    AddProductView()
}

extension String: @retroactive Identifiable {
    public var id: String { self }
}
