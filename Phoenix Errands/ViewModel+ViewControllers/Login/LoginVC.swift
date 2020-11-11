//
//  LoginVC.swift
//  Phoenix Errands
//
//  Created by Shyam Future Tech on 07/08/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import UIKit
import FacebookLogin
import FBSDKLoginKit
import FBSDKCoreKit
import GoogleSignIn
import Crashlytics
import Localize_Swift
import Alamofire

class LoginVC: UIViewController{
    @IBOutlet weak var loginTableView: UITableView!
    @IBOutlet weak var lblHTitle : UILabel!
    @IBOutlet weak var btnLogin : UIButton!
    var userObject = UserModel()
    
    lazy var viewModel: LoginVM = {
        return LoginVM()
    }()
    lazy var registerViewModel: RegisterVM = {
        return RegisterVM()
    }()
    var userDetails = UserResponse()
    var fbdataDict = [String:Any]()
    var popup: ForgotPassword!
    var testData : String?
    
    var userSelectedImage : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loginTableView.delegate = self
        self.loginTableView.dataSource = self
        self.initializeViewModel()
       // userObject.userName = "samir.samanta@gmail.com"//"sata@gmail.com"//"h.oo@aol.fr"//"sata@gmail.com"//."samir.samanta@gmail.com"// "asif@gmail.com"  //"sata@gmail.com"//"asif@gmail.com"//
      //  userObject.userPassword = "Shaila@12345" //"Pw123456"//"Shaila@12345" //"Samir1103@1qaz"//"Shaila@12345"//
//        print("login check")
       // Crashlytics.sharedInstance().crash()
       // print(testData!)
        self.initializeRegisterViewModel()
        setText()
    }
    
    func setText(){
        lblHTitle.text = Localize.currentLanguage() == "en" ? "Log In" : "s'identifier"
        let btnLoginTitle = Localize.currentLanguage() == "en" ? "Log In" : "s'identifier"
        btnLogin.setTitle(btnLoginTitle, for: .normal)
    }
    
    @IBAction func btnCloseAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonLoginSubmitAction(_ sender: Any){
//        Crashlytics.sharedInstance().crash()
        userObject.userFCMToken = UserDefaults.standard.string(forKey: PreferencesKeys.userToken)!
        viewModel.sendLoginCredentialsToAPIService(user: userObject)
    }
    
    func logInWithGmailAction() {
        GIDSignIn.sharedInstance().clientID = "321505110953-rrdi1bhiec35e9usncs01si24sdoh67j.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().signIn()
    }
    
    func logInWithFaceBookAction(){
        
        
//        let fbLoginManager : LoginManager = LoginManager()
//        fbLoginManager.loginBehavior = LoginBehavior.browser
//        fbLoginManager.logOut()
//        fbLoginManager.logIn(permissions: ["public_profile","email"], from: self) { (result, error) -> Void in
//            if error != nil {
//                self.dismiss(animated: true, completion: nil)
//
//            }else if (result?.isCancelled)! {
//
//                self.dismiss(animated: true, completion: nil)
//
//            }else{
//                self.getFBUserData()
//            }
//        }
        
//        let loginManager = LoginManager()
//        loginManager.logIn(
//            permissions: ["public_profile", "email"],
//            viewController: self
//        ) { result in
//            self.addLoaderView()
//             self.loginManagerDidComplete(result)
//        }
        
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["public_profile", "email"], from: self) { (result, error) in
          if let error = error {
            print("Failed to login: \(error.localizedDescription)")
            return
          }
           print(result?.token)
           self.getFBUserData()
        }
    }
    
    
