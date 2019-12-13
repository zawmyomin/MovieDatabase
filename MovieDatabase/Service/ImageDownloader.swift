//
//  ImageDownloader.swift
//  MovieDatabase
//
//  Created by Justin Zaw on 01/12/2019.
//  Copyright © 2019 Justin Zaw. All rights reserved.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()

class ImageLoader{
    
      static func downloadImageWithUrl(url: URL, completion: @escaping (_ image: UIImage?, _ imgUrl: String,_ error: Error? ) -> Void) {
            
            if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
                completion(cachedImage, url.absoluteString,nil)
            } else {
                WSAPIClient.shared.getImageWithUrl(url: url) { (image, status) in
                    imageCache.setObject(image!, forKey: url.absoluteString as NSString)
                    completion(image, url.absoluteString,nil)
                }
            }
        }
}
