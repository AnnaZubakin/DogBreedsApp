//
//  DetailSearchedViewController.swift
//  DogBreedsApp
//
//  Created by anna.zubakina on 04/12/2023.
//

import UIKit

class DetailSearchedViewController: UIViewController {

    var searchedBreed: DogBreed?
    
    
    @IBOutlet weak var imageSearched: UIImageView!
    @IBOutlet weak var nameSearched: UILabel!
    @IBOutlet weak var otherSearched: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let breed = searchedBreed {
            nameSearched.text = breed.name
                             otherSearched.text = "Group of Breeds: \(breed.breed_group ?? "")\n\n" +
                             "Temperament: \(breed.temperament ?? "")\n\n" +
                             "Bred For: \(breed.bred_for ?? "")\n\n" +
                             "Origin: \(breed.origin ?? "")\n\n" +
                             "Life Span: \(breed.life_span ?? "")\n\n" +
                             "Weight: \(breed.weight.metric) kg\n\n" +
                             "Height: \(breed.height.metric) sm"
            
            
            
            let imageURLString = "https://cdn2.thedogapi.com/images/\(breed.referenceImageID).jpg"
            if let imageURL = URL(string: imageURLString) {
                imageSearched.loadImage(fromURL: imageURL)
            }
            
            
        }
        
        
    }

}
