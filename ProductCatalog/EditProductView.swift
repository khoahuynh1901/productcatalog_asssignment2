import SwiftUI
import CoreData

struct EditProductView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode

    @ObservedObject var product: Product

    @State private var productName: String
    @State private var productDescription: String
    @State private var productPrice: String
    @State private var productProvider: String

    init(product: Product) {
        _product = ObservedObject(wrappedValue: product)
        _productName = State(initialValue: product.productName ?? "")
        _productDescription = State(initialValue: product.productDescription ?? "")
        _productPrice = State(initialValue: product.productPrice?.stringValue ?? "")
        _productProvider = State(initialValue: product.productProvider ?? "")
    }

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 18) {
                Text("✨ Edit Product ✨")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .shadow(radius: 5)
                    .padding(.bottom, 10)

                CustomTextField(text: $productName, placeholder: "Product Name", icon: "cart")
                CustomTextField(text: $productDescription, placeholder: "Product Description", icon: "text.alignleft")
                CustomTextField(text: $productPrice, placeholder: "Product Price", icon: "dollarsign.circle", keyboardType: .decimalPad)
                CustomTextField(text: $productProvider, placeholder: "Product Provider", icon: "person")

                Button(action: saveChanges) {
                    Text("Save Changes")
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
        .navigationTitle("Edit Product")
    }

    private func saveChanges() {
        product.productName = productName
        product.productDescription = productDescription
        product.productPrice = NSDecimalNumber(string: productPrice)
        product.productProvider = productProvider

        do {
            try viewContext.save()
            presentationMode.wrappedValue.dismiss()
        } catch {
            print("Error saving changes: \(error)")
        }
    }
}

