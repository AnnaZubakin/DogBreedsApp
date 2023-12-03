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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchedTableView.delegate = self
        searchedTableView.dataSource = self
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
            return cell
        }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           searchedTableView.reloadData() 
       }
    
}
