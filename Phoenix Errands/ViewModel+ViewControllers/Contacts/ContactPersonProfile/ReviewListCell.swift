//
//  ReviewListCell.swift
//  Phoenix Errands
//
//  Created by Shyam Future Tech on 01/11/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import UIKit

class ReviewListCell: UITableViewCell {

    @IBOutlet var imgStart: [UIImageView]!
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblReviewComments: UILabel!
    
    var rating : Int? {
        didSet{
            let tmpRating : Int = self.rating!
            var pos = 0
            
            for obj in imgStart {
                
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
