//
//  SelectedViewController.swift
//  DogBreedsApp
//
//  Created by anna.zubakina on 29/11/2023.
//

import UIKit
import CoreData

class SelectedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate, UISearchBarDelegate {
    
    var isSelectedSearching: Bool = false
    
    @IBOutlet weak var searchSelectedBreed: UISearchBar!
    
    @IBOutlet weak var selectedTableView: UITableView!
    
    @IBOutlet weak var deleteAll: UIBarButtonItem!
    
    
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
           searchSelectedBreed.delegate = self
           
           setupSearchBar()
           
           do {
               try fetchedResultsController.performFetch()
           } catch {
               print("Error performing fetch: \(error.localizedDescription)")
           }
          
           selectedTableView.allowsMultipleSelectionDuringEditing = true
           
       }
    
    
    @IBAction func deleteAllButtonTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Delete All", message: "Are you sure you want to delete all selected breeds?", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            
            self.deleteAllSelectedBreeds()
            
            self.refreshTable()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

                alertController.addAction(confirmAction)
                alertController.addAction(cancelAction)

                present(alertController, animated: true, completion: nil)
    }
    
    private func deleteAllSelectedBreeds() {
            let fetchRequest: NSFetchRequest<SelectedBreed> = SelectedBreed.fetchRequest()

            do {
                let selectedBreeds = try CoreDataManager.shared.managedObjectContext.fetch(fetchRequest)

                for selectedBreed in selectedBreeds {
                    CoreDataManager.shared.managedObjectContext.delete(selectedBreed)
                }

                CoreDataManager.shared.saveContext()
            } catch {
                print("Error deleting selected breeds: \(error.localizedDescription)")
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
               refreshTable()
           }
       }
       
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, completionHandler) in
            guard let self = self else { return }

            let selectedBreed = self.fetchedResultsController.object(at: indexPath)
            CoreDataManager.shared.managedObjectContext.delete(selectedBreed)
            CoreDataManager.shared.saveContext()

            completionHandler(true)
        }

        deleteAction.backgroundColor = .red

        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false

        return configuration
    }
    
       func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
           selectedTableView.reloadData()
       }
       
    
    
    func refreshTable() {
            do {
                try fetchedResultsController.performFetch()
            } catch {
                print("Error fetching selected breeds: \(error.localizedDescription)")
            }
            
            selectedTableView.reloadData()
         //   printAllData()
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSelected", let detailVC = segue.destination as? DetailSelectedViewController {
            if let selectedIndexPath = selectedTableView.indexPathForSelectedRow {
                let selectedBreed = fetchedResultsController.object(at: selectedIndexPath)
                detailVC.selectedBreed = selectedBreed
            }
        }
    }
    
   func setupSearchBar() {
       searchSelectedBreed.placeholder = "Tap here to find a breed"
      }
    
   

    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            isSelectedSearching = true
            fetchedResultsController.fetchRequest.predicate = NSPredicate(format: "name CONTAINS[c] %@", searchText)
        } else {
            resetSearch()
        }
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Error performing fetch: \(error.localizedDescription)")
        }
        
        selectedTableView.reloadData()
    }
    


    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        resetSearch()
        selectedTableView.reloadData()
    }
    
    private func resetSearch() {
        isSelectedSearching = false
        fetchedResultsController.fetchRequest.predicate = nil
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Error performing fetch: \(error.localizedDescription)")
        }
        selectedTableView.reloadData()
    }
    
    
   }
