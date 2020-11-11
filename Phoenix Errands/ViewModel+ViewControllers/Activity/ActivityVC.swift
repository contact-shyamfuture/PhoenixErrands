//
//  ActivityVC.swift
//  Phoenix Errands
//
//  Created by Raghav Beriwala on 14/08/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import UIKit
import Localize_Swift

class ActivityVC: BaseViewController {
    
    @IBOutlet weak var segmentControll: UISegmentedControl!
    @IBOutlet weak var segmentController: UISegmentedControl!
    var segmentDoctorIsSelected:Bool = false
    let buttonBar = UIView()
    @IBOutlet weak var btnPeoposerMyService: UIButton!
    @IBOutlet weak var btnAskedService: UIButton!
    @IBOutlet weak var lblPublishedResult: UILabel!
    @IBOutlet weak var inProgressTable: UITableView!
    @IBOutlet weak var inProgressView: UIView!
    @IBOutlet weak var reserveView: UIView!
    @IBOutlet weak var lblPropose : UILabel!
    @IBOutlet weak var btnPropose : UIButton!
    @IBOutlet weak var btnAsk : UIButton!
    
    lazy var viewModel: ActivityVM = {
        return ActivityVM()
    }()
    
    var inProgressDetails = AcitivityModel()
    var serviceList : [ServiceList]?
    var providerOnGoingList : [ProviderOngoingList]?
    var providerOnGoing = ProviderOngoingModel()
    var isProgress = Bool()
    override func viewDidLoad(){
        super.viewDidLoad()
        headerSetup()
        CustomSegmentControl()
        setText()
        self.reserveView.isHidden = true
        self.inProgressTable.delegate = self
        self.inProgressTable.dataSource = self
        self.inProgressTable.register(UINib(nibName: "InProgressTableCell", bundle: Bundle.main), forCellReuseIdentifier: "InProgressTableCell")
        
        self.inProgressTable.register(UINib(nibName: "ProviderServiceDetailsCell", bundle: Bundle.main), forCellReuseIdentifier: "ProviderServiceDetailsCell")
        
        initializeViewModel()
        getInProgressList()
        isProgress = false
        if Localize.currentLanguage() == "en" {
            segmentControll.setTitle("Service history Phoenix USER", forSegmentAt: 0)
            segmentControll.setTitle("Service history Phoenix vendor", forSegmentAt: 1)
        }else{
            segmentControll.setTitle("Historique des services Phoenix USER", forSegmentAt: 0)
            segmentControll.setTitle("Historique des services du fournisseur Phoenix", forSegmentAt: 1)
        }
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.setText), name: NSNotification.Name( LCLLanguageChangeNotification), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func setText(){
        if Localize.currentLanguage() == "en" {
            headerView.lblHeaderTitle.text = "Activity"
            lblPropose.text = "Your published requests and those where you applied will appear here"
            btnPropose.setTitle("Propose my service", for: .normal)
            btnAsk.setTitle("Ask for a service", for: .normal)
        }else{
            headerView.lblHeaderTitle.text = "Activité"
            lblPropose.text = "Vos demandes publiées et celles auxquelles vous avez postulé apparaîtront ici"
            btnPropose.setTitle("Proposer mon service", for: .normal)
            btnAsk.setTitle("Demandez un service", for: .normal)
        }
        self.tabBarView.lblHome.textColor = UIColor.lightGray
        self.tabBarView.lblMe.textColor = UIColor.lightGray
        self.tabBarView.lblApply.textColor = UIColor.lightGray
        self.tabBarView.lblActivity.textColor = UIColor.black
        self.tabBarView.lblActivity.font = UIFont.boldSystemFont(ofSize: 14.0)
        self.tabBarView.lblContacts.textColor = UIColor.lightGray
        self.tabBarView.menuActivityImg.image = UIImage(named:"ActivitySelected")
        self.tabBarView.imgArray = ["NewHome","ServiceNewDark","ActivitySelected","ApplyNewDark","ProfileNewDark"]
        self.tabBarView.tabCollection.reloadData()
    }
    
    @IBAction func segmentChangeTapped(_ sender: Any){
        if (sender as AnyObject).selectedSegmentIndex == 0 {
            print("First Segment Select")
            self.reserveView.isHidden = true
            self.inProgressView.isHidden = false
            isProgress = false
            getInProgressList()
        }
        else {
            isProgress = true
            print("Second Segment Select")
            self.getProviderOngoingService()
            self.reserveView.isHidden = true
            self.inProgressView.isHidden = false
        }
    }
    
