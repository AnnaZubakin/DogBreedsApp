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
    @IBOutlet weak var weightMinTextField: UITextField!
    @IBOutlet weak var weightMaxTextField: UITextField!
    @IBOutlet weak var heightMinTextField: UITextField!
    @IBOutlet weak var heightMaxTextField: UITextField!
    
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
        
            let weightMin = Double(weightMinTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "") ?? 0.0
            let weightMax = Double(weightMaxTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "") ?? Double.greatestFiniteMagnitude
        
            let heightMin = Double(heightMinTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "") ?? 0.0
            let heightMax = Double(heightMaxTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "") ?? Double.greatestFiniteMagnitude

        
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
             
               
               //   let weightMinCondition = Double(breed.weight.metric) ?? 0.0 >= weightMin
                 // let weightMaxCondition = Double(breed.weight.metric) ?? Double.greatestFiniteMagnitude <= weightMax
                  
                  let breedWeight = breed.weight.metric 
                  let isWeightInRange = isWeightInRange(breedWeight: breedWeight, minWeight: String(weightMin), maxWeight: String(weightMax))
                  
                  let breedHeight = breed.height.metric
                  let isHeightInRange = isHeightInRange(breedHeight: breedHeight, minHeight: String(heightMin), maxHeight: String(heightMax))
                         
                  
                    let nameMatched = name.isEmpty || lowercasedName.range(of: name, options: .caseInsensitive) != nil
                    let breedGroupMatched = breedGroup.isEmpty || lowercasedBreedGroup.range(of: breedGroup, options: .caseInsensitive) != nil
                    let temperamentMatched = temperament.isEmpty || lowercasedTemperament.range(of: temperament, options: .caseInsensitive) != nil
                    
                    return nameMatched && breedGroupMatched && temperamentMatched && isWeightInRange && isHeightInRange
                        
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
    
    func isWeightInRange(breedWeight: String, minWeight: String, maxWeight: String) -> Bool {
        let components = breedWeight.components(separatedBy: "-")

        guard let breedMin = Double(components.first?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""),
              let breedMax = Double(components.last?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""),
              let min = Double(minWeight),
              let max = Double(maxWeight) else {
            return true // По умолчанию считаем, что вес попадает в диапазон
        }

        return (min...max).contains(breedMin) || (min...max).contains(breedMax)
    }
    
    func isHeightInRange(breedHeight: String, minHeight: String, maxHeight: String) -> Bool {
        let components = breedHeight.components(separatedBy: "-")

        guard let breedMinHeight = Double(components.first?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""),
              let breedMaxHeight = Double(components.last?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""),
              let min = Double(minHeight),
              let max = Double(maxHeight) else {
            return true
        }

        return (min...max).contains(breedMinHeight) || (min...max).contains(breedMaxHeight)
    }
    
//    func isWeightInRange(breedWeight: String, minWeight: String, maxWeight: String) -> Bool {
//        let components = breedWeight.components(separatedBy: "-")
//        
//        guard components.count == 2,
//              let breedWeightMin = components.first?.trimmingCharacters(in: .whitespacesAndNewlines),
//              let breedWeightMax = components.last?.trimmingCharacters(in: .whitespacesAndNewlines),
//              let min = Int(minWeight),
//              let max = Int(maxWeight),
//              let breedMin = Int(breedWeightMin),
//              let breedMax = Int(breedWeightMax) else {
//            return true // По умолчанию считаем, что вес попадает в диапазон
//        }
//        
//        return breedMin >= min && breedMax <= max
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSearchResults" {
            if let destinationVC = segue.destination as? SearchResultsViewController {
              
                destinationVC.searchResults = filteredBreeds 
            }
        }
    }
}
        
    
    

