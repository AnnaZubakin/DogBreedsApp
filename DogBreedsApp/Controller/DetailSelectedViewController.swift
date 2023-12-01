//
//  DetailSelectedViewController.swift
//  DogBreedsApp
//
//  Created by anna.zubakina on 01/12/2023.
//

import UIKit

class DetailSelectedViewController: UIViewController {

    var selectedBreed: SelectedBreed?
    
    @IBOutlet weak var selectedImage: UIImageView!
    @IBOutlet weak var selectedName: UILabel!
    @IBOutlet weak var selectedOther: UILabel!
    
    
    
    override func viewDidLoad() {
            super.viewDidLoad()
            
            if let selectedBreed = selectedBreed {
               
                selectedName.text = selectedBreed.name
                
                selectedOther.text = "Group of Breeds: \(selectedBreed.breed_group ?? "")\n" +
                "Temperament: \(selectedBreed.temperament ?? "")\n" +
                "Bred For: \(selectedBreed.bred_for ?? "")\n" +
                "Origin: \(selectedBreed.origin ?? "")\n" +
                "Life Span: \(selectedBreed.life_span ?? "")\n" +
                "Weight: \(selectedBreed.weightMetric ?? "") kg\n" +
                "Height: \(selectedBreed.heightMetric ?? "") sm"

                if let imageURLString = selectedBreed.referenceImageID, let imageURL = URL(string: "https://cdn2.thedogapi.com/images/\(imageURLString).jpg") {
                    selectedImage.loadImage(fromURL: imageURL)
                }

              
            }
        }
    
}
