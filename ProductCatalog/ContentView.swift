import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                ProductListView()
            }
            .navigationBarTitle("Product Catalog", displayMode: .inline)
            .navigationBarItems(trailing: NavigationLink(destination: AddProductView()) {
                Text("Add Product")
                    .font(.body)
                    .foregroundColor(.blue)
                    .padding(8)
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(radius: 3)
            })
        }
        .accentColor(.blue) // Customizes the Navigation bar color
        .background(Color(.systemGray6).edgesIgnoringSafeArea(.all)) // Background for the entire screen
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}


