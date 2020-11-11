//
//  ImageCollectionCell.swift
//  Phoenix Errands
//
//  Created by Shyam Future Tech on 06/09/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import UIKit
protocol AddPrescriptionImageProtocal {
    func captureImage(indexPath : Int)
    func removeImage(indexPath : Int)
}

class ImageCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var imageDocFile: UIImageView!
    @IBOutlet weak var imageAdd: UIImageView!
    @IBOutlet weak var btnPrescriptionImageOutlet: UIButton!
    @IBOutlet weak var addImageButtonAOutlet: UIButton!
    
    var addImageDelegate : AddPrescriptionImageProtocal?
    
    @IBAction func imageAddButton(_ sender: Any) {
        addImageDelegate?.captureImage(indexPath: (sender as AnyObject).tag)
    }
    @IBAction func buttonRemoveAction(_ sender: Any) {
        addImageDelegate?.removeImage(indexPath: (sender as AnyObject).tag)
    }
}
