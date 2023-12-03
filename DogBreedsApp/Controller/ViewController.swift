//
//  ViewController.swift
//  DogBreedsApp
//
//  Created by anna.zubakina on 13/11/2023.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UILargeContentViewerInteractionDelegate {
    
    
    var dogBreeds: [DogBreed] = []
    var isSearching: Bool = false
    
    var isAnimationCompleted = false
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBreed: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBreed.delegate = self
        
        setupSearchBar()
        
        DogApiManager.shared.fetchDogBreeds { (breeds, error) in
            if let error = error {
                print("Error fetching dog breeds: \(error.localizedDescription)")
            } else if let breeds = breeds {
                DispatchQueue.main.async {
                    self.dogBreeds = breeds
                    self.tableView.reloadData()
                    self.animateTable()
                }
            }
        }
    }
    
    
    
//    class DogApiManager {
//        static let shared = DogApiManager()
//        
//        private init() {}
//        
//        func fetchDogBreeds(completion: @escaping ([DogBreed]?, Error?) -> Void) {
//            let urlString = "https://api.thedogapi.com/v1/breeds"
//            let apiKey = "live_QWJPuUE2QEAz2DuRuusyeXaO9YrX18xMKE3Pkb70XGrqvbK007WtjiZfLkL6PLYz"
//            
//            
//            guard var urlComponents = URLComponents(string: urlString) else {
//                completion(nil, NSError(domain: "Invalid URL", code: 0, userInfo: nil))
//                return
//            }
//            
//            urlComponents.queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
//            
//            guard let url = urlComponents.url else {
//                completion(nil, NSError(domain: "Invalid URL", code: 0, userInfo: nil))
//                return
//            }
//            
//            URLSession.shared.dataTask(with: url) { data, response, error in
//                if let error = error {
//                    completion(nil, error)
//                    return
//                }
//                
//                if let data = data {
//                    
//                    do {
//                        let breeds = try JSONDecoder().decode([DogBreed].self, from: data)
//                        completion(breeds, nil)
//                    } catch {
//                        completion(nil, error)
//                    }
//                }
//            }.resume()
//        }
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dogBreeds.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "breedCell", for: indexPath) as? BreedsTableViewCell else {
            return UITableViewCell()
        }
        
        let breed = dogBreeds[indexPath.row]
        cell.configure(with: breed, at: indexPath)
        
        if breed.isInUserList() {
                cell.addButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
            } else {
                cell.addButton.setImage(UIImage(systemName: "plus.circle"), for: .normal)
            }
        
        cell.addButton.tag = indexPath.row
        cell.addButton.addTarget(self, action: #selector(addButtonTapped(_:)), for: .touchUpInside)
            

        return cell
    }
    
    @objc func addButtonTapped(_ sender: UIButton) {
        let index = sender.tag
        
        print("addButtonTapped for index: \(index)")
        
        guard index < dogBreeds.count else {
            return
        }
        
        let selectedBreed = dogBreeds[index]
        
        
        // Проверяем, находится ли порода уже в списке избранных
        if selectedBreed.isInUserList() {
            showAlreadyInListAlert()
        } else {
            // Если порода не в списке, показываем алерт для добавления
            showAddToListAlert(breed: selectedBreed) { updatedBreed in
                
                DispatchQueue.main.async {
                    self.dogBreeds[index] = updatedBreed
                    self.tableView.reloadData()
                    
                    let addedToListImage = updatedBreed.isSelected ? "checkmark.circle" : "plus.circle"
                    sender.setImage(UIImage(systemName: addedToListImage), for: .normal)
                    
                }
            }
        }
    }
        
        
    
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let selectedBreed = dogBreeds[indexPath.row]
            performSegue(withIdentifier: "detailBreed", sender: selectedBreed)
        }

        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "detailBreed", let detailVC = segue.destination as? DetailViewController {
                if let selectedBreed = sender as? DogBreed {
                    detailVC.selectedBreed = selectedBreed
                }
            }
        }
    
    func setupSearchBar() {
        searchBreed.placeholder = "Tap here to find a breed"
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            if let searchText = searchBar.text {
                if !searchText.isEmpty {
                    isSearching = true
                    dogBreeds = dogBreeds.filter { breed in
                        return breed.name.lowercased().contains(searchText.lowercased())
                    }
                } else {
                    resetSearch()
                }
                tableView.reloadData()
            }
        }

        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            resetSearch()
            tableView.reloadData()
        }

        private func resetSearch() {
            isSearching = false
            DogApiManager.shared.fetchDogBreeds { (breeds, error) in
                if let error = error {
                    print("Error fetching dog breeds: \(error.localizedDescription)")
                } else if let breeds = breeds {
                    DispatchQueue.main.async {
                        self.dogBreeds = breeds
                        self.tableView.reloadData()
                    }
                }
            }
        }
    
    
    func animateTable() {
        guard !isAnimationCompleted else {
            return
        }
        
        tableView.reloadData()
        
        let cells = tableView.visibleCells
        let tableHeight = tableView.bounds.size.height
        
        for i in cells {
            let cell: UITableViewCell = i as UITableViewCell
            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
        }
        
        var index = 0
        
        for a in cells {
            let cell: UITableViewCell = a as UITableViewCell
            UIView.animate(withDuration: 1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0);
            }, completion: nil)
            
            index += 1
        }
        
        isAnimationCompleted = true
    }
   

}
    
extension ViewController {
    
    func showAddToListAlert(breed: DogBreed, completion: @escaping (DogBreed) -> Void) {
        let alert = UIAlertController(title: "Add to My List", message: "Do you want to add \(breed.name) to your list?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { _ in
            let updatedBreed = breed
            updatedBreed.addToUserList()
            print(updatedBreed)
          
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
    

    
    extension DogBreed {
        
        @discardableResult
        
        func addToUserList() -> DogBreed {
            
            self.isSelected = true
            
            let context = CoreDataManager.shared.managedObjectContext
            
            let selectedBreed = SelectedBreed(context: context)
            selectedBreed.id = Int64(self.id)
            selectedBreed.name = self.name
            selectedBreed.referenceImageID = self.referenceImageID
            selectedBreed.weightMetric = self.weight.metric
            selectedBreed.heightMetric = self.height.metric
            selectedBreed.bred_for = self.bred_for
            selectedBreed.breed_group = self.breed_group
            selectedBreed.life_span = self.life_span
            selectedBreed.temperament = self.temperament
            selectedBreed.origin = self.origin
            
            CoreDataManager.shared.saveContext()
      
            self.isSelected = true
            
            return self
        }
        
        func isInUserList() -> Bool {
                let context = CoreDataManager.shared.managedObjectContext
                let fetchRequest: NSFetchRequest<SelectedBreed> = SelectedBreed.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id == %d", self.id)

                do {
                    let count = try context.count(for: fetchRequest)
                    return count > 0
                } catch {
                    print("Error checking if breed is in user list: \(error.localizedDescription)")
                    return false
                }
            }
        
    }

