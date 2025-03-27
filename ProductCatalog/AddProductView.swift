import SwiftUI
import CoreData

struct AddProductView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    @State private var productName = ""
    @State private var productDescription = ""
    @State private var productPrice = ""
    @State private var productProvider = ""
    
    var body: some View {
        VStack {
            TextField("Product Name", text: $productName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Product Description", text: $productDescription)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Product Price", text: $productPrice)
                .keyboardType(.decimalPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Product Provider", text: $productProvider)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button(action: addProduct) {
                Text("Add Product")
                    .font(.title)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
        .navigationTitle("Add New Product")
        .padding()
    }
    
    private func addProduct() {
        let newProduct = Product(context: viewContext)
        newProduct.productID = Int64(Date().timeIntervalSince1970)
        newProduct.productName = productName
        newProduct.productDescription = productDescription
        newProduct.productPrice = NSDecimalNumber(string: productPrice)
        newProduct.productProvider = productProvider
        
        do {
            try viewContext.save()
            presentationMode.wrappedValue.dismiss()
        } catch {
            print("Error saving product: \(error)")
        }
    }
}

struct AddProductView_Previews: PreviewProvider {
    static var previews: some View {
        AddProductView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

