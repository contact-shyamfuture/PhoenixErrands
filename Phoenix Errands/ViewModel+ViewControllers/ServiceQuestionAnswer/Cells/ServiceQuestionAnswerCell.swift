//
//  ServiceQuestionAnswerCell.swift
//  Phoenix Errands
//
//  Created by Shyam Future Tech on 09/08/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import UIKit

class ServiceQuestionAnswerCell: UITableViewCell {

    @IBOutlet weak var imgRadioCheck: UIImageView!
    @IBOutlet weak var lblQuestionName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
