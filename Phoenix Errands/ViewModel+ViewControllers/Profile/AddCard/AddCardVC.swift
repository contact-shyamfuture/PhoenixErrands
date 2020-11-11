//
//  AddCardVC.swift
//  Phoenix Errands
//
//  Created by Raghav Beriwala on 22/08/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import UIKit
import Localize_Swift

class AddCardVC: UIViewController
{
    @IBOutlet weak var lblHtitle : UILabel!
    @IBOutlet weak var lblMap : UILabel!
    @IBOutlet weak var btnScannerMap : UIButton!
    @IBOutlet weak var btnOk : UIButton!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setText()
    }
    func setText(){
        if Localize.currentLanguage() == "en"{
            lblHtitle.text = "Add a map"
            lblMap.text = "Map"
            btnScannerMap.setTitle("Scanner the Map", for: .normal)
            btnOk.setTitle("OK", for: .normal)
        }else{
            lblHtitle.text = "Ajouter une carte"
            lblMap.text = "Carte"
            btnScannerMap.setTitle("Scanner la carte", for: .normal)
            btnOk.setTitle("D'accord", for: .normal)
        }
        
    }
    @IBAction func scannCardTapped(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Profile", bundle: Bundle.main).instantiateViewController(withIdentifier: "ScannCardVC") as? ScannCardVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    @IBAction func btnBackTapped(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
}
