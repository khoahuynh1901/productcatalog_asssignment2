import SwiftUI
import CoreData

struct ProductListView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: Product.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Product.productID, ascending: true)],
        animation: .default
    ) private var products: FetchedResults<Product>
    
    @State private var currentIndex = 0
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            VStack {
                if !products.isEmpty {
                    VStack {
                        Text(products[currentIndex].productName ?? "No Name")
                            .font(.largeTitle)
                            .padding()
                        
                        Text(products[currentIndex].productDescription ?? "No Description")
                            .padding()
                        
                        Text("$\(products[currentIndex].productPrice?.floatValue ?? 0, specifier: "%.2f")")
                            .padding()
                        
                        Text(products[currentIndex].productProvider ?? "No Provider")
                            .padding()
                    }
                    
                    HStack {
                        Button(action: {
                            if currentIndex > 0 {
                                currentIndex -= 1
                            }
                        }) {
                            Text("Previous")
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        
                        Button(action: {
                            if currentIndex < products.count - 1 {
                                currentIndex += 1
                            }
                        }) {
                            Text("Next")
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }
                } else {
                    Text("No products available")
                        .font(.title)
                        .padding()
                }
                
                // Search bar
                // Search bar
                // Search bar
                TextField("Search Products", text: $searchText)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onChange(of: searchText) { _ in
                        filterProducts()
                    }



                
                // List of products
                List(filteredProducts.prefix(10), id: \.productID) { product in
                    VStack(alignment: .leading) {
                        Text(product.productName ?? "No Name")
                            .font(.headline)
                        Text(product.productDescription ?? "No Description")
                            .font(.subheadline)
                    }
                }
                
                // Add Product Button with NavigationLink
                NavigationLink(destination: AddProductView()) {
                    Text("Add Product")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
            .navigationTitle("Products")
        }
    }

    private var filteredProducts: [Product] {
        if searchText.isEmpty {
            return Array(products)
        } else {
            return products.filter { (product) -> Bool in
                product.productName?.lowercased().contains(searchText.lowercased()) ?? false ||
                product.productDescription?.lowercased().contains(searchText.lowercased()) ?? false
            }
        }
    }

    private func filterProducts() {
        // This can be customized to implement the actual search functionality
    }
}

