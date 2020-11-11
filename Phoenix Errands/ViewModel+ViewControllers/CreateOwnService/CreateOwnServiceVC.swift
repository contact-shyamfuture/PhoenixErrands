//
//  CreateOwnServiceVC.swift
//  Phoenix Errands
//
//  Created by Shyam Future Tech on 02/11/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import UIKit
import Localize_Swift
import CoreLocation

class CreateOwnServiceVC: BaseViewController {

    var isprovider : Bool?
    var serviceType : String?
    
    @IBOutlet weak var txtViewDescription: UITextView!
    @IBOutlet weak var lblHTitle : UILabel!
    @IBOutlet weak var btnContinue : UIButton!
    
    lazy var viewModel: SubCategoryVM = {
        return SubCategoryVM()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lblHTitle.text = Localize.currentLanguage() == "en" ? "Give description to your own request" : "Donnez une description à votre propre demande"
        let btnTitle = Localize.currentLanguage() == "en" ? "Continue" : "Continuer"
        btnContinue.setTitle(btnTitle, for: .normal)
        headerView.lblHeaderTitle.text = Localize.currentLanguage() == "en" ? "Create Own Service" : "Créer son propre service"
        headerView.imgProfileIcon.isHidden = true
        headerView.menuButtonOutlet.isHidden = false
        headerView.notificationValueView.isHidden = true
        headerView.imgViewMenu.isHidden = false
        headerView.menuButtonOutlet.tag = 1
        headerView.imgViewMenu.image = UIImage(named:"whiteback")
        tabBarView.isHidden = true
        self.initializeViewModel()
    }
    
    @IBAction func btnContinueAction(_ sender: Any) {
        let param = CreateOwnParams()
        param.user_id = AppPreferenceService.getString(PreferencesKeys.userID)
        param.subcategory = ""
        param.serviceDetails = self.txtViewDescription.text
        param.serviceType = serviceType
        
        if Localize.currentLanguage() == "en" {
            viewModel.postCreateOwnCategoryToAPIService(user: param , lang : "en")
        }else{
            viewModel.postCreateOwnCategoryToAPIService(user: param , lang : "fr")
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
        
        viewModel.refreshViewSearchNotFoundClosure = {[weak self]() in
            DispatchQueue.main.async {
                if (self?.viewModel.createOwnDetails.status) == 200 {
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message: (self?.viewModel.createOwnDetails.message)!, okButtonText: okText, completion: {
                        for controller in self!.navigationController!.viewControllers as Array {
                            if controller.isKind(of: DashboardVC.self) {
                                self!.navigationController!.popToViewController(controller, animated: true)
                                break
                            }
                        }
                    })
                }else{
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message: (self?.viewModel.createOwnDetails.message)!, okButtonText: okText, completion: nil)
                }
            }
        }
    }
}
