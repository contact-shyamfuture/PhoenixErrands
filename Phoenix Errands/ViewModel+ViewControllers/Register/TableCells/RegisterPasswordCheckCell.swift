//
//  RegisterPasswordCheckCell.swift
//  Phoenix Errands
//
//  Created by Shyam Future Tech on 08/08/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import UIKit

class RegisterPasswordCheckCell: UITableViewCell {

    
    @IBOutlet weak var imgTinyLatter: UIImageView!
    @IBOutlet weak var imgCapitalLatter: UIImageView!
    @IBOutlet weak var imgSpecialCharacter: UIImageView!
    @IBOutlet weak var imgEightCharacter: UIImageView!
    @IBOutlet weak var lblDescriptionTxt: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    func initializeCell(cellDic : UserRegister , indexPath : Int){
        
        if (cellDic.userpassword != nil ) && (cellDic.userpassword?.count)! >= 8 {
            self.imgEightCharacter.image = UIImage(named: "GreenCheck")!
        }else{
            self.imgEightCharacter.image = UIImage(named: "Radio")!
        }
        
        if (cellDic.userpassword != nil ){
            if checkTextSufficientCapitalresult(text: cellDic.userpassword!){
                self.imgCapitalLatter.image = UIImage(named: "GreenCheck")!
            }else{
                self.imgCapitalLatter.image = UIImage(named: "Radio")!
            }
            
            if checkTextSufficientSpecialresult(text: cellDic.userpassword!){
                self.imgSpecialCharacter.image = UIImage(named: "GreenCheck")!
            }else{
                self.imgSpecialCharacter.image = UIImage(named: "Radio")!
            }
            
            if checkTextSufficientAlphabet(text: cellDic.userpassword!){
                self.imgTinyLatter.image = UIImage(named: "GreenCheck")!
            }else{
                self.imgTinyLatter.image = UIImage(named: "Radio")!
            }
        }
    }
    
    func checkTextSufficientCapitalresult(text : String) -> Bool{
        
        let capitalLetterRegEx  = ".*[A-Z]+.*"
        let texttest = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
        let capitalresult = texttest.evaluate(with: text)
        print("\(capitalresult)")
        
        return capitalresult
    }
    
    func checkTextSufficientAlphabet(text : String) -> Bool{
        
        let capitalLetterRegEx  = ".*[a-z]+.*"
        let texttest = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
        let capitalresult = texttest.evaluate(with: text)
        print("\(capitalresult)")
        
        return capitalresult
    }
    
    func checkTextSufficientSpecialresult(text : String) -> Bool{
        let specialCharacterRegEx  = ".*[!&^%$#@()/]+.*"
        let texttest2 = NSPredicate(format:"SELF MATCHES %@", specialCharacterRegEx)
        
        let specialresult = texttest2.evaluate(with: text)
        print("\(specialresult)")
        
        let numberRegEx  = ".*[0-9]+.*"
        let texttest1 = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        let numberresult = texttest1.evaluate(with: text)
        print("\(numberresult)")
        
        
        return specialresult || numberresult
        
    }
}
