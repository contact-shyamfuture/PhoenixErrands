//
//  InProgressTableCell.swift
//  Phoenix Errands
//
//  Created by Raghav Beriwala on 06/09/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import UIKit
import Localize_Swift
protocol cancelRequestDelegates {
    func cancelRequest(indexPathValue : Int)
    func detailsRequest(indexPathValue : Int)
}

class InProgressTableCell: UITableViewCell {

    @IBOutlet weak var detailsButton: UIButton!
    @IBOutlet weak var activeView: UIView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblServiceDescribtion: UILabel!
    @IBOutlet weak var lblServiceName: UILabel!
    @IBOutlet weak var cancelRequestBtnOutlet: UIButton!
    var cancelDelegate : cancelRequestDelegates?
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if Localize.currentLanguage() == "en" {
            detailsButton.setTitle("Details", for: .normal)
        }else{
            detailsButton.setTitle("détails", for: .normal)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func initializeCellDetails(cellDic : ServiceList)
    {
        if cellDic.is_active == "1" {
            activeView.isHidden = true
        }else{
            activeView.isHidden = false
        }
        lblServiceName.text = cellDic.serviceName
        lblServiceDescribtion.text = cellDic.serviceDescription
        //let dateTime = dateFormate(date: cellDic.created_at!)
//        lblDate.text = cellDic.created_at //dateTime
        
        let utcTime = localToUTC(dateStr: cellDic.created_at!)
        let localTime = utcToLocal(dateStr: utcTime!)

        if Localize.currentLanguage() == "en" {
            lblDate.text = "Posted On :\(localTime ?? "")"
        }else{
            lblDate.text = "Posté sur :\(localTime ?? "")"
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
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss a"
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
    
    @IBAction func cancelRequestBtn(_ sender: Any) {
        cancelDelegate?.cancelRequest(indexPathValue: (sender as AnyObject).tag)
    }
    
    @IBAction func detailsButtonAction(_ sender: Any) {
        cancelDelegate?.detailsRequest(indexPathValue: (sender as AnyObject).tag)
    }
}
