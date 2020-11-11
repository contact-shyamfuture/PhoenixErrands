//
//  ServiceCell.swift
//  Phoenix Errands
//
//  Created by Raghav Beriwala on 11/09/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import UIKit

class ServiceCell: UITableViewCell
{
    @IBOutlet weak var bidView: RoundUIView!
    
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var btnBid: UIButton!
    @IBOutlet weak var btnInfo: UIButton!
    @IBOutlet weak var btnDetails: UIButton!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblBidAmount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
