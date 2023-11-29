//
//  CoreDataManager.swift
//  DogBreedsApp
//
//  Created by anna.zubakina on 29/11/2023.
//

import UIKit
import CoreData

class CoreDataManager {

    static let shared = CoreDataManager()

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DogBreedsApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            else {
                    print("Core Data loaded successfully")
                }
        })
        return container
    }()

    var managedObjectContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func getAllObjects<T: NSManagedObject>(_ type: T.Type) -> [T]? {
        do {
            return try managedObjectContext.fetch(type.fetchRequest()) as? [T]
        } catch {
            print("Error fetching objects: \(error.localizedDescription)")
            return nil
        }
    }
    
    func printAllData() {
            let fetchRequest: NSFetchRequest<SelectedBreed> = SelectedBreed.fetchRequest()
            
            do {
                let selectedBreeds = try managedObjectContext.fetch(fetchRequest)
                selectedBreeds.forEach { breed in
                    print(breed)
                }
            } catch {
                print("Error fetching selected breeds: \(error.localizedDescription)")
            }
        }
    
    func fetchSelectedBreeds() -> [SelectedBreed] {
        let request: NSFetchRequest<SelectedBreed> = SelectedBreed.fetchRequest()
        
        do {
            let selectedBreeds = try managedObjectContext.fetch(request)
            return selectedBreeds
        } catch {
            print("Error fetching selected breeds: \(error)")
            return []
        }
    }
}
