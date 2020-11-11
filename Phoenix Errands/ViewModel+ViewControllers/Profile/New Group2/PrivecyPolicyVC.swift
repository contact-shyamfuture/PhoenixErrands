//
//  PrivecyPolicyVC.swift
//  Phoenix Errands
//
//  Created by Shyam Future Tech on 03/05/20.
//  Copyright © 2020 Shyam Future Tech. All rights reserved.
//

import UIKit
import Localize_Swift
class PrivecyPolicyVC: UIViewController {

    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var contentTxtView: UITextView!
    
    lazy var viewModel: IntroVM = {
        return IntroVM()
    }()
    var introDetails = IntroModel()
    var introArray : [IntroImageArray]?
    
    
    var isTerm : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentTxtView.isEditable = false
        if Localize.currentLanguage() == "en" {
            if isTerm == true {
                self.headerLbl.text = "Terms and Condition"
            }else{
                self.headerLbl.text = "Privacy Policy"
            }
            
        }else{
            if isTerm == true {
                self.headerLbl.text = "termes et conditions"
            }else{
                self.headerLbl.text = "Politique de confidentialité"
            }
        }
        initializeViewModel()
        getIntroDetails()
    }
    
    func getIntroDetails(){
        viewModel.getIntroDetailsToAPIService()
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
                
                if (self?.viewModel.introDetails.status) == 201 {
                    self!.introDetails = (self?.viewModel.introDetails)!
                    if self!.isTerm == true {
                        self!.contentTxtView.text = self!.introDetails.terms
                    }else{
                        self!.contentTxtView.text = self!.introDetails.privacy
                    }
                }else{
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message: (self?.viewModel.introDetails.message)!, okButtonText: okText, completion: nil)
                }
            }
        }
    }
}
