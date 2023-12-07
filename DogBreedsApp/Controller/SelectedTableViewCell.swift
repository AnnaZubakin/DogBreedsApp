//
//  SelectedTableViewCell.swift
//  DogBreedsApp
//
//  Created by anna.zubakina on 29/11/2023.
//


import UIKit
import SDWebImage

class SelectedTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var selectedView: UIImageView!
    @IBOutlet weak var selectedName: UILabel!
    
    
    func configure(with selectedBreed: SelectedBreed) {
            selectedName.text = selectedBreed.name

        let imageURLString = "https://cdn2.thedogapi.com/images/\(selectedBreed.referenceImageID ?? "").jpg"
            if let imageURL = URL(string: imageURLString) {
       //         selectedView.loadImage(fromURL: imageURL)
                selectedView.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "dogs-avatar.jpg"))
            }
        }
    
}
