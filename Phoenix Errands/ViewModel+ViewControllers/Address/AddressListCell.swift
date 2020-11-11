//
//  AddressListCell.swift
//  Phoenix Errands
//
//  Created by Shyam Future Tech on 24/09/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import UIKit

class AddressListCell: UITableViewCell {
    
    @IBOutlet weak var imgRadioCheck: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAddressTitle: UILabel!
    @IBOutlet weak var lblFullAddress: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func cellInitializeCellDetails(cellDic : AddressList){
        
        lblAddressTitle.text = cellDic.title
        lblFullAddress.text = cellDic.fulladress
        lblPhone.text = cellDic.phone
    }
}
