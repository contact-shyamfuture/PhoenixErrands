//
//  ServiceTypeListVC.swift
//  Phoenix Errands
//
//  Created by Shyam Future Tech on 09/08/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import UIKit
import Localize_Swift
class ServiceTypeListVC: BaseViewController {

    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var tableServiceTypeList: UITableView!
    var categoryID : Int?
    var categoryName : String?
    lazy var viewModel: SubCategoryVM = {
        return SubCategoryVM()
    }()
    var subCategoryListDetails = SubCategoryModel()
    var subCategoryArray : [SubCategoryList]?
    
    @IBOutlet weak var suCategoryNotFZoundView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableServiceTypeList.delegate = self
        self.tableServiceTypeList.dataSource = self
        if categoryName != nil {
            self.headerView.lblHeaderTitle.text = categoryName
        }
        self.headerView.imgProfileIcon.isHidden = false
        self.headerView.menuButtonOutlet.isHidden = false
        self.headerView.imgViewMenu.isHidden = false
        self.headerView.menuButtonOutlet.tag = 1
        self.headerView.imgViewMenu.image = UIImage(named:"whiteback")
        headerView.lblNotificationCount.text =  UserDefaults.standard.string(forKey: PreferencesKeys.notificationCount)!
        self.initializeViewModel()
        self.getSubCetgoryList(lang: Localize.currentLanguage())
        self.txtSearch.delegate = self
        //self.txtSearch.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(searchDoneAction(_ :)))
        self.suCategoryNotFZoundView.isHidden = true
    }
    
    @objc func searchDoneAction(_ sender: UITextField){
        print("searchDoneAction")
        let subCatagorySearchParams = SubCatagorySearchParams()
        if txtSearch.text != nil{
            subCatagorySearchParams.searchText = txtSearch.text
            viewModel.getSubCategorySearchDetailsToAPIService(user: subCatagorySearchParams)
        }
    }
    
    func searchDoneButtonAction(){
        let subCatagorySearchParams = SubCatagorySearchParams()
        if txtSearch.text != nil{
            subCatagorySearchParams.searchText = txtSearch.text
            viewModel.getSubCategorySearchDetailsToAPIService(user: subCatagorySearchParams)
        }
    }
    
    func getSubCetgoryList(lang : String){
        if categoryID != nil {
            viewModel.getSubCategoryDetailsToAPIService(categoryID: String(categoryID!), lang: lang)
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
                if self?.viewModel.subCategoryDetails.status != nil{
                    if (self?.viewModel.subCategoryDetails.status) == 200 {
                        self!.subCategoryListDetails = (self?.viewModel.subCategoryDetails)!
                        self!.subCategoryArray = (self?.viewModel.subCategoryDetails.subCategoryArray)!
                        self!.tableServiceTypeList.reloadData()
                    }else{
                        self?.showAlertWithSingleButton(title: commonAlertTitle, message: (self?.viewModel.subCategoryDetails.message)!, okButtonText: okText, completion: nil)
                    }
                }else{
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message: "Server error", okButtonText: okText, completion: nil)
                }
            }
        }
        
        viewModel.refreshViewSearchClosure = {[weak self]() in
            DispatchQueue.main.async {
                if self?.viewModel.subCategoryDetails.status != nil{
                    
                    if (self?.viewModel.subCategoryDetails.status) == 200 {
                        self!.subCategoryListDetails = (self?.viewModel.subCategoryDetails)!
                        self!.subCategoryArray = (self?.viewModel.subCategoryDetails.subCategoryArray)!
                        self!.tableServiceTypeList.isHidden = false
                        self!.suCategoryNotFZoundView.isHidden = true
                        self!.tableServiceTypeList.reloadData()
                    }else{
                        self!.tableServiceTypeList.isHidden = true
                        self?.showAlertWithSingleButton(title: commonAlertTitle, message: (self?.viewModel.subCategoryDetails.message)!, okButtonText: okText, completion: {
                            self!.suCategoryNotFZoundView.isHidden = false
                        })
                    }
                    
                }else{
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message: "Server error", okButtonText: okText, completion: nil)
                }
                
            }
        }
        
        viewModel.refreshViewSearchNotFoundClosure = {[weak self]() in
            DispatchQueue.main.async {
                if self?.viewModel.createOwnDetails.status != nil{
                    
                    if (self?.viewModel.createOwnDetails.status) == 200 {
                        self?.showAlertWithSingleButton(title: commonAlertTitle, message: (self?.viewModel.createOwnDetails.message)!, okButtonText: okText, completion: {
                        self?.navigationController?.popViewController(animated: true)
                        })
                        self!.txtSearch.text = ""
                        self!.suCategoryNotFZoundView.isHidden = true
                    }else{
                        self?.showAlertWithSingleButton(title: commonAlertTitle, message: (self?.viewModel.createOwnDetails.message)!, okButtonText: okText, completion: nil)
                    }
                    
                }else{
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message: "Server error", okButtonText: okText, completion: nil)
                }
            }
        }
    }
    
    @IBAction func buttonCreateOwnRequestAction(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Dashboard", bundle: Bundle.main).instantiateViewController(withIdentifier: "AskForServiceOrProvder") as? AskForServiceOrProvder
        vc!.isNonFoundService = false
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}

extension ServiceTypeListVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if subCategoryArray != nil && (self.subCategoryArray?.count)! > 0 {
            return (self.subCategoryArray?.count)!
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let Cell = tableView.dequeueReusableCell(withIdentifier: "ServiceTypeListCell") as! ServiceTypeListCell
        Cell.initializeCellDetails(cellDic : self.subCategoryArray![indexPath.row])
        return Cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: "Dashboard", bundle: Bundle.main).instantiateViewController(withIdentifier: "ServiceNameVC") as? ServiceNameVC
        vc!.subCategoryName = self.subCategoryArray![indexPath.row].subcategoryName
        vc!.subCategoryID = self.subCategoryArray![indexPath.row].id
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}

extension ServiceTypeListVC : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.searchDoneButtonAction()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        self.searchDoneButtonAction()
    }
}