//    func loginManagerDidComplete(_ result: LoginResult) {
//
//        switch result {
//        case .cancelled:
//            self.showAlertWithSingleButton(title: commonAlertTitle, message: "User cancelled login.", okButtonText: okText, completion: nil)
//        case .failed(let error):
//
//            self.showAlertWithSingleButton(title: commonAlertTitle, message: "Login failed with error \(error)", okButtonText: okText, completion: nil)
//
//        case .success( _, _, let token):
//            print(token.userID)
//            self.getFBUserData()
//        }
//    }
    
    func getFBUserData(){
        GraphRequest(graphPath: "me?fields", parameters: ["fields": "id, name , first_name, last_name, email, picture"]).start(completionHandler: { (connection, result, error) -> Void in
            if (error == nil){
                let fbDetails = result as! NSDictionary
                self.fbdataDict = fbDetails as! [String : Any]
                print("fbdataDict==>\(self.fbdataDict)")
                print("first_name==>\(self.fbdataDict["first_name"] as! String)")
                
                if let imageURL = ((self.fbdataDict["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String {
                    print(imageURL)
                    let url = URL(string: imageURL)
                    let data = NSData(contentsOf: url!)
                    let image = UIImage(data: data! as Data)
//                    self.profileImageView.image = image
                    self.userSelectedImage = image
                }
                
                self.removeLoaderView()
                let registerObject = UserRegister()
                registerObject.userFirstName = (self.fbdataDict["first_name"] as! String)
                registerObject.userLastName = (self.fbdataDict["last_name"] as! String)
                registerObject.userEmail = (self.fbdataDict["email"] as! String)
                registerObject.userpassword = "Admin@123"
                registerObject.userPhone = ""
                registerObject.userFCMToken = UserDefaults.standard.string(forKey: PreferencesKeys.userToken)!
                registerObject.social_type = "1"
                registerObject.fb_token = (self.fbdataDict["id"] as! String)
                registerObject.google_token = ""
                self.registerViewModel.sendRegisterCredentialsToAPIService(user : registerObject)
            }
            else{
                print(error?.localizedDescription ?? "Not found")
            }
        })
    }
    
    func ForgotPasswordAction(){
        self.popup = ForgotPassword(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height))
        self.view.addSubview(self.popup!)
        self.popup.btnCalcel.addTarget(self, action: #selector(btnCalcelTapped), for: UIControl.Event.touchUpInside)
        self.popup.btnForgotPassword.addTarget(self, action: #selector(btnSubmitTapped), for: UIControl.Event.touchUpInside)
    }
    
    @objc func btnCalcelTapped(){
        self.popup.removeFromSuperview()
    }
    
    @objc func btnSubmitTapped(){
        let userObject = UserModel()
        userObject.userName = popup.txtEmail.text
        viewModel.sendForgotCredentialsToAPIService(user: userObject)
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
                    
                    if self?.viewModel.userDetails.userCardList != nil && (self?.viewModel.userDetails.userCardList?.count)! > 0 {
                       
//                       // UserDefaults.standard.set(self?.viewModel.userDetails.userCardList, forKey: "CardDetails")
//                        do{
//                            let encodedData = try NSKeyedArchiver.archivedData(withRootObject: (self?.viewModel.userDetails.userCardList)!, requiringSecureCoding: false)
//                            let userDefaults = UserDefaults.standard
//                            userDefaults.set(encodedData, forKey: "CardDetails")
//
//                        }catch{
//
//                        }
                    }
                    
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.openHomeViewController()
                    
                } else {
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message: (self?.viewModel.userDetails.message)!, okButtonText: okText, completion: nil)
                }
            }
        }
        
        viewModel.refreshForgotpasswordViewClosure = {[weak self]() in
            DispatchQueue.main.async {
                
                if  (self?.viewModel.userDetails.status) == 200 {
                    self!.userDetails = (self?.viewModel.userDetails)!
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message: (self?.viewModel.userDetails.message)!, okButtonText: okText, completion: nil)
                    self?.popup.removeFromSuperview()
                } else{
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message: (self?.viewModel.userDetails.message)!, okButtonText: okText, completion: nil)
                }
            }
        }
    }
    
    func initializeRegisterViewModel() {
        
        registerViewModel.showAlertClosure = {[weak self]() in
            DispatchQueue.main.async {
                if let message = self?.registerViewModel.alertMessage {
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message: message, okButtonText: okText, completion: nil)
                }
            }
        }
        
        registerViewModel.updateLoadingStatus = {[weak self]() in
            DispatchQueue.main.async {
                
                let isLoading = self?.registerViewModel.isLoading ?? false
                if isLoading {
                    self?.addLoaderView()
                } else {
                    self?.removeLoaderView()
                }
            }
        }
        
        registerViewModel.refreshViewClosure = {[weak self]() in
            DispatchQueue.main.async {
                
                if  (self?.registerViewModel.userDetails.status) == 200 {
                    self!.userDetails = (self?.registerViewModel.userDetails)!
                    
                    AppPreferenceService.setInteger(IS_LOGGED_IN, key: PreferencesKeys.loggedInStatus)
                    AppPreferenceService.setString(String((self?.registerViewModel.userDetails.id!)!), key: PreferencesKeys.userID)
                    AppPreferenceService.setString(String((self?.registerViewModel.userDetails.email!)!), key: PreferencesKeys.userName)
                    AppPreferenceService.setString(String((self?.registerViewModel.userDetails.authorizationToke!)!), key: PreferencesKeys.userToken)
                    AppPreferenceService.setString(String((self?.registerViewModel.userDetails.userFirstName!)!), key: PreferencesKeys.userFirstName)
                    AppPreferenceService.setString(String((self?.registerViewModel.userDetails.userLastName!)!), key: PreferencesKeys.userLastName)
                    if self?.registerViewModel.userDetails.image != nil {
                        AppPreferenceService.setString(String((self?.registerViewModel.userDetails.image!)!), key: PreferencesKeys.userImage)
                    }
                    
                    
                    let obj = UserProfile()
                    obj.userFirstName = self?.registerViewModel.userDetails.userFirstName
                    obj.userLastName = self?.registerViewModel.userDetails.userLastName
                    obj.userEmail = self?.registerViewModel.userDetails.email
                    obj.is_changed = 0
                    obj.phone = ""
                    if let img = self!.userSelectedImage {
                        let data = img.jpegData(compressionQuality: 0)
                        
                        self!.requestWith(endUrl: "", imageData: data, parameters: obj.toJSON())
                    }else{
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.openHomeViewController()
                    }
                    
                }else{
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message: (self?.viewModel.userDetails.isSuccess)!, okButtonText: okText, completion: nil)
                }
            }
        }
    }
    
    func passwordEyeAction(){
        if userObject.isPasswordOpen == false {
            userObject.isPasswordOpen = true
        }else{
            userObject.isPasswordOpen = false
        }
        loginTableView.reloadData()
    }
}

