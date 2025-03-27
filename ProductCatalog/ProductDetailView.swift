//
//  ProductDetailView.swift
//  ProductCatalog
//
//  Created by Khoa Huynh Ly Nhut on 2025-03-27.
//

import SwiftUI

struct ProductDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var product: Product
    @Binding var isEditing: Bool
    var onSave: (Product) -> Void
    
    var body: some View {
        VStack {
            TextField("Product Name", text: Binding(
                get: { product.productName ?? "" },
                set: { product.productName = $0 }
            ))
            .padding()
            .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("Product Description", text: Binding(
                get: { product.productDescription ?? "" },
                set: { product.productDescription = $0 }
            ))
            .padding()
            .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("Product Price", value: Binding(
                get: { product.productPrice?.doubleValue ?? 0.0 },
                set: { product.productPrice = NSDecimalNumber(value: $0) }
            ), formatter: NumberFormatter())
            .padding()
            .keyboardType(.decimalPad)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("Product Provider", text: Binding(
                get: { product.productProvider ?? "" },
                set: { product.productProvider = $0 }
            ))
            .padding()
            .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button(action: {
                onSave(product)
                isEditing = false
            }) {
                Text("Save")
                    .fontWeight(.bold)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.top)
            
            Spacer()
        }
        .padding()
        .navigationTitle("Edit Product")
        .onDisappear {
            isEditing = false
        }
    }
}

struct ProductDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ProductDetailView(product: Product(), isEditing: .constant(true), onSave: { _ in })
    }
}
