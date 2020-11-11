//
//  ApplyCell.swift
//  Phoenix Errands
//
//  Created by Raghav Beriwala on 09/08/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import UIKit
import CoreLocation

class ApplyCell: UITableViewCell
{
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var yellowBtntext: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblService: UILabel!
    @IBOutlet weak var imgProviderIcon: UIImageView!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func cellData(latLong : String){        
        method(arg: latLong, completion: { (success) -> Void in
            if success != "" { // this will be equal to whatever value is set in this method call
                lblAddress.text = success
            } else {
                print("false")
            }
        })
    }
    
    func method(arg: String, completion: (String) -> ()) {
        
        let latLongArr = arg.components(separatedBy: ",")
        let lat  = latLongArr[0]
        let long = latLongArr[1]
        var addressString : String = ""
        
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = Double(lat)!
        center.longitude = Double(long)!
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = placemarks! as [CLPlacemark]
                
                if pm.count > 0 {
                    let pm = placemarks![0]
                    
                    if pm.subLocality != nil {
                        addressString = addressString + pm.subLocality! + ", "
                    }
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + ", "
                    }
                    if pm.locality != nil {
                        addressString = addressString + pm.locality! + ", "
                    }
                    if pm.country != nil {
                        addressString = addressString + pm.country! + ", "
                    }
                    if pm.postalCode != nil {
                        addressString = addressString + pm.postalCode! + " "
                    }
                }
        })
        completion(addressString)
    }
}
