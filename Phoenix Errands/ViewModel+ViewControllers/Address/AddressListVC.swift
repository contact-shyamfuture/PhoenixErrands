//
//  AddressListVC.swift
//  Phoenix Errands
//
//  Created by Shyam Future Tech on 24/09/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import UIKit
import Localize_Swift
class AddressListVC: BaseViewController {

    @IBOutlet weak var addAddressbtnOutlet: UIButton!
    @IBOutlet weak var addressListTable: UITableView!
    
    lazy var viewModel: AddressVM = {
        return AddressVM()
    }()
    var addressResponse = AddressListModel()
    var AddressListArray : [AddressList]?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addressListTable.register(UINib(nibName: "AddressListCell", bundle: Bundle.main), forCellReuseIdentifier: "AddressListCell")
        self.addressListTable.dataSource = self
        self.addressListTable.delegate = self
        self.headerSetup()
        self.initializeViewModel()
        self.getAddressList()
    }
    
    func headerSetup()
    {
//        UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
        
        if #available(iOS 13.0, *) {
            let statusBar = UIView(frame: UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
             statusBar.backgroundColor = UIColor.clear
             UIApplication.shared.keyWindow?.addSubview(statusBar)
        } else {
             UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
        }
        if Localize.currentLanguage() == "en" {
            addAddressbtnOutlet.setTitle("Add Address", for: .normal)
            headerView.lblHeaderTitle.text = "My Address"
        }else{
            addAddressbtnOutlet.setTitle("Ajoutez l'adresse", for: .normal)
            headerView.lblHeaderTitle.text = "Mon adresse"
        }
        
        headerView.imgProfileIcon.isHidden = false
        headerView.menuButtonOutlet.isHidden = false
        headerView.imgViewMenu.isHidden = false
        headerView.menuButtonOutlet.tag = 1
        headerView.imgViewMenu.image = UIImage(named:"whiteback")
        headerView.notificationValueView.isHidden = true
        headerView.imgProfileIcon.isHidden = true
        tabBarView.isHidden = true
    }
    
    func getAddressList(){
        viewModel.getAddressListToAPIService()
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
                
                if (self?.viewModel.addressResponse.status) == 200 {
                    self!.addressResponse = (self?.viewModel.addressResponse)!
                    self!.AddressListArray = (self?.viewModel.addressResponse.AddressListArray)!
                    self!.addressListTable.reloadData()
                }else{
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message:"", okButtonText: okText, completion: nil)
                }
            }
        }
    }
    
    @IBAction func btnAddAddressAction(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Profile", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddressAddVC") as? AddressAddVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}

extension AddressListVC : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if AddressListArray != nil && (self.AddressListArray?.count)! > 0 {
            return (self.AddressListArray?.count)!
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let Cell = tableView.dequeueReusableCell(withIdentifier: "AddressListCell") as! AddressListCell
        Cell.cellInitializeCellDetails(cellDic: AddressListArray![indexPath.row])
        Cell.imgRadioCheck.isHidden = true
        return Cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
