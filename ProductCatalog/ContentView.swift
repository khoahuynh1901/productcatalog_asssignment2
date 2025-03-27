import SwiftUI
import CoreData

struct ContentView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Product.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Product.productID, ascending: true)])
    private var products: FetchedResults<Product>
    
    @State private var currentIndex = 0
    
    var body: some View {
        VStack {
            if !products.isEmpty {
                VStack {
                    Text(products[currentIndex].productName ?? "No Name")
                        .font(.largeTitle)
                        .padding()
                    
                    Text(products[currentIndex].productDescription ?? "No Description")
                        .padding()
                    
                    Text("$\(products[currentIndex].productPrice?.floatValue ?? 0, specifier: "%.2f")")
                        .padding()
                    
                    Text(products[currentIndex].productProvider ?? "No Provider")
                        .padding()
                }
                
                HStack {
                    Button(action: {
                        if currentIndex > 0 {
                            currentIndex -= 1
                        }
                    }) {
                        Text("Previous")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    
                    Button(action: {
                        if currentIndex < products.count - 1 {
                            currentIndex += 1
                        }
                    }) {
                        Text("Next")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                
            } else {
                Text("No products available")
                    .font(.title)
                    .padding()
            }
        }
        .navigationBarTitle("Product Details", displayMode: .inline)
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

