//
//  RegisterVC.swift
//  Phoenix Errands
//
//  Created by Shyam Future Tech on 07/08/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import UIKit
import FacebookLogin
import FBSDKLoginKit
import GoogleSignIn

class RegisterVC: UIViewController {

    @IBOutlet weak var registerTable: UITableView!
    var placeHolderArr : NSArray?
    var registerObject = UserRegister()
    
    lazy var viewModel: RegisterVM = {
        return RegisterVM()
    }()
    var userDetails = UserResponse()
    var fbdataDict = [String:Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.placeHolderArr = ["First Name" , "Last Name" , "Email", "Password"]
        self.registerTable.delegate = self
        self.registerTable.dataSource = self
         self.registerTable.register(UINib(nibName: "RegisterPasswordCheckCell", bundle: Bundle.main), forCellReuseIdentifier: "RegisterPasswordCheckCell")
        self.initializeViewModel()
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCloseAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnRegisterAction(_ sender: Any) {
        registerObject.userPhone = ""
        registerObject.userFCMToken = UserDefaults.standard.string(forKey: PreferencesKeys.userToken)!
        registerObject.social_type = "0"
        registerObject.fb_token = ""
        registerObject.google_token = ""
        viewModel.sendRegisterCredentialsToAPIService(user : registerObject)
    }
    
    func registerWithGmailAction(){
        GIDSignIn.sharedInstance().clientID = "321505110953-rrdi1bhiec35e9usncs01si24sdoh67j.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().signIn()
    }
    
    func registerWithFaceBookAction(){
        let fbLoginManager : LoginManager = LoginManager()
        fbLoginManager.loginBehavior = LoginBehavior.browser
        fbLoginManager.logOut()
        fbLoginManager.logIn(permissions: ["public_profile","email"], from: self) { (result, error) -> Void in
            if error != nil {
                self.dismiss(animated: true, completion: nil)
            }
            else if (result?.isCancelled)! {
                self.dismiss(animated: true, completion: nil)
            }
            else{
                self.getFBUserData()
            }
        }
    }
    
    func getFBUserData() {
        GraphRequest(graphPath: "me?fields", parameters: ["fields": "id, name , first_name, last_name, email"]).start(completionHandler: { (connection, result, error) -> Void in
            if (error == nil){
                let fbDetails = result as! NSDictionary
                self.fbdataDict = fbDetails as! [String : Any]
            }else{
                print(error?.localizedDescription ?? "Not found")
            }
        })
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
                
                if  (self?.viewModel.userDetails.status) == 200 {
                    self!.userDetails = (self?.viewModel.userDetails)!
                    
                    AppPreferenceService.setInteger(IS_LOGGED_IN, key: PreferencesKeys.loggedInStatus)
                    AppPreferenceService.setString(String((self?.viewModel.userDetails.id!)!), key: PreferencesKeys.userID)
                    AppPreferenceService.setString(String((self?.viewModel.userDetails.email!)!), key: PreferencesKeys.userName)
                    AppPreferenceService.setString(String((self?.viewModel.userDetails.authorizationToke!)!), key: PreferencesKeys.userToken)
                    AppPreferenceService.setString(String((self?.viewModel.userDetails.userFirstName!)!), key: PreferencesKeys.userFirstName)
                    AppPreferenceService.setString(String((self?.viewModel.userDetails.userLastName!)!), key: PreferencesKeys.userLastName)
                    if self?.viewModel.userDetails.image != nil {
                        AppPreferenceService.setString(String((self?.viewModel.userDetails.image!)!), key: PreferencesKeys.userImage)
                    }
                  //  let appDelegate = UIApplication.shared.delegate as! AppDelegate
                  //  appDelegate.openHomeViewController()                    
                    
                    self?.showAlertWithSingleButton(title: "Registration completed successfully", message: "Please check your registered email for verification", okButtonText: okText, completion: {
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.openLoginInViewController()
                    })
                    
                }else if (self?.viewModel.userDetails.status) == 201 {
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message: (self?.viewModel.userDetails.errorMsg![0])!, okButtonText: okText, completion: nil)
                }else{
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message: (self?.viewModel.userDetails.message)!, okButtonText: okText, completion: nil)
                }
            }
        }
    }
    
    func passwordOpenAction(){
        
        if registerObject.isPasswordOpen == false {
            registerObject.isPasswordOpen = true
        }else{
            registerObject.isPasswordOpen = false
        }
        registerTable.reloadData()
    }
}

extension RegisterVC : UITableViewDelegate, UITableViewDataSource, RegisterDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (placeHolderArr?.count)! + 2
    }
    
    //"leftmenu-icon-messages.png"
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let Cell = tableView.dequeueReusableCell(withIdentifier: "RegisterHeaderCell") as! RegisterHeaderCell
            Cell.btnDelegate = self
            return Cell
        case 1...4:
            let Cell = tableView.dequeueReusableCell(withIdentifier: "RegisterFieldCell") as! RegisterFieldCell
            let name = placeHolderArr![indexPath.row - 1]
            Cell.txtField.placeholder = (name as! String)
            Cell.txtField.delegate = self
            Cell.txtField.tag = indexPath.row
            
            Cell.btnTxtDelegate = self
            Cell.initializeCell(cellDic : registerObject , indexPath : indexPath.row)
            return Cell
        case 5:
            let Cell = tableView.dequeueReusableCell(withIdentifier: "RegisterPasswordCheckCell") as! RegisterPasswordCheckCell
            Cell.initializeCell(cellDic: registerObject, indexPath: indexPath.row)
            return Cell
        default:
            return UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "Cell")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 0//180
        case 1...4:
            return 75
        case 5:
            return 330
        default:
            return 0
        }
    }
}

extension RegisterVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        let txtAfterUpdate = textField.text! as NSString
        let updateText = txtAfterUpdate.replacingCharacters(in: range, with: string) as NSString
        print("Updated TextField:: \(updateText)")
        switch textField.tag {
            case 1:
                registerObject.userFirstName = updateText as String
            case 2:
                registerObject.userLastName = updateText as String
            case 3:
                registerObject.userEmail = updateText as String
            case 4:
                registerObject.userpassword = updateText as String
                let indexPath = IndexPath(item: 5, section: 0)
                registerTable.reloadRows(at: [indexPath], with: .none)
            default:
                break
        }
        return true
    }
}
