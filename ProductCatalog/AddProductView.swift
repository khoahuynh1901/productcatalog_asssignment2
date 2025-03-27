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
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 18) {
                Text("✨ Add a New Product ✨")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .shadow(radius: 5)
                    .padding(.bottom, 10)

                CustomTextField(text: $productName, placeholder: "Product Name", icon: "cart")
                CustomTextField(text: $productDescription, placeholder: "Product Description", icon: "text.alignleft")
                CustomTextField(text: $productPrice, placeholder: "Product Price", icon: "dollarsign.circle", keyboardType: .decimalPad)
                CustomTextField(text: $productProvider, placeholder: "Product Provider", icon: "person")

                Button(action: addProduct) {
                    Text("Add Product")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]),
                                                   startPoint: .leading,
                                                   endPoint: .trailing))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .shadow(color: Color.purple.opacity(0.4), radius: 8, x: 0, y: 4)
                }
                .padding(.horizontal)
            }
            .padding()
            .background(Color.white.opacity(0.9))
            .cornerRadius(15)
            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
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

