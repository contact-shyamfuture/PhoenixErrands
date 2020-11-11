//
//  ApplyVC.swift
//  Phoenix Errands
//
//  Created by Raghav Beriwala on 09/08/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import UIKit
import Localize_Swift
import CoreLocation
import MapKit

class ApplyVC: BaseViewController
{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnMySkill: UIButton!
    @IBOutlet weak var txtSectionDropdown: IQDropDownTextField!
    @IBOutlet weak var lblComplete: UILabel!
    @IBOutlet weak var showImgVw : UIView!
    @IBOutlet weak var showProfileImgVw : UIImageView!
    
    var nameArr = [String]()
    var serviceArr = [String]()
    var btntextArr = [String]()
    let tapRec = UITapGestureRecognizer()
    
    lazy var viewModel: ApplyVM = {
        return ApplyVM()
    }()
    
    var providerDetails = ProviderServcieModel()
    var serviceListArr : [ProviderServcieList]?
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        showImgVw.isHidden = true
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "ApplyCell", bundle: Bundle.main), forCellReuseIdentifier: "ApplyCell")
        
        nameArr = ["Mathieu H.","Marle A.","Zachaeie D."]
        serviceArr = ["Man's hairstyle.","Household.","Zachaeie D."]
        btntextArr = ["New","Full","Rest place"]
        setDropDown()
        headerSetup()
        setText()
        self.initializeViewModel()
        self.getServiceProvider()
        if Localize.currentLanguage() == "en"{
             txtSectionDropdown.text = "Provider List"
        }else{
            txtSectionDropdown.text = "Liste des fournisseurs"
        }
        btnMySkill.setTitle("My skills".localized(), for: UIControl.State.normal)
    }
    @objc func setText() {
        self.tabBarView.lblHome.textColor = UIColor.lightGray
        self.tabBarView.lblMe.textColor = UIColor.lightGray
        self.tabBarView.lblApply.textColor = UIColor.black
        self.tabBarView.lblActivity.textColor = UIColor.lightGray
        self.tabBarView.lblContacts.textColor = UIColor.lightGray
        self.tabBarView.lblApply.font = UIFont.boldSystemFont(ofSize: 14.0)
        self.tabBarView.menuApplyImg.image = UIImage(named:"ApplySelected")
        lblComplete.text = "Complete your information to apply for mission".localized();
        btnMySkill.setTitle("My skills".localized(), for: UIControl.State.normal)
        if Localize.currentLanguage() == "en"{
             txtSectionDropdown.text = "Provider List"
             headerView.lblHeaderTitle.text = "provider details"
        }else{
            txtSectionDropdown.text = "Liste des fournisseurs"
             headerView.lblHeaderTitle.text = "fournisseuse"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name( LCLLanguageChangeNotification), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    func headerSetup()
    {
        //UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear//Constants.App.statusBarColor
        
        if #available(iOS 13.0, *) {
            let statusBar = UIView(frame: UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
             statusBar.backgroundColor = UIColor.clear
             UIApplication.shared.keyWindow?.addSubview(statusBar)
        } else {
             UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
        }
        
        if Localize.currentLanguage() == "en"{
             headerView.lblHeaderTitle.text = "provider details"
            
        }else{
             headerView.lblHeaderTitle.text = "fournisseuse"
            
        }
        
        headerView.imgProfileIcon.isHidden = false
        headerView.menuButtonOutlet.isHidden = true
        headerView.imgViewMenu.isHidden = true
        headerView.menuButtonOutlet.tag = 1
        headerView.lblNotificationCount.text =  UserDefaults.standard.string(forKey: PreferencesKeys.notificationCount)!
        headerView.imgViewMenu.image = UIImage(named:"whiteback")
        
        self.tabBarView.imgArray = ["NewHome","ServiceNewDark","ActivityNewDark","ApplySelected","ProfileNewDark"]
        self.tabBarView.tabCollection.reloadData()
        
    }
    
    func setDropDown()
    {
        var ServiceLists = [NSString]()
        ServiceLists.append("Service A")
        ServiceLists.append("Service B")
        ServiceLists.append("Service C")
    }
    
    @IBAction func btnCrossAction(_ sender : UIButton){
        showImgVw.isHidden = true
    }
    
    @IBAction func mySkillTapped(_ sender: Any)
    {
        let vc = UIStoryboard.init(name: "Apply", bundle: Bundle.main).instantiateViewController(withIdentifier: "MySkillVC") as? MySkillVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func getServiceProvider(){
        viewModel.getServiceProviderDetailsToAPIService()
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
                
                if (self?.viewModel.providerDetails.status) == 200 {
                    self!.providerDetails = (self?.viewModel.providerDetails)!
                    self!.serviceListArr = (self?.viewModel.providerDetails.serviceListArr)!
                    self!.tableView.reloadData()
                }else{
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message: "" , okButtonText: okText, completion: nil)
                }
            }
        }
    }
}

