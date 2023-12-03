//
//  SearchViewController.swift
//  DogBreedsApp
//
//  Created by anna.zubakina on 01/12/2023.
//

import UIKit

class SearchViewController: UIViewController {
    
    var dogBreeds: [DogBreed] = []
    var filteredBreeds: [DogBreed] = []
    
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var breedGroupTextField: UITextField!
    @IBOutlet weak var temperamentTextField: UITextField!
    
    @IBOutlet weak var searhButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchDogBreeds()
    }
    
    func fetchDogBreeds() {
        DogApiManager.shared.fetchDogBreeds { [weak self] (breeds, error) in
            guard let self = self else { return }
            
            if let error = error {
                print("Error fetching dog breeds: \(error.localizedDescription)")
            } else if let breeds = breeds {
                self.dogBreeds = breeds
                print("Dog breeds loaded successfully.")
                for breed in self.dogBreeds {
                               print("Breed: \(breed.name)")
                           }
            }
        }
    }
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        
        
            let name = nameTextField.text?.lowercased() ?? ""
            let breedGroup = breedGroupTextField.text?.lowercased() ?? ""
            let temperament = temperamentTextField.text?.lowercased() ?? ""
        
        // Проверяем, загружены ли данные
        guard !dogBreeds.isEmpty else {
            print("No dog breeds loaded.")
            return
        }
        

            // Фильтруем массив dogBreeds с учетом введенных параметров
              filteredBreeds = dogBreeds.filter { breed in
                let lowercasedName = breed.name.lowercased()
                let lowercasedBreedGroup = breed.breed_group?.lowercased() ?? ""
                let lowercasedTemperament = breed.temperament?.lowercased() ?? ""

                    let nameMatched = name.isEmpty || lowercasedName.range(of: name, options: .caseInsensitive) != nil
                    let breedGroupMatched = breedGroup.isEmpty || lowercasedBreedGroup.range(of: breedGroup, options: .caseInsensitive) != nil
                    let temperamentMatched = temperament.isEmpty || lowercasedTemperament.range(of: temperament, options: .caseInsensitive) != nil

                    return nameMatched && breedGroupMatched && temperamentMatched
                        
            }
        

        if filteredBreeds.isEmpty {
            print("No breeds found for the specified criteria.")
        } else {
            for breed in filteredBreeds {
                print("Found breed: \(breed.name)")
            }
        }
        
        performSegue(withIdentifier: "showSearchResults", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSearchResults" {
            if let destinationVC = segue.destination as? SearchResultsViewController {
              
                destinationVC.searchResults = filteredBreeds 
            }
        }
    }
}
        
    
    

