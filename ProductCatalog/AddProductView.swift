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
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 15) {
                Text("Add a New Product")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.bottom, 20)
                
                CustomTextField(text: $productName, placeholder: "Product Name", icon: "cart.fill")
                CustomTextField(text: $productDescription, placeholder: "Product Description", icon: "text.alignleft")
                CustomTextField(text: $productPrice, placeholder: "Product Price", icon: "dollarsign.circle.fill", keyboardType: .decimalPad)
                CustomTextField(text: $productProvider, placeholder: "Product Provider", icon: "person.fill")
                
                Button(action: addProduct) {
                    Text("Add Product")
                        .font(.title2)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(LinearGradient(gradient: Gradient(colors: [Color.green, Color.teal]), startPoint: .leading, endPoint: .trailing))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .shadow(radius: 5)
                }
                .padding(.horizontal)
            }
            .padding()
        }
        .navigationTitle("Add New Product")
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

