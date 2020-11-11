//
//  TabBarView.swift
//  Phoenix Errands
//
//  Created by Shyam Future Tech on 08/08/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import UIKit
import Localize_Swift

class TabBarView: UIView {
    
    @IBOutlet weak var tabCollection: UICollectionView!
    @IBOutlet weak var menuHomeImg: UIImageView!
    @IBOutlet weak var menuContactImg: UIImageView!
    @IBOutlet weak var menuActivityImg: UIImageView!
    @IBOutlet weak var menuApplyImg: UIImageView!
    @IBOutlet weak var menuProfileImg: UIImageView!

    @IBOutlet var tabBarView: UIView!
    
    @IBOutlet weak var lblMe: UILabel!
    @IBOutlet weak var lblApply: UILabel!
    @IBOutlet weak var lblActivity: UILabel!
    @IBOutlet weak var lblContacts: UILabel!
    @IBOutlet weak var lblHome: UILabel!
    var onClickHomeButtonAction: (() -> Void)? = nil
    var onClickContactButtonAction: (() -> Void)? = nil
    var onClickMonitorButtonAction: (() -> Void)? = nil
    var onClickApplyButtonAction: (() -> Void)? = nil
    var onClickProfileButtonAction: (() -> Void)? = nil
    let availableLanguages = Localize.availableLanguages()
    var nameArray = NSArray()
    var imgArray = NSArray()
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name( LCLLanguageChangeNotification), object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name( LCLLanguageChangeNotification), object: nil)
    }
    
    @objc func setText(){
//        lblHome.text = "Home".localized();
//        lblContacts.text = "Contacts".localized();
//        lblActivity.text = "Activity".localized();
//        lblApply.text = "Apply".localized();
//        lblMe.text = "Me".localized();
        
        if Localize.currentLanguage() == "en" {
           nameArray = ["Home","Service","Activity","Provider","Me"]
        }else{
            nameArray = ["Accueil","Un service","Activité","Fournisseur","Moi"]
        }
       // tabCollection.reloadData()
    }
    
    private func commonInit(){
        if Localize.currentLanguage() == "en" {
           nameArray = ["Home","Service","Activity","Provider","Me"]
        }else{
            nameArray = ["Accueil","Un service","Activité","Fournisseur","Moi"]
        }
        Bundle.main.loadNibNamed("TabBarView", owner: self, options: nil)
        addSubview(tabBarView)
        tabBarView.frame = self.bounds
        tabBarView.autoresizingMask = .flexibleHeight
        //nameArray = ["Home","Service","Activity","Apply","Me"]
        imgArray = ["HomeSelected","ServiceNewDark","ActivityNewDark","ApplyNewDark","ProfileNewDark"]
        self.tabCollection.register(UINib(nibName: "TabCollectionCell", bundle: Bundle.main), forCellWithReuseIdentifier: "TabCollectionCell")
        tabCollection.delegate = self
        tabCollection.dataSource = self
    }
    
    
    @IBAction func btnHomeAction(_ sender: Any) {
        if self.onClickHomeButtonAction != nil{
            self.onClickHomeButtonAction!()
        }
    }
    
    @IBAction func btnContactAction(_ sender: Any) {
        if self.onClickContactButtonAction != nil{
            self.onClickContactButtonAction!()
            
        }
    }
    
    @IBAction func btnMonitorAction(_ sender: Any) {
        if self.onClickMonitorButtonAction != nil{
            self.onClickMonitorButtonAction!()
        }
    }
    
    @IBAction func btnApplyAction(_ sender: Any) {
        if self.onClickApplyButtonAction != nil{
            self.onClickApplyButtonAction!()
        }
    }
    
    @IBAction func btnProfileAction(_ sender: Any) {
        if self.onClickProfileButtonAction != nil{
            self.onClickProfileButtonAction!()
        }
    }
}

extension TabBarView : UICollectionViewDelegate , UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int)-> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TabCollectionCell", for: indexPath as IndexPath) as! TabCollectionCell
        cell.lblMenuName.text = (nameArray[indexPath.row] as! String)
        cell.menuImgView.image = UIImage(named: imgArray[indexPath.row] as! String)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width : CGFloat = (collectionView.frame.width - (5 + 10))/5 //150
        let height: CGFloat = 100
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        return UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            if self.onClickHomeButtonAction != nil{
                self.onClickHomeButtonAction!()
            }
        case 1:
            if self.onClickContactButtonAction != nil{
                self.onClickContactButtonAction!()
            }
        case 2:
            if self.onClickMonitorButtonAction != nil{
                self.onClickMonitorButtonAction!()
            }
        case 3:
            if self.onClickApplyButtonAction != nil{
                self.onClickApplyButtonAction!()
            }
        case 4:
            if self.onClickProfileButtonAction != nil{
                self.onClickProfileButtonAction!()
            }
        default:
            break
        }
    }
}
