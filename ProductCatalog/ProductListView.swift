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
                    productDetailView
                    navigationButtons
                } else {
                    emptyProductsView
                }

                searchTextField
                productList
                addProductButton
            }
            .navigationTitle("Products")
        }
    }

    // MARK: - Subviews

    private var productDetailView: some View {
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
    }

    private var navigationButtons: some View {
        HStack {
            Button(action: previousProduct) {
                Text("Previous")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }

            Button(action: nextProduct) {
                Text("Next")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
    }

    private var emptyProductsView: some View {
        Text("No products available")
            .font(.title)
            .padding()
    }

    private var searchTextField: some View {
        TextField("Search Products", text: $searchText)
            .padding()
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .onChange(of: searchText) { _ in
                // No need to call filterProducts() here, as filteredProducts is computed.
            }
    }

    private var productList: some View {
        List(filteredProducts.prefix(10), id: \.productID) { product in
            VStack(alignment: .leading) {
                Text(product.productName ?? "No Name")
                    .font(.headline)
                Text(product.productDescription ?? "No Description")
                    .font(.subheadline)
            }
        }
    }

    private var addProductButton: some View {
        NavigationLink(destination: AddProductView()) {
            Text("Add Product")
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
        .padding()
    }

    // MARK: - Computed Properties

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

    // MARK: - Actions

    private func previousProduct() {
        if currentIndex > 0 {
            currentIndex -= 1
        }
    }

    private func nextProduct() {
        if currentIndex < products.count - 1 {
            currentIndex += 1
        }
    }
}
