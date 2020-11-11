//
//  FaqCellTableViewCell.swift
//  Phoenix Errands
//
//  Created by Shyam Future Tech on 05/05/20.
//  Copyright © 2020 Shyam Future Tech. All rights reserved.
//

import UIKit

class FaqCellTableViewCell: UITableViewCell {

    @IBOutlet weak var lblAnswer: UILabel!
    @IBOutlet weak var lblQuestion: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
