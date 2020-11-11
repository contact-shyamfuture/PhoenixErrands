//
//  AddAddressCell.swift
//  Phoenix Errands
//
//  Created by Shyam Future Tech on 24/09/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import UIKit

class AddAddressCell: UITableViewCell {

    @IBOutlet weak var txtField: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func initializeCellDetails(cellString : String , indexPath : Int , value : AddressParamModel){
        switch indexPath {
        case 0:
            txtField.placeholder = cellString
            txtField.keyboardType = .default
            txtField.text = value.title
        case 1:
            txtField.placeholder = cellString
            txtField.keyboardType = .default
            txtField.text = value.fulladress
        case 2:
            txtField.placeholder = cellString
            txtField.keyboardType = .numberPad
            txtField.text = value.phone
        default:
            break
        }
    }
}
