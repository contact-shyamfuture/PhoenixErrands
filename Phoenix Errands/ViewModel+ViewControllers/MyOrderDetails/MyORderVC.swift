//
//  MyORderVC.swift
//  Phoenix Errands
//
//  Created by Shyam Future Tech on 30/09/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import UIKit
import Localize_Swift

class MyORderVC: BaseViewController {

    @IBOutlet weak var myOrderTable: UITableView!
    @IBOutlet weak var lblServiceName: UILabel!
    var tagID : Int?
    
    lazy var viewModel: MyOrderVM = {
        return MyOrderVM()
    }()
    var myOrderDetails = MyOrderModel()
    var myOrderArray : [MyOrderList]?
    var order_Id : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if Localize.currentLanguage() == "en" {
            self.headerView.lblHeaderTitle.text = "My Orders"
        }else{
            self.headerView.lblHeaderTitle.text = "Mes commandes"
        }
        self.headerView.imgProfileIcon.isHidden = false
        self.headerView.menuButtonOutlet.isHidden = false
        self.headerView.imgViewMenu.isHidden = false
        self.headerView.menuButtonOutlet.tag = tagID!
        self.headerView.imgViewMenu.image = UIImage(named:"whiteback")
        self.headerView.notificationValueView.isHidden = true
        self.headerView.imgProfileIcon.isHidden = true
        self.tabBarView.isHidden = true
        self.myOrderTable.dataSource = self
        self.myOrderTable.delegate = self
        self.tabBarView.imgArray = ["NewHome","ServiceNewDark","ActivityNewDark","ApplyNewDark","ProfilSelected"]
        self.tabBarView.tabCollection.reloadData()
        
        self.initializeViewModel()
        self.getMyOrderDetails()
    }
    
    func getMyOrderDetails(){
        viewModel.getMyOrderListToAPIService()
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
                
                if (self?.viewModel.myOrderDetails.status) == 201 {
                    self!.myOrderDetails = (self?.viewModel.myOrderDetails)!
                    self!.myOrderArray = (self?.viewModel.myOrderDetails.myOrderArray)!
                    self!.myOrderTable.reloadData()
                }else{
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message:"", okButtonText: okText, completion: nil)
                }
            }
        }
    }
    
    func acceptProposal(indexPath : Int)
    {
        if myOrderArray![indexPath].status == 1
        {
            
        }
        else{
            let vc = UIStoryboard.init(name: "Profile", bundle: Bundle.main).instantiateViewController(withIdentifier: "ReviewVC") as? ReviewVC
            vc?.orderId = myOrderArray![indexPath].id
            vc?.providerId = myOrderArray![indexPath].provider_id
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
    
    func goToContactDetails(indexPath : Int){
        let vc = UIStoryboard.init(name: "Contacts", bundle: Bundle.main).instantiateViewController(withIdentifier: "ContactPersonProfileVC") as? ContactPersonProfileVC
        vc!.contactID = myOrderArray![indexPath].provider_id
        vc!.serviceID = myOrderArray![indexPath].serviceID
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}

extension MyORderVC : UITableViewDelegate, UITableViewDataSource,MyOrderMarkasCompleteProtocol {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if myOrderArray != nil && (self.myOrderArray?.count)! > 0 {
            return (myOrderArray?.count)!
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let Cell = tableView.dequeueReusableCell(withIdentifier: "MyOrderCell") as! MyOrderCell
        Cell.initializeCellDetails(cellDic: myOrderArray![indexPath.row])
        Cell.btnMaskasComplete.tag = indexPath.row
        Cell.contactBtnOutlet.tag = indexPath.row
        Cell.myOrderMarkasCompleteDelegate = self
        return Cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 280
    }
}
