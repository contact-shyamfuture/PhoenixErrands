//
//  IntroVC.swift
//  Phoenix Errands
//
//  Created by Shyam Future Tech on 06/08/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import UIKit
import SDWebImage
import Auk
import moa
import Localize_Swift

class IntroVC: UIViewController,UIScrollViewDelegate {
    
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblRatingValue: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var lblIntroText: UILabel!
    @IBOutlet weak var btnSkip : UIButton!
    
    lazy var viewModel: IntroVM = {
        return IntroVM()
    }()
    var introDetails = IntroModel()
    var introArray : [IntroImageArray]?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()
        //UIApplication.shared.statusBarView?.backgroundColor = Constants.App.statusBarColor
        if #available(iOS 13.0, *) {
            let statusBar = UIView(frame: UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
             statusBar.backgroundColor = UIColor.init(red: 243/250, green: 243/250, blue: 243/250, alpha: 1)
             UIApplication.shared.keyWindow?.addSubview(statusBar)
        } else {
             UIApplication.shared.statusBarView?.backgroundColor = UIColor.init(red: 243/250, green: 243/250, blue: 243/250, alpha: 1)
        }
        setUI()
        self.initializeViewModel()
        self.getIntroDetails()
        
    }
    
    func setUI(){
        if Localize.currentLanguage() == "en"{
            btnSkip.setTitle("Skip", for: .normal)
        }else{
            btnSkip.setTitle("Sauter", for: .normal)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    @IBAction func buttonSkip(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HomeVC") as? HomeVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func getIntroDetails(){
        viewModel.getIntroDetailsToAPIService()
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
                
                if (self?.viewModel.introDetails.status) == 201 {
                    self!.introDetails = (self?.viewModel.introDetails)!
                    self!.introArray = (self?.viewModel.introDetails.IntroImageArr)!
                    if (self!.introArray?.count)! > 0 {
                        self!.initializeSlider()
                    }
                    
                }else{
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message: (self?.viewModel.introDetails.message)!, okButtonText: okText, completion: nil)
                }
            }
        }
    }
    
    
    func initializeSlider(){
        lblRatingValue.text = introDetails.averageReview! + "/5 - " + String(introDetails.totalReview!) + " reviews"
        lblIntroText.text = introDetails.introductionText
        scrollView.delegate = self
        scrollView.auk.settings.preloadRemoteImagesAround = 1
        Moa.logger = MoaConsoleLogger
        scrollView.isPagingEnabled = true
        scrollView.auk.settings.pageControl.visible = true
        scrollView.auk.settings.pageControl.backgroundColor = UIColor.lightGray
        //showInitialImage()
        
        
        for remoteImage in introArray! {
            if remoteImage.image != "" {
                let urlMain = APIConstants.baseImageURL + remoteImage.image!                
                let url = URL(string:urlMain)
                if let data = try? Data(contentsOf: url!)
                {
                    let image: UIImage = UIImage(data: data)!
                    scrollView.auk.show(image: image, accessibilityLabel: "Test")
                }
            }
        }
        scrollView.auk.startAutoScroll(delaySeconds: 3)
    }
    
    
    private func showInitialImage() {
        let url = introArray![0]
        let urlMain = APIConstants.baseImageURL + url.image!
        let url1 = URL(string:urlMain)
        if let data = try? Data(contentsOf: url1!)
        {
            let image: UIImage = UIImage(data: data)!
            scrollView.auk.show(image: image, accessibilityLabel: "Test")
        }
    }
    
    override func viewWillTransition(to size: CGSize,
                                     with coordinator: UIViewControllerTransitionCoordinator) {
        
        super.viewWillTransition(to: size, with: coordinator)
        guard let pageIndex = scrollView.auk.currentPageIndex else { return }
        let newScrollViewWidth = size.width
        
        coordinator.animate(alongsideTransition: { [weak self] _ in
            self?.scrollView.auk.scrollToPage(atIndex: pageIndex, pageWidth: newScrollViewWidth, animated: false)
            }, completion: nil)
    }
    
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation,
                             duration: TimeInterval) {
        
        super.willRotate(to: toInterfaceOrientation, duration: duration)
        var screenWidth = UIScreen.main.bounds.height
        if (UIApplication.shared.statusBarOrientation == UIInterfaceOrientation.portrait){
            screenWidth = UIScreen.main.bounds.width
        }
        guard let pageIndex = scrollView.auk.currentPageIndex else { return }
        scrollView.auk.scrollToPage(atIndex: pageIndex, pageWidth: screenWidth, animated: false)
    }
}
