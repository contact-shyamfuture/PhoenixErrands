//
//  CheckOutVC.swift
//  Phoenix Errands
//
//  Created by Shyam Future Tech on 25/09/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import UIKit
import Braintree
import Stripe
import MaterialComponents.MaterialCards
import Localize_Swift

class CheckOutVC: BaseViewController {
    
    
    var paymentIntentClientSecret: String?
    var paymentMethodId: String?
    
    @IBOutlet weak var paymentCardView: UIView!
    @IBOutlet weak var addressLine: UITextView!
    @IBOutlet weak var cityTxtField: UITextField!
    @IBOutlet weak var stateTxtField: UITextField!
    @IBOutlet weak var countryTxtField: UITextField!
    @IBOutlet weak var postalCodeTxtField: UITextField!
    var billingAddress : String = ""
    
    
    @IBOutlet weak var lblFullAddress: UILabel!
    @IBOutlet weak var billingAddressBtnOutlet: UIButton!
    @IBOutlet weak var billingAddressMainView: UIView!
    @IBOutlet weak var billingAddressBgView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var cardListCollectionView: UICollectionView!
    @IBOutlet weak var txtExpDate: UITextField!
    @IBOutlet weak var txtCvvNumber: UITextField!
    @IBOutlet weak var txtCardNumber: UITextField!
    var clientToken : String?
    var nonce:String?
    var strstripeCode : String?
    var proposalID : Int = 0
    @IBOutlet weak var btnBillingAddress: UIButton!
    lazy var viewModel: PaymentVM = {
        return PaymentVM()
    }()
    
    lazy var viewProfileModel: ProfileVM = {
        return ProfileVM()
    }()
    
    var PaymentDetails = PaymentModel()
    let card = MDCCard()
    
    var userCardList : [UserCardList]?
    var isExistingCardPay = false
    var isExistingToken : String?
    
    
    lazy var payButton: UIButton = {
        let button = UIButton(type: .custom)
        button.layer.cornerRadius = 5
        button.backgroundColor = .systemBlue
        button.titleLabel?.font = UIFont.systemFont(ofSize: 22)
        button.setTitle("Pay", for: .normal)
        button.addTarget(self, action: #selector(acceptProposal), for: .touchUpInside)
        return button
    }()
    
    lazy var cardTextField: STPPaymentCardTextField = {
        let cardTextField = STPPaymentCardTextField()
        return cardTextField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeViewModel()
        //self.acceptProposal()
        setText()
        billingAddressMainView.isHidden = true
        billingAddressBgView.isHidden = true
        btnBillingAddress.layer.masksToBounds = true
        btnBillingAddress.layer.cornerRadius = 15//btnBillingAddress.frame.width/2
        
        billingAddressBtnOutlet.layer.masksToBounds = true
        billingAddressBtnOutlet.layer.cornerRadius = billingAddressBtnOutlet.frame.width/2
        
        
        txtCardNumber.keyboardType = .numberPad
        txtCvvNumber.keyboardType = .numberPad
        txtExpDate.delegate = self
        txtCardNumber.delegate = self

        self.cardListCollectionView.register(UINib(nibName: "CardListCell", bundle: Bundle.main), forCellWithReuseIdentifier:  "CardListCell")
        self.cardListCollectionView.delegate = self
        self.cardListCollectionView.dataSource = self
        
        
        view.backgroundColor = .white
        let stackView = UIStackView(arrangedSubviews: [cardTextField, payButton])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        paymentCardView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leftAnchor.constraint(equalToSystemSpacingAfter: paymentCardView.leftAnchor, multiplier: 2),
            paymentCardView.rightAnchor.constraint(equalToSystemSpacingAfter: stackView.rightAnchor, multiplier: 2),
            stackView.topAnchor.constraint(equalToSystemSpacingBelow: paymentCardView.topAnchor, multiplier: 2),
        ])
        
