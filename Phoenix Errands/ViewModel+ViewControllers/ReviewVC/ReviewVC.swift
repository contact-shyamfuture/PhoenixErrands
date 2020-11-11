//
//  ReviewVC.swift
//  Phoenix Errands
//
//  Created by Raghav Beriwala on 03/10/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import UIKit
import Localize_Swift

class ReviewVC: BaseViewController, UITextViewDelegate
{
    @IBOutlet weak var btnReviewFive: UIButton!
    @IBOutlet weak var btnReviewFour: UIButton!
    @IBOutlet weak var btnReviewThree: UIButton!
    @IBOutlet weak var btnReviewTwo: UIButton!
    @IBOutlet weak var btnReviewOne: UIButton!
    @IBOutlet weak var txtReview: UITextView!
    @IBOutlet weak var lblWriteReview : UILabel!
    @IBOutlet weak var btnSubmitOutlet: UIButton!
    var placeholderLabel : UILabel!
    var ratingStarCount : Int?
    var orderId: Int?
    var providerId: Int?
    
    lazy var viewModel: ReviewVM = {
        return ReviewVM()
    }()
    var biddetails = BidModel()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        setText()
        self.headerView.lblHeaderTitle.text = Localize.currentLanguage() == "en" ? "Review" : "La revue"
        self.headerView.imgProfileIcon.isHidden = false
        self.headerView.menuButtonOutlet.isHidden = false
        self.headerView.imgViewMenu.isHidden = false
        self.headerView.menuButtonOutlet.tag = 1
        self.headerView.imgViewMenu.image = UIImage(named:"whiteback")
        self.headerView.notificationValueView.isHidden = true
        self.headerView.imgProfileIcon.isHidden = true
        self.tabBarView.isHidden = true
        
        txtReview.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.text = Localize.currentLanguage() == "en" ? "Please enter some message..." : "Veuillez saisir un message ..."
        placeholderLabel.font = UIFont.italicSystemFont(ofSize: (txtReview.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        txtReview.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (txtReview.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !txtReview.text.isEmpty
        initializeViewModel()
        self.completedService()
        //txtReview.layer.borderColor = (UIColor.red as! CGColor)
    }
    
    func setText(){
        lblWriteReview.text = Localize.currentLanguage() == "en" ? "Write a review" : "Écrire une critique"
        let btnTitle = Localize.currentLanguage() == "en" ? "Submit" : "Soumettre"
        btnSubmitOutlet.setTitle(btnTitle, for: .normal)
    }
    
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        txtReview.layer.borderColor =  (UIColor.red as! CGColor)
//    }
//    
//    func textViewDidEndEditing(_ textView: UITextView) {
//        txtReview.layer.borderColor = (UIColor.clear as! CGColor)
//    }
    
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
                
                if  (self?.viewModel.bidService.status) == 201 {
                    self!.biddetails = (self?.viewModel.bidService)!
                    let localizeString = Localize.currentLanguage() == "en" ? "Review completed successfully" : "Examen terminé avec succès"
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message: localizeString, okButtonText: okText, completion:
                        {
                            self?.navigationController?.popViewController(animated: true)
                    })
                }else{
                    let localizeString = Localize.currentLanguage() == "en" ? "Review submitted faild" : "Examen soumis échoué"
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message: localizeString, okButtonText: okText, completion: nil)
                }
            }
        }
        
        viewModel.refreshViewCompletedClosure = {[weak self]() in
            DispatchQueue.main.async {
                
                if  (self?.viewModel.orderCompleted.status) == 200 {
                    
                }else{
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message: (self?.viewModel.orderCompleted.message)!, okButtonText: okText, completion: nil)
                }
            }
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !txtReview.text.isEmpty
    }
    
    @IBAction func btnReviewFiveTapped(_ sender: Any){
        ratingStarCount = 5
        //if you set the image on same  UIButton
        (sender as AnyObject).setImage(UIImage(named: "starIcon"), for: .normal)
        
        //if you set the image on another  UIButton
        btnReviewOne.setImage(UIImage(named: "starIcon"), for: .normal)
        btnReviewThree.setImage(UIImage(named: "starIcon"), for: .normal)
        btnReviewFour.setImage(UIImage(named: "starIcon"), for: .normal)
        btnReviewTwo.setImage(UIImage(named: "starIcon"), for: .normal)
    }
    
    @IBAction func btnReviewFourTapped(_ sender: Any){
        ratingStarCount = 4
        
        (sender as AnyObject).setImage(UIImage(named: "starIcon"), for: .normal)
        
        btnReviewOne.setImage(UIImage(named: "starIcon"), for: .normal)
        btnReviewThree.setImage(UIImage(named: "starIcon"), for: .normal)
        btnReviewTwo.setImage(UIImage(named: "starIcon"), for: .normal)
        btnReviewFive.setImage(UIImage(named: "starEmptyIcon"), for: .normal)
    }
    
    @IBAction func btnReviewThreewTapped(_ sender: Any){
        ratingStarCount = 3
        //if you set the image on same  UIButton
        (sender as AnyObject).setImage(UIImage(named: "starIcon"), for: .normal)
        //if you set the image on another  UIButton
        btnReviewOne.setImage(UIImage(named: "starIcon"), for: .normal)
        btnReviewTwo.setImage(UIImage(named: "starIcon"), for: .normal)
        btnReviewFive.setImage(UIImage(named: "starEmptyIcon"), for: .normal)
        btnReviewFour.setImage(UIImage(named: "starEmptyIcon"), for: .normal)
    }
    
    @IBAction func btnReviewTwoTapped(_ sender: Any){
        ratingStarCount = 2
        //if you set the image on same  UIButton
        (sender as AnyObject).setImage(UIImage(named: "starIcon"), for: .normal)
        //if you set the image on another  UIButton
        btnReviewOne.setImage(UIImage(named: "starIcon"), for: .normal)
        btnReviewFive.setImage(UIImage(named: "starEmptyIcon"), for: .normal)
        btnReviewThree.setImage(UIImage(named: "starEmptyIcon"), for: .normal)
        btnReviewFour.setImage(UIImage(named: "starEmptyIcon"), for: .normal)
    }
    
    @IBAction func btnReviewOneTapped(_ sender: Any){
        ratingStarCount = 1
        //if you set the image on same  UIButton
        (sender as AnyObject).setImage(UIImage(named: "starIcon"), for: .normal)
        //if you set the image on another  UIButton
        //btnReviewOne.setImage(UIImage(named: "star-fill-128"), for: .normal)
        btnReviewFive.setImage(UIImage(named: "starEmptyIcon"), for: .normal)
        btnReviewThree.setImage(UIImage(named: "starEmptyIcon"), for: .normal)
        btnReviewFour.setImage(UIImage(named: "starEmptyIcon"), for: .normal)
        btnReviewTwo.setImage(UIImage(named: "starEmptyIcon"), for: .normal)
    }
    
    @IBAction func btnSubmitTapped(_ sender: Any){
        print("ratingStarCount==>\(ratingStarCount)")
        let reviewParams = ReviewParam()
        if orderId != nil{
            reviewParams.order_id = orderId
            reviewParams.review = txtReview.text
            reviewParams.rating = ratingStarCount
            viewModel.getReviewDetailsToAPIService(user: reviewParams)
        }
    }
    
    func completedService(){
        let param = CompletedOrderParam()
        param.contact_id = orderId
        param.provider_id = providerId
        viewModel.completedOrderToAPIService(user: param)
    }
}
