//
//  RegisterHeaderCell.swift
//  Phoenix Errands
//
//  Created by Shyam Future Tech on 07/08/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import UIKit

protocol RegisterDelegate
{
    func registerWithGmailAction()
    func registerWithFaceBookAction()
    func passwordOpenAction()
}

class RegisterHeaderCell: UITableViewCell
{
    var btnDelegate : RegisterDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func btnFacebookAction(_ sender: Any)
    {
        self.btnDelegate?.registerWithFaceBookAction()
    }
    @IBAction func btnGoogleAction(_ sender: Any)
    {
        self.btnDelegate?.registerWithGmailAction()
    }
}

class RegisterFieldCell: UITableViewCell {
    
    var btnTxtDelegate : RegisterDelegate?
    @IBOutlet weak var imgPasswordOpen: UIImageView!
    @IBOutlet weak var paswwordOpenView: UIView!
    @IBOutlet weak var txtField: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func initializeCell(cellDic : UserRegister , indexPath : Int){
        switch indexPath {
        case 1:
            paswwordOpenView.isHidden = true
            txtField.text = cellDic.userFirstName
        case 2:
            paswwordOpenView.isHidden = true
            txtField.text = cellDic.userLastName
        case 3:
            paswwordOpenView.isHidden = true
            txtField.text = cellDic.userEmail
        case 4:
            paswwordOpenView.isHidden = false
            if cellDic.isPasswordOpen == false {
                imgPasswordOpen.image = UIImage(named: "eyeHide")
                txtField.isSecureTextEntry = true
            }else{
                txtField.isSecureTextEntry = false
                imgPasswordOpen.image = UIImage(named: "eyeOpen")
            }
            txtField.text = cellDic.userpassword
        default:
            break
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func btnPasswordOpenAction(_ sender: Any) {
        btnTxtDelegate?.passwordOpenAction()
    }
}