        getProfileDetailsview()
        initializeViewProfileModel()
    }
    
    func getProfileDetailsview(){
        viewProfileModel.getProfileDetailsToAPIService()
    }
    
    func setText(){
        
       // UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
        
        if #available(iOS 13.0, *) {
            let statusBar = UIView(frame: UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
             statusBar.backgroundColor = UIColor.clear
             UIApplication.shared.keyWindow?.addSubview(statusBar)
        } else {
             UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
        }
        if Localize.currentLanguage() == "en"{
            headerView.lblHeaderTitle.text = "Wallet"//"Card Details"
            txtCardNumber.placeholder = "Card Number"
            lblTitle.text = "Use this card for your payment on Phoenix Errands"
        }else{
            headerView.lblHeaderTitle.text = "Wallet"//"Détails de la carte"
            txtCardNumber.placeholder = "Numéro de carte"
            lblTitle.text = "Utilisez cette carte pour votre paiement sur Phoenix Errands"
        }
        headerView.imgProfileIcon.isHidden = false
        headerView.menuButtonOutlet.isHidden = false
        headerView.imgViewMenu.isHidden = false
        headerView.menuButtonOutlet.tag = 1
        headerView.imgViewMenu.image = UIImage(named:"whiteback")
        headerView.notificationValueView.isHidden = true
        headerView.imgProfileIcon.isHidden = true
    }
    
    @IBAction func btnBillingAddressAction(_ sender: Any) {
        billingAddressMainView.isHidden = false
        billingAddressBgView.isHidden = false
    }
    
    @IBAction func billingAddressCancelBtn(_ sender: Any) {
        billingAddressMainView.isHidden = true
        billingAddressBgView.isHidden = true
    }
    
    @IBAction func btnBillingAddressSave(_ sender: Any) {
        
        if addressLine.text == "" {
            self.showAlertWithSingleButton(title: commonAlertTitle, message:"Please enter address line", okButtonText: okText, completion: nil)
        } else if cityTxtField.text == "" {
            self.showAlertWithSingleButton(title: commonAlertTitle, message:"Please enter city", okButtonText: okText, completion: nil)
        }else if stateTxtField.text == "" {
            self.showAlertWithSingleButton(title: commonAlertTitle, message:"Please enter state", okButtonText: okText, completion: nil)
        }else if countryTxtField.text == "" {
            self.showAlertWithSingleButton(title: commonAlertTitle, message:"Please enter country", okButtonText: okText, completion: nil)
        }else if postalCodeTxtField.text == "" {
            self.showAlertWithSingleButton(title: commonAlertTitle, message:"Please enter postal code", okButtonText: okText, completion: nil)
        }else{
            billingAddress = "\(addressLine.text!) , \(cityTxtField.text!) , \(stateTxtField.text!) , \(countryTxtField.text!) , \(postalCodeTxtField.text!)"
            lblFullAddress.text = billingAddress
            billingAddressMainView.isHidden = true
            billingAddressBgView.isHidden = true
        }
    }
    
    @IBAction func btnOkTapped(_ sender: Any){
        //callStripeViewControllerMethod()
        isExistingToken = nil
        isExistingCardPay = false
        if txtCardNumber.text == "" {
            self.showAlertWithSingleButton(title: commonAlertTitle, message:"Please enter valid card number", okButtonText: okText, completion: nil)
        }else if txtExpDate.text == "" {
            
            self.showAlertWithSingleButton(title: commonAlertTitle, message:"Please enter expiry date", okButtonText: okText, completion: nil)
            
        }else if txtCvvNumber.text == "" {
            
            self.showAlertWithSingleButton(title: commonAlertTitle, message:"Please enter valid CVV number", okButtonText: okText, completion: nil)
            
        }else if addressLine.text == "" {
            self.showAlertWithSingleButton(title: commonAlertTitle, message:"Please enter address line", okButtonText: okText, completion: nil)
        } else if cityTxtField.text == "" {
            self.showAlertWithSingleButton(title: commonAlertTitle, message:"Please enter city", okButtonText: okText, completion: nil)
        }else if stateTxtField.text == "" {
            self.showAlertWithSingleButton(title: commonAlertTitle, message:"Please enter state", okButtonText: okText, completion: nil)
        }else if countryTxtField.text == "" {
            self.showAlertWithSingleButton(title: commonAlertTitle, message:"Please enter country", okButtonText: okText, completion: nil)
        }else if postalCodeTxtField.text == "" {
            self.showAlertWithSingleButton(title: commonAlertTitle, message:"Please enter postal code", okButtonText: okText, completion: nil)
        }else{
            self.acceptProposal()
        }
    }
    
    @IBAction func scanCardTapped(_ sender: Any){
        let vc = UIStoryboard.init(name: "Profile", bundle: Bundle.main).instantiateViewController(withIdentifier: "ScannCardVC") as? ScannCardVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @objc func acceptProposal(){
        let obj = AcceptProposalParam()
        obj.proposal_id = proposalID
        viewModel.sendAcceptProposalToAPIService(user: obj)
    }
    
    func postPaymentDetails(stripeToken : String){
        let obj = AcceptProposalParam()
        obj.stripeToken = stripeToken
        obj.contactid = Int(PaymentDetails.id!)
        obj.proposal_id = proposalID
        viewModel.sendPaymentDetailsToAPIService(user: obj)
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
                if (self?.viewModel.PaymentDetails.status) == 200 {
                    self!.PaymentDetails = (self?.viewModel.PaymentDetails)!
                    if self!.isExistingCardPay == true{
                        self!.postPaymentDetails(stripeToken: self!.isExistingToken!)
                    }else{
                        self!.callStripeViewControllerMethod()
                    }
                    
                }else{
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message:(self?.viewModel.PaymentDetails.message)!, okButtonText: okText, completion: nil)
                }
            }
        }
        
        viewModel.refreshPaymentViewClosure = {[weak self]() in
            DispatchQueue.main.async {
                if (self?.viewModel.PaymentDetails.status) == 200 {
                    
//                    self?.showAlertWithSingleButton(title: commonAlertTitle, message:alertPaymentSucessMessage, okButtonText: okText, completion: {
//                        let vc = UIStoryboard.init(name: "Activity", bundle: Bundle.main).instantiateViewController(withIdentifier: "MyORderVC") as? MyORderVC
//                        vc!.tagID = 3
//                        self!.navigationController?.pushViewController(vc!, animated: true)
//                    })
                    if self?.viewModel.PaymentDetails.client_secret != nil {
                        self!.paymentIntentClientSecret = self?.viewModel.PaymentDetails.client_secret
                        self!.paymentMethodId = self?.viewModel.PaymentDetails.PaymentID
                        
                        if self!.isExistingCardPay == true{
                            self!.confirmPaymentIntents(clientSecret: self!.paymentIntentClientSecret!, paymentMethodId: self!.paymentMethodId!)
                        }else{
                            self!.pay()
                        }
                    }
                    
                }else if (self?.viewModel.PaymentDetails.status) == 201 {
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message:(self?.viewModel.PaymentDetails.error)!, okButtonText: okText, completion: {
                        self?.navigationController?.popViewController(animated: true)
                    })
                }else {
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message:(self?.viewModel.PaymentDetails.message)!, okButtonText: okText, completion: nil)
                }
            }
        }
        
        viewModel.refreshDeleteViewClosure = {[weak self]() in
            DispatchQueue.main.async {
                if (self?.viewModel.deleteCardModel.status) == 200 {
                    
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message:(self?.viewModel.deleteCardModel.message)!, okButtonText: okText, completion: {
                        self?.getProfileDetailsview()
                    })
                }else{
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message:(self?.viewModel.deleteCardModel.message)!, okButtonText: okText, completion: nil)
                }
            }
        }
        
        viewModel.refreshConfirmPaymentViewClosure = {[weak self]() in
            DispatchQueue.main.async {
                if (self?.viewModel.confirmPayment.status) == 200 {
                    
                    let vc = UIStoryboard.init(name: "Activity", bundle: Bundle.main).instantiateViewController(withIdentifier: "MyORderVC") as? MyORderVC
                    vc!.tagID = 3
                    self!.navigationController?.pushViewController(vc!, animated: true)
                    
                }else{
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message:(self?.viewModel.confirmPayment.message)!, okButtonText: okText, completion: nil)
                }
            }
        }
    }
    
    
    func initializeViewProfileModel() {
        
        viewProfileModel.showAlertClosure = {[weak self]() in
            DispatchQueue.main.async {
                if let message = self?.viewProfileModel.alertMessage {
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message: message, okButtonText: okText, completion: nil)
                }
            }
        }
        
        viewProfileModel.updateLoadingStatus = {[weak self]() in
            DispatchQueue.main.async {
                
                let isLoading = self?.viewProfileModel.isLoading ?? false
                if isLoading {
                    self?.addLoaderView()
                } else {
                    self?.removeLoaderView()
                }
            }
        }
        
        viewProfileModel.refreshViewClosure = {[weak self]() in
            DispatchQueue.main.async {
                
                if (self?.viewProfileModel.profileDetails.status) == 200 {
                    
                    self!.userCardList = self?.viewProfileModel.profileDetails.ProfileDetails!.userCardList
                    self!.cardListCollectionView.reloadData()
                    
                }
                else{
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message: (self?.viewProfileModel.profileDetails.message)!, okButtonText: okText, completion: nil)
                }
            }
        }
    }
    
    
    func callStripeViewControllerMethod(){
        
        let cardParams = STPCardParams()
        let cardParamsValue = cardTextField.cardParams
        cardParams.number = cardParamsValue.number
        cardParams.expYear = cardParamsValue.expYear as! UInt
        cardParams.expMonth = cardParamsValue.expMonth as! UInt //UInt(expMonth)!
        cardParams.cvc = cardParamsValue.cvc//txtCvvNumber.text//myPaymentCardTextField.cvc
        
        //cardParams.phone_number = ""
        
        STPAPIClient.shared().createToken(withCard: cardParams) { token, error in
            guard let token = token else {
                self.showAlertWithSingleButton(title: commonAlertTitle, message: error!.localizedDescription, okButtonText: okText, completion: nil)
                return
            }
//           // print(token)
//           // self.handleResponse()
            self.postPaymentDetails(stripeToken: token.tokenId)
//           // self.extraSecurityCheck()
        }
    }
    
    func handleResponse() {
        // Payment failed
        let paymentHandler = STPPaymentHandler.shared()
        let clientSecret = "sk_test_bVtEHlHruzVtZQ2MYg6Ylqwh00a9BoeT0d"//json["clientSecret"] as! String
        paymentHandler.handleNextAction(forPayment: clientSecret, authenticationContext: self, returnURL: nil) { status, paymentIntent, handleActionError in
            switch (status) {
            case .failed:
                // Display handleActionError to the customer
                break
            case .canceled:
                // Canceled
                break
            case .succeeded:
                // The card action has been handled
                // Send the PaymentIntent ID to your server and confirm it again
                break
            @unknown default:
                fatalError()
                break
            }
        }
    }
    
    
    func extraSecurityCheck(){
        
        let uiCustomization = STPPaymentHandler.shared().threeDSCustomizationSettings.uiCustomization
        uiCustomization.textFieldCustomization.keyboardAppearance = .dark
        uiCustomization.navigationBarCustomization.barStyle = .black
        uiCustomization.navigationBarCustomization.textColor = .white
        uiCustomization.buttonCustomization(for: .cancel).textColor = .white
    }
    
    func confirmPayment(){
        let param = ConfirmPaymentParam()
        param.contact_id = Int(PaymentDetails.id!)
        viewModel.confirmPaymentToAPIService(user: param)
    }
}

