//
//  DetailViewController.swift
//  DogBreedsApp
//
//  Created by anna.zubakina on 25/11/2023.
//

import UIKit
import SDWebImage

class DetailViewController: UIViewController {
    
    var selectedBreed: DogBreed?
    
    @IBOutlet weak var imageBreed: UIImageView!
    @IBOutlet weak var nameBreed: UILabel!
    @IBOutlet weak var otherInfo: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let breed = selectedBreed {
            nameBreed.text = breed.name
            otherInfo.text = "Group of Breeds: \(breed.breed_group ?? "")\n\n" +
            "Temperament: \(breed.temperament ?? "")\n\n" +
            "Bred For: \(breed.bred_for ?? "")\n\n" +
            "Origin: \(breed.origin ?? "")\n\n" +
            "Life Span: \(breed.life_span ?? "")\n\n" +
            "Weight: \(breed.weight.metric) kg\n\n" +
            "Height: \(breed.height.metric) sm"
            
            
            
            let imageURLString = "https://cdn2.thedogapi.com/images/\(breed.referenceImageID).jpg"
            if let imageURL = URL(string: imageURLString) {
           //     imageBreed.loadImage(fromURL: imageURL)
                imageBreed.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "dogs-avatar.jpg"))
                
            }
            
            updateAddButtonState(isInUserList: breed.isInUserList())
            
            if let scrollView = self.view as? UIScrollView {
                scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height + 1)
            }
        }
        
        shareButton.target = self
        shareButton.action = #selector(shareButtonTapped)
        
    }
    
    private func updateAddButtonState(isInUserList: Bool) {
            let buttonText = isInUserList ? "In My List" : "Add to My List"
            addButton.setTitle(buttonText, for: .normal)
        }
       
        @objc func shareButtonTapped() {
            
            guard let breed = selectedBreed else {
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
        
    
    
    @IBAction func addButtonTapped(_ sender: Any) {
        
        guard let breed = selectedBreed else {
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

extension DetailViewController {
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

