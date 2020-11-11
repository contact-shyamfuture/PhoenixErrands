//
//  ProviderServiceList.swift
//  Phoenix Errands
//
//  Created by Shyam Future Tech on 09/08/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import UIKit
import Localize_Swift
import CoreLocation


class ProviderServiceList: BaseViewController {

    @IBOutlet weak var btnValidateOutlet: UIButton!
    @IBOutlet weak var providerServiceListCollectionView: UICollectionView!
    @IBOutlet weak var lblHint : UILabel!
    @IBOutlet weak var addSkillView : UIView!
    @IBOutlet weak var btnAddSkillOutlet : UIButton!
    @IBOutlet weak var validateBtnVw : UIView!
    
    var serviceNameArray : NSArray?
    var serviceID : String?
    var serviceName : String?
    var isprovider : Bool?
    lazy var viewModel: ProviderSkillVM = {
        return ProviderSkillVM()
    }()
    
    var MySkillDetails = MySkillModel()
    var mySkillArray : [MySkillList]?
    
    var skillDetails = SkillListModel()
    var skillListArray : [SkillListListModel]?
    var skillValidateString : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblHint.isHidden = true
        self.headerView.imgProfileIcon.isHidden = true
        self.headerView.menuButtonOutlet.isHidden = false
        self.headerView.notificationValueView.isHidden = true
        self.headerView.imgViewMenu.isHidden = false
        self.headerView.menuButtonOutlet.tag = 1
        self.headerView.imgViewMenu.image = UIImage(named:"whiteback")
        self.tabBarView.isHidden = true
        self.providerServiceListCollectionView.delegate = self
        self.providerServiceListCollectionView.dataSource = self
        self.serviceNameArray = ["Mover","Housekeeper","Plumber","heating engineer"]
        self.initializeViewModel()
        
        
        if Localize.currentLanguage() == "en" {
            //btnValidateOutlet.setTitle("validate", for: .normal)
            self.headerView.lblHeaderTitle.text = "Skills".localized();
            lblHint.text = "Select your skills to access requests"
            btnAddSkillOutlet.setTitle("Add new skill", for: .normal)
             btnValidateOutlet.setTitle("Validate", for: .normal)
        }else{
            //btnValidateOutlet.setTitle("valider", for: .normal)
            self.headerView.lblHeaderTitle.text = "Compétences".localized();
            lblHint.text = "Sélectionnez vos compétences pour accéder aux demandes"
            btnAddSkillOutlet.setTitle("Ajouter une nouvelle compétence", for: .normal)
            btnValidateOutlet.setTitle("Valider", for: .normal)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getSkillListDetails()
    }
    
    func getSkillListDetails(){
        viewModel.getSkillDetailsToAPIService(serviceID : serviceID!)
    }
    
    @IBAction func btnAddSkillAction(_ sender : UIButton){
        let vc = UIStoryboard.init(name: "Apply", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddSkillVC") as? AddSkillVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func btnValidateAction(_ sender: Any) {
        
        for obj in mySkillArray! {
            if obj.isSelected == true{
                let vc = UIStoryboard.init(name: "Dashboard", bundle: Bundle.main).instantiateViewController(withIdentifier: "PostalCodeVC") as? PostalCodeVC
                vc!.isprovider = isprovider
                vc!.serviceID = serviceID
                vc!.serviceName = serviceName ?? ""
                self.navigationController?.pushViewController(vc!, animated: true)
                break
            }
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
                if (self?.viewModel.skillDetails.status) == 200 {
                    self!.MySkillDetails = (self?.viewModel.skillDetails)!
                    self!.mySkillArray = (self?.viewModel.skillDetails.mySkillArray)!
                    if self!.mySkillArray!.count > 0{
                        self?.lblHint.isHidden = true
                        self?.validateBtnVw.isHidden = false
                        self?.addSkillView.isHidden = false
                    }else{
                        self?.lblHint.isHidden = true
                        self?.validateBtnVw.isHidden = true
                        self?.addSkillView.isHidden = false
                    }
                    self!.providerServiceListCollectionView.reloadData()
                }else{
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message: (self?.viewModel.skillDetails.message)!, okButtonText: okText, completion: nil)
                }
            }
        }
    }
}

extension ProviderServiceList : UICollectionViewDelegate , UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int)-> Int {
        
        if mySkillArray != nil && (mySkillArray?.count)! > 0 {
            return (mySkillArray?.count)!
        }else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProviderServiceCell", for: indexPath as IndexPath) as! ProviderServiceCell
        cell.initializeCellDetails(cellDic: mySkillArray![indexPath.row])
//        cell.lbServiceName.text = (serviceNameArray![indexPath.row] as! String)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width : CGFloat = (collectionView.frame.width - (20 + 20))/2
        let height: CGFloat = 150
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
        }else {
            return 10
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 10, bottom: 0, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let isSected = mySkillArray![indexPath.row].isSelected
        if isSected == false {
            mySkillArray![indexPath.row].isSelected = true
        }else{
            mySkillArray![indexPath.row].isSelected = false
        }
        self.providerServiceListCollectionView.reloadData()
    }
}
