//
//  DetailSearchedViewController.swift
//  DogBreedsApp
//
//  Created by anna.zubakina on 04/12/2023.
//

import UIKit
import SDWebImage

class DetailSearchedViewController: UIViewController {

    var searchedBreed: DogBreed?
    
    
    @IBOutlet weak var imageSearched: UIImageView!
    @IBOutlet weak var nameSearched: UILabel!
    @IBOutlet weak var otherSearched: UILabel!
    @IBOutlet weak var shareSearched: UIBarButtonItem!
    @IBOutlet weak var addSearched: UIButton!
    
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
     //           imageSearched.loadImage(fromURL: imageURL)
                imageSearched.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "dogs-avatar.jpg"))
            }
            
            updateAddButtonState(isInUserList: breed.isInUserList())
            
        }
        
        shareSearched.target = self
        shareSearched.action = #selector(shareButtonTapped)
        
    }
    
    @objc func shareButtonTapped() {
        
        guard let breed = searchedBreed else {
            return
        }
        
            let imageURLString = breed.referenceImageID
           
            if !imageURLString.isEmpty,
                let imageURL = URL(string: "https://cdn2.thedogapi.com/images/\(imageURLString).jpg") {
               
            let breedDetails = """
                Name: \(breed.name)
                Group of Breeds: \(breed.breed_group ?? "")
                Temperament: \(breed.temperament ?? "")
                Bred For: \(breed.bred_for ?? "")
                Origin: \(breed.origin ?? "")
                Life Span: \(breed.life_span ?? "")
                Weight: \(breed.weight.metric) kg
                Height: \(breed.height.metric) sm
            """
            
            let activityViewController = UIActivityViewController(
                activityItems: [breedDetails, imageURL],
                applicationActivities: nil
            )

            present(activityViewController, animated: true, completion: nil)
        } else {
           
        }

    }
    
    private func updateAddButtonState(isInUserList: Bool) {
            let buttonText = isInUserList ? "In My List" : "Add to My List"
            addSearched.setTitle(buttonText, for: .normal)
        }
    
    
    @IBAction func addButtonTapped(_ sender: Any) {
        guard let breed = searchedBreed else {
                    return
                }
                
                if breed.isInUserList() {
                    showAlreadyInListAlert()
                } else {
                    showAddToListAlert(breed: breed) { updatedBreed in
                        DispatchQueue.main.async {
                           
                            self.updateAddButtonState(isInUserList: true)
                        }
                    }
                }
        
    }
    
}

extension DetailSearchedViewController {
    func showAddToListAlert(breed: DogBreed, completion: @escaping (DogBreed) -> Void) {
        let alert = UIAlertController(title: "Add to My List", message: "Do you want to add \(breed.name) to your list?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { _ in
            let updatedBreed = breed
            updatedBreed.addToUserList()
            
            completion(updatedBreed)
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    func showAlreadyInListAlert() {
        let alert = UIAlertController(title: "Already Added", message: "This breed is already in your list", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
}

