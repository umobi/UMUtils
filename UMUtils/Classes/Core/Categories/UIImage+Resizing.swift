//
//  UIImage+Resizing.swift
//  Umobi
//
//  Created by Ramon Vicente on 27/03/17.
//  Copyright © 2017 Umobi. All rights reserved.
//


import UIKit
import ImageIO

public extension UIImage {
    
    func square(toSize size: CGSize) -> UIImage? {
        return self.square()?.resize(toSize: size)
    }
    
    func square() -> UIImage? {
        let originalWidth  = self.size.width
        let originalHeight = self.size.height
        
        var edge: CGFloat
        if originalWidth > originalHeight {
            edge = originalHeight
        } else {
            edge = originalWidth
        }
        
        let posX = (originalWidth  - edge) / 2.0
        let posY = (originalHeight - edge) / 2.0
        
        let cropSquare = CGRect(x: posX, y: posY, width: edge, height: edge)
        
        if let imageRef = self.cgImage?.cropping(to: cropSquare) {
            return UIImage(cgImage: imageRef, scale: UIScreen.main.scale, orientation: self.imageOrientation)
        }
        return nil
    }
    
    func resize(toSize size: CGSize) -> UIImage? {
        
        let widthRatio  = size.width  / self.size.width
        let heightRatio = size.height / self.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: self.size.width * heightRatio, height: self.size.height * heightRatio)
        } else {
            newSize = CGSize(width: self.size.width * widthRatio,  height: self.size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, UIScreen.main.scale)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
