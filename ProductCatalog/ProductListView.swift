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
        VStack(spacing: 15) {
            if !products.isEmpty {
                VStack {
                    Text(products[currentIndex].productName ?? "No Name")
                        .font(.title)
                        .bold()
                        .foregroundColor(.blue)
                        .padding(.top, 10)
                    
                    Text(products[currentIndex].productDescription ?? "No Description")
                        .font(.body)
                        .foregroundColor(.gray)
                        .padding()
                        .multilineTextAlignment(.center)
                    
                    Text("$\(products[currentIndex].productPrice?.floatValue ?? 0, specifier: "%.2f")")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.green)
                    
                    Text("Provider: \(products[currentIndex].productProvider ?? "Unknown")")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.bottom, 10)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(15)
                .shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 3)

                HStack {
                    Button(action: {
                        if currentIndex > 0 {
                            currentIndex -= 1
                        }
                    }) {
                        Label("Previous", systemImage: "chevron.left")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .shadow(radius: 3)
                    }

                    Button(action: {
                        if currentIndex < products.count - 1 {
                            currentIndex += 1
                        }
                    }) {
                        Label("Next", systemImage: "chevron.right")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(LinearGradient(gradient: Gradient(colors: [Color.purple, Color.blue]), startPoint: .leading, endPoint: .trailing))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .shadow(radius: 3)
                    }
                }
                .padding(.horizontal)
            } else {
                Text("No products available")
                    .font(.title)
                    .foregroundColor(.red)
                    .padding()
            }

            // Search Bar
            TextField("🔍 Search Products...", text: $searchText)
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.white)
                        .shadow(color: Color.gray.opacity(0.4), radius: 4, x: 2, y: 2)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.blue, lineWidth: 2)
                )
                .padding(.horizontal)
                .onChange(of: searchText) { _, _ in
                    filterProducts()
                }

            // Product List
            List {
                ForEach(filteredProducts.prefix(10), id: \.productID) { product in
                    HStack {
                        VStack(alignment: .leading, spacing: 5) {
                            Text(product.productName ?? "No Name")
                                .font(.headline)
                                .foregroundColor(.blue)
                            Text(product.productDescription ?? "No Description")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding()

                        Spacer()
                        
                        // Delete Button
                        Button(action: {
                            withAnimation {
                                deleteProduct(product)
                            }
                        }) {
                            Image(systemName: "trash")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.red)
                                .clipShape(Circle())
                                .shadow(radius: 4)
                        }
                    }
                    .padding(8)
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: Color.gray.opacity(0.2), radius: 4, x: 2, y: 2)
                }
            }
            .listStyle(PlainListStyle())

            // Add Product Button
            NavigationLink(destination: AddProductView()) {
                Text("➕ Add Product")
                    .bold()
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(LinearGradient(gradient: Gradient(colors: [Color.green, Color.teal]), startPoint: .leading, endPoint: .trailing))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(radius: 4)
            }
            .padding()
        }
        .navigationTitle("Products")
    }

    private var filteredProducts: [Product] {
        if searchText.isEmpty {
            return Array(products)
        } else {
            return products.filter { product in
                product.productName?.lowercased().contains(searchText.lowercased()) ?? false ||
                product.productDescription?.lowercased().contains(searchText.lowercased()) ?? false
            }
        }
    }

    private func filterProducts() {}

    private func deleteProduct(_ product: Product) {
        viewContext.delete(product)
        do {
            try viewContext.save()
        } catch {
            print("Error deleting product: \(error)")
        }
    }
}

