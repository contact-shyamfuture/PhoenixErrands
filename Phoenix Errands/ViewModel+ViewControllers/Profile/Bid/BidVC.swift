//
//  BidVC.swift
//  Phoenix Errands
//
//  Created by Raghav Beriwala on 10/09/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import UIKit
import Localize_Swift
class BidVC: UIViewController
{
    @IBOutlet weak var lblHeaderTitle: UILabel!
    @IBOutlet weak var txtAmount: UITextField!
    @IBOutlet weak var lblCurrency : UILabel!
    var requestid: Int?
    lazy var viewModel: BidVM = {
        return BidVM()
    }()
    var biddetails = BidModel()
    @IBOutlet weak var btnSubmitOutlet: UIButton!
     
    var toolBar = UIToolbar()
    var picker  = UIPickerView()
    var amountSign = ["Dollar($)","Euro(€)","Pound(£)"]
    var SelectSign = "",updateTextFieldAmount = ""
    var valueType = Int()
    
    override func viewDidLoad(){
        super.viewDidLoad()
       // txtAmount.delegate = self
        initializeViewModel()
        if Localize.currentLanguage() == "en" {
            lblHeaderTitle.text = "Bid"
            btnSubmitOutlet.setTitle("SEND", for: .normal)
            txtAmount.placeholder = "Amount"
        }else{
            txtAmount.placeholder = "Montante"
            lblHeaderTitle.text = "offre"
            btnSubmitOutlet.setTitle("Envoyer", for: .normal)
        }
        lblCurrency.text = "$"
        valueType = 1
        txtAmount.keyboardType = .decimalPad
        
        txtAmount.addTarget(self, action: #selector(myTextFieldDidChange), for: .editingChanged)
    }
    @objc func myTextFieldDidChange(_ textField: UITextField) {
        if let amountString = textField.text?.currencyInputFormatting() {
            txtAmount.text = amountString
        }
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
                
                if  (self?.viewModel.bidService.status) == 200
                {
                    self!.biddetails = (self?.viewModel.bidService)!
                    
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message: (self?.viewModel.bidService.message)!, okButtonText: okText, completion: {
                        self?.navigationController?.popViewController(animated: true)
                    })
                    
                    
                }else{
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message: (self?.viewModel.bidService.message)!, okButtonText: okText, completion: nil)
                }
            }
        }
    }
    
    @IBAction func btnBackTapped(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnDropDownAction(_ sender : UIButton){
        txtAmount.endEditing(true)
        picker = UIPickerView.init()
        picker.delegate = self
        picker.backgroundColor = UIColor.white
        picker.setValue(UIColor.black, forKey: "textColor")
        picker.autoresizingMask = .flexibleWidth
        picker.contentMode = .center
        picker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
        self.view.addSubview(picker)

        toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
        toolBar.barStyle = .default
        toolBar.items = [UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(onDoneButtonTapped))]
        self.view.addSubview(toolBar)
    }
    
    @objc func onDoneButtonTapped() {
        toolBar.removeFromSuperview()
        picker.removeFromSuperview()
        lblCurrency.text = SelectSign
    }
    
    @IBAction func btnSubmitTapped(_ sender: Any){
        
        print(txtAmount.text as Any)
        let bidParams = BidParams()
        if requestid != nil
        {
            bidParams.servicerequestid = requestid
        }
        else{
             
        }
        if SelectSign != ""{
            if self.txtAmount.text != "" {
                let value = txtAmount.text!.replacingOccurrences(of: ",", with: "", options: NSString.CompareOptions.literal, range:nil)
                if value != "" {
                    bidParams.proposalamount = Double(value)
                }else{
                    bidParams.proposalamount = Double(self.txtAmount.text!)
                }
                bidParams.type = valueType
                viewModel.getBidServicesToAPIService(user: bidParams)
            }else{
                self.showAlertWithSingleButton(title: commonAlertTitle, message: "Please enter proposal amount", okButtonText: okText, completion: nil)
            }
        }else{
            self.showAlertWithSingleButton(title: commonAlertTitle, message: "Please select currency first", okButtonText: okText, completion: nil)
        }
    }
    
    static func df2so(_ price: Double) -> String{
        let numberFormatter = NumberFormatter()
        numberFormatter.groupingSeparator = ","
        numberFormatter.groupingSize = 3
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.decimalSeparator = "."
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 2
        return numberFormatter.string(from: price as NSNumber)!
    }
}

