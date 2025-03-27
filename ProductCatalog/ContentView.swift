import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var searchQuery = ""
    @State private var currentProductIndex = 0

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Product.productName, ascending: true)],
        animation: .default)
    private var products: FetchedResults<Product>

    var body: some View {
        NavigationView {
            VStack {
                // Enhanced Search Bar with White Background and Icons
                HStack {
                    // Magnifying Glass Icon
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.purple)
                        .padding(.leading, 10)

                    // Search Text Field
                    TextField("Search by name or description", text: $searchQuery)
                        .padding(10)
                        .background(Color.white) // White background
                        .cornerRadius(25) // Rounded corners
                        .foregroundColor(.purple)
                        .padding([.leading, .trailing], 10)
                        .shadow(radius: 5)

                    // Clear Button (appears when typing)
                    if !searchQuery.isEmpty {
                        Button(action: {
                            searchQuery = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.purple)
                                .padding(.trailing, 10)
                        }
                    }
                }
                .padding()

                // Add Product Button with Gradient
                NavigationLink(destination: AddProductView()) {
                    Text("Add Product")
                        .fontWeight(.bold)
                        .padding()
                        .background(LinearGradient(gradient: Gradient(colors: [Color.green, Color.blue]), startPoint: .leading, endPoint: .trailing))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding(.top)
                        .shadow(radius: 10)
                }

                if !products.isEmpty {
                    let currentProduct = products[currentProductIndex]

                    // Display current product details
                    VStack(alignment: .leading) {
                        Text("Product Name: \(currentProduct.productName ?? "Unknown")")
                            .font(.title)
                            .foregroundColor(.purple)
                        Text("Description: \(currentProduct.productDescription ?? "No Description")")
                            .font(.body)
                            .foregroundColor(.blue)
                        Text("Price: $\(currentProduct.productPrice?.doubleValue ?? 0.0, specifier: "%.2f")")
                            .font(.body)
                            .foregroundColor(.green)
                        Text("Provider: \(currentProduct.productProvider ?? "Unknown")")
                            .font(.body)
                            .foregroundColor(.purple)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 10)

                    // Navigation Buttons (Next & Previous)
                    HStack {
                        Button(action: previousProduct) {
                            Text("Previous")
                                .padding()
                                .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                                .foregroundColor(.white)
                                .cornerRadius(8)
                                .shadow(radius: 5)
                        }
                        .disabled(currentProductIndex == 0)

                        Button(action: nextProduct) {
                            Text("Next")
                                .padding()
                                .background(LinearGradient(gradient: Gradient(colors: [Color.green, Color.blue]), startPoint: .leading, endPoint: .trailing))
                                .foregroundColor(.white)
                                .cornerRadius(8)
                                .shadow(radius: 5)
                        }
                        .disabled(currentProductIndex == products.count - 1)
                    }
                    .padding(.top)

                    Spacer()
                } else {
                    Text("No products available")
                        .padding()
                        .foregroundColor(.red)
                        .font(.headline)
                }

                // Product List
                List {
                    ForEach(filteredProducts, id: \.self) { product in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(product.productName ?? "Unknown")
                                    .font(.headline)
                                    .foregroundColor(.purple)
                                Text(product.productDescription ?? "No Description")
                                    .font(.subheadline)
                                    .foregroundColor(.blue)
                            }

                            Spacer()

                            // Delete button
                            Button(action: { deleteProduct(product) }) {
                                Image(systemName: "trash.circle.fill")
                                    .foregroundColor(.red)
                                    .font(.system(size: 20))
                                    .shadow(radius: 5)
                            }
                            .padding(.trailing, 10)
                        }
                    }
                    .onDelete(perform: deleteProducts)
                }
                .listStyle(PlainListStyle())
                .padding(.top, 20)
            }
            .background(LinearGradient(gradient: Gradient(colors: [Color.purple.opacity(0.2), Color.blue.opacity(0.2)]), startPoint: .top, endPoint: .bottom))
            .navigationTitle("Product Catalog")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: AddProductView()) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title)
                            .foregroundColor(.purple)
                            .shadow(radius: 10)
                    }
                }
            }
            .padding()
        }
    }

    private func deleteProduct(_ product: Product) {
        viewContext.delete(product)

        do {
            try viewContext.save()
        } catch {
            print("Error deleting product: \(error.localizedDescription)")
        }
    }

    private func deleteProducts(at offsets: IndexSet) {
        for index in offsets {
            let product = products[index]
            viewContext.delete(product)
        }

        do {
            try viewContext.save()
        } catch {
            print("Error deleting product: \(error.localizedDescription)")
        }
    }

    private func nextProduct() {
        if currentProductIndex < products.count - 1 {
            currentProductIndex += 1
        }
    }

    private func previousProduct() {
        if currentProductIndex > 0 {
            currentProductIndex -= 1
        }
    }

    private var filteredProducts: [Product] {
        if searchQuery.isEmpty {
            return Array(products)
        } else {
            return products.filter { product in
                let nameMatch = product.productName?.lowercased().contains(searchQuery.lowercased()) ?? false
                let descriptionMatch = product.productDescription?.lowercased().contains(searchQuery.lowercased()) ?? false
                return nameMatch || descriptionMatch
            }
        }
    }
}

