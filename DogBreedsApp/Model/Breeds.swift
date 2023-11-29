//
//  Breeds.swift
//  DogBreedsApp
//
//  Created by anna.zubakina on 13/11/2023.
//

import Foundation

class DogBreed: Codable {
    let id: Int
    let name: String
    let bred_for: String?
    let breed_group: String?
    let life_span: String?
    let temperament: String?
    let origin: String?
    let referenceImageID: String
    let image: DogBreedImage
    let weight: DogBreedMeasurement
    let height: DogBreedMeasurement
    var isSelected: Bool = false

    enum CodingKeys: String, CodingKey {
            case id, name, bred_for, breed_group, life_span, temperament, origin
            case referenceImageID = "reference_image_id"
            case image, weight, height
        }
}

struct DogBreedImage: Codable {
    let id: String
    let width: Int
    let height: Int
    let url: String
}

struct DogBreedMeasurement: Codable {
    let imperial: String
    let metric: String
}

