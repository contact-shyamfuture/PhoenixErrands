//
//  AddPaymentVC.swift
//  Phoenix Errands
//
//  Created by Raghav Beriwala on 19/08/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import UIKit
import Localize_Swift

class AddPaymentVC: UIViewController
{

    @IBOutlet weak var btnAddacard: UIButton!
    @IBOutlet weak var lblAddAccount: UILabel!
    @IBOutlet weak var lblDoNotHaveAccount: UILabel!
    @IBOutlet weak var imgThumb: UIImageView!
    @IBOutlet weak var lblHeader: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        imgThumb.layer.cornerRadius = imgThumb.frame.size.width/2
        imgThumb.clipsToBounds = true
        imgThumb.layer.borderColor = UIColor(red:17/255, green:136/255, blue:255/255, alpha: 1).cgColor
        imgThumb.layer.borderWidth = 1
        setText()

    }
    @IBAction func addPaymentTapped(_ sender: Any)
    {
        let vc = UIStoryboard.init(name: "Profile", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddCardVC") as? AddCardVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    @IBAction func btnBackTapped(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func setText()
    {
        if Localize.currentLanguage() == "en"{
            lblHeader.text = "Means of payment"
            lblDoNotHaveAccount.text = "You do not have a payment method"
            lblAddAccount.text = "You can add a map to book a provider faster"
            btnAddacard.setTitle("Add a map", for: UIControl.State.normal)
        }else{
            lblHeader.text = "Moyens de paiement"
            lblDoNotHaveAccount.text = "Vous n'avez pas de mode de paiement"
            lblAddAccount.text = "Vous pouvez ajouter une carte pour réserver un fournisseur plus rapidement"
            btnAddacard.setTitle("Ajouter une carte", for: UIControl.State.normal)
        }
        
        //headerView.lblHeaderTitle.text = "My profile".localized();
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name( LCLLanguageChangeNotification), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
}
