# iOS Product Management App

## Overview
This iOS application demonstrates key skills in building functional and visually appealing apps. It consists of two main screens:
1. **Product Listing Screen**: Displays a list of products with features like searching, scrolling, and marking products as favorites. It includes a button to navigate to the "Add Product" screen.
2. **Add Product Screen**: Enables users to add new products with details like name, type,selling price, tax rate, and an optional image


## Features

### Screen 1: Product Listing
- **Display Products**: List of products with details like name, type, price, and tax.
- **Search Functionality**: Users can search products by name.
- **Favorites**: Mark products as favorites to display them at the top of the list.
- **Image Handling**:
  - Load product images from URLs.
  - Use a default image if the URL is missing.
- **Navigation**: Button to navigate to the "Add Product" screen.
  
### Screen 2: Add Product 
- **Form Inputs**: Enter product details including:
  - Product Name
  - Product Type (Dropdown selection)
  - Selling Price
  - Tax Rate
  - Image (Optional)
- **Validation**: Ensure fields like product name and price are non-empty, and tax rate is a valid decimal number.
- **User Feedback**: Notify the user of success or errors after submission.
- **Image Picker**: Allow users to select or change images for the product.

## Technical Details
- **Architecture**: MVVM (Model-View-ViewModel).
- **Frameworks**: Swift, SwiftUI, CoreData.
- **Local Storage**: local storage of added products for unsynced data.
- **Version Control**: Public repository available on GitHub.

## App Screenshots
<p align="center">
  <img src="SwipeAssignment/App Screenshots/Screen1_Product List.png" alt="Screen1 Product List" width="29.75%" />
  <img src="SwipeAssignment/App Screenshots/Screen2_Add Product.png" alt="Screen2 Add Product" width="30%" />
  <img src="SwipeAssignment/App Screenshots/Add Product Success.png" alt="Add Product Success" width="30%" />
</p>

