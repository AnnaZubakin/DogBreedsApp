//
//  SearchResultTableViewCell.swift
//  DogBreedsApp
//
//  Created by anna.zubakina on 03/12/2023.
//

import UIKit
import SDWebImage

class SearchResultTableViewCell: UITableViewCell {
    
    var indexPath: IndexPath?
    
    @IBOutlet weak var imageSearched: UIImageView!
    @IBOutlet weak var nameSearched: UILabel!
    @IBOutlet weak var addSearchedButton: UIButton!
    
    func configure(with breed: DogBreed) {
            
            nameSearched.text = breed.name
        
            let imageURLString = "https://cdn2.thedogapi.com/images/\(breed.referenceImageID ).jpg"
            if let imageURL = URL(string: imageURLString) {
     //       imageSearched.loadImage(fromURL: imageURL)
            imageSearched.sd_setImage(with: imageURL, completed: nil)
            }
        
        //ADD BUTTON
        
        addSearchedButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)

        let addedToListImage = breed.isSelected ? "checkmark.circle" : "plus.circle"
        addSearchedButton.setImage(UIImage(systemName: addedToListImage), for: .normal)
        
        }
    
    //ADD BUTTON
    
    @objc func addButtonTapped() {
        guard indexPath != nil else { return }

         }
    
}

extension UIImageView {
    func loadImage(fromURL url: URL) {
        self.sd_setImage(with: url, completed: nil)
    }
}
