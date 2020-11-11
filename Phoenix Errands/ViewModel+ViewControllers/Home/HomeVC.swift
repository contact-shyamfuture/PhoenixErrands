//
//  HomeVC.swift
//  Phoenix Errands
//
//  Created by Shyam Future Tech on 07/08/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import UIKit
import Localize_Swift
import FacebookLogin
import FBSDKLoginKit
import GoogleSignIn
//EEF3F7
class HomeVC: UIViewController {

    @IBOutlet weak var btnorLogin: UILabel!
    @IBOutlet weak var btnRegistrationWithEmail: UIButton!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblCreateAnAccount: UILabel!
    
    @IBOutlet weak var formTableView: UITableView!
    var actionSheet: UIAlertController!
    let availableLanguages = Localize.availableLanguages()
    var fbdataDict = [String:Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setText()
        self.formTableView.delegate = self
        self.formTableView.dataSource = self
        GIDSignIn.sharedInstance().delegate = self
        //GIDSignIn.sharedInstance().uiDelegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name( LCLLanguageChangeNotification), object: nil)
    }
    @objc func setText(){
        lblCreateAnAccount.text = "Create an account".localized();
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func btnCloseAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }

    func registerWithEmailButtonAction(){
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "RegisterVC") as? RegisterVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func alreadyRegisterButtonAction(){
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginVC") as? LoginVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    func registerWithGmailAction()
    {
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
            else
            {
                self.getFBUserData()
            }
        }
    }
    func getFBUserData()
    {
        GraphRequest(graphPath: "me?fields", parameters: ["fields": "id, name , first_name, last_name, email"]).start(completionHandler: { (connection, result, error) -> Void in
            if (error == nil){
                let fbDetails = result as! NSDictionary
                self.fbdataDict = fbDetails as! [String : Any]
                print("fbdataDict==>\(self.fbdataDict)")
                print("first_name==>\(self.fbdataDict["first_name"] as! String)")
//                let params = UserRegistration()
//                params.FirstName = (self.fbdataDict["first_name"] as! String)
//                params.LastName = (self.fbdataDict["last_name"] as! String)
//                params.EmailID = (self.fbdataDict["email"] as! String)
//                params.SocialID = (self.fbdataDict["id"] as! String)
//                params.FcmToken = AppPreferenceService.getString(PreferencesKeys.FCMTokenDeviceID)
//                params.SocialType = "Facebook"
                //self.googleSignInViewModel.sendSocialUserSignUpCredentialsToAPIService(user: params)
            }
            else{
                print(error?.localizedDescription ?? "Not found")
            }
        })
    }
}
extension HomeVC : UITableViewDelegate, UITableViewDataSource,HomePageDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    //"leftmenu-icon-messages.png"
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let Cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell") as! HomeCell
            Cell.lblDescription.text = Localize.currentLanguage() == "en" ? "Register or log in to discover the services offered" : "Inscrivez-vous ou connectez-vous pour découvrir les services offerts"
            return Cell
        case 1:
            let Cell = tableView.dequeueReusableCell(withIdentifier: "RegisterButtonCell") as! RegisterButtonCell
            Cell.btnAlreadyregistred.setTitle("Registration with an email".localized(), for: .normal)
            Cell.lblOr.text = "Or".localized()
            Cell.alreadyBtnDelegate = self
            return Cell
        case 2:
            let Cell = tableView.dequeueReusableCell(withIdentifier: "LoginButtonCell") as! LoginButtonCell
            Cell.lblAlreadyRegister.text = Localize.currentLanguage() == "en" ? "Already registered?" : "Déjà enregistré?"
            Cell.lblLogIn.text = Localize.currentLanguage() == "en" ? "log in" : "s'identifier"
            Cell.alreadyBtnDelegate = self
            return Cell
        default:
            return UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "Cell")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 150
        case 1:
            return 150
        case 2:
            return 222
        default:
            return 0
        }
    }
}

extension HomeVC : GIDSignInDelegate
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
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            print("email==>\(email)")
            //googleSignInViewModel.sendSocialUserSignUpCredentialsToAPIService(user: registerObj)
        }
    }
}