extension CheckOutVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == txtExpDate
        {
            if string == "" {
                return true
            }
            
            let currentText = txtExpDate.text! as NSString
            let updatedText = currentText.replacingCharacters(in: range, with: string)
            
            txtExpDate.text = updatedText
            let numberOfCharacters = updatedText.count
            if numberOfCharacters == 2 {
                txtExpDate.text?.append("/")
            }
            return false
        }
        if textField == txtCardNumber
        {
            let replacementStringIsLegal = string.rangeOfCharacter(from: NSCharacterSet(charactersIn: "0123456789").inverted) == nil
            
            if !replacementStringIsLegal
            {
                return false
            }
            
            let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            let components = newString.components(separatedBy: NSCharacterSet(charactersIn: "0123456789").inverted)
            
            let decimalString = components.joined(separator: "") as NSString
            let length = decimalString.length
            let hasLeadingOne = length > 0 && decimalString.character(at: 0) == (1 as unichar)
            
            if length == 0 || (length > 16 && !hasLeadingOne) || length > 19
            {
                let newLength = (textField.text! as NSString).length + (string as NSString).length - range.length as Int
                
                return (newLength > 16) ? false : true
            }
            var index = 0 as Int
            let formattedString = NSMutableString()
            
            if hasLeadingOne
            {
                formattedString.append("1 ")
                index += 1
            }
            if length - index > 4
            {
                let prefix = decimalString.substring(with: NSMakeRange(index, 4))
                formattedString.appendFormat("%@-", prefix)
                index += 4
            }
            
            if length - index > 4
            {
                let prefix = decimalString.substring(with: NSMakeRange(index, 4))
                formattedString.appendFormat("%@-", prefix)
                index += 4
            }
            if length - index > 4
            {
                let prefix = decimalString.substring(with: NSMakeRange(index, 4))
                formattedString.appendFormat("%@-", prefix)
                index += 4
            }
            
            
            let remainder = decimalString.substring(from: index)
            formattedString.append(remainder)
            textField.text = formattedString as String
            print("remainder==>\(remainder)")
            print("formattedString==>\(formattedString)")
            print("textField.text==>\(textField.text)")
            return false
        }
        else
        {
            return true
        }
    }
    
    func cardInActiveActive(index : Int){
     
        let alertController = UIAlertController(title: commonAlertTitle, message: "You want to delete?".localized(), preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            UIAlertAction in
            NSLog("OK Pressed")
            self.deleteCardDetails(cardId: self.userCardList![index].id!)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func deleteCardDetails(cardId : String){
        let param = DeleteCardParam()
        param.card_id = cardId
        viewModel.deleteCardDetailsToAPIService(user: param)
    }
    
    func pay() {
        guard let paymentIntentClientSecret = paymentIntentClientSecret else {
            return;
        }
        // Collect card details
        let cardParams = cardTextField.cardParams
        let paymentMethodParams = STPPaymentMethodParams(card: cardParams, billingDetails: nil, metadata: nil)
        let paymentIntentParams = STPPaymentIntentParams(clientSecret: paymentIntentClientSecret)
        paymentIntentParams.paymentMethodParams = paymentMethodParams
        

        // Submit the payment
        let paymentHandler = STPPaymentHandler.shared()
        paymentHandler.confirmPayment(withParams: paymentIntentParams, authenticationContext: self) { (status, paymentIntent, error) in
            switch (status) {
            case .failed:
                self.displayAlert(title: "Payment failed", message: error?.localizedDescription ?? "")
                break
            case .canceled:
                self.displayAlert(title: "Payment canceled", message: error?.localizedDescription ?? "")
                break
            case .succeeded:
               // self.displayAlert(title: "Payment succeeded", message: paymentIntent?.description ?? "", restartDemo: true)
                self.confirmPayment()
                break
            @unknown default:
                fatalError()
                break
            }
        }
    }
    
    func confirmPaymentIntents(clientSecret:String, paymentMethodId:String){
        let paymentIntentParams = STPPaymentIntentParams(clientSecret: clientSecret)
        paymentIntentParams.paymentMethodId = paymentMethodId
        paymentIntentParams.returnURL = "com.PhoenixErrands.payments" // to open your app after 3D authentication
        let paymentManager = STPPaymentHandler.shared()
        paymentManager.confirmPayment(withParams: paymentIntentParams, authenticationContext: self) { (status, paymentIntent, error) in
            switch (status)
            {
            case .succeeded:
                print("success")
                self.confirmPayment()
                break
            case .canceled:
                print("cancel")
                // Handle cancel
                break
            case .failed:
                print("failed")
                // Handle error
                break
            @unknown default:
                print("Error")
            }
        }
    }
    
    func displayAlert(title: String, message: String, restartDemo: Bool = false) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            if restartDemo {
                alert.addAction(UIAlertAction(title: "Restart demo", style: .cancel) { _ in
                    self.cardTextField.clear()
                   // self.startCheckout()
                })
            }else {
                alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            }
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension CheckOutVC : UICollectionViewDelegate , UICollectionViewDataSource,UICollectionViewDelegateFlowLayout , cardActiveInActiveDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int)-> Int {
        if userCardList != nil  && userCardList!.count > 0 {
            return userCardList!.count
        }else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardListCell", for: indexPath as IndexPath) as! CardListCell
        cell.delegate = self
        cell.initializeCellDetails(cellDic: userCardList![indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width : CGFloat = 264
        let height: CGFloat = 120
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        return UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        isExistingToken = userCardList![indexPath.row].id!
        isExistingCardPay = true
        self.acceptProposal()
    }
}

extension CheckOutVC: STPAuthenticationContext {
    func authenticationPresentingViewController() -> UIViewController {
        return self
    }
}
