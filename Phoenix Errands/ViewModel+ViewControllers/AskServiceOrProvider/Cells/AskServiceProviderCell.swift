//
//  AskServiceProviderCell.swift
//  Phoenix Errands
//
//  Created by Shyam Future Tech on 09/08/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import UIKit

class AskServiceProviderCell: UITableViewCell {

    @IBOutlet weak var buttonRadio: UIImageView!
    @IBOutlet weak var lblOptionName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func initializeCellDetails(indexPath : Int , isProvider : Bool){
        
        if isProvider == true {
            switch indexPath {
            case 0:
                self.buttonRadio.image = UIImage(named: "Radio")!
            case 1:
                self.buttonRadio.image = UIImage(named: "RadioRed")!
            default:
                break
            }
        }else{
            switch indexPath {
            case 0:
                self.buttonRadio.image = UIImage(named: "RadioRed")!
            case 1:
                self.buttonRadio.image = UIImage(named: "Radio")!
            default:
                break
            }
        }
    }
}
