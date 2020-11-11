//
//  ContactCollectionViewCell.swift
//  Phoenix Errands
//
//  Created by Raghav Beriwala on 13/08/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import UIKit

class ContactCollectionViewCell: UICollectionViewCell
{
    @IBOutlet weak var ratingCountLbl: UILabel!
    @IBOutlet weak var imgContactView: UIImageView!
    @IBOutlet weak var lblContactName: UILabel!
    
    @IBOutlet var startRatingImg: [UIImageView]!
    
    
    var rating : Int? {
        didSet{
            let tmpRating : Int = self.rating!
            var pos = 0
            
            for obj in startRatingImg {
                
                if (pos >= tmpRating)
                {
                    obj.image = UIImage(named: "starEmptyIcon")
                }
                else{
                    obj.image = UIImage(named: "star-fill-128")
                }
                pos += 1
            }
        }
    }
    
    func initializeCellDetails(cellDic : ContactList){
        lblContactName.text = cellDic.contactName
        if let ratigValue = cellDic.contactRating {
            let ratingFloat = Float(ratigValue)
            self.rating = Int(ratingFloat!)
        }else{
            self.rating = 0
        }
        if let ratingCount = cellDic.contactTotalRating {
            self.ratingCountLbl.text = "( " + String(ratingCount) + " )"
        }else{
            self.ratingCountLbl.text = "(0)"
        }
        
        if cellDic.contactImage != nil {
            let urlMain = APIConstants.baseImageURL + cellDic.contactImage!
            self.imgContactView.sd_setImage(with: URL(string: urlMain))
        }else{
            self.imgContactView.image = UIImage(named: "download")
        }
    }
}
