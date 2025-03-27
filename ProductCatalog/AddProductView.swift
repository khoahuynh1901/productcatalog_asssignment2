import SwiftUI
import CoreData

struct AddProductView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var productName = ""
    @State private var productDescription = ""
    @State private var productPrice = ""
    @State private var productProvider = ""

    var body: some View {
        VStack {
            Text("Add Product")
                .font(.title)
                .fontWeight(.bold)
                .padding()
                .foregroundColor(.purple)

            TextField("Product Name", text: $productName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .background(Color.white)
                .cornerRadius(8)

            TextField("Product Description", text: $productDescription)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .background(Color.white)
                .cornerRadius(8)

            TextField("Product Price", text: $productPrice)
                .keyboardType(.decimalPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .background(Color.white)
                .cornerRadius(8)

            TextField("Product Provider", text: $productProvider)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .background(Color.white)
                .cornerRadius(8)

            Button(action: addProduct) {
                Text("Save Product")
                    .fontWeight(.bold)
                    .padding()
                    .background(LinearGradient(gradient: Gradient(colors: [Color.green, Color.blue]), startPoint: .leading, endPoint: .trailing))
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding()
            }
            .disabled(productName.isEmpty || productPrice.isEmpty || productProvider.isEmpty)
            .shadow(radius: 10)

            Spacer()
        }
        .padding()
        .background(LinearGradient(gradient: Gradient(colors: [Color.purple.opacity(0.2), Color.blue.opacity(0.2)]), startPoint: .top, endPoint: .bottom))
    }

    private func addProduct() {
        let newProduct = Product(context: viewContext)
        newProduct.productName = productName
        newProduct.productDescription = productDescription
        newProduct.productPrice = NSDecimalNumber(string: productPrice)
        newProduct.productProvider = productProvider

        do {
            try viewContext.save()
        } catch {
            print("Error saving product: \(error.localizedDescription)")
        }

        // Reset fields after saving
        productName = ""
        productDescription = ""
        productPrice = ""
        productProvider = ""

        // Go back to the home page
    }
}

