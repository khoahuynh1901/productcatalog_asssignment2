//
//  EditProductView.swift
//  ProductCatalog
//
//  Created by Khoa Huynh Ly Nhut on 2025-03-27.
//

import SwiftUI
import CoreData

struct EditProductView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var product: Product
    
    @State private var productName: String
    @State private var productDescription: String
    @State private var productPrice: String
    @State private var productProvider: String
    
    init(product: Product) {
        self.product = product
        _productName = State(initialValue: product.productName ?? "")
        _productDescription = State(initialValue: product.productDescription ?? "")
        _productPrice = State(initialValue: String(format: "%.2f", product.productPrice?.floatValue ?? 0))
        _productProvider = State(initialValue: product.productProvider ?? "")
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Edit Product")
                .font(.title)
                .bold()
                .padding(.top, 20)
            
            TextField("Product Name", text: $productName)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1))
            
            TextField("Product Description", text: $productDescription)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1))
            
            TextField("Product Price", text: $productPrice)
                .keyboardType(.decimalPad)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1))
            
            TextField("Product Provider", text: $productProvider)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1))
            
            Button(action: {
                saveChanges()
            }) {
                Text("Save Changes")
                    .bold()
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(LinearGradient(gradient: Gradient(colors: [Color.green, Color.teal]), startPoint: .leading, endPoint: .trailing))
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.top)
        }
        .padding()
        .navigationTitle("Edit Product")
    }
    
    private func saveChanges() {
        // Update product properties
        product.productName = productName
        product.productDescription = productDescription
        if let price = Float(productPrice) {
            product.productPrice = NSNumber(value: price)
        }
        product.productProvider = productProvider
        
        // Save the context
        do {
            try viewContext.save()
            print("Product updated successfully.")
        } catch {
            print("Error saving product: \(error)")
        }
    }
}
