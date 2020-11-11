//
//  ProposalListCell.swift
//  Phoenix Errands
//
//  Created by Shyam Future Tech on 10/09/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import UIKit
import Localize_Swift
protocol ProposalDetailsProtocol {
    func acceptProposal(indexPath : Int)
    func detailsProposal(indexPath : Int)
}

class ProposalListCell: UITableViewCell {

    @IBOutlet weak var imgProvider: UIImageView!
    @IBOutlet weak var lblNameProvider: UILabel!
    @IBOutlet weak var lblProposalPrice: UILabel!
    @IBOutlet weak var lblProposalStatus: UILabel!
    @IBOutlet weak var lblProposalDate: UILabel!
    
    @IBOutlet weak var btnAcceptOutlet: UIButton!
    @IBOutlet weak var btnDetailsOutlet: UIButton!
    var proposalDelegate : ProposalDetailsProtocol?
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if Localize.currentLanguage() == "en" {
            btnAcceptOutlet.setTitle("Accept", for: .normal)
            btnDetailsOutlet.setTitle("Details", for: .normal)
        }else{
            btnDetailsOutlet.setTitle("Détails", for: .normal)
            btnAcceptOutlet.setTitle("J'accepte", for: .normal)
        }
        imgProvider.layer.cornerRadius = imgProvider.frame.size.width/2
        imgProvider.clipsToBounds = true
        imgProvider.layer.borderColor = UIColor(red:17/255, green:136/255, blue:255/255, alpha: 1).cgColor
        imgProvider.layer.borderWidth = 1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func initializeCellDetails(cellDic : ProposalList){
        
        if let name = cellDic.providerName {
            if Localize.currentLanguage() == "en" {
                self.lblNameProvider.text =  "Provider Name : " + name
            }else{
                self.lblNameProvider.text =  "Nom du fournisseur : " + name
            }
            
        }else{
            if Localize.currentLanguage() == "en" {
                self.lblNameProvider.text =  "Provider Name : "
            }else{
                self.lblNameProvider.text =  "Nom du fournisseur : "
            }
        }
        
        if let price = cellDic.proposalPrice {
            if Localize.currentLanguage() == "en" {
                let type = priceType(type: cellDic.proposalType!)
                self.lblProposalPrice.text =  "Proposal price : \(type)" + price
            }else{
                let type = priceType(type: cellDic.proposalType!)
                self.lblProposalPrice.text =  "Prix ​​de la proposition : \(type)" + price
            }
        }else{
            if Localize.currentLanguage() == "en" {
                self.lblProposalPrice.text =  "Proposal price : $"
            }else{
                self.lblProposalPrice.text =  "Prix ​​de la proposition : $"
            }
        }
        
        if let proposalStatus = cellDic.proposalStatus {
            if Localize.currentLanguage() == "en" {
                self.lblProposalStatus.text =  "Provider status : " + proposalStatus
            }else{
                self.lblProposalStatus.text =  "Statut de fournisseur : " + proposalStatus
            }
        }else{
            if Localize.currentLanguage() == "en" {
                self.lblProposalStatus.text =  "Provider status : "
            }else{
                self.lblProposalStatus.text =  "Statut de fournisseur : "
            }
        }
        
        if let date = cellDic.proposalDateTime {
            let convertedDate = dateFormate(date: date)
            if Localize.currentLanguage() == "en" {
                self.lblProposalDate.text = "Proposal date : "  +  convertedDate
            }else{
                self.lblProposalDate.text = "Date de la proposition : "  +  convertedDate
            }
        }else{
            if Localize.currentLanguage() == "en" {
                self.lblProposalDate.text = "Proposal date : "
            }else{
                self.lblProposalDate.text = "Date de la proposition : "
            }
        }
        
        if cellDic.providerImage != nil {
            let urlMain = APIConstants.baseImageURL + cellDic.providerImage!
            self.imgProvider.sd_setImage(with: URL(string: urlMain))
        }else{
            self.imgProvider.image = UIImage(named: "download")
        }
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
    
    @IBAction func btnAcceptAction(_ sender: Any) {
        proposalDelegate?.acceptProposal(indexPath: (sender as AnyObject).tag)
    }
    
    @IBAction func btnDetailsAction(_ sender: Any) {
        proposalDelegate?.detailsProposal(indexPath: (sender as AnyObject).tag)
    }
    
    
    func dateFormate(date : String) -> String {
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd MMM,yyyy"
        
        let date: NSDate? = (dateFormatterGet.date(from: date)! as NSDate)
        print(dateFormatterPrint.string(from: date! as Date))
        
        return dateFormatterPrint.string(from: date! as Date)
    }
}
