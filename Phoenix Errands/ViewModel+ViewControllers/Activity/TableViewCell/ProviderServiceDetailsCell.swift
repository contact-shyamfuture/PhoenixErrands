//
//  ProviderServiceDetailsCell.swift
//  Phoenix Errands
//
//  Created by Shyam Future Tech on 19/10/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import UIKit
import Localize_Swift
class ProviderServiceDetailsCell: UITableViewCell {

    @IBOutlet weak var lblServiceName: UILabel!
    @IBOutlet weak var userImag: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var userStatus: UILabel!
    @IBOutlet weak var serviceDate: UILabel!
    @IBOutlet weak var paymentStatus: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initializeCellDetails(cellObject : ProviderOngoingList){
        
        if let serviceName = cellObject.serviceserviceName {
            
            if Localize.currentLanguage() == "en" {
                lblServiceName.text = "Service Name : " + serviceName
            }else{
                lblServiceName.text = "Nom du service : " + serviceName
            }
        }else{
            if Localize.currentLanguage() == "en" {
                lblServiceName.text = "Service Name : "
            }else{
                lblServiceName.text = "Nom du service : "
            }
        }
        
        if let userName = cellObject.useruserFirstName {
            if Localize.currentLanguage() == "en" {
                self.userName.text = "User Name : "  + userName + " " + cellObject.provideruserLastName!
            }else{
                self.userName.text = "Nom d'utilisateur : "  + userName + " " + cellObject.provideruserLastName!
            }
        }else{
            if Localize.currentLanguage() == "en" {
                self.userName.text = "User Name : "
            }else{
                self.userName.text = "Nom d'utilisateur : "
            }
        }
        
        if let price = cellObject.cost {
            guard let Type = cellObject.type else {return}
            if Localize.currentLanguage() == "en" {
                lblPrice.text = "Price : \(priceType(type: Type))" + price
            }else{
                lblPrice.text = "Prix : \(priceType(type: Type))" + price
            }
        }else{
            if Localize.currentLanguage() == "en" {
                lblPrice.text = "Price : "
            }else{
                lblPrice.text = "Prix : "
            }
        }
        
        if let userStatus = cellObject.useris_active {
            if userStatus == "0" {
                if Localize.currentLanguage() == "en" {
                    self.userStatus.text = "User Status : Active"
                }else{
                    self.userStatus.text = "Statut de l'utilisateur: actif"
                }
            }else{
                if Localize.currentLanguage() == "en" {
                    self.userStatus.text = "User Status : De Active"
                }else{
                    self.userStatus.text = "Statut de l'utilisateur: De actif"
                }
            }
        }else{
            if Localize.currentLanguage() == "en" {
                self.userStatus.text = "User Status : "
            }else{
                self.userStatus.text = "Statut de l'utilisateur:"
            }
        }
        
        if let date = cellObject.created_at {
           // let dateString = dateFormate(date: date)
            
            let utcTime = localToUTC(dateStr: date)
            let localTime = utcToLocal(dateStr: utcTime!)
            
            if Localize.currentLanguage() == "en" {
                serviceDate.text = "Date : \(localTime ?? "")"
            }else{
                serviceDate.text = "Date : \(localTime ?? "")"
            }
        }
        
        if let payment = cellObject.payment_status {
            if payment == 1 {
                if Localize.currentLanguage() == "en" {
                   paymentStatus.text = "Payment Status : Done"
                }else{
                    paymentStatus.text = "Statut de paiement : Terminé"
                }
                
            }else{
                if Localize.currentLanguage() == "en" {
                   paymentStatus.text = "Payment Status : Pending"
                }else{
                    paymentStatus.text = "Statut de paiement : En attente"
                }
                
            }
        }else{
            if Localize.currentLanguage() == "en" {
               paymentStatus.text = "Payment Status :"
            }else{
                paymentStatus.text = "Statut de paiement :"
            }
        }
        
        if cellObject.userimage != nil {
            let urlMain = APIConstants.baseImageURL + cellObject.userimage!
            userImag.sd_setImage(with: URL(string: urlMain))
        }else{
            userImag.image = UIImage(named: "download")
        }
        
        userImag.layer.cornerRadius = userImag.frame.size.width/2
        userImag.clipsToBounds = true
        userImag.layer.borderColor = UIColor(red:17/255, green:136/255, blue:255/255, alpha: 1).cgColor
        userImag.layer.borderWidth = 0
    }
    
    func priceType(type : String) -> String{
        if type == "1"{
            return "$"
        }else if type == "2"{
            return "€"
        }else{
            return "£"
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
