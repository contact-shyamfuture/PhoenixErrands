//
//  AddServiceVC.swift
//  Phoenix Errands
//
//  Created by Raghav Beriwala on 19/08/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import UIKit
import Localize_Swift

class AddServiceVC: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    lazy var viewModel: AddServiceVM = {
        return AddServiceVM()
    }()
    var nearestService = NearestServiceModel()
    var nearestServiceList : [ServiceNearMeList]?
    var selectedIndex: Int = 0
    var localizedString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "ServiceCell", bundle: Bundle.main), forCellReuseIdentifier: "ServiceCell")
        tableView.estimatedRowHeight = 120
        
        headerSetup()
        initializeViewModel()
    }
    func getNearestServiceApi(){
        viewModel.getNearestServicesToAPIService()
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        getNearestServiceApi()
    }

    func headerSetup()
    {
        //UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear//Constants.App.statusBarColor
        
        if #available(iOS 13.0, *) {
            let statusBar = UIView(frame: UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
             statusBar.backgroundColor = UIColor.clear
             UIApplication.shared.keyWindow?.addSubview(statusBar)
        } else {
             UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
        }
        if Localize.currentLanguage() == "en" {
            headerView.lblHeaderTitle.text = "My Service"
            localizedString = "Bid amount : "
        }else{
            headerView.lblHeaderTitle.text = "Mon service"
            localizedString = "Montant de l'enchère:"
        }
        headerView.imgProfileIcon.isHidden = true
        headerView.menuButtonOutlet.isHidden = true
        headerView.imgViewMenu.isHidden = true
        headerView.menuButtonOutlet.tag = 11
        headerView.imgViewMenu.image = UIImage(named:"whiteback")
        headerView.notificationValueView.isHidden = true
        headerView.imgProfileIcon.isHidden = true
        
        
        
        self.tabBarView.lblHome.textColor = UIColor.lightGray
        self.tabBarView.lblMe.textColor = UIColor.lightGray
        self.tabBarView.lblApply.textColor = UIColor.lightGray
        self.tabBarView.lblActivity.textColor = UIColor.lightGray
        self.tabBarView.lblContacts.textColor = UIColor.black
        self.tabBarView.lblContacts.font = UIFont.boldSystemFont(ofSize: 14.0)
        self.tabBarView.menuContactImg.image = UIImage(named:"ServiceNewSelected")
        self.tabBarView.imgArray = ["NewHome","ServiceNewSelected","ActivityNewDark","ApplyNewDark","ProfileNewDark"]
        self.tabBarView.tabCollection.reloadData()
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
                
                if (self?.viewModel.nearestService.status) == 200
                {
                    self!.nearestService = (self?.viewModel.nearestService)!
                    self!.nearestServiceList = (self?.viewModel.nearestService.serviceNearMeList)!
                    self?.tableView.reloadData()
               }
                else{
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message: (self?.viewModel.nearestService.message)!, okButtonText: okText, completion: nil)
                }
            }
        }
    }
    
    func dateFormate(date : String) -> String {
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd MMM,yyyy hh:mm"
        
        let date: NSDate? = (dateFormatterGet.date(from: date)! as NSDate)
        print(dateFormatterPrint.string(from: date! as Date))

        return dateFormatterPrint.string(from: date! as Date)
    }
    
    func localToUTC(dateStr: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "IST")
        
        if let date = dateFormatter.date(from: dateStr) {
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            return dateFormatter.string(from: date)
        }
        return nil
    }
    
    func utcToLocal(dateStr: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        if let date = dateFormatter.date(from: dateStr) {
            dateFormatter.timeZone = TimeZone.current //TimeZone(abbreviation: "CEST")//
            dateFormatter.dateFormat = "dd MMM,yyyy hh:mm"
        
            return dateFormatter.string(from: date)
        }
        return nil
    }
}


extension AddServiceVC : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
       
        if nearestServiceList != nil  && (self.nearestServiceList?.count)! > 0{
            return (self.nearestServiceList?.count)!
        }else{
            return 0
        }
    }
    //"leftmenu-icon-messages.png"
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let Cell = tableView.dequeueReusableCell(withIdentifier: "ServiceCell") as! ServiceCell
        Cell.btnDetails.isHidden = true
        if nearestServiceList![indexPath.row].isbid == "false"
        {
            Cell.btnDetails.isHidden = false
            Cell.lblBidAmount.isHidden = true
            Cell.bidView.isHidden = false
        }else{
            Cell.bidView.isHidden = true
            Cell.lblBidAmount.isHidden = false
            let type = nearestServiceList![indexPath.row].type ?? ""
            Cell.lblBidAmount.text = localizedString + priceType(type: type) + nearestServiceList![indexPath.row].bidamount!
        }
        let utcTime = localToUTC(dateStr: (nearestServiceList![indexPath.row].created_at)!)
        let localTime = utcToLocal(dateStr: utcTime!)
       // let createdDate = dateFormate(date: (nearestServiceList![indexPath.row].created_at)!)
            Cell.lblDate.text = localTime//createdDate
        
        Cell.lblName.text = nearestServiceList![indexPath.row].serviceName
        Cell.btnInfo.addTarget(self, action: #selector(AddServiceVC.btnInfoTapped(_:)), for: UIControl.Event.touchUpInside)
        Cell.btnBid.addTarget(self, action: #selector(AddServiceVC.btnBidTapped(_:)), for: UIControl.Event.touchUpInside)
        return Cell
    }
    func priceType(type : String) -> String{
        if type == "1"{
            return "$"
        }else if type == "2"{
            return "€"
        }else if type == "3"{
            return "£"
        }
        else{
            return ""
        }
    }
    
    @objc func btnInfoTapped(_ sender: UIButton!)
    {
        let position = sender.convert(CGPoint.zero, to: self.tableView)
        selectedIndex = (self.tableView.indexPathForRow(at: position)?.row)!
        let vc = UIStoryboard.init(name: "Profile", bundle: Bundle.main).instantiateViewController(withIdentifier: "ServiceDetailsVC") as? ServiceDetailsVC
        vc?.requestid = nearestServiceList![selectedIndex].requestid
        vc!.bidAmount = priceType(type: nearestServiceList![selectedIndex].type ?? "") + (nearestServiceList![selectedIndex].bidamount ?? "")
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    @objc func btnBidTapped(_ sender: UIButton!)
    {
        let position = sender.convert(CGPoint.zero, to: self.tableView)
        selectedIndex = (self.tableView.indexPathForRow(at: position)?.row)!
        print("You selected cell #\(selectedIndex)!")
        
        if nearestServiceList![selectedIndex].isbid == "false"
        {
            let vc = UIStoryboard.init(name: "Profile", bundle: Bundle.main).instantiateViewController(withIdentifier: "BidVC") as? BidVC
            vc?.requestid = nearestServiceList![selectedIndex].requestid
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView( _ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        print("You selected cell #\(indexPath.row)!")
        if nearestServiceList![indexPath.row].isbid == "false"
        {
            let vc = UIStoryboard.init(name: "Profile", bundle: Bundle.main).instantiateViewController(withIdentifier: "BidVC") as? BidVC
            vc?.requestid = nearestServiceList![indexPath.row].requestid
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
}

