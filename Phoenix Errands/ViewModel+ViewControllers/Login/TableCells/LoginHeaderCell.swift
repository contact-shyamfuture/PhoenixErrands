//
//  LoginHeaderCell.swift
//  Phoenix Errands
//
//  Created by Shyam Future Tech on 07/08/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import UIKit
import Localize_Swift
protocol LoginDelegate {
    func logInWithGmailAction()
    func logInWithFaceBookAction()
    func ForgotPasswordAction()
    func passwordEyeAction()
}

class LoginHeaderCell: UITableViewCell {

    var btnDelegate : LoginDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    @IBAction func btnFacebookAction(_ sender: Any) {
        self.btnDelegate?.logInWithFaceBookAction()
    }
    
    @IBAction func btnGoogleAction(_ sender: Any) {
        self.btnDelegate?.logInWithGmailAction()
    }
}



class LoginEmailPasswordCell: UITableViewCell {
    @IBOutlet weak var imgEyeIcon: UIImageView!
    
    @IBOutlet weak var txtFieldEmail: UITextField!
    @IBOutlet weak var txtFieldPassword: UITextField!
    @IBOutlet weak var btnForgetpas : UIButton!
    var btnDelegate : LoginDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        txtFieldEmail.placeholder = Localize.currentLanguage() == "en" ? "Email" : "Email"
        txtFieldPassword.placeholder = Localize.currentLanguage() == "en" ? "Password" : "Mot de passe"
        let btnTitle =  Localize.currentLanguage() == "en" ? "Forgot your password?" : "Mot de passe oublié?"
        btnForgetpas.setTitle(btnTitle, for: .normal)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func initializeCellObject(cellDic : UserModel){
         self.txtFieldEmail.text = cellDic.userName
         self.txtFieldPassword.text = cellDic.userPassword
        if cellDic.isPasswordOpen == false {
            imgEyeIcon.image = UIImage(named: "eyeHide")
            txtFieldPassword.isSecureTextEntry = true
        }else{
            txtFieldPassword.isSecureTextEntry = false
            imgEyeIcon.image = UIImage(named: "eyeOpen")
        }
    }
    
    @IBAction func buttonForgotPasswordAction(_ sender: Any) {
        self.btnDelegate?.ForgotPasswordAction()
    }
    
    @IBAction func openPassword(_ sender: Any) {
        self.btnDelegate?.passwordEyeAction()
    }
}
