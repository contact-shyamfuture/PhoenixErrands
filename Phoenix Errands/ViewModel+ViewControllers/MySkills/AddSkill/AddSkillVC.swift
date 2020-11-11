//
//  AddSkillVC.swift
//  Phoenix Errands
//
//  Created by Shyam Future Tech on 01/10/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import UIKit
import Localize_Swift

class AddSkillVC: BaseViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var addSkillCollectionView: UICollectionView!
    @IBOutlet weak var btnSaveOutlet: UIButton!
    
    lazy var viewModel: MySkillVM = {
        return MySkillVM()
    }()
    var SkillDetails = SkillListModel()
    var skillListArray : [SkillListListModel]?
    var selectedIndex : Int?
    var addSkillParam = AddSkill()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if Localize.currentLanguage() == "en" {
            btnSaveOutlet.setTitle("save", for: .normal)
            lblTitle.text = "select your skill to add new skill"
            self.headerView.lblHeaderTitle.text = "Add Skills"
        }else{
            btnSaveOutlet.setTitle("enregistrer", for: .normal)
            lblTitle.text = "sélectionnez votre compétence pour ajouter une nouvelle compétence"
            self.headerView.lblHeaderTitle.text = "Ajouter des compétences"
        }
        self.headerView.imgProfileIcon.isHidden = false
        self.headerView.menuButtonOutlet.isHidden = false
        self.headerView.imgViewMenu.isHidden = false
        self.headerView.menuButtonOutlet.tag = 1
        self.headerView.imgViewMenu.image = UIImage(named:"whiteback")
        self.headerView.notificationValueView.isHidden = true
        self.headerView.imgProfileIcon.isHidden = true
        self.tabBarView.isHidden = true
        self.addSkillCollectionView.delegate = self
        self.addSkillCollectionView.dataSource = self
        self.getAllSkill()
        self.initializeViewModel()
    }
    func getAllSkill(){
        viewModel.getAllSkillListToAPIService()
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
                
                if (self?.viewModel.SkillDetails.status) == 200 {
                    self!.SkillDetails = (self?.viewModel.SkillDetails)!
                    self!.skillListArray = (self?.viewModel.SkillDetails.skillListArray)!
                    self!.addSkillCollectionView.reloadData()
                }else{
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message:"", okButtonText: okText, completion: nil)
                }
            }
        }
        
        viewModel.showAlertAddSkillClosure = {[weak self]() in
            DispatchQueue.main.async {
               
                //(self?.viewModel.addSkillDetails.message)!
                 
                
                if (self?.viewModel.addSkillDetails.status) == 200 {
                    var message = ""
                    if Localize.currentLanguage() == "en" {
                        message = "Your skill has been successfully added, Please endeavor to register yourself for the desired service, to be notified when a service is posted."
                    }else{
                        message = "Votre compétence a été ajoutée avec succès, veuillez essayer de vous inscrire au service souhaité, pour être averti lorsqu'un service est publié"
                    }
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message: message, okButtonText: okText, completion: {
                    self?.navigationController?.popViewController(animated: true)
                    })
                }else{
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message:(self?.viewModel.addSkillDetails.message)!, okButtonText: okText, completion: nil)
                }
            }
        }
    }
    
    @IBAction func btnSaveSkillAction(_ sender: Any) {
        if selectedIndex != nil {
            addSkillParam.skillid = skillListArray![selectedIndex!].id
            viewModel.addSkillToAPIService(user: addSkillParam)
        }else{
            self.showAlertWithSingleButton(title: commonAlertTitle, message:"Please select skill", okButtonText: okText, completion: nil)
        }
    }
}

extension AddSkillVC : UICollectionViewDelegate , UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int)-> Int {
        
        if skillListArray != nil && (skillListArray?.count)! > 0 {
            return (skillListArray?.count)!
        }else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MySKillCell", for: indexPath as IndexPath) as! MySKillCell
//        cell.lblSkillName.text = skillListArray![indexPath.row].skillName
        cell.initializeCellDetails(cellDic: skillListArray![indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width : CGFloat = (collectionView.frame.width - (20 + 20))/2
        let height: CGFloat = 160
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
       
        for index in 0...(((skillListArray?.count)! - 1)) {
            if index == indexPath.row {
                let isSected = skillListArray![index].isSelected
                if isSected == false {
                    skillListArray![index].isSelected = true
                    selectedIndex = index
                }else{
                    selectedIndex = nil
                    skillListArray![index].isSelected = false
                }
            }else{
                 skillListArray![index].isSelected = false
            }
        }
        self.addSkillCollectionView.reloadData()
    }
}
