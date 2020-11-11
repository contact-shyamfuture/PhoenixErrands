//
//  ProposalListVC.swift
//  Phoenix Errands
//
//  Created by Shyam Future Tech on 10/09/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import UIKit
import Localize_Swift

class ProposalListVC: BaseViewController {

    var serviceRequestID : String?
    @IBOutlet weak var lblServiceName: UILabel!
    @IBOutlet weak var prpposalListTableView: UITableView!
    lazy var viewModel: ActivityVM = {
        return ActivityVM()
    }()
    var proposalDetails = ProposalListModel()
    var proposalListArr : [ProposalList]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(serviceRequestID as Any)
        self.prpposalListTableView.delegate = self
        self.prpposalListTableView.dataSource = self
        self.setText()
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name( LCLLanguageChangeNotification), object: nil)
        self.initializeViewModel()
        self.getproposalList()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func setText(){
        
//        UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
        
        if #available(iOS 13.0, *) {
            let statusBar = UIView(frame: UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
             statusBar.backgroundColor = UIColor.clear
             UIApplication.shared.keyWindow?.addSubview(statusBar)
        } else {
             UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
        }
        
        if Localize.currentLanguage() == "en" {
            headerView.lblHeaderTitle.text = "Proposal List"
        }else{
            headerView.lblHeaderTitle.text = "Liste des propositions"
        }
        headerView.imgProfileIcon.isHidden = false
        headerView.menuButtonOutlet.isHidden = false
        headerView.imgViewMenu.isHidden = false
        headerView.menuButtonOutlet.tag = 1
        headerView.imgViewMenu.image = UIImage(named:"whiteback")
        headerView.notificationValueView.isHidden = true
        headerView.imgProfileIcon.isHidden = true
    }
    
    func getproposalList(){
        viewModel.getProposalDetailsToAPIService(servicerequestID: serviceRequestID!)
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
                
                if (self?.viewModel.prposalDetails.status) == 200 {
                    self!.proposalDetails = (self?.viewModel.prposalDetails)!
                    self!.proposalListArr = (self?.viewModel.prposalDetails.proposalListArr)!
                    if Localize.currentLanguage() == "en" {
                        self!.lblServiceName.text = "Service Name : " + (self?.viewModel.prposalDetails.serviceName)!
                    }else{
                        self!.lblServiceName.text = "Nom du service : " + (self?.viewModel.prposalDetails.serviceName)!
                    }
                    if (self!.proposalListArr?.count)! > 0 {
                        self?.prpposalListTableView.reloadData()
                    }else{
                        self?.showAlertWithSingleButton(title: commonAlertTitle, message: proposalISMessage, okButtonText: okText, completion: {
                        self?.navigationController?.popViewController(animated: true)
                        })
                    }
                }else{
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message: (self?.viewModel.prposalDetails.message)!, okButtonText: okText, completion: nil)
                }
            }
        }
    }
    
    func acceptProposal(indexPath : Int){
        
        let vc = UIStoryboard.init(name: "Activity", bundle: Bundle.main).instantiateViewController(withIdentifier: "CheckOutVC") as? CheckOutVC
        vc!.proposalID = proposalListArr![indexPath].id!
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func detailsProposal(indexPath : Int){
        
        let vc = UIStoryboard.init(name: "Request", bundle: Bundle.main).instantiateViewController(withIdentifier: "NewRequestDetailsVC") as? NewRequestDetailsVC
        vc!.serviceID = String(proposalDetails.id!)
        vc!.providerID = String(proposalListArr![indexPath].providerId!)
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}

extension ProposalListVC : UITableViewDelegate, UITableViewDataSource,ProposalDetailsProtocol{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if proposalListArr != nil  && (self.proposalListArr?.count)! > 0 {
            return (self.proposalListArr?.count)!
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Cell = tableView.dequeueReusableCell(withIdentifier: "ProposalListCell") as! ProposalListCell
        Cell.initializeCellDetails(cellDic : proposalListArr![indexPath.row])
        Cell.btnAcceptOutlet.tag = indexPath.row
        Cell.btnDetailsOutlet.tag = indexPath.row
        Cell.proposalDelegate = self
        return Cell
    }
    
    func tableView( _ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 185
    }
}