extension ApplyVC : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if serviceListArr != nil && serviceListArr!.count > 0 {
            return serviceListArr!.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if serviceListArr != nil && serviceListArr!.count > 0 {
            if serviceListArr![section].providerListArr != nil &&  serviceListArr![section].providerListArr!.count > 0 {
                return serviceListArr![section].providerListArr!.count
            }else{
                return 0
            }
        }else{
            return 0
        }
    }
    //"leftmenu-icon-messages.png"
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let Cell = tableView.dequeueReusableCell(withIdentifier: "ApplyCell") as! ApplyCell
        Cell.lblName.text = serviceListArr![indexPath.section].providerListArr![indexPath.row].contactName
        if serviceListArr![indexPath.section].providerListArr![indexPath.row].contactImage != nil {
            let urlMain = APIConstants.baseImageURL + serviceListArr![indexPath.section].providerListArr![indexPath.row].contactImage!
            Cell.imgProviderIcon.sd_setImage(with: URL(string: urlMain))
        }else{
            Cell.imgProviderIcon.image = UIImage(named: "Group 2257")
        }
        
        if serviceListArr![indexPath.section].providerListArr![indexPath.row].contactAddress != nil{
            let latlong = serviceListArr![indexPath.section].providerListArr![indexPath.row].contactAddress
//            Cell.cellData(latLong : latlong!)
            Cell.lblAddress.text = latlong
        }
        
        Cell.imgProviderIcon.layer.cornerRadius = Cell.imgProviderIcon.frame.size.width/2
        Cell.imgProviderIcon.clipsToBounds = true
        Cell.imgProviderIcon.layer.borderColor = UIColor(red:17/255, green:136/255, blue:255/255, alpha: 1).cgColor
        Cell.imgProviderIcon.layer.borderWidth = 1
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ApplyVC.cellTappedMethod(_:)))

        Cell.imgProviderIcon.isUserInteractionEnabled = true
        Cell.imgProviderIcon.tag = (indexPath.section*100)+indexPath.row
        Cell.imgProviderIcon.addGestureRecognizer(tapGestureRecognizer)
        return Cell
    }
    
    func tableView( _ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let vc = UIStoryboard.init(name: "Request", bundle: Bundle.main).instantiateViewController(withIdentifier: "NewRequestDetailsVC") as? NewRequestDetailsVC
        
        let providerID = serviceListArr![indexPath.section].providerListArr![indexPath.row].contactID
        vc!.serviceID = String(serviceListArr![indexPath.section].servie_id ?? 0)
        vc!.providerID = String(providerID!)
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        
        let label = UILabel()
        label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-5)
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor.black
        
        label.text = serviceListArr![section].serviceName
        headerView.addSubview(label)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 108
    }
    @objc func cellTappedMethod(_ sender:AnyObject){
       // print("you tap image number: \(sender.view.tag)")
        let section = sender.view.tag / 100
        let row = sender.view.tag % 100
       // print("Section: \(section)")
       // print("Index: \(row)")
         showImgVw.isHidden = false
        if serviceListArr![section].providerListArr![row].contactImage != nil {
            let urlMain = APIConstants.baseImageURL + serviceListArr![section].providerListArr![row].contactImage!
            showProfileImgVw.sd_setImage(with: URL(string: urlMain))
        }else{
            showProfileImgVw.image = UIImage(named: "Group 2257")
        }
         
    }
}
extension ApplyVC {
}
