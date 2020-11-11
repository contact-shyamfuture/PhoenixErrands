//
//  DashboardVC.swift
//  Phoenix Errands
//
//  Created by Shyam Future Tech on 07/08/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import UIKit
import Localize_Swift
import CoreLocation

class DashboardVC: BaseViewController {

    @IBOutlet weak var lblTry: UILabel!
    @IBOutlet weak var lblTrasnport: UITextField!
    @IBOutlet weak var serviceCategoryCollection: UICollectionView!
    
    lazy var viewModel: CategoryVM = {
        return CategoryVM()
    }()
    var categoryListDetails = CategoryModel()
    var categoryArray : [CategoryList]?
    var categoryID : Int?
    var categoryName : String?
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            let statusBar = UIView(frame: UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
             statusBar.backgroundColor = UIColor.clear
             UIApplication.shared.keyWindow?.addSubview(statusBar)
        }else{
             UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
        }
        headerView.lblHeaderTitle.text = "Choose Your Service".localized();
        headerView.imgProfileIcon.isHidden = false
        headerView.menuButtonOutlet.isHidden = false
        headerView.imgViewMenu.isHidden = true
        headerView.menuButtonOutlet.tag = 101
        headerView.btnNotrificationIconOutlet.tag = 1
        if Localize.currentLanguage() == "en" {
            let img = UIImage(named: "engFlag")
            headerView.menuButtonOutlet.setImage(img, for: .normal)
            self.lblTry.text = "Try"
        }else{
            let img = UIImage(named: "ChangeLanguage")
            headerView.menuButtonOutlet.setImage(img, for: .normal)
            self.lblTry.text = "Essayer"
        }
        //headerView.imgViewMenu.image = UIImage(named:"ChangeLanguage")
        self.serviceCategoryCollection.delegate = self
        self.serviceCategoryCollection.dataSource = self
    }
    
    var i = 0
    @objc func update(){
        if(i==categoryArray?.count){
            i=0
        }
        lblTrasnport.text = categoryArray![i].categoryName
        categoryID = categoryArray![i].id
        categoryName = categoryArray![i].categoryName
        i += 1
    }
    
    @IBAction func btnSearchTapped(_ sender: Any){
        
        if categoryID != nil {
            let vc = UIStoryboard.init(name: "Dashboard", bundle: Bundle.main).instantiateViewController(withIdentifier: "ServiceTypeListVC") as? ServiceTypeListVC
            vc!.categoryID = categoryID
            vc!.categoryName = categoryName
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
    
    @objc func setText(){
        
        print(Localize.currentLanguage())
        if Localize.currentLanguage() == "en" {
            let img = UIImage(named: "engFlag")
            self.lblTry.text = "Try"
            headerView.menuButtonOutlet.setImage(img, for: .normal)
        }else{
            self.lblTry.text = "Essayer"
            let img = UIImage(named: "ChangeLanguage")
            headerView.menuButtonOutlet.setImage(img, for: .normal)
        }
        viewModel.getCategoryDetailsToAPIService(lang : Localize.currentLanguage())
        self.tabBarView.lblHome.textColor = UIColor.black
        self.tabBarView.lblHome.font = UIFont.boldSystemFont(ofSize: 14.0)
        self.tabBarView.lblMe.textColor = UIColor.lightGray
        self.tabBarView.lblApply.textColor = UIColor.lightGray
        self.tabBarView.lblActivity.textColor = UIColor.lightGray
        self.tabBarView.lblContacts.textColor = UIColor.lightGray
       // self.tabBarView.menuHomeImg.image = UIImage(named:"HomeSelected")
        
        self.tabBarView.imgArray = ["HomeSelected","ServiceNewDark","ActivityNewDark","ApplyNewDark","ProfileNewDark"]
        self.headerView.lblHeaderTitle.text = "Choose Your Service".localized();
        self.postUpdateLanguage(language: Localize.currentLanguage())
        self.serviceCategoryCollection.reloadData()
        self.tabBarView.tabCollection.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name( LCLLanguageChangeNotification), object: nil)
        self.initializeViewModel()
         
        //self.getCategoryList()
        if Localize.currentLanguage() == "en" {
            viewModel.getCategoryDetailsToAPIService(lang : "en")
            let img = UIImage(named: "engFlag")
            headerView.menuButtonOutlet.setImage(img, for: .normal)
        }else{
            viewModel.getCategoryDetailsToAPIService(lang : "fr")
            let img = UIImage(named: "ChangeLanguage")
            headerView.menuButtonOutlet.setImage(img, for: .normal)
        }
        self.postUpdateLanguage(language: Localize.currentLanguage())
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func postUpdateLanguage(language : String){
        let param = LanguageParam()
        param.lang = language
        viewModel.postLanguageToAPIService(params : param)
    }
    
    func getCategoryList(){
        viewModel.getCategoryDetailsToAPIService(lang: "")
    }
    
    func initializeViewModel() {
        
        viewModel.showAlertClosure = {[weak self]() in
            DispatchQueue.main.async {
                if let message = self?.viewModel.alertMessage {
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message: message, okButtonText: okText, completion: {
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.openSignInViewController()
                    })
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
                
                if (self?.viewModel.categoryDetails.status) == 200 {
                    self!.categoryListDetails = (self?.viewModel.categoryDetails)!
                    self!.categoryArray = (self?.viewModel.categoryDetails.categoryArray)!
                    AppPreferenceService.setString(String((self?.viewModel.categoryDetails.notificationCount)!), key: PreferencesKeys.notificationCount)
                    self!.headerView.lblNotificationCount.text =  UserDefaults.standard.string(forKey: PreferencesKeys.notificationCount)!
                    self!.serviceCategoryCollection.reloadData()
                    Timer.scheduledTimer(timeInterval: 6.0, target: self as Any, selector: #selector(DashboardVC.update), userInfo: nil, repeats: true)
                }else{
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message: (self?.viewModel.categoryDetails.message)!, okButtonText: okText, completion: {
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.openSignInViewController()
                    })
                }
            }
        }
        
        viewModel.refreshLanguageViewClosure = {[weak self]() in
        DispatchQueue.main.async {
                if (self?.viewModel.language.status) == 200 {
                    
                }
            }
        }
    }
}

extension DashboardVC : UICollectionViewDelegate , UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int)-> Int {
  
        if categoryArray != nil && (self.categoryArray?.count)! > 0{
            return (self.categoryArray?.count)!
        }else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ServiceCollectionCell", for: indexPath as IndexPath) as! ServiceCollectionCell
//        cell.lblServiceCategoryName.text = "House".localized();
        cell.intializeCellDetails(cellDic: self.categoryArray![indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width : CGFloat = (collectionView.frame.width - (20 + 20))/2 //150
        let height: CGFloat = 190
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
        return UIEdgeInsets(top: 5, left: 10, bottom: 0, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: "Dashboard", bundle: Bundle.main).instantiateViewController(withIdentifier: "ServiceTypeListVC") as? ServiceTypeListVC
        vc!.categoryID = self.categoryArray![indexPath.row].id
        vc!.categoryName = self.categoryArray![indexPath.row].categoryName
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}
