//
//  ProductCatalogApp.swift
//  ProductCatalog
//
//  Created by Khoa Huynh Ly Nhut on 2025-03-26.
//

import SwiftUI

@main
struct ProductCatalogApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            NavigationView {
                ProductListView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            }
        }
    }
}
