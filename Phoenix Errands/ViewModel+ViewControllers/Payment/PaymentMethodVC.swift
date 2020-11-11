//
//  PaymentMethodVC.swift
//  Phoenix Errands
//
//  Created by Samir Samanta on 21/07/20.
//  Copyright © 2020 Shyam Future Tech. All rights reserved.
//

import UIKit
import Localize_Swift

class PaymentMethodVC: BaseViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var cardListCollectionView: UICollectionView!
    var userCardList : [UserCardList]?
    
    lazy var viewModel: PaymentVM = {
        return PaymentVM()
    }()
    
    lazy var viewProfileModel: ProfileVM = {
        return ProfileVM()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setText()
        
        self.cardListCollectionView.register(UINib(nibName: "CardListCell", bundle: Bundle.main), forCellWithReuseIdentifier:  "CardListCell")
        self.cardListCollectionView.delegate = self
        self.cardListCollectionView.dataSource = self
        initializeViewProfileModel()
        initializeViewModel()
        getProfileDetailsview()
    }
    
    func getProfileDetailsview(){
        viewProfileModel.getProfileDetailsToAPIService()
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
                if (self?.viewModel.PaymentDetails.status) == 200 {
                    
                    
                }else{
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message:(self?.viewModel.PaymentDetails.message)!, okButtonText: okText, completion: nil)
                }
            }
        }
        
        viewModel.refreshDeleteViewClosure = {[weak self]() in
            DispatchQueue.main.async {
                if (self?.viewModel.deleteCardModel.status) == 200 {
                    
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message:(self?.viewModel.deleteCardModel.message)!, okButtonText: okText, completion: {
                        self?.getProfileDetailsview()
                    })
                }else{
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message:(self?.viewModel.deleteCardModel.message)!, okButtonText: okText, completion: nil)
                }
            }
        }
    }
    
    
    func initializeViewProfileModel() {
        
        viewProfileModel.showAlertClosure = {[weak self]() in
            DispatchQueue.main.async {
                if let message = self?.viewProfileModel.alertMessage {
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message: message, okButtonText: okText, completion: nil)
                }
            }
        }
        
        viewProfileModel.updateLoadingStatus = {[weak self]() in
            DispatchQueue.main.async {
                
                let isLoading = self?.viewProfileModel.isLoading ?? false
                if isLoading {
                    self?.addLoaderView()
                } else {
                    self?.removeLoaderView()
                }
            }
        }
        
        viewProfileModel.refreshViewClosure = {[weak self]() in
            DispatchQueue.main.async {
                
                if (self?.viewProfileModel.profileDetails.status) == 200 {
                    
                    self!.userCardList = self?.viewProfileModel.profileDetails.ProfileDetails!.userCardList
                    self!.cardListCollectionView.reloadData()
                }
                else{
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message: (self?.viewProfileModel.profileDetails.message)!, okButtonText: okText, completion: nil)
                }
            }
        }
    }
    
    func setText(){
        
        if #available(iOS 13.0, *) {
            let statusBar = UIView(frame: UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
             statusBar.backgroundColor = UIColor.clear
             UIApplication.shared.keyWindow?.addSubview(statusBar)
        } else {
             UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
        }
        if Localize.currentLanguage() == "en"{
            lblTitle.text = "User saved card"
            headerView.lblHeaderTitle.text = "Payment methods"//"Card Details"
        }else{
            lblTitle.text = "Carte enregistrée par l'utilisateur"
            headerView.lblHeaderTitle.text = "Méthodes de payement"//"Détails de la carte"
        }
        headerView.imgProfileIcon.isHidden = false
        headerView.menuButtonOutlet.isHidden = false
        headerView.imgViewMenu.isHidden = false
        headerView.menuButtonOutlet.tag = 1
        headerView.imgViewMenu.image = UIImage(named:"whiteback")
        headerView.notificationValueView.isHidden = true
        headerView.imgProfileIcon.isHidden = true
    }
    
    func cardInActiveActive(index : Int){
     
        let alertController = UIAlertController(title: commonAlertTitle, message: "You want to delete?".localized(), preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK".localized(), style: UIAlertAction.Style.default) {
            UIAlertAction in
            NSLog("OK Pressed")
            self.deleteCardDetails(cardId: self.userCardList![index].id!)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel".localized(), style: UIAlertAction.Style.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func deleteCardDetails(cardId : String){
        let param = DeleteCardParam()
        param.card_id = cardId
        viewModel.deleteCardDetailsToAPIService(user: param)
    }
}

extension PaymentMethodVC : UICollectionViewDelegate , UICollectionViewDataSource,UICollectionViewDelegateFlowLayout , cardActiveInActiveDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int)-> Int {
        if userCardList != nil  && userCardList!.count > 0 {
            return userCardList!.count
        }else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardListCell", for: indexPath as IndexPath) as! CardListCell
        cell.delegate = self
        cell.initializeCellDetails(cellDic: userCardList![indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width : CGFloat = 264
        let height: CGFloat = 120
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        return UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
