//
//  FAQVC.swift
//  Phoenix Errands
//
//  Created by Shyam Future Tech on 03/05/20.
//  Copyright © 2020 Shyam Future Tech. All rights reserved.
//

import UIKit
import Localize_Swift
class FAQVC: UIViewController {

    @IBOutlet weak var faqTableView: UITableView!
    @IBOutlet weak var headerLbl: UILabel!
    var faqList : [FaqList]?
    lazy var viewModel: IntroVM = {
        return IntroVM()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.faqTableView.delegate = self
        self.faqTableView.dataSource = self
        //self.faqTableView.register(UINib(nibName: "FaqCellTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "FaqCellTableViewCell")
        
        if Localize.currentLanguage() == "en" {
            self.headerLbl.text = "FAQ"
            
        }else{
            self.headerLbl.text = "FAQ"
        }
        initializeViewModel()
        viewModel.getFAQDetailsToAPIService()
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
                
                if (self?.viewModel.faqModelDetails.status) == 200 {
                    self?.faqList = self?.viewModel.faqModelDetails.faqList
                    self!.faqTableView.reloadData()
                }else{
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message: "", okButtonText: okText, completion: {
                        self!.navigationController?.popViewController(animated: true)
                    })
                }
            }
        }
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension FAQVC : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if faqList != nil && faqList!.count > 0 {
            return faqList!.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let Cell = tableView.dequeueReusableCell(withIdentifier: "FaqCellTableViewCell") as! FaqCellTableViewCell
        Cell.lblQuestion.text = faqList![indexPath.row].question
        Cell.lblAnswer.text = faqList![indexPath.row].answer
        return Cell
    }
    
    func tableView( _ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected cell #\(indexPath.row)!")
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if faqList![indexPath.row].question!.count > 40 {
            return UITableView.automaticDimension
        } else if faqList![indexPath.row].answer!.count > 40{
            return UITableView.automaticDimension
        }else{
            return 80//UITableView.automaticDimension
        }
    }
}
