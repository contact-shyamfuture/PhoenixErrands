//
//  TextBoxCell.swift
//  Phoenix Errands
//
//  Created by Shyam Future Tech on 04/09/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import UIKit
import Localize_Swift

class TextBoxCell: UITableViewCell {

    @IBOutlet weak var questionAnswerTxtView: UITextView!
    @IBOutlet weak var lblYourText : UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
