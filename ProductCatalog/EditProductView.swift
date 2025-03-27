import SwiftUI
import CoreData

struct EditProductView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var product: Product
    @State private var productName: String
    @State private var productDescription: String
    @State private var productPrice: String
    @State private var productProvider: String
    
    init(product: Binding<Product>) {
        _product = product
        _productName = State(initialValue: product.wrappedValue.productName ?? "")
        _productDescription = State(initialValue: product.wrappedValue.productDescription ?? "")
        _productPrice = State(initialValue: product.wrappedValue.productPrice?.stringValue ?? "")
        _productProvider = State(initialValue: product.wrappedValue.productProvider ?? "")
    }
    
    var body: some View {
        VStack {
            TextField("Product Name", text: $productName)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).strokeBorder())
            
            TextField("Product Description", text: $productDescription)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).strokeBorder())
            
            TextField("Product Price", text: $productPrice)
                .keyboardType(.decimalPad)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).strokeBorder())
            
            TextField("Product Provider", text: $productProvider)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).strokeBorder())
            
            Button("Save Changes") {
                saveChanges()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
        .navigationTitle("Edit Product")
    }
    
    private func saveChanges() {
        // Update the product with the edited values
        product.productName = productName
        product.productDescription = productDescription
        if let price = Float(productPrice) {
            product.productPrice = NSDecimalNumber(value: price)
        }
        product.productProvider = productProvider
        
        // Save the changes to CoreData
        do {
            try viewContext.save()
            print("Product updated successfully.")
        } catch {
            print("Error saving product: \(error)")
        }
    }
}

struct EditProductView_Previews: PreviewProvider {
    static var previews: some View {
        //Product to preview
        let context = PersistenceController.preview.container.viewContext
        let product = Product(context: context)
        product.productName = "Sample Product"
        product.productDescription = "Sample Description"
        product.productPrice = NSDecimalNumber(value: 19.99)
        product.productProvider = "Sample Provider"
        
        return NavigationView {
            EditProductView(product: .constant(product))
        }
    }
}

