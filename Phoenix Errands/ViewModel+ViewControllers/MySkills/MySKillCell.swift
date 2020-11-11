//
//  MySKillCell.swift
//  Phoenix Errands
//
//  Created by Shyam Future Tech on 01/10/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import UIKit
import Localize_Swift
protocol removeSkillsDelegates {
    func removeSkill(indexPathValue : Int)
}
class MySKillCell: UICollectionViewCell {
    
    @IBOutlet weak var btnRemovSkillOutlet: UIButton!
    @IBOutlet weak var lblSkillName: UILabel!
    @IBOutlet weak var imgSkillIcon: UIImageView!
    @IBOutlet weak var imgCheckBox: UIImageView!
    var delegate : removeSkillsDelegates?
    
    func initializeCellDetails(cellDic : SkillListListModel){
        
        if Localize.currentLanguage() == "en" {
            self.lblSkillName.text = cellDic.skillName
        }else{
            self.lblSkillName.text = cellDic.fr_skillName
        }
        
        if cellDic.isSelected == true {
            self.imgCheckBox.image = UIImage(named: "checkBoxSelect")!
        }else{
            self.imgCheckBox.image = UIImage(named: "checkBox")!
        }
    }
    
    @IBAction func btnRemoveAction(_ sender: Any) {
        delegate?.removeSkill(indexPathValue: (sender as AnyObject).tag)
    }
}
