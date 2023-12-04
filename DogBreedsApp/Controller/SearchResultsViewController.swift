//
//  SearchResultsViewController.swift
//  DogBreedsApp
//
//  Created by anna.zubakina on 03/12/2023.
//

import UIKit


class SearchResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
   
    @IBOutlet weak var searchedTableView: UITableView!
    
    var searchResults: [DogBreed] = []
    var selectedSearchResult: DogBreed?
 //   var isInitialAppearance = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchedTableView.delegate = self
        searchedTableView.dataSource = self
 //       self.animateTable()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return searchResults.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "searchResultCell", for: indexPath) as? SearchResultTableViewCell else {
                return UITableViewCell()
            }
            
            let breed = searchResults[indexPath.row]
            cell.configure(with: breed)
            
            
            if breed.isInUserList() {
                    cell.addSearchedButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
                } else {
                    cell.addSearchedButton.setImage(UIImage(systemName: "plus.circle"), for: .normal)
                }
            
            cell.addSearchedButton.tag = indexPath.row
            cell.addSearchedButton.addTarget(self, action: #selector(addButtonTapped(_:)), for: .touchUpInside)
                
            
            return cell
        }
    
    @objc func addButtonTapped(_ sender: UIButton) {
        let index = sender.tag
        
        print("addButtonTapped for index: \(index)")
        
        guard index < searchResults.count else {
            return
        }
        
        let selectedBreed = searchResults[index]
        
      
        if selectedBreed.isInUserList() {
            showAlreadyInListAlert()
        } else {
            
            showAddToListAlert(breed: selectedBreed) { updatedBreed in
                
                DispatchQueue.main.async {
                    print("Adding to the list...")
                    
                    
                    self.searchResults[index] = updatedBreed
                    self.searchedTableView.reloadData()
                    
                    let addedToListImage = updatedBreed.isSelected ? "checkmark.circle" : "plus.circle"
                    sender.setImage(UIImage(systemName: addedToListImage), for: .normal)
                    
                    print("Reloaded table and updated image")
                    
                }
            }
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        selectedSearchResult = searchResults[indexPath.row]
//        performSegue(withIdentifier: "detailSearch", sender: self)
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            selectedSearchResult = searchResults[selectedIndexPath.row]
            performSegue(withIdentifier: "detailSearch", sender: self)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("SearchResultsViewController viewWillAppear")

        searchedTableView.reloadData()

    }
    
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            print("SearchResultsViewController viewDidAppear")
            
        }
    
//    override func viewWillAppear(_ animated: Bool) {
//           super.viewWillAppear(animated)
//           searchedTableView.reloadData() 
//        
//           if isInitialAppearance {
//                    self.animateTable()
//                    isInitialAppearance = false
//            }
//        
// //          self.animateTable()
//       }
    


    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        if isMovingFromParent {
//            searchedTableView.reloadData()
//        } else {
//            if isInitialAppearance {
//                self.animateTable()
//                isInitialAppearance = false
//            }
//        }
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSearch", let detailVC = segue.destination as? DetailSearchedViewController {
            detailVC.searchedBreed = selectedSearchResult
        }
    }
    
//    func animateTable() {
//        searchedTableView.reloadData()
//
//        let cells = searchedTableView.visibleCells
//
//        for (index, cell) in cells.enumerated() {
//            cell.transform = CGAffineTransform(translationX: 0, y: 300)
//            UIView.animate(withDuration: 1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
//                cell.transform = CGAffineTransform(translationX: 0, y: 0)
//            }, completion: nil)
//        }
//    }
    
}

extension SearchResultsViewController {
    func showAddToListAlert(breed: DogBreed, completion: @escaping (DogBreed) -> Void) {
           let alert = UIAlertController(title: "Add to My List", message: "Do you want to add \(breed.name) to your list?", preferredStyle: .alert)

           alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

           alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { _ in
               let updatedBreed = breed
               updatedBreed.addToUserList()

               completion(updatedBreed)
           }))

           present(alert, animated: true, completion: nil)
       }

       func showAlreadyInListAlert() {
           let alert = UIAlertController(title: "Already Added", message: "This breed is already in your list", preferredStyle: .alert)

           alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

           present(alert, animated: true, completion: nil)
       }
}
