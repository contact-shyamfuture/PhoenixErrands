//
//  PostalCodeVC.swift
//  Phoenix Errands
//
//  Created by Shyam Future Tech on 09/08/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import UIKit
import Localize_Swift
import CoreLocation

class PostalCodeVC: UIViewController {

    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblHeaderTitle: UILabel!
    @IBOutlet weak var validateBtnView: RoundUIView!
    @IBOutlet weak var postalCode1: UITextField!
    @IBOutlet weak var postalCode2: UITextField!
    @IBOutlet weak var postalCode3: UITextField!
    @IBOutlet weak var postalCode4: UITextField!
    @IBOutlet weak var postalCode5: UITextField!
    @IBOutlet weak var btnValidateOutlet: UIButton!
    @IBOutlet weak var lblExample : UILabel!
    var serviceID : String?
    var serviceName = ""
    var isprovider : Bool?
    //var postalCode : String?
    var validateMsg = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.postalCode1.delegate = self
        self.postalCode2.delegate = self
        self.postalCode3.delegate = self
        self.postalCode4.delegate = self
        self.postalCode5.delegate = self
        postalCode1.becomeFirstResponder()
        
//        postalCode1.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
//        postalCode2.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
//        postalCode3.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
//        postalCode4.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
//        postalCode5.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        if Localize.currentLanguage() == "en" {
            btnValidateOutlet.setTitle("Validate", for: .normal)
            lblDescription.text = "Specify the postal code of the location of your project to \(serviceName) available nearby"
            lblHeaderTitle.text = "postal Code"
            lblExample.text = "Example : 75 100"
            validateMsg = "Please enter postal code"
        }else{
            btnValidateOutlet.setTitle("Valider", for: .normal)
            lblHeaderTitle.text = "Code postal"
            lblDescription.text = "Spécifiez le code postal de l'emplacement de votre projet pour cibler \(serviceName) disponibles à proximité"
            lblExample.text = "Exemple : 75 100"
            validateMsg = "Veuillez saisir le code postal"
        }
    }
    
    @IBAction func buttonBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonValidate(_ sender: Any) {
        
        if ((postalCode1.text?.count)! != 1) {
            
            self.showAlertWithSingleButton(title: commonAlertTitle, message: validateMsg, okButtonText: okText, completion: nil)
            
        }else if ((postalCode2.text?.count)! != 1){
            self.showAlertWithSingleButton(title: commonAlertTitle, message: validateMsg, okButtonText: okText, completion: nil)
            
        }else if ((postalCode3.text?.count)! != 1){
            self.showAlertWithSingleButton(title: commonAlertTitle, message: validateMsg, okButtonText: okText, completion: nil)
            
        }else if ((postalCode4.text?.count)! != 1){
            self.showAlertWithSingleButton(title: commonAlertTitle, message: validateMsg, okButtonText: okText, completion: nil)
            
        }else if ((postalCode5.text?.count)! != 1){
            self.showAlertWithSingleButton(title: commonAlertTitle, message: validateMsg, okButtonText: okText, completion: nil)
            
        }else{
            let vc = UIStoryboard.init(name: "Dashboard", bundle: Bundle.main).instantiateViewController(withIdentifier: "ServiceQuestionAnswerVC") as? ServiceQuestionAnswerVC
            vc!.serviceID = serviceID
            vc!.isprovider = isprovider
            vc!.postalCode = postalCode1!.text! + postalCode2!.text! + postalCode3!.text! + postalCode4!.text! + postalCode5!.text!
            self.navigationController?.pushViewController(vc!, animated: false)
        }
    }
    
    @objc func textFieldDidChange(textField: UITextField){
        let text = textField.text
        if  text?.count == 1 {
            switch textField{
            case postalCode1:
                postalCode2.becomeFirstResponder()
            case postalCode2:
                postalCode3.becomeFirstResponder()
            case postalCode3:
                postalCode4.becomeFirstResponder()
            case postalCode4:
                postalCode5.becomeFirstResponder()
            case postalCode5:
                postalCode5.resignFirstResponder()
            default:
                break
            }
        }
        if  text?.count == 0 {
            switch textField{
            case postalCode1:
                postalCode1.becomeFirstResponder()
            case postalCode2:
                postalCode2.becomeFirstResponder()
            case postalCode3:
                postalCode3.becomeFirstResponder()
            case postalCode4:
                postalCode4.becomeFirstResponder()
            case postalCode5:
                postalCode5.resignFirstResponder()
            default:
                break
            }
        }
        else{
            
        }
    }
}
extension PostalCodeVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        //textField.text = ""
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        let txtAfterUpdate = textField.text! as NSString
        let updateText = txtAfterUpdate.replacingCharacters(in: range, with: string) as NSString
        print("Updated TextField:: \(updateText)")
        
        if (textField.text!.count < 1) && (string.count > 0){
            if textField == postalCode1{
                postalCode2.becomeFirstResponder()
            }
            if textField == postalCode2{
                postalCode3.becomeFirstResponder()
            }
            if textField == postalCode3{
                postalCode4.becomeFirstResponder()
            }
            if textField == postalCode4{
                postalCode5.becomeFirstResponder()
            }
            if textField == postalCode5{
                postalCode5.resignFirstResponder()
            }
            
            textField.text = string
            return false
        }else if (textField.text!.count >= 1) && (string.count == 0){
            if textField == postalCode2{
                postalCode1.becomeFirstResponder()
            }
            if textField == postalCode3{
                postalCode2.becomeFirstResponder()
            }
            if textField == postalCode4{
                postalCode3.becomeFirstResponder()
            }
            if textField == postalCode5{
                postalCode4.becomeFirstResponder()
            }
            if textField == postalCode1{
                postalCode1.resignFirstResponder()
            }
            textField.text = ""
            return false
        }else if (textField.text!.count >= 1){
            textField.text = string
            return false
        }
       
        return true
    }
}
