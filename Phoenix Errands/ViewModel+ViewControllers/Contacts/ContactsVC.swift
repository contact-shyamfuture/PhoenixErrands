//
//  ContactsVC.swift
//  Phoenix Errands
//
//  Created by Raghav Beriwala on 13/08/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import UIKit
import Localize_Swift
import Localize_Swift
class ContactsVC: BaseViewController
{
    @IBOutlet weak var contactCollectionView: UICollectionView!
    @IBOutlet weak var lblDontHaveContact: UILabel!
    @IBOutlet weak var btnDiscover: UIButton!
    @IBOutlet weak var lblPhoenicOfMoment: UILabel!
    
    lazy var viewModel: ContactVM = {
        return ContactVM()
    }()
    
    var contactDetails = ContactModel()
    var contactArr : [ContactList]?
    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.contactCollectionView.delegate = self
        self.contactCollectionView.dataSource = self
        self.headerSetup()
        self.setText()
        self.initializeViewModel()
        self.getContactList()
        btnDiscover.isHidden = true
        
        self.tabBarView.imgArray = ["NewHome","ServiceNewDark","ActivityNewDark","ApplyNewDark","ProfilSelected"]
        self.tabBarView.tabCollection.reloadData()
    }
    
    @IBAction func btnDiscoverTapped(_ sender: Any){
        let vc = UIStoryboard.init(name: "Contacts", bundle: Bundle.main).instantiateViewController(withIdentifier: "DiscoverVC") as? DiscoverVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func headerSetup(){
       // UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear//Constants.App.statusBarColor
        
        if #available(iOS 13.0, *) {
            let statusBar = UIView(frame: UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
             statusBar.backgroundColor = UIColor.clear
             UIApplication.shared.keyWindow?.addSubview(statusBar)
        } else {
             UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
        }
        
        if Localize.currentLanguage() == "en" {
            headerView.lblHeaderTitle.text = "Contacts"
            lblPhoenicOfMoment.text = "Phoenix of the moment"
            lblDontHaveContact.text = "You do not have any contacts yet. In the meantime, find out the current Phoenix Errands."
        }else{
            headerView.lblHeaderTitle.text = "Contacts"
            lblPhoenicOfMoment.text = "Phoenix du moment"
            lblDontHaveContact.text = "Vous n'avez pas encore de contacts. En attendant, découvrez les courses de Phoenix actuelles."
        }
        
        headerView.imgProfileIcon.isHidden = false
        headerView.menuButtonOutlet.isHidden = false
        headerView.imgViewMenu.isHidden = false
        headerView.menuButtonOutlet.tag = 11
        headerView.imgViewMenu.image = UIImage(named:"whiteback")
        headerView.notificationValueView.isHidden = true
        headerView.imgProfileIcon.isHidden = true
        
    }
    
    @objc func setText(){
        self.tabBarView.lblHome.textColor = UIColor.lightGray
        self.tabBarView.lblMe.textColor = UIColor.lightGray
        self.tabBarView.lblApply.textColor = UIColor.lightGray
        self.tabBarView.lblActivity.textColor = UIColor.lightGray
        self.tabBarView.lblContacts.textColor = UIColor.black
        self.tabBarView.lblContacts.font = UIFont.boldSystemFont(ofSize: 14.0)
        self.tabBarView.menuContactImg.image = UIImage(named:"DarkContact")
        //btnDiscover.setTitle("Discover".localized(), for: UIControl.State.normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name( LCLLanguageChangeNotification), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func getContactList(){
        viewModel.getContactDetailsToAPIService()
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
                
                if (self?.viewModel.contactDetails.status) == 201 {
                    self!.contactDetails = (self?.viewModel.contactDetails)!
                    self!.contactArr = (self?.viewModel.contactDetails.contactArr)!
                    if self!.contactArr != nil && self!.contactArr!.count > 0 {
                        self!.lblDontHaveContact.isHidden = true
                    }else{
                        self!.lblDontHaveContact.isHidden = false
                    }
                    self!.contactCollectionView.reloadData()
                }else{
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message: (self?.viewModel.contactDetails.message)!, okButtonText: okText, completion: nil)
                }
            }
        }
    }
}

extension ContactsVC : UICollectionViewDelegate , UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int)-> Int {
        if contactArr != nil  && (self.contactArr?.count)! > 0{
            return (self.contactArr?.count)!
        }else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContactCollectionViewCell", for: indexPath as IndexPath) as! ContactCollectionViewCell
        cell.imgContactView.layer.cornerRadius = cell.imgContactView.frame.size.width/2
        cell.imgContactView.clipsToBounds = true
        cell.imgContactView.layer.borderColor = UIColor(red:17/255, green:136/255, blue:255/255, alpha: 1).cgColor
        cell.imgContactView.layer.borderWidth = 1
        cell.initializeCellDetails(cellDic : contactArr![indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width : CGFloat = 145
        let height: CGFloat = 145
        return CGSize(width: width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if section == 0 {
            return 10
        }else{
            return 10
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if section == 0 {
            return 10
        }else{
            return 10
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        let vc = UIStoryboard.init(name: "Contacts", bundle: Bundle.main).instantiateViewController(withIdentifier: "ContactPersonProfileVC") as? ContactPersonProfileVC
        vc!.contactID = contactArr![indexPath.row].contactID
        vc!.serviceID = contactArr![indexPath.row].service_id
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}

