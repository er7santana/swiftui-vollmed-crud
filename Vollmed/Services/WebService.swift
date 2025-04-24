//
//  WebService.swift
//  Vollmed
//
//  Created by Giovanna Moeller on 12/09/23.
//

import UIKit

struct WebService {
    
    private let baseURL = "http://localhost:3000"
    let imageCache = NSCache<NSString, UIImage>()
    
    func getAllSpecialists() async throws -> [Specialist]? {
        let endpoint = baseURL + "/especialista"
        guard let url = URL(string: endpoint) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let specialists = try JSONDecoder().decode([Specialist].self, from: data)
        return specialists
    }
    
    func downloadImage(from url: String) async -> UIImage? {
        guard let url = URL(string: url) else { return nil }
        
        // Verificar cache
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            return cachedImage
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else { return nil }
            
            // Armazenar imagem no cache
            imageCache.setObject(image, forKey: url.absoluteString as NSString)
            
            return image
        } catch {
            print("Error downloading image: \(error)")
            return nil
        }
    }
}
