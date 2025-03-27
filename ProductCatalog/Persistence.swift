import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "ProductCatalog")
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { description, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        // Creating mock data
        for _ in 0..<10 {
            let newProduct = Product(context: viewContext)
            newProduct.productID = Int64(Date().timeIntervalSince1970)
            newProduct.productName = "Sample Product"
            newProduct.productDescription = "Sample Description"
            newProduct.productPrice = NSDecimalNumber(string: "9.99")
            newProduct.productProvider = "Sample Provider"
        }
        do {
            try viewContext.save()
        } catch {
            fatalError("Unresolved error \(error), \(error.localizedDescription)")
        }
        return result
    }()
}

