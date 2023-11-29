//
//  ViewController.swift
//  DogBreedsApp
//
//  Created by anna.zubakina on 13/11/2023.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    
    var dogBreeds: [DogBreed] = []
    var isSearching: Bool = false
    
    var isAnimationCompleted = false
    
    // var filteredBreeds: [DogBreed] = []
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBreed: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBreed.delegate = self
        
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
    
    
    class DogApiManager {
        static let shared = DogApiManager()
        
        private init() {}
        
        func fetchDogBreeds(completion: @escaping ([DogBreed]?, Error?) -> Void) {
            let urlString = "https://api.thedogapi.com/v1/breeds"
            let apiKey = "live_QWJPuUE2QEAz2DuRuusyeXaO9YrX18xMKE3Pkb70XGrqvbK007WtjiZfLkL6PLYz"
            
            
            guard var urlComponents = URLComponents(string: urlString) else {
                completion(nil, NSError(domain: "Invalid URL", code: 0, userInfo: nil))
                return
            }
            
            urlComponents.queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
            
            guard let url = urlComponents.url else {
                completion(nil, NSError(domain: "Invalid URL", code: 0, userInfo: nil))
                return
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    completion(nil, error)
                    return
                }
                
                if let data = data {
                    
                    do {
                        let breeds = try JSONDecoder().decode([DogBreed].self, from: data)
                        completion(breeds, nil)
                    } catch {
                        completion(nil, error)
                    }
                }
            }.resume()
        }
    }
    
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
        cell.configure(with: breed)
        
        return cell
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
    
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//            if let searchText = searchBar.text {
//                if !searchText.isEmpty {
//                    isSearching = true
//                    dogBreeds = dogBreeds.filter { breed in
//                        return breed.name.lowercased().contains(searchText.lowercased())
//                    }
//                } else {
//                    isSearching = false
//
//                    DogApiManager.shared.fetchDogBreeds { (breeds, error) in
//                        if let error = error {
//                            print("Error fetching dog breeds: \(error.localizedDescription)")
//                        } else if let breeds = breeds {
//                            DispatchQueue.main.async {
//                                self.dogBreeds = breeds
//                                self.tableView.reloadData()
//                            }
//                        }
//                    }
//                }
//                tableView.reloadData()
//            }
//        }
    
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
    
