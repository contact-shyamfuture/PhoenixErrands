//
//  WereGoingVC.swift
//  Phoenix Errands
//
//  Created by Raghav Beriwala on 22/08/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import UIKit
import Localize_Swift

class WereGoingVC: UIViewController {
    @IBOutlet weak var txtAccountNumber: UITextField!
    @IBOutlet weak var txtBankName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var lbl1 : UILabel!
    @IBOutlet weak var lbl2 : UILabel!
    @IBOutlet weak var lbl3 : UILabel!
    @IBOutlet weak var lbl4 : UILabel!
    @IBOutlet weak var btnValidate : UIButton!
    
    //OTP VIew Outlets
    @IBOutlet weak var vwOTP : UIView!
    @IBOutlet weak var txtOTP1 : UITextField!
    @IBOutlet weak var txtOTP2 : UITextField!
    @IBOutlet weak var txtOTP3 : UITextField!
    @IBOutlet weak var txtOTP4 : UITextField!
    @IBOutlet weak var btnOTPSave : UIButton!
    
    var tappedEdit = true
    
    lazy var viewModel: CardSaveVM = {
        return CardSaveVM()
    }()
    var cardSave = CardSaveModel()
    override func viewDidLoad(){
        super.viewDidLoad()
        getCardDetails()
        self.initializeViewModel()
        setUI()
    }
    
    func setUI(){
        if Localize.currentLanguage() == "en"{
            lbl1.text = "Receive my remunerations"
            lbl2.text = "Your IBAN will not be visible publicly, it will be used to pay your remuneration into your bank account"
            lbl3.text = ""
            lbl4.text = "Account Details"
            txtFirstName.placeholder = "First Name"
            txtLastName.placeholder = "Last Name"
            txtBankName.placeholder = "Bank Name"
            txtAccountNumber.placeholder = "Account Number"
            btnValidate.setTitle("Validate", for: .normal)
            btnOTPSave.setTitle("SUBMIT", for: .normal)
        }else{
            lbl1.text = "Recevez mes rémunérations"
            lbl2.text = "Votre IBAN ne sera pas visible publiquement, il sera utilisé pour verser votre rémunération sur votre compte bancaire"
            lbl3.text = ""
            lbl4.text = "Détails du compte"
            txtFirstName.placeholder = "Prénom"
            txtLastName.placeholder = "dernier"
            txtBankName.placeholder = "Nom de banque"
            txtAccountNumber.placeholder = "Numéro de compte"
            btnValidate.setTitle("Valider", for: .normal)
            btnOTPSave.setTitle("SOUMETTRE", for: .normal)
        }
    }
    
    func getCardDetails(){
        vwOTP.isHidden = true
        txtOTP1.delegate = self
        txtOTP2.delegate = self
        txtOTP3.delegate = self
        txtOTP4.delegate = self
        viewModel.getVendorDetailsToAPIService()
    }
    
    func saveCardDetails(){
        
        let param = IBANParams()
        param.provider_id = AppPreferenceService.getString(PreferencesKeys.userID)
        param.account_holder_name = self.txtFirstName.text! + " " + self.txtLastName.text!
        param.account_number = self.txtAccountNumber.text
        param.bank_name = self.txtBankName.text
        viewModel.saveVendorDetailsToAPIService(user: param)
    }
    
