//
//  CustomTextField.swift
//  ProductCatalog
//
//  Created by Khoa Huynh Ly Nhut on 2025-03-27.
//

import SwiftUI

struct CustomTextField: View {
    @Binding var text: String
    var placeholder: String
    var icon: String
    var keyboardType: UIKeyboardType = .default

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(Color.blue)
                .padding(.leading, 12)

            TextField(placeholder, text: $text)
                .keyboardType(keyboardType)
                .padding()
                .background(Color.white)
                .overlay(RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.blue, lineWidth: 2))
                .cornerRadius(8)
                .foregroundColor(.primary)
                .autocapitalization(.none)
        }
        .padding(.horizontal)
    }
}
