//
//  DetailViewController.swift
//  DogBreedsApp
//
//  Created by anna.zubakina on 25/11/2023.
//

import UIKit

class DetailViewController: UIViewController {
    
    var selectedBreed: DogBreed?
    
    @IBOutlet weak var imageBreed: UIImageView!
    @IBOutlet weak var nameBreed: UILabel!
    @IBOutlet weak var otherInfo: UILabel!
    
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
                        imageBreed.loadImage(fromURL: imageURL)
                }
            
            // Do any additional setup after loading the view.
            
            if let scrollView = self.view as? UIScrollView {
                   scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height + 1)
               }
        }
        
        
        /*
         // MARK: - Navigation
         
         // In a storyboard-based application, you will often want to do a little preparation before navigation
         override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
         }
         */
        
    }
}
