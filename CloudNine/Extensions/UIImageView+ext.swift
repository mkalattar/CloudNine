//
//  UIImageView+ext.swift
//  CloudNine
//
//  Created by Mohamed Attar on 25/03/2025.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    func load(urlString: String) {
        let url = URL(string: urlString)
        
        guard let url else {
            return
        }
        
        image = nil
        
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = imageFromCache
            return
        }
        
        URLSession.shared.dataTask(with: url) {
            data, response, error in
            if let response = data {
                DispatchQueue.main.async {
                    let imageToCache = UIImage(data: response)
                    imageCache.setObject(imageToCache!, forKey: urlString as AnyObject)
                    self.image = imageToCache
                }
            } else {
                self.image = UIImage(named: "imgError")
            }
        }.resume()
    }
}
