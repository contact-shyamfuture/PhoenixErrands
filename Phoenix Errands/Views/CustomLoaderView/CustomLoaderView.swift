//
//  CustomLoaderView.swift
//  LastingVideoMemories
//
//  Created by  Software Llp on 01/11/18.
//  Copyright © 2018 iOS Dev. All rights reserved.
//

import UIKit

class CustomLoaderView: UIView {
    @IBOutlet weak var imageView: UIImageView!

    class func instanceFromNib() -> CustomLoaderView {
        return UINib(nibName: "CustomLoaderView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomLoaderView
    }

    func initialize() {
        self.rounded(with: 5.0)
        self.imageView.contentMode = .scaleAspectFit
        let image = UIImage.gif(name: "loader")
        self.imageView.image = image
    }

    func hideLoader() {
        self.removeFromSuperview()
    }
    
}
