//
//  ContactPersonProfileVC.swift
//  Phoenix Errands
//
//  Created by Shyam Future Tech on 13/08/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import UIKit
import Localize_Swift

class ContactPersonProfileVC: BaseViewController
{
    @IBOutlet weak var reviewTableview: UITableView!
    @IBOutlet weak var reviewMainView: RoundUIView!
    @IBOutlet weak var reviewBGView: UIView!
    @IBOutlet weak var lblTotalCount: UILabel!
    
    @IBOutlet var startImgView: [UIImageView]!
    @IBOutlet weak var lblProfileType: UILabel!
    @IBOutlet weak var imgViewProfile: UIImageView!
    @IBOutlet weak var lblProfileName: UILabel!
    @IBOutlet weak var lblWhoAMI: UILabel!
    @IBOutlet weak var lblProfileDetails: UILabel!
    @IBOutlet weak var lblProfileDescription: UILabel!
    lazy var viewModel: ContactVM = {
        return ContactVM()
    }()
    
    lazy var viewProviderModel: ProviderDetailsVM = {
        return ProviderDetailsVM()
    }()
    
    var providerDetails = ProviderDetailsModel()
    var questionsetListArray : [ProviderQuestionSetModel]?
    
    var reviewsDetails = ReviewListModel()
    var contactDetails = ContactDetailsModel()
    var reviewList : [ReviewList]?
    
