//
//  ProviderServiceCell.swift
//  Phoenix Errands
//
//  Created by Shyam Future Tech on 09/08/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import UIKit

class ProviderServiceCell: UICollectionViewCell {
    
    @IBOutlet weak var serviceImgIcon: UIImageView!
    @IBOutlet weak var lbServiceName: UILabel!
    @IBOutlet weak var imgCheckBox: UIImageView!
    
    func initializeCellDetails(cellDic : MySkillList){
        self.lbServiceName.text = cellDic.skillName
        
        if let icon = cellDic.skillIcon {
            let urlMain = APIConstants.baseURL + icon
            self.serviceImgIcon.sd_setImage(with: URL(string: urlMain))
        }
        
        if cellDic.isSelected == true {
            self.imgCheckBox.image = UIImage(named: "checkBoxSelect")!
        }else{
            self.imgCheckBox.image = UIImage(named: "checkBox")!
        }
    }
}
