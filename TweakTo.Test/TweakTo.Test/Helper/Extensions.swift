//
//  Extensions.swift
//  TweakTo.Test
//
//  Created by Irshad Ahmed on 11/03/21.
//

import UIKit

var loader:UIActivityIndicatorView {
    let spinner = UIActivityIndicatorView(style: .medium)
    spinner.startAnimating()
    spinner.frame = .init(x: 0, y: 0, width: screen_width, height: 40)
    spinner.color = .black
    return spinner
}


extension UIScrollView {
    func shouldPaginate()->Bool {
        let currentOffset = self.contentOffset.y
        let maximumOffset = self.contentSize.height - self.frame.size.height
        if (maximumOffset - currentOffset <= 20) {
            return true
        }
        return false
    }
}




extension UIImage {
    
    func inverted()-> UIImage? {
        let beginImage = CIImage(image: self)
        if let filter = CIFilter(name: "CIColorInvert") {
            filter.setValue(beginImage, forKey: kCIInputImageKey)
            let newImage = UIImage(ciImage: filter.outputImage!)
            return newImage
        }
        return nil
    }
}