    var contactID : Int?
    var serviceID : Int?
    @IBOutlet weak var imgThumb: UIImageView!
    var rating : Int? {
        didSet{
            let tmpRating : Int = self.rating!
            var pos = 0
            
            for obj in startImgView {
                
                if (pos >= tmpRating){
                    obj.image = UIImage(named: "starEmptyIcon")
                }
                else{
                    obj.image = UIImage(named: "star-fill-128")
                }
                pos += 1
            }
        }
    }
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        headerSetup()
        imgThumb.layer.cornerRadius = imgThumb.frame.size.width/2
        imgThumb.clipsToBounds = true
        imgThumb.layer.borderColor = UIColor(red:17/255, green:136/255, blue:255/255, alpha: 1).cgColor
        imgThumb.layer.borderWidth = 1
        imgThumb.contentMode = .scaleAspectFill
        self.initializeViewModel()
        self.getContactDetails()
        self.reviewBGView.isHidden = true
        self.reviewMainView.isHidden = true
        self.reviewTableview.delegate = self
        self.reviewTableview.dataSource = self
        initializeProviderViewModel()
        getProviderDetails()
        
    }
    
    func getProviderDetails(){
        if serviceID != nil {
            viewProviderModel.getProviderDetailsToAPIService(serviceID: "\(serviceID!)", providerID: "\(contactID!))")
        }
        
    }
    @IBAction func btnAskforServicetapped(_ sender: Any){
        let vc = UIStoryboard.init(name: "Contacts", bundle: Bundle.main).instantiateViewController(withIdentifier: "AskForServiceVC") as? AskForServiceVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func getContactDetails(){
    let obj = ContactParams()
        obj.contactID = contactID
        viewModel.getContactDetailsToAPIService(user: obj)
    }
    
    func headerSetup(){
//        UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
        
        if #available(iOS 13.0, *) {
            let statusBar = UIView(frame: UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
             statusBar.backgroundColor = UIColor.clear
             UIApplication.shared.keyWindow?.addSubview(statusBar)
        } else {
             UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
        }
        if Localize.currentLanguage() == "en" {
            headerView.lblHeaderTitle.text = "contact details"
        }else{
            headerView.lblHeaderTitle.text = "détails du contact"
        }
        headerView.imgProfileIcon.isHidden = false
        headerView.menuButtonOutlet.isHidden = false
        headerView.imgViewMenu.isHidden = false
        headerView.menuButtonOutlet.tag = 1
        headerView.imgViewMenu.image = UIImage(named:"whiteback")
        headerView.notificationValueView.isHidden = true
        headerView.imgProfileIcon.isHidden = true
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
        
        viewModel.refreshViewContactClosure = {[weak self]() in
            DispatchQueue.main.async {
                
                if (self?.viewModel.contactDetailsObj.status) == 201 {
                    self!.contactDetails = (self?.viewModel.contactDetailsObj)!
                    self!.lblProfileName.text = self!.contactDetails.contactName
                    
                    
                    if self!.contactDetails.contactImage != nil {
                        let urlMain = APIConstants.baseImageURL + self!.contactDetails.contactImage!
                        self!.imgThumb.sd_setImage(with: URL(string: urlMain))
                    }else{
                        self!.imgThumb.image = UIImage(named: "download")
                    }
                    if let ratigValue = self!.contactDetails.contactRating {
                        let ratingFloat = Float(ratigValue)
                        self!.rating = Int(ratingFloat!)
                    }else{
                        self!.rating = 0
                    }
                    if let ratingCount = self!.contactDetails.contactTotalRating {
                        self!.lblTotalCount.text = "( " + String(ratingCount) + " )"
                    }else{
                        self!.lblTotalCount.text = "(0)"
                    }
                    
                }else{
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message: (self?.viewModel.contactDetails.message)!, okButtonText: okText, completion: nil)
                }
            }
        }
        
        viewModel.refreshViewReviewClosure = {[weak self]() in
            DispatchQueue.main.async {
                if (self?.viewModel.reviewsDetails.status) == 200 {
                    self!.reviewsDetails = (self?.viewModel.reviewsDetails)!
                    self!.reviewList = self?.viewModel.reviewsDetails.reviewList
                    //print(self!.reviewList?.count)
                    if self!.reviewList != nil {
                        if (self!.reviewList?.count)! > 0 {
                            self!.reviewBGView.isHidden = false
                            self!.reviewMainView.isHidden = false
                            self!.reviewTableview.reloadData()
                        }else{
                            self?.showAlertWithSingleButton(title: commonAlertTitle, message: (self?.viewModel.reviewsDetails.error)!, okButtonText: okText, completion: nil)
                        }
                    }else{
                        self?.showAlertWithSingleButton(title: commonAlertTitle, message: (self?.viewModel.reviewsDetails.error)!, okButtonText: okText, completion: nil)
                    }
                }else{
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message: (self?.viewModel.reviewsDetails.error)!, okButtonText: okText, completion: nil)
                }
            }
        }
    }
    
    func initializeProviderViewModel() {
        
        viewProviderModel.showAlertClosure = {[weak self]() in
            DispatchQueue.main.async {
                if let message = self?.viewProviderModel.alertMessage {
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message: message, okButtonText: okText, completion: {
                    
                        self!.navigationController?.popViewController(animated: true)
                    })
                }
            }
        }
        
        viewProviderModel.updateLoadingStatus = {[weak self]() in
            DispatchQueue.main.async {
                
                let isLoading = self?.viewProviderModel.isLoading ?? false
                if isLoading {
                    self?.addLoaderView()
                } else {
                    self?.removeLoaderView()
                }
            }
        }
        
        viewProviderModel.refreshViewClosure = {[weak self]() in
            DispatchQueue.main.async {
                
                if (self?.viewProviderModel.providerDetails.status) == 200 {
                    
                    
                    self!.providerDetails = (self?.viewProviderModel.providerDetails)!
                    self!.questionsetListArray = self?.viewProviderModel.providerDetails.questionsetListArray
                    if self!.questionsetListArray != nil && self!.questionsetListArray!.count > 0 {
                        self!.lblProfileDetails.text = self!.questionsetListArray![0].question
                        self!.lblProfileDescription.text = self!.questionsetListArray![0].answer
                    }
                    //self?.tableView.reloadData()
                }else{
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message:"", okButtonText: okText, completion: {
                        self!.navigationController?.popViewController(animated: true)
                    })
                }
            }
        }
    }
    
    @IBAction func btnCall(_ sender: Any) {
        
        if let number = contactDetails.contactNumber {
            dialNumber(number: String(number))
        }
    }
    
    func dialNumber(number : String) {
     if let url = URL(string: "tel://\(number)"),
       UIApplication.shared.canOpenURL(url) {
          if #available(iOS 10, *) {
            UIApplication.shared.open(url, options: [:], completionHandler:nil)
           } else {
               UIApplication.shared.openURL(url)
           }
       } else {
                
       }
    }
    
    @IBAction func btnAllReviewsAction(_ sender: Any) {
        let param = ReviewsParams()
        param.vendor_id = String(contactDetails.contactID!)
        viewModel.getReviewListToAPIService(user: param)
    }
    @IBAction func btnReviewListCancel(_ sender: Any) {
        self.reviewBGView.isHidden = true
        self.reviewMainView.isHidden = true
    }
}

extension ContactPersonProfileVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if reviewList != nil && (self.reviewList?.count)! > 0 {
            return (reviewList?.count)!
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let Cell = tableView.dequeueReusableCell(withIdentifier: "ReviewListCell") as! ReviewListCell
        Cell.lblName.text = self.reviewList![indexPath.row].name
        Cell.rating = self.reviewList![indexPath.row].rating
        Cell.lblReviewComments.text = self.reviewList![indexPath.row].review
        return Cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