    func CustomSegmentControl(){
        /*segmentControll.multilinesMode = true
        for segmentViews in segmentControll.subviews {
            for segmentLabel in segmentViews.subviews {
                if segmentLabel is UILabel {
                    (segmentLabel as! UILabel).numberOfLines = 2
                }
            }
        }*/
        UILabel.appearance(whenContainedInInstancesOf: [UISegmentedControl.self]).numberOfLines = 0
        let font = UIFont.systemFont(ofSize: 15)
        segmentControll.setTitleTextAttributes([NSAttributedString.Key.font: font],
                                                 for: .normal)
        segmentControll.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
            NSAttributedString.Key.foregroundColor: UIColor(red: 148/255.0, green: 82/255.0, blue: 0/255.0, alpha: 1.0)
            ], for: .normal)
        
        segmentControll.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
            NSAttributedString.Key.foregroundColor: UIColor.white
            ], for: .selected)
        
        segmentControll.rounded(with: 10.0)
    }
    
    func getInProgressList(){
        viewModel.getInProgressDetailsToAPIService()
    }
    
    func getProviderOngoingService(){
        viewModel.getOngoingServiceToAPIService()
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
                
                if (self?.viewModel.inProgressDetails.status) == 200 {
                    self!.inProgressDetails = (self?.viewModel.inProgressDetails)!
                    self!.serviceList = (self?.viewModel.inProgressDetails.serviceList)!
                    print("Count==>\(self?.serviceList?.count)")
                    
                    if self?.serviceList?.count == 0
                    {
                        self?.reserveView.isHidden = false
                        self?.inProgressView.isHidden = true
                    }
                    else
                    {
                        self?.reserveView.isHidden = true
                        self?.inProgressView.isHidden = false
                    }
                    self?.inProgressTable.reloadData()
                }else{
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message: (self?.viewModel.inProgressDetails.message)!, okButtonText: okText, completion: nil)
                }
            }
        }
        
        viewModel.refreshViewOngoingClosure = {[weak self]() in
            DispatchQueue.main.async {
                
                if (self?.viewModel.onGongProvider.status) == 201 {
                    self!.providerOnGoing = (self?.viewModel.onGongProvider)!
                   self!.providerOnGoingList = (self?.viewModel.onGongProvider.OngoingList)!
                    self?.inProgressTable.reloadData()
                }else{
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message:"", okButtonText: okText, completion: nil)
                }
            }
        }
        viewModel.refreshViewRequestCancelClosure = {[weak self]() in
            DispatchQueue.main.async {
                
                if (self?.viewModel.cancelRequest.status) == 200 {
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message:(self?.viewModel.cancelRequest.message)!, okButtonText: okText, completion: {
                        self!.getInProgressList()
                    })
                }else{
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message:(self?.viewModel.cancelRequest.message)!, okButtonText: okText, completion: nil)
                }
            }
        }
    }
    
    @IBAction func btnServiceTapped(_ sender: Any)
    {
        let vc = UIStoryboard.init(name: "Dashboard", bundle: Bundle.main).instantiateViewController(withIdentifier: "DashboardVC") as? DashboardVC
        self.navigationController?.pushViewController(vc!, animated: false)
    }
    
    @IBAction func offerForServiceTapped(_ sender: Any)
    {
        let vc = UIStoryboard.init(name: "Apply", bundle: Bundle.main).instantiateViewController(withIdentifier: "ApplyVC") as? ApplyVC
        self.navigationController?.pushViewController(vc!, animated: false)
    }
    
    func headerSetup()
    {
//        UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
        
        if #available(iOS 13.0, *) {
            let statusBar = UIView(frame: UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
             statusBar.backgroundColor = UIColor.clear
             UIApplication.shared.keyWindow?.addSubview(statusBar)
        } else {
             UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
        }
        
        headerView.lblHeaderTitle.text = "Activity"
        headerView.imgProfileIcon.isHidden = false
        headerView.menuButtonOutlet.isHidden = true
        headerView.imgViewMenu.isHidden = true
        headerView.menuButtonOutlet.tag = 1
        headerView.lblNotificationCount.text =  UserDefaults.standard.string(forKey: PreferencesKeys.notificationCount)!
        headerView.imgViewMenu.image = UIImage(named:"whiteback")
    }
    func serviceRequestCancel(index : Int){
        let requestId = serviceList![index].requestid
        viewModel.cancelRequestToAPIService(servicerequestID : String(requestId!))
    }
    
    func detailsRequest(indexPathValue : Int){
        let vc = UIStoryboard.init(name: "Profile", bundle: Bundle.main).instantiateViewController(withIdentifier: "ServiceDetailsVC") as? ServiceDetailsVC
        vc?.requestid = serviceList![indexPathValue].requestid
//        vc!.bidAmount = serviceList![indexPathValue].bidamount
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func cancelRequest(indexPathValue : Int){
        print("IndexPath : \(indexPathValue)")
        
        let refreshAlert = UIAlertController(title: commonAlertTitle, message: "You want to cancel your service request", preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            self.serviceRequestCancel(index: indexPathValue)
          }))

        refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
          print("Handle Cancel Logic here")
          }))

        present(refreshAlert, animated: true, completion: nil)
    }
}

extension ActivityVC : UITableViewDelegate, UITableViewDataSource , cancelRequestDelegates {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isProgress == false {
            if serviceList != nil  && (self.serviceList?.count)! > 0{
                return (self.serviceList?.count)!
            }else{
                return 0
            }
        }else{
            if providerOnGoingList != nil  && (self.providerOnGoingList?.count)! > 0{
                return (self.providerOnGoingList?.count)!
            }else{
                return 0
            }
        }
    }
    
    //"leftmenu-icon-messages.png"
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isProgress == false {
            let Cell = tableView.dequeueReusableCell(withIdentifier: "InProgressTableCell") as! InProgressTableCell
            Cell.initializeCellDetails(cellDic : serviceList![indexPath.row])
            Cell.cancelRequestBtnOutlet.tag = indexPath.row
            Cell.detailsButton.tag = indexPath.row
            Cell.cancelDelegate = self
            return Cell
        } else {
            let Cell = tableView.dequeueReusableCell(withIdentifier: "ProviderServiceDetailsCell") as! ProviderServiceDetailsCell
            Cell.initializeCellDetails(cellObject: providerOnGoingList![indexPath.row])
            return Cell
        }
    }
    
    func tableView( _ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        print("You selected cell #\(indexPath.row)!")
        if isProgress == false {
            let vc = UIStoryboard.init(name: "Activity", bundle: Bundle.main).instantiateViewController(withIdentifier: "ProposalListVC") as? ProposalListVC
            vc!.serviceRequestID = String(serviceList![indexPath.row].requestid!)
            self.navigationController?.pushViewController(vc!, animated: false)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isProgress == false {
            return UITableView.automaticDimension
        }else{
            return 280
        }
    }
}

