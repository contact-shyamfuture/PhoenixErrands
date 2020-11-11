//
//  ProfileDetailsVC.swift
//  Phoenix Errands
//
//  Created by Raghav Beriwala on 09/08/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import UIKit
import Localize_Swift

class ProfileDetailsVC: BaseViewController
{
    @IBOutlet weak var lblProfileName: UILabel!
    @IBOutlet weak var imgThumb: UIImageView!
    
    @IBOutlet weak var lblOneHour: UILabel!
    @IBOutlet weak var lblResponseTime: UILabel!
    @IBOutlet weak var lblMyStatistics: UILabel!
    @IBOutlet weak var lblSoldItems: UILabel!
    @IBOutlet weak var lblServicessProvided: UILabel!
    @IBOutlet weak var lblMissionsCarriedout: UILabel!
    @IBOutlet weak var lblActivity: UILabel!
    @IBOutlet weak var lblParticular: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblVarification: UILabel!
    @IBOutlet weak var lblNew: UILabel!
    @IBOutlet weak var btnLanguage: UIButton!
    @IBOutlet weak var btnEditProfile: UIButton!
    
//    var actionSheet: UIAlertController!
//    let availableLanguages = Localize.availableLanguages()
    
    lazy var viewModel: ProfileVM = {
        return ProfileVM()
    }()
    var profileDetails = ProfileModel()
    var profileDetailsList : ProfileDetails?
    var profileActivity : ProfileActivity?
    var myStatistics : MyStatistics?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        imgThumb.layer.cornerRadius = imgThumb.frame.size.width/2
        imgThumb.clipsToBounds = true
        imgThumb.layer.borderColor = UIColor(red:17/255, green:136/255, blue:255/255, alpha: 1).cgColor
        imgThumb.layer.borderWidth = 1
        
        self.lblProfileName.text = UserDefaults.standard.string(forKey: PreferencesKeys.userFirstName)! + " " + UserDefaults.standard.string(forKey: PreferencesKeys.userLastName)!
        
        self.tabBarView.imgArray = ["NewHome","ServiceNewDark","ActivityNewDark","ApplyNewDark","ProfilSelected"]
        self.tabBarView.tabCollection.reloadData()
        
        setText()
        headerSetup()
        self.initializeViewModel()
        //getProfileDetailsview()
    }
    
    @objc func setText()
    {
        lblOneHour.text = "1 hour".localized();
        lblNew.text = "New".localized();
        lblVarification.text = "Verification".localized();
        lblStatus.text = "Status".localized();
        lblParticular.text = "Particular".localized();
        lblActivity.text = "My activity".localized();
        lblMissionsCarriedout.text = "Missions carried out".localized();
        lblServicessProvided.text = "Services provided".localized();
        lblSoldItems.text = "Sold items".localized();
        lblMyStatistics.text = "My statistics".localized();
        lblResponseTime.text = "Response time".localized();
        headerView.lblHeaderTitle.text = "My profile".localized();
        btnLanguage.setTitle("Language".localized(), for: UIControl.State.normal)
        let btnEditTitle = Localize.currentLanguage() == "en" ? "Edit Profile" : "Editer le profil"
        btnEditProfile.setTitle(btnEditTitle, for: UIControl.State.normal)
    }
    func getProfileDetailsview(){
        viewModel.getProfileDetailsToAPIService()
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
                
                if (self?.viewModel.profileDetails.status) == 200
                {
                    self!.profileDetails = (self?.viewModel.profileDetails)!
                    self!.profileDetailsList = (self?.viewModel.profileDetails.ProfileDetails)!
                    
                    if self!.profileDetailsList!.image != nil {
                        AppPreferenceService.setString(String((self!.profileDetailsList!.image!)), key: PreferencesKeys.userImage)
                    }
                    self!.initializeUserView()
                }
                else{
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message: (self?.viewModel.profileDetails.message)!, okButtonText: okText, completion: nil)
                }
            }
        }
    }
    
    func initializeUserView(){
        
        if UserDefaults.standard.string(forKey: PreferencesKeys.userImage) != nil {
            let urlMain = APIConstants.baseImageURL + UserDefaults.standard.string(forKey: PreferencesKeys.userImage)!
            self.imgThumb.sd_setImage(with: URL(string: urlMain))
        }
        self.lblProfileName.text  = (profileDetailsList?.userFirstName)! + " " +  (profileDetailsList?.userLastName)!
        if let boight = profileDetailsList?.bought {
            self.lblMissionsCarriedout.text = String(boight)
        }
        if let sold = profileDetailsList?.sold {
            self.lblSoldItems.text = String(sold)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name( LCLLanguageChangeNotification), object: nil)
        getProfileDetailsview()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func changeLanguageTapped(_ sender: Any)
    {
//        actionSheet = UIAlertController(title: nil, message: "Switch Language".localized(), preferredStyle: UIAlertController.Style.actionSheet)
//        for language in availableLanguages {
//            let displayName = Localize.displayNameForLanguage(language)
//            let languageAction = UIAlertAction(title: displayName, style: .default, handler: {
//                (alert: UIAlertAction!) -> Void in
//                print("language==>\(language)")
//                Localize.setCurrentLanguage(language)
//            })
//            actionSheet.addAction(languageAction)
//        }
//        let cancelAction = UIAlertAction(title: "Cancel".localized(), style: UIAlertAction.Style.cancel, handler: {
//            (alert: UIAlertAction) -> Void in
//        })
//        actionSheet.addAction(cancelAction)
//        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func headerSetup()
    {
       // UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear//Constants.App.statusBarColor
        
        if #available(iOS 13.0, *) {
            let statusBar = UIView(frame: UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
             statusBar.backgroundColor = UIColor.clear
             UIApplication.shared.keyWindow?.addSubview(statusBar)
        } else {
             UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
        }
        
        headerView.lblHeaderTitle.text = "My profile".localized()
        headerView.imgProfileIcon.isHidden = false
        headerView.menuButtonOutlet.isHidden = false
        headerView.imgViewMenu.isHidden = false
        headerView.menuButtonOutlet.tag = 1
        headerView.imgViewMenu.image = UIImage(named:"whiteback")
        headerView.notificationValueView.isHidden = true
//        headerView.imgProfileIcon.isHidden = true
        headerView.menuButtonOutlet.tag = 10
        headerView.btnNotrificationIconOutlet.isHidden = true
        headerView.imgProfileIcon.isHidden = true
        headerView.imgProfileIcon.image  = UIImage(named: "EditIcon")
        self.tabBarView.menuProfileImg.image = UIImage(named:"ProfilSelected")
    }
    
    @IBAction func btnUpdateProfile(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "EditProfileVC") as? EditProfileVC
        vc!.profileDetailsList = profileDetailsList
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}
