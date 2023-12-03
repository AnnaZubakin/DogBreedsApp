//
//  DogApiManager.swift
//  DogBreedsApp
//
//  Created by anna.zubakina on 01/12/2023.
//

import Foundation

class DogApiManager {
    static let shared = DogApiManager()
    
    private init() {}
    
    func fetchDogBreeds(completion: @escaping ([DogBreed]?, Error?) -> Void) {
        let urlString = "https://api.thedogapi.com/v1/breeds"
        let apiKey = "live_QWJPuUE2QEAz2DuRuusyeXaO9YrX18xMKE3Pkb70XGrqvbK007WtjiZfLkL6PLYz"
        
        
        guard var urlComponents = URLComponents(string: urlString) else {
            completion(nil, NSError(domain: "Invalid URL", code: 0, userInfo: nil))
            return
        }
        
        urlComponents.queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        
        guard let url = urlComponents.url else {
            completion(nil, NSError(domain: "Invalid URL", code: 0, userInfo: nil))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            if let data = data {
                
                do {
                    let breeds = try JSONDecoder().decode([DogBreed].self, from: data)
                    completion(breeds, nil)
                } catch {
                    completion(nil, error)
                }
            }
        }.resume()
    }
}
