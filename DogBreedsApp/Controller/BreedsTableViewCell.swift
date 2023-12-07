//
//  BreedsTableViewCell.swift
//  DogBreedsApp
//
//  Created by anna.zubakina on 13/11/2023.
//

import UIKit
import SDWebImage

class BreedsTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var breedImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    var indexPath: IndexPath?
    
    func configure(with breed: DogBreed, at indexPath: IndexPath) {
        
            self.indexPath = indexPath
        
            nameLabel.text = breed.name

        let imageURLString = "https://cdn2.thedogapi.com/images/\(breed.referenceImageID).jpg"
        if let imageURL = URL(string: imageURLString) {
            
          //  breedImageView.sd_setImage(with: imageURL, completed: nil)
            breedImageView.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "dogs-avatar.jpg"))
            
        }
            
        
               addButton.tag = indexPath.row
               addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)

               let addedToListImage = breed.isSelected ? "checkmark.circle" : "plus.circle"
               addButton.setImage(UIImage(systemName: addedToListImage), for: .normal)
       }
    
   @objc func addButtonTapped() {
       guard indexPath != nil else { return }

        }
        
}
   
