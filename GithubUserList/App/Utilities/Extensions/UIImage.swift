//
//  UIImage.swift
//  GithubUserList
//
//  Created by Vince Santos on 8/1/20.
//  Copyright © 2020 Vince Santos. All rights reserved.
//

import UIKit

extension UIImage {
    func invertedImage() -> UIImage? {
        
        let img = CoreImage.CIImage(cgImage: self.cgImage!)
        
        let filter = CIFilter(name: "CIColorInvert")
        filter!.setDefaults()
        
        filter!.setValue(img, forKey: "inputImage")
        
        let context = CIContext(options:nil)
        
        let cgimg = context.createCGImage((filter?.outputImage!)!, from: (filter?.outputImage!.extent)!)

        return UIImage(cgImage: cgimg!)
    }
}
