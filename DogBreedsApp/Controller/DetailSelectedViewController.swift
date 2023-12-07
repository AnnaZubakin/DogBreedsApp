//
//  DetailSelectedViewController.swift
//  DogBreedsApp
//
//  Created by anna.zubakina on 01/12/2023.
//

import UIKit
import SDWebImage

class DetailSelectedViewController: UIViewController {
    
    var selectedBreed: SelectedBreed?
    
    @IBOutlet weak var selectedImage: UIImageView!
    @IBOutlet weak var selectedName: UILabel!
    @IBOutlet weak var selectedOther: UILabel!
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noteTextView.delegate = self
        
        configureUI()
        
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
       //         selectedImage.loadImage(fromURL: imageURL)
                selectedImage.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "dogs-avatar.jpg"))
            }
            
            
        }
        
        func configureUI() {
            guard let selectedBreed = selectedBreed, let note = selectedBreed.note else {
                
                noteTextView.text = "Add your notes here..."
                noteTextView.textColor = .lightGray
                return
            }
            
            
            noteTextView.text = note.isEmpty ? "Add your notes here..." : note
            noteTextView.textColor = note.isEmpty ? .lightGray : .black
        }
        
        shareButton.target = self
        shareButton.action = #selector(shareButtonTapped)
        
        
    }
    
    @objc func shareButtonTapped() {
        guard let selectedBreed = selectedBreed else {
            return
        }
        
        let breedDetails = """
                Name: \(selectedBreed.name ?? "")
                Group of Breeds: \(selectedBreed.breed_group ?? "")
                Temperament: \(selectedBreed.temperament ?? "")
                Bred For: \(selectedBreed.bred_for ?? "")
                Origin: \(selectedBreed.origin ?? "")
                Life Span: \(selectedBreed.life_span ?? "")
                Weight: \(selectedBreed.weightMetric ?? "") kg
                Height: \(selectedBreed.heightMetric ?? "") sm
                Notes: \(selectedBreed.note ?? "")
            """
        
        guard let imageURLString = selectedBreed.referenceImageID,
              let imageURL = URL(string: "https://cdn2.thedogapi.com/images/\(imageURLString).jpg") else {
            return
        }
          
        
        
        
        let activityViewController = UIActivityViewController(
            activityItems: [breedDetails, imageURL],
            applicationActivities: nil
        )
        
        present(activityViewController, animated: true, completion: nil)
    }
    
}


extension DetailSelectedViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
            if textView.textColor == .lightGray {
                textView.text = nil
                textView.textColor = .black
            }
        }

    func textViewDidChange(_ textView: UITextView) {
       
        selectedBreed?.note = textView.text
        CoreDataManager.shared.saveContext()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
            
            if textView.text.isEmpty {
                textView.text = "Add your notes here..."
                textView.textColor = .lightGray
            }
        }
}
