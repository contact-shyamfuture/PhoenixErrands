//
//  AskForServiceOrProvder.swift
//  Phoenix Errands
//
//  Created by Shyam Future Tech on 09/08/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import UIKit
import Localize_Swift
import CoreLocation

class AskForServiceOrProvder: BaseViewController {

    var optionArray : NSArray?
    var optionCheckArry  : [Bool]?
    @IBOutlet weak var tableSelectServiceOrProvide: UITableView!
    @IBOutlet weak var lblOptionName: UILabel!
    var isProvider : Bool = false
    var serviceID : String?
    var serviceName : String?
    var isNonFoundService : Bool = false
    
    lazy var viewModel: ServiceVM = {
        return ServiceVM()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerView.imgProfileIcon.isHidden = true
        headerView.menuButtonOutlet.isHidden = false
        headerView.notificationValueView.isHidden = true
        headerView.imgViewMenu.isHidden = false
        headerView.menuButtonOutlet.tag = 1
        headerView.imgViewMenu.image = UIImage(named:"whiteback")
        tabBarView.isHidden = true

        self.tableSelectServiceOrProvide.delegate = self
        self.tableSelectServiceOrProvide.dataSource = self
        
        self.optionCheckArry = [false,false]
        isProvider = false
        
        if Localize.currentLanguage() == "en" {
            self.optionArray = ["Yes" , "No, I am a provider, I offer my service"]
            headerView.lblHeaderTitle.text = "Looking for a provider".localized();
        }else{
            self.optionArray = ["Oui" , "Non, je suis fournisseur, j'offre mon service"]
            headerView.lblHeaderTitle.text = "Recherche d'un prestataire".localized();
        }
        self.initializeViewModel()
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
                
                if (self?.viewModel.existingproviderModel.status) == true {
                    self!.navigateToNextScreens()
                }else{
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message: (self?.viewModel.existingproviderModel.message)!, okButtonText: okText, completion: {
                    
                        self?.navigationController?.popViewController(animated: true)
                        
                    })
                }
            }
        }
    }
    
    func existingProviderCheck(){
        
        let Params = ExistingProviderParam()
        Params.service_id = Int(serviceID!)
        Params.user_id = Int(AppPreferenceService.getString(PreferencesKeys.userID)!)
        viewModel.checkExistingProviderServiceSearchToAPIService(user: Params)
    }
    
    func navigateToNextScreens(){
        
        let vc = UIStoryboard.init(name: "Dashboard", bundle: Bundle.main).instantiateViewController(withIdentifier: "ProviderServiceList") as? ProviderServiceList
        vc!.serviceID = serviceID
        vc!.serviceName = serviceName
        vc!.isprovider = true
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}

extension AskForServiceOrProvder : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    //"leftmenu-icon-messages.png"
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let Cell = tableView.dequeueReusableCell(withIdentifier: "AskServiceProviderCell") as! AskServiceProviderCell
//        Cell.initializeCellDetails(indexPath: indexPath.row, isProvider: isProvider)
        Cell.lblOptionName.text = (optionArray![indexPath.row] as! String)
        let checkvalue = optionCheckArry![indexPath.row]
        if checkvalue == true {
            Cell.buttonRadio.image = UIImage(named: "RadioRed")
        }else{
            Cell.buttonRadio.image = UIImage(named: "Radio")
        }
        return Cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        optionCheckArry![0] = false
        optionCheckArry![1] = false
        
        optionCheckArry![indexPath.row] = true
        
        if isNonFoundService == false {
            if indexPath.row == 0 {
                isProvider = false
                let vc = UIStoryboard.init(name: "Dashboard", bundle: Bundle.main).instantiateViewController(withIdentifier: "CreateOwnServiceVC") as? CreateOwnServiceVC
                vc!.isprovider = false
                vc!.serviceType = "Yes"
                self.navigationController?.pushViewController(vc!, animated: true)
            }else{
                isProvider = true
                let vc = UIStoryboard.init(name: "Dashboard", bundle: Bundle.main).instantiateViewController(withIdentifier: "CreateOwnServiceVC") as? CreateOwnServiceVC
                vc!.isprovider = true
                vc!.serviceType = "No, I am a provider, I offer my service"
                self.navigationController?.pushViewController(vc!, animated: true)
            }
            self.tableSelectServiceOrProvide.reloadData()
        }else{
            if indexPath.row == 0 {
                isProvider = false
                self.tableSelectServiceOrProvide.reloadData()
                let vc = UIStoryboard.init(name: "Dashboard", bundle: Bundle.main).instantiateViewController(withIdentifier: "PostalCodeVC") as? PostalCodeVC
                vc!.serviceID = serviceID
                vc!.serviceName = serviceName ?? ""
                vc!.isprovider = false
                self.navigationController?.pushViewController(vc!, animated: true)
            }else{
                isProvider = true
                self.tableSelectServiceOrProvide.reloadData()
                existingProviderCheck()
            }
        }
    }
}
