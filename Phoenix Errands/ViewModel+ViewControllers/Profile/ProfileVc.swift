//
//  ProfileVc.swift
//  Phoenix Errands
//
//  Created by Raghav Beriwala on 09/08/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import UIKit
import Localize_Swift
import SDWebImage

class ProfileVc: BaseViewController {
    @IBOutlet weak var lblProfileName: UILabel!
    @IBOutlet weak var imgthumb: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblNew: UILabel!
    @IBOutlet weak var lblAddMyService: UILabel!
    lazy var viewModel: ProfileVM = {
        return ProfileVM()
    }()
    
    var profileDetails = ProfileModel()
    var profileDetailsList : ProfileDetails?
    var profileActivity : ProfileActivity?
    var myStatistics : MyStatistics?
    var lblName = NSArray()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "ProfileCell", bundle: Bundle.main), forCellReuseIdentifier: "ProfileCell")
        imgthumb.layer.cornerRadius = imgthumb.frame.size.width/2
        imgthumb.clipsToBounds = true
        imgthumb.layer.borderColor = UIColor(red:17/255, green:136/255, blue:255/255, alpha: 1).cgColor
        imgthumb.layer.borderWidth = 1
        headerSetup()
        
        if Localize.currentLanguage() == "en" {
            self.lblName = ["IBAN","Setting","My Contact","My Address","My Order"]
        }else{
            self.lblName = ["IBAN","Réglage","Mon contact","Mon adresse","Ma commande"]
        }
        initializeViewModel()
        getProfileDetailsview()
        setText()
        
        if UserDefaults.standard.string(forKey: PreferencesKeys.userFirstName) != nil {
            self.lblProfileName.text = UserDefaults.standard.string(forKey: PreferencesKeys.userFirstName)! + " " + UserDefaults.standard.string(forKey: PreferencesKeys.userLastName)!
        }
    }
    
    @IBAction func btnAddServices(_ sender: Any){
        let vc = UIStoryboard.init(name: "Profile", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddServiceVC") as? AddServiceVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func headerSetup(){
        if #available(iOS 13.0, *) {
            let statusBar = UIView(frame: UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
             statusBar.backgroundColor = UIColor.clear
             UIApplication.shared.keyWindow?.addSubview(statusBar)
        } else {
             UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
        }
        
        headerView.lblHeaderTitle.text = "My profile".localized();
        headerView.imgProfileIcon.isHidden = false
        headerView.menuButtonOutlet.isHidden = true
        headerView.imgViewMenu.isHidden = true
        headerView.menuButtonOutlet.tag = 1
        headerView.imgViewMenu.image = UIImage(named:"whiteback")
        headerView.notificationValueView.isHidden = true
        headerView.imgProfileIcon.isHidden = true
        headerView.imgProfileIcon.image  = UIImage(named: "EditIcon")
        self.tabBarView.menuProfileImg.image = UIImage(named:"ProfilSelected")
        self.tabBarView.imgArray = ["NewHome","ServiceNewDark","ActivityNewDark","ApplyNewDark","ProfilSelected"]
        self.tabBarView.tabCollection.reloadData()
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
                
                if (self?.viewModel.profileDetails.status) == 200 {
                    self!.profileDetails = (self?.viewModel.profileDetails)!
                    self!.profileDetailsList = (self?.viewModel.profileDetails.ProfileDetails)!
//                    self!.profileActivity = (self?.viewModel.profileDetails.ProfileActivity)!
//                    self!.myStatistics = (self?.viewModel.profileDetails.MyStatistics)!
                }else{
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message: (self?.viewModel.profileDetails.message)!, okButtonText: okText, completion: nil)
                }
            }
        }
    }
    
    @objc func setText() {
        self.tabBarView.lblHome.textColor = UIColor.lightGray
        self.tabBarView.lblMe.textColor = UIColor.black
        self.tabBarView.lblApply.textColor = UIColor.lightGray
        self.tabBarView.lblActivity.textColor = UIColor.lightGray
        self.tabBarView.lblContacts.textColor = UIColor.lightGray
        self.tabBarView.lblMe.font = UIFont.boldSystemFont(ofSize: 14.0)
        //self.tabBarView.menuProfileImg.image = UIImage(named:"DarkProfile")
        lblNew.text = "New".localized();
        lblAddMyService.text = "My Bids".localized();
        headerView.lblHeaderTitle.text = "My profile".localized();
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name( LCLLanguageChangeNotification), object: nil)
        
        if UserDefaults.standard.string(forKey: PreferencesKeys.userImage) != nil {
            let urlMain = APIConstants.baseImageURL + UserDefaults.standard.string(forKey: PreferencesKeys.userImage)!
            self.imgthumb.sd_setImage(with: URL(string: urlMain))
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func btnProfiledetailsTapped(_ sender: Any){
        let vc = UIStoryboard.init(name: "Profile", bundle: Bundle.main).instantiateViewController(withIdentifier: "ProfileDetailsVC") as? ProfileDetailsVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}

extension ProfileVc : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lblName.count
    }
    
    //"leftmenu-icon-messages.png"
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let Cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell") as! ProfileCell
        Cell.lblName.text = (lblName[indexPath.row] as! String)
        return Cell
    }
    
    func tableView( _ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        print("You selected cell #\(indexPath.row)!")
        switch indexPath.row {
//        case 0:
//            let vc = UIStoryboard.init(name: "Profile", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddPaymentVC") as? AddPaymentVC
//            self.navigationController?.pushViewController(vc!, animated: true)
        case 0:
            let vc = UIStoryboard.init(name: "Profile", bundle: Bundle.main).instantiateViewController(withIdentifier: "WereGoingVC") as? WereGoingVC
            self.navigationController?.pushViewController(vc!, animated: true)
        case 1:
            let vc = UIStoryboard.init(name: "Profile", bundle: Bundle.main).instantiateViewController(withIdentifier: "SettingsVC") as? SettingsVC
            self.navigationController?.pushViewController(vc!, animated: true)
        case 2:
            let vc = UIStoryboard.init(name: "Contacts", bundle: Bundle.main).instantiateViewController(withIdentifier: "ContactsVC") as? ContactsVC
            self.navigationController?.pushViewController(vc!, animated: false)
        case 3:
            let vc = UIStoryboard.init(name: "Profile", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddressListVC") as? AddressListVC
            self.navigationController?.pushViewController(vc!, animated: true)
        case 4:
            let vc = UIStoryboard.init(name: "Activity", bundle: Bundle.main).instantiateViewController(withIdentifier: "MyORderVC") as? MyORderVC
            vc!.tagID = 1
            self.navigationController?.pushViewController(vc!, animated: true)
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
}
