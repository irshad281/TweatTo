//
//  Constants.swift
//  TweakTo.Test
//
//  Created by Irshad Ahmed on 11/03/21.
//

import Foundation
import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()


class ImageLoader: UIImageView {

    var imageURL: URL?

    let activityIndicator = UIActivityIndicatorView()

    func loadImageWithUrl(_ url: String, completion:((_ image:UIImage?)->Void)?) {

        self.imageURL = URL.init(string: url)
        // setup activityIndicator...
        activityIndicator.color = .darkGray

        addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        image = nil
        activityIndicator.startAnimating()

        guard let imageUrl = self.imageURL else {return}
        
        // retrieves image if already available in cache
        if let imageFromCache = imageCache.object(forKey: imageUrl as AnyObject) as? UIImage {
            self.image = imageFromCache
            completion?(imageFromCache)
            activityIndicator.stopAnimating()
            return
        }

        
        URLSession.shared.dataTask(with: imageUrl) { (data, respnse, error) in
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                if let imageData = data {
                    let image = UIImage.init(data: imageData)
                    imageCache.setObject(image as AnyObject, forKey: imageUrl as AnyObject)
                    self.image = image
                    completion?(image)
                }
            }
        }
        .resume()
    }
}
