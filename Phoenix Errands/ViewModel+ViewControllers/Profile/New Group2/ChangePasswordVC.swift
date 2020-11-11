//
//  ChangePasswordVC.swift
//  Phoenix Errands
//
//  Created by Raghav Beriwala on 22/08/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import UIKit
import Localize_Swift

class ChangePasswordVC: UIViewController {
    
    
    @IBOutlet weak var lblTitle : UILabel!
    @IBOutlet weak var txtFldCurrentPass : UITextField!
    @IBOutlet weak var txtFldNewPass : UITextField!
    @IBOutlet weak var txtFldChangePass : UITextField!
    @IBOutlet weak var lblPassHint1 : UILabel!
    @IBOutlet weak var lblPassHint2 : UILabel!
    @IBOutlet weak var lblPassHint3 : UILabel!
    @IBOutlet weak var lblPassHint4 : UILabel!
    @IBOutlet weak var btnforgetPass : UIButton!
    @IBOutlet weak var btnSaveOutlet : UIButton!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        setText()
    }
    
    func setText(){
        lblTitle.text = Localize.currentLanguage() == "en" ? "Change your password" : "changez votre mot de passe"
        txtFldCurrentPass.placeholder = Localize.currentLanguage() == "en" ? "Current Password" : "Mot de passe actuel"
        txtFldNewPass.placeholder = Localize.currentLanguage() == "en" ? "New Password" : "nouveau mot de passe"
        txtFldChangePass.placeholder = Localize.currentLanguage() == "en" ? "Confirm Password" : "Confirmez le mot de passe"
        lblPassHint1.text = Localize.currentLanguage() == "en" ? "A tiny one" : "Un tout petit"
        lblPassHint2.text = Localize.currentLanguage() == "en" ? "A capital lattrum" : "Un lattrum capital"
        lblPassHint3.text = Localize.currentLanguage() == "en" ? "A special number or carectere" : "Un numéro spécial ou un carectère"
        lblPassHint4.text = Localize.currentLanguage() == "en" ? "8 characters minimum" : "8 caractères minimum"
        let title1 = Localize.currentLanguage() == "en" ? "Forgot your password" : "Mot de passe oublié"
        btnforgetPass.setTitle(title1, for: .normal)
        let title2 = Localize.currentLanguage() == "en" ? "Save" : "sauvegarder"
        btnSaveOutlet.setTitle(title2, for: .normal)
    }
    
    @IBAction func btnBackTapped(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
}
