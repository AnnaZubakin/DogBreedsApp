//
//  BreedsTableViewCell.swift
//  DogBreedsApp
//
//  Created by anna.zubakina on 13/11/2023.
//

import UIKit

class BreedsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var breedImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    func configure(with breed: DogBreed) {
            nameLabel.text = breed.name

        let imageURLString = "https://cdn2.thedogapi.com/images/\(breed.referenceImageID).jpg"
                if let imageURL = URL(string: imageURLString) {
                    breedImageView.loadImage(fromURL: imageURL)
            }
        }
    
}

extension UIImageView {
    func loadImage(fromURL url: URL, completion: (() -> Void)? = nil) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error loading image: \(error.localizedDescription)")
            } else if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = image
                    completion?()
                }
            }
        }.resume()
    }
}
