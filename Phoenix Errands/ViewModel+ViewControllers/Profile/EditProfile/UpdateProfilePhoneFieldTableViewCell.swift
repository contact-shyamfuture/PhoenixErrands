//
//  UpdateProfilePhoneFieldTableViewCell.swift
//  Phoenix Errands
//
//  Created by Samir Samanta on 10/06/20.
//  Copyright © 2020 Shyam Future Tech. All rights reserved.
//

import UIKit
import FlagPhoneNumber
class UpdateProfilePhoneFieldTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var txtPhoneNumber: FPNTextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
