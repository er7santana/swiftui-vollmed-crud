//
//  WebService.swift
//  Vollmed
//
//  Created by Giovanna Moeller on 12/09/23.
//

import UIKit

struct WebService {
    
    let imageCache = NSCache<NSString, UIImage>()
    
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