extension LoginVC : UITableViewDelegate, UITableViewDataSource, LoginDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    //"leftmenu-icon-messages.png"
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let Cell = tableView.dequeueReusableCell(withIdentifier: "LoginHeaderCell") as! LoginHeaderCell
            Cell.btnDelegate = self
            return Cell
        case 1:
            let Cell = tableView.dequeueReusableCell(withIdentifier: "LoginEmailPasswordCell") as! LoginEmailPasswordCell
            Cell.txtFieldEmail.tag = 0
            Cell.txtFieldPassword.tag = 1
            Cell.txtFieldEmail.delegate = self
            Cell.txtFieldPassword.delegate = self
            Cell.initializeCellObject(cellDic : userObject)
            Cell.btnDelegate = self
            return Cell
        default:
            return UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "Cell")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 212
        case 1:
            return 300
        default:
            return 0
        }
    }
}

extension LoginVC: UITextFieldDelegate {
    
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
        case 0:
            userObject.userName = updateText as String
        case 1:
            userObject.userPassword = updateText as String
        default:
            break
        }
        return true
    }
}

extension LoginVC : GIDSignInDelegate
{
    private func signInWillDispatch(signIn: GIDSignIn!, error: NSError!) {
        //UIActivityIndicatorView.stopAnimating()
    }
    
    // Present a view that prompts the user to sign in with Google
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!,
              dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            print("Error\(error.localizedDescription)")
        } else {
            let userId = user.userID
            let idToken = user.authentication.idToken
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
        }
    }
}

extension LoginVC {
    func requestWith(endUrl: String, imageData: Data?, parameters: [String : Any], onCompletion: ((Any?) -> Void)? = nil, onError: ((Error?) -> Void)? = nil){
        let url = "http://phoenixerrands.com/public/api/editprofile"
        let headers = ["Content-type": "multipart/form-data", "Accept": "application/json", "Authorization" : "Bearer " + UserDefaults.standard.string(forKey: PreferencesKeys.userToken)!]
        self.addLoaderView()
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            if let data = imageData{
                multipartFormData.append(data, withName: "image", fileName: "12345" , mimeType: "")
            }
        }, usingThreshold: UInt64.init(), to: url, method: .post, headers: headers) { (result) in
            switch result{
                
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (Progress) in
                    print("Upload Progress: \(Progress.fractionCompleted * 100)")
                })
                upload.responseJSON { response in
                    upload.responseJSON { response in
                        self.removeLoaderView()
                        guard let result = response.result.value else { return }
                        print("\(result)")
                        let resultDic = result as! Dictionary<String,Any>
                        let status = resultDic["status"] as! Int
                        if status == 200 {
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            appDelegate.openHomeViewController()
                        }else{
                            self.showAlertWithSingleButton(title: commonAlertTitle, message: "", okButtonText: okText, completion: nil)
                        }
                    }
                    if let err = response.error{
                        onError?(err)
                        return
                    }
                    onCompletion?(nil)
                }
            case .failure(let error):
                self.removeLoaderView()
                print("Error in upload: \(error.localizedDescription)")
                onError?(error)
            }
        }
    }
}
extension UserDefaults {

   func save<T:Encodable>(customObject object: T, inKey key: String) {
       let encoder = JSONEncoder()
       if let encoded = try? encoder.encode(object) {
           self.set(encoded, forKey: key)
       }
   }

   func retrieve<T:Decodable>(object type:T.Type, fromKey key: String) -> T? {
       if let data = self.data(forKey: key) {
           let decoder = JSONDecoder()
           if let object = try? decoder.decode(type, from: data) {
               return object
           }else {
               print("Couldnt decode object")
               return nil
           }
       }else {
           print("Couldnt find key")
           return nil
       }
   }

}