extension BidVC : UITextFieldDelegate{
 
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//
//        let txtAfterUpdate = textField.text! as NSString
//        let updateText = txtAfterUpdate.replacingCharacters(in: range, with: string) as String
//        print("Updated TextField:: \(updateText)")
////        //let valueTXt = updateText.replacingOccurrences(of: ",", with: "", options: NSString.CompareOptions.literal, range:nil)
////        let doubleValue = Double(updateText)
////        let value = BidVC.df2so(doubleValue!)
////        txtAmount.text = ""
////        txtAmount.text = value
//        updateTextFieldAmount = updateText
////        txtAmount.text?.removeAll()
////
////        let largeNumber = Double(updateText)//31908551587
////        let numberFormatter = NumberFormatter()
////        numberFormatter.numberStyle = .decimal
////        let formattedNumber = numberFormatter.string(from: NSNumber(value:largeNumber!))
////        txtAmount.text = formattedNumber
//        return true
//    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {


         let formatter = NumberFormatter()
         formatter.numberStyle = .decimal
         formatter.locale = Locale.current
         formatter.maximumFractionDigits = 0


        if let groupingSeparator = formatter.groupingSeparator {

            if string == groupingSeparator {
                return true
            }
            if let textWithoutGroupingSeparator = textField.text?.replacingOccurrences(of: groupingSeparator, with: "") {
                var totalTextWithoutGroupingSeparators = textWithoutGroupingSeparator + string
                if string.isEmpty { // pressed Backspace key
                    totalTextWithoutGroupingSeparators.removeLast()
                }
                if let numberWithoutGroupingSeparator = formatter.number(from: totalTextWithoutGroupingSeparators),
                    let formattedText = formatter.string(from: numberWithoutGroupingSeparator) {

                    txtAmount.text = formattedText
                    updateTextFieldAmount = formattedText
                    return false
                }
            }
        }
        return true
    }
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//
//        // max 2 fractional digits allowed
//        let newText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
//        let regex = try! NSRegularExpression(pattern: "\\..{3,}", options: [])
//        let matches = regex.matches(in: newText, options:[], range:NSMakeRange(0, newText.count))
//        guard matches.count == 0 else { return false }
//
//        switch string {
//        case "0","1","2","3","4","5","6","7","8","9":
//            return true
//        case ".":
//            let array = textField.text?.map { String($0) }
//            var decimalCount = 0
//            for character in array! {
//                if character == "." {
//                    decimalCount += 1
//                }
//            }
//            if decimalCount == 1 {
//                return false
//            } else {
//                return true
//            }
//        default:
//            let array = string.map { String($0) }
//            if array.count == 0 {
//                return true
//            }
//            return false
//        }
//    }
}

extension BidVC : UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return amountSign.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return amountSign[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(amountSign[row])
        switch  amountSign[row]{
        case "Euro(€)":
            SelectSign = "€"
            valueType = 2
        case "Pound(£)":
            SelectSign = "£"
            valueType = 3
        default:
            SelectSign = "$"
            valueType = 1
        }
        
    }
}
extension String {
    // formatting text for currency textField
    func currencyInputFormatting() -> String {
        
        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        
        var amountWithPrefix = self
        
        // remove from String: "$", ".", ","
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count), withTemplate: "")
        
        let double = (amountWithPrefix as NSString).doubleValue
        number = NSNumber(value: (double / 100))
        
        // if first number is 0 or all numbers were deleted
        guard number != 0 as NSNumber else {
            return ""
        }
        
        return formatter.string(from: number)!
    }
}