    func initializeViewModel() {
            
            viewModel.showAlertClosure = {[weak self]() in
                DispatchQueue.main.async {
                    if let message = self?.viewModel.alertMessage {
                        self?.showAlertWithSingleButton(title: commonAlertTitle, message: message, okButtonText: okText, completion: nil)
                    }
                }
            }
            
            viewModel.updateLoadingStatus = {[weak self]() in
                DispatchQueue.main.async {
                    
                    let isLoading = self?.viewModel.isLoading ?? false
                    if isLoading {
                        self?.addLoaderView()
                    } else {
                        self?.removeLoaderView()
                    }
                }
            }
            
            viewModel.refreshViewClosure = {[weak self]() in
                DispatchQueue.main.async {
                    
                    if (self?.viewModel.cardSave.status) == 200
                    {
                        self?.showAlertWithSingleButton(title: commonAlertTitle, message: (self?.viewModel.cardSave.message)!, okButtonText: okText, completion: {
                            if self?.tappedEdit == true {
                               self?.vwOTP.isHidden = false
                               self?.txtOTP1.becomeFirstResponder()
                            }else{
                                self?.navigationController?.popViewController(animated: true)
                            }
                        })
                    }
                    else{
                        self?.showAlertWithSingleButton(title: commonAlertTitle, message: (self?.viewModel.cardSave.message)!, okButtonText: okText, completion: nil)
                    }
                }
            }
        
            viewModel.refreshGETViewClosure = {[weak self]() in
                DispatchQueue.main.async {
                    if (self?.viewModel.cardGET.status) == 200
                    {
                        self?.tappedEdit = true
                        //print(self?.viewModel.cardGET.provider_id)
                        if let name = self?.viewModel.cardGET.account_holder_name {
                            let splitStr = name.components(separatedBy: " ")
                            if splitStr.count > 1 {
                                self?.txtFirstName.text = splitStr[0]
                                self?.txtLastName.text = splitStr[1]
                            }else{
                                self?.txtFirstName.text = name
                            }
                        }
                        self?.txtBankName.text = self?.viewModel.cardGET.bank_name ?? ""
                        self?.txtAccountNumber.text = self?.viewModel.cardGET.account_number ?? ""
                    }
                    else{
                         self?.tappedEdit = false
                    }
                }
            }
        }
    
    
    @IBAction func btnBackTapped(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSubmitBnkDetailsAction(_ sender: Any) {
        self.saveCardDetails()
    }
    
    @IBAction func btnCrossOTPVw(_ sender : UIButton){
        vwOTP.isHidden = true
    }
    
    @IBAction func btnSaveOTPVw(_ sender : UIButton){
        let otp = txtOTP1.text! + txtOTP2.text! + txtOTP3.text! + txtOTP4.text!
        print(String(describing: self.viewModel.cardSave.otp!))
        if otp != ""{
            if otp == String(self.viewModel.cardSave.otp!){
                self.tappedEdit = false
                let param = IBANParams()
                let userID = AppPreferenceService.getString(PreferencesKeys.userID)
                param.provider_id = userID //String(describing: self.viewModel.cardGET.provider_id!)
                param.account_holder_name = self.txtFirstName.text! + " " + self.txtLastName.text!
                param.account_number = self.txtAccountNumber.text
                param.bank_name = self.txtBankName.text
                param.otp = self.viewModel.cardSave.otp!
                viewModel.saveVendorDetailsToAPIService(user: param)
            }else{
                let msg = Localize.currentLanguage() == "en" ? "Please put the correct otp" : "Veuillez mettre le bon otp"
                self.showAlertWithSingleButton(title: commonAlertTitle, message: msg, okButtonText: okText, completion: nil)
            }
        }else{
             let msg = Localize.currentLanguage() == "en" ? "Please put the correct otp" : "Veuillez mettre le bon otp"
            self.showAlertWithSingleButton(title: commonAlertTitle, message: msg, okButtonText: okText, completion: nil)
        }
    }
}
//TextField Delegate
extension WereGoingVC : UITextFieldDelegate{
    
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
            if textField == txtOTP1{
                txtOTP2.becomeFirstResponder()
            }
            if textField == txtOTP2{
                txtOTP3.becomeFirstResponder()
            }
            if textField == txtOTP3{
                txtOTP4.becomeFirstResponder()
            }
            if textField == txtOTP4{
                txtOTP4.resignFirstResponder()
            }
            
            textField.text = string
            return false
        }else if (textField.text!.count >= 1) && (string.count == 0){
            if textField == txtOTP2{
                txtOTP1.becomeFirstResponder()
            }
            if textField == txtOTP3{
                txtOTP2.becomeFirstResponder()
            }
            if textField == txtOTP4{
                txtOTP3.becomeFirstResponder()
            }
            if textField == txtOTP1{
                txtOTP1.resignFirstResponder()
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
