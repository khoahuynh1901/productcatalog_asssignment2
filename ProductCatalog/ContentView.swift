import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            ProductListView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

