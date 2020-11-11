//
//  NotificationVC.swift
//  Phoenix Errands
//
//  Created by Shyam Future Tech on 30/09/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import UIKit
import Localize_Swift

class NotificationVC: BaseViewController {

    @IBOutlet weak var btnMarkAsComplete: UIButton!
    @IBOutlet weak var notificationListTable: UITableView!
    lazy var viewModel: NotificationVM = {
        return NotificationVM()
    }()
    var NotificationDetails = NotificationListModel()
    var notificationArray : [NotificationList]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Localize.currentLanguage() == "en" {
            self.btnMarkAsComplete.setTitle("Mark all as complete", for: .normal)
            self.headerView.lblHeaderTitle.text = "Notification List"
        }else{
            self.btnMarkAsComplete.setTitle("Tout marquer comme terminé", for: .normal)
            self.headerView.lblHeaderTitle.text = "Liste des notifications"
        }
        
        self.headerView.imgProfileIcon.isHidden = false
        self.headerView.menuButtonOutlet.isHidden = false
        self.headerView.imgViewMenu.isHidden = false
        self.headerView.menuButtonOutlet.tag = 1
        self.headerView.imgViewMenu.image = UIImage(named:"whiteback")
        self.headerView.notificationValueView.isHidden = true
        self.headerView.imgProfileIcon.isHidden = true
        self.tabBarView.isHidden = true
        //AppPreferenceService.setString(String(0), key: PreferencesKeys.notificationCount)
        
        self.notificationListTable.register(UINib(nibName: "NotificationCell", bundle: Bundle.main), forCellReuseIdentifier: "NotificationCell")
        self.notificationListTable.dataSource = self
        self.notificationListTable.delegate = self
        self.initializeViewModel()
        self.getNotificationDetails()
    }
    
    @IBAction func btnMarkAsCompleteAction(_ sender: Any) {
        
        let refreshAlert = UIAlertController(title: commonAlertTitle, message: "Do you want all notification mark as read?.", preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            self.viewModel.getNotificationAllStatusUpdateToAPIService()
        }))

        refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
              
        }))
        present(refreshAlert, animated: true, completion: nil)
    }
    
    func getNotificationDetails(){
        viewModel.getNotificationListToAPIService()
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
                
                if (self?.viewModel.NotificationDetails.status) == 200 {
                    self!.NotificationDetails = (self?.viewModel.NotificationDetails)!
                    if self?.viewModel.NotificationDetails.notificationArray != nil {
                        self!.notificationArray = (self?.viewModel.NotificationDetails.notificationArray)!
                    }
                    self!.notificationListTable.reloadData()
                }else{
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message:"", okButtonText: okText, completion: nil)
                }
            }
        }
        
        viewModel.refreshViewUpdateClosure = {[weak self]() in
            DispatchQueue.main.async {
                
                if (self?.viewModel.NotificationUpdate.status) == 200 {
                    
                }else{
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message:"", okButtonText: okText, completion: nil)
                }
            }
        }
        viewModel.refreshViewAllUpdateClosure = {[weak self]() in
            DispatchQueue.main.async {
                
                if (self?.viewModel.NotificationUpdate.status) == 200 {
                    self!.getNotificationDetails()
                }else{
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message:"", okButtonText: okText, completion: nil)
                }
            }
        }
    }
    
    func updateNotificationStatus(id : String){
        viewModel.getNotificationUpdateToAPIService(id: id)
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
    
    func getNotificationMessageType(messageType : String , id  : String){
        updateNotificationStatus(id: id)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //appDelegate.openHomeViewController()
        switch messageType {
        case "NewService":
            appDelegate.openAddServiceVCController()
        case "MakeProposal":
            appDelegate.openActivityVCController()
         case "AcceptProposal":
            appDelegate.openActivityVCController()
        case "AdminNotification":
            appDelegate.openHomeViewController()
            
        default:
            break
        }
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

extension NotificationVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if notificationArray != nil && (self.notificationArray?.count)! > 0 {
            return (notificationArray?.count)!
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let Cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell") as! NotificationCell
        Cell.lblCOntent.text = notificationArray![indexPath.row].message
        
        let utcTime = localToUTC(dateStr: notificationArray![indexPath.row].created_at!)
        let localTime = utcToLocal(dateStr: utcTime!)
        
        Cell.lblDate.text = localTime//dateFormate(date: notificationArray![indexPath.row].created_at!)
        if notificationArray![indexPath.row].status == "0" {
            Cell.lblCOntent.textColor = UIColor.blue
            Cell.lblDate.textColor = UIColor.blue
            //Cell.bgView.backgroundColor = UIColor.lightGray
        }else{
            Cell.lblCOntent.textColor = UIColor.gray
            Cell.lblDate.textColor = UIColor.gray
            //Cell.bgView.backgroundColor = UIColor.white
        }
        return Cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let dataType = notificationArray![indexPath.row].notiType {
            let id = notificationArray![indexPath.row].id
            self.getNotificationMessageType(messageType: dataType, id: String(id!))
        }
    }
}
