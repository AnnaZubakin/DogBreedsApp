//
//  SelectedViewController.swift
//  DogBreedsApp
//
//  Created by anna.zubakina on 29/11/2023.
//

import UIKit
import CoreData

class SelectedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    
    
    @IBOutlet weak var selectedTableView: UITableView!
    
    lazy var fetchedResultsController: NSFetchedResultsController<SelectedBreed> = {
           let fetchRequest: NSFetchRequest<SelectedBreed> = SelectedBreed.fetchRequest()
           let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
           fetchRequest.sortDescriptors = [sortDescriptor]
           
           let fetchedResultsController = NSFetchedResultsController(
               fetchRequest: fetchRequest,
               managedObjectContext: CoreDataManager.shared.managedObjectContext,
               sectionNameKeyPath: nil,
               cacheName: nil
           )
           
           fetchedResultsController.delegate = self
           
           return fetchedResultsController
       }()
       
       override func viewDidLoad() {
           super.viewDidLoad()
           
           selectedTableView.delegate = self
           selectedTableView.dataSource = self
           
           do {
               try fetchedResultsController.performFetch()
           } catch {
               print("Error performing fetch: \(error.localizedDescription)")
           }
       }
       
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           guard let sections = fetchedResultsController.sections else {
               return 0
           }
           return sections[section].numberOfObjects
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           guard let cell = tableView.dequeueReusableCell(withIdentifier: "selectedBreedCell", for: indexPath) as? SelectedTableViewCell else {
               return UITableViewCell()
           }
           
           let selectedBreed = fetchedResultsController.object(at: indexPath)
           cell.configure(with: selectedBreed)
           
           return cell
       }
       
       func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
           if editingStyle == .delete {
               let selectedBreed = fetchedResultsController.object(at: indexPath)
               CoreDataManager.shared.managedObjectContext.delete(selectedBreed)
               CoreDataManager.shared.saveContext()
           }
       }
       
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
       func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
           selectedTableView.reloadData()
       }
       
       // Добавьте функцию для печати всех данных
    
    
    
    func refreshTable() {
            do {
                try fetchedResultsController.performFetch()
            } catch {
                print("Error fetching selected breeds: \(error.localizedDescription)")
            }
            
            selectedTableView.reloadData()
         //   printAllData()
        }
    
   }
