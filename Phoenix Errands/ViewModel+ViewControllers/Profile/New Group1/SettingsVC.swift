//
//  SettingsVC.swift
//  Phoenix Errands
//
//  Created by Raghav Beriwala on 22/08/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import UIKit
import Localize_Swift

class SettingsVC: UIViewController
{
    @IBOutlet weak var tableView: UITableView!
    var nameArr = [String]()
    @IBOutlet weak var lblTxtName: UILabel!
    @IBOutlet weak var lblHTitle : UILabel!
    @IBOutlet weak var lblVersion : UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "ProfileCell", bundle: Bundle.main), forCellReuseIdentifier: "ProfileCell")
        setUI()
    
        if let name = AppPreferenceService.getString(PreferencesKeys.userFirstName) {
            lblTxtName.text = name + " " + AppPreferenceService.getString(PreferencesKeys.userLastName)!
        }
    }
    
    func setUI(){
        if Localize.currentLanguage() == "en"{
            lblHTitle.text = "Settings"
            //lblVersion.text = "Version of the application: 6.14.0(7)"
             nameArr = ["Change my password","Mode of payment","FAQ", "Terms and condition","Privacy Policy","Log Out"]
        }else{
            lblHTitle.text = "Réglages"
            //lblVersion.text = "Version de l'application: 6.14.0 (7)"
             nameArr = ["Changer mon mot de passe","Moyen de paiement","FAQ","Termes et conditions","Politique de confidentialité","Se déconnecter"]
        }
    }
    
    @IBAction func btnBackTapped(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
}

extension SettingsVC : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let Cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell") as! ProfileCell
        Cell.lblName.text = nameArr[indexPath.row]
        if indexPath.row == 1 || indexPath.row == 2
        {
            //Cell.btnDetails.isHidden = true
        }
        return Cell
    }
    
    func tableView( _ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected cell #\(indexPath.row)!")
        switch indexPath.row {
        case 0:
            let vc = UIStoryboard.init(name: "Profile", bundle: Bundle.main).instantiateViewController(withIdentifier: "ChangePasswordVC") as? ChangePasswordVC
            self.navigationController?.pushViewController(vc!, animated: true)
        case 1:
            let vc = UIStoryboard.init(name: "Activity", bundle: Bundle.main).instantiateViewController(withIdentifier: "PaymentMethodVC") as? PaymentMethodVC
            self.navigationController?.pushViewController(vc!, animated: true)
        case 2:
            let vc = UIStoryboard.init(name: "Profile", bundle: Bundle.main).instantiateViewController(withIdentifier: "FAQVC") as? FAQVC
            self.navigationController?.pushViewController(vc!, animated: true)
        case 4:
            let vc = UIStoryboard.init(name: "Profile", bundle: Bundle.main).instantiateViewController(withIdentifier: "PrivecyPolicyVC") as? PrivecyPolicyVC
            vc!.isTerm = false
            self.navigationController?.pushViewController(vc!, animated: true)
        case 3:
            let vc = UIStoryboard.init(name: "Profile", bundle: Bundle.main).instantiateViewController(withIdentifier: "PrivecyPolicyVC") as? PrivecyPolicyVC
            vc!.isTerm = true
            self.navigationController?.pushViewController(vc!, animated: true)
        case 5:
            let msg = Localize.currentLanguage() == "en" ? "Do You Want To Logout ?" : "Voulez-vous vous déconnecter?"
            self.showAlertWithDoubleButtons(title: commonAlertTitle, message: msg, okButtonText: "Ok".localized(), cancelButtonText: "Cancel".localized()){
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.openSignInViewController()
            }
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
}

