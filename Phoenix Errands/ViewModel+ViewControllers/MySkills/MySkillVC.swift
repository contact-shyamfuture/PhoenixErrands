//
//  MySkillVC.swift
//  Phoenix Errands
//
//  Created by Shyam Future Tech on 01/10/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import UIKit
import Localize_Swift

class MySkillVC: BaseViewController {
    @IBOutlet weak var muSkillCollectionView: UICollectionView!
    
    lazy var viewModel: MySkillVM = {
        return MySkillVM()
    }()
    var MySkillDetails = MySkillModel()
    var mySkillArray : [MySkillList]?
    @IBOutlet weak var btnAddNewSkillOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if Localize.currentLanguage() == "en" {
            btnAddNewSkillOutlet.setTitle("Add new skill", for: .normal)
            self.headerView.lblHeaderTitle.text = "My Skills"
        }else{
            btnAddNewSkillOutlet.setTitle("Ajouter une nouvelle compétence", for: .normal)
            self.headerView.lblHeaderTitle.text = "Mes compétences"
        }
//        self.headerView.lblHeaderTitle.text = "My Skills"
        self.headerView.imgProfileIcon.isHidden = false
        self.headerView.menuButtonOutlet.isHidden = false
        self.headerView.imgViewMenu.isHidden = false
        self.headerView.menuButtonOutlet.tag = 1
        self.headerView.imgViewMenu.image = UIImage(named:"whiteback")
        self.headerView.notificationValueView.isHidden = true
        self.headerView.imgProfileIcon.isHidden = true
        self.tabBarView.isHidden = true
        self.muSkillCollectionView.delegate = self
        self.muSkillCollectionView.dataSource = self
        self.initializeViewModel()
        //viewModel.getCategoryDetailsToAPIService(lang : Localize.currentLanguage())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.getMySkillS()
    }
    
    func getMySkillS(){
        viewModel.getSkillListToAPIService(lang: Localize.currentLanguage())
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
                
                if (self?.viewModel.MySkillDetails.status) == 200 {
                    self!.MySkillDetails = (self?.viewModel.MySkillDetails)!
                    self!.mySkillArray = (self?.viewModel.MySkillDetails.mySkillArray)!
                    self!.muSkillCollectionView.reloadData()
                }else{
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message:"", okButtonText: okText, completion: nil)
                }
            }
        }
        
        viewModel.showAlertRemoveSkillClosure = {[weak self]() in
            DispatchQueue.main.async {
                
                if (self?.viewModel.addSkillDetails.status) == 200 {
                    
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message:(self?.viewModel.addSkillDetails.message)!, okButtonText: okText, completion: {
                    self!.getMySkillS()
                    })
                    
                }else{
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message:(self?.viewModel.addSkillDetails.message)!, okButtonText: okText, completion: nil)
                }
            }
        }
    }
    
    @IBAction func btnAddSkillAction(_ sender: Any) {
        
        let vc = UIStoryboard.init(name: "Apply", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddSkillVC") as? AddSkillVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    func removeSkillFromList(skillID : Int){
        let obj =  RemoveSkill()
        obj.skill_id = Int(mySkillArray![skillID].skill_id!)
        viewModel.removekillToAPIService(user: obj)
    }
    
    func removeSkill(indexPathValue : Int){
        var message = String()
        if Localize.currentLanguage() == "en" {
            message = "You want to delete your skill"
        }else{
            message = "Vous souhaitez supprimer votre compétence"
        }
        let refreshAlert = UIAlertController(title: commonAlertTitle, message: message, preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            self.removeSkillFromList(skillID: indexPathValue)
          }))

        refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
          print("Handle Cancel Logic here")
          }))

        present(refreshAlert, animated: true, completion: nil)
    }
}

extension MySkillVC : UICollectionViewDelegate , UICollectionViewDataSource,UICollectionViewDelegateFlowLayout , removeSkillsDelegates{
    
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MySKillCell", for: indexPath as IndexPath) as! MySKillCell
        cell.lblSkillName.text = mySkillArray![indexPath.row].skillName
        cell.btnRemovSkillOutlet.tag = indexPath.row
        cell.delegate = self
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
    }
}
