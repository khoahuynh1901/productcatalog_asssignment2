import SwiftUI
import CoreData

struct ContentView: View {
    @FetchRequest(
        entity: Product.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Product.productName, ascending: true)],
        animation: .default
    ) private var products: FetchedResults<Product>
    
    @State private var searchText = ""
    @Environment(\.managedObjectContext) private var viewContext
    
    var filteredProducts: [Product] {
        if searchText.isEmpty {
            return products.map { $0 }
        } else {
            return products.filter {
                $0.productName?.lowercased().contains(searchText.lowercased()) ?? false
            }
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                // Search Bar
                TextField("Search Products", text: $searchText)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .padding()
                
                List {
                    ForEach(filteredProducts, id: \.productID) { product in
                        NavigationLink(destination: EditProductView(product: product)) {
                            HStack {
                                Text(product.productName ?? "Unnamed Product")
                                    .fontWeight(.bold)
                                    .padding(.trailing, 10)
                                Spacer()
                                Button(action: {
                                    deleteProduct(product: product)
                                }) {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                }
                                .padding(.leading, 10)
                            }
                        }
                    }
                    .onDelete(perform: deleteProducts)
                }
                .navigationTitle("Product List")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: AddProductView()) {
                            Text("Add Product")
                        }
                    }
                }
            }
        }
    }

    private func deleteProduct(product: Product) {
        viewContext.delete(product)
        do {
            try viewContext.save()
        } catch {
            print("Error deleting product: \(error)")
        }
    }

    private func deleteProducts(offsets: IndexSet) {
        withAnimation {
            offsets.map { filteredProducts[$0] }.forEach(viewContext.delete)
            do {
                try viewContext.save()
            } catch {
                print("Error deleting products: \(error)")
            }
        }
    }
}

