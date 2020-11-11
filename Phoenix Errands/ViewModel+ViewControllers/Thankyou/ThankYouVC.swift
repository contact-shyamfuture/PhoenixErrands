//
//  ThankYouVC.swift
//  Phoenix Errands
//
//  Created by Shyam Future Tech on 09/08/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import UIKit
import Localize_Swift

class ThankYouVC: BaseViewController {

    @IBOutlet weak var lblProviderMsg: UILabel!
    @IBOutlet weak var lblHTitle: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var btnContinue: UIButton!
    
    var isprovider : Bool?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerView.lblHeaderTitle.isHidden = true
        headerView.imgProfileIcon.isHidden = false
        headerView.imgProfileIcon.image = UIImage(named:"closebtn")
        headerView.menuButtonOutlet.isHidden = false
        headerView.notificationValueView.isHidden = true
        headerView.imgViewMenu.isHidden = false
        headerView.menuButtonOutlet.tag = 1
        headerView.imgViewMenu.isHidden = true//image = UIImage(named:"whiteback")
        tabBarView.isHidden = true
        if isprovider == true {
            lblMessage.text = Localize.currentLanguage() == "en" ? "Thank you for submiting your request." : "Merci d'avoir soumis votre demande."
            
            lblProviderMsg.text = Localize.currentLanguage() == "en" ? "Your provider registration successfull." : "L'inscription de votre fournisseur a réussi."
        }else{
            lblMessage.text = Localize.currentLanguage() == "en" ? "We have alerted the service providers on Phoenix Errands around you." : "Nous avons alerté les prestataires de services sur Phoenix Errands autour de vous."
            
            lblProviderMsg.text = Localize.currentLanguage() == "en" ? "Your request has been sent, we have notified our service providers around you." : "Votre demande a bien été envoyée, nous en avons informé nos prestataires autour de vous."
        }
        lblHTitle.text = Localize.currentLanguage() == "en" ? "Your request has been sent" : "Votre demande à été envoyé"
        let continueTitle = Localize.currentLanguage() == "en" ? "Continue " : "Continuer"
        btnContinue.setTitle(continueTitle, for: .normal)
    }
    
    @IBAction func submitBtnAction(_ sender: Any) {
        if isprovider == true {
            let vc = UIStoryboard.init(name: "Profile", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddServiceVC") as? AddServiceVC
            self.navigationController?.pushViewController(vc!, animated: true)
        }else{
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKind(of: DashboardVC.self) {
                    self.navigationController!.popToViewController(controller, animated: true)
                    break
                }
                
            }
        }
    }
}
