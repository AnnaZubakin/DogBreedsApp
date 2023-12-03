//
//  SearchResultTableViewCell.swift
//  DogBreedsApp
//
//  Created by anna.zubakina on 03/12/2023.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageSearched: UIImageView!
    @IBOutlet weak var nameSearched: UILabel!
    
    func configure(with breed: DogBreed) {
            
            nameSearched.text = breed.name
        
            let imageURLString = "https://cdn2.thedogapi.com/images/\(breed.referenceImageID ).jpg"
            if let imageURL = URL(string: imageURLString) {
            imageSearched.loadImage(fromURL: imageURL)
            }
        
        }
    
}
