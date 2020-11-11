//
//  AddressAddVC.swift
//  Phoenix Errands
//
//  Created by Shyam Future Tech on 24/09/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import UIKit
import CoreLocation
import Localize_Swift
class AddressAddVC: BaseViewController {

    @IBOutlet weak var btnSubmitOutlet: UIButton!
    @IBOutlet weak var useCurrentLocationBtnAction: UIButton!
    @IBOutlet weak var addAddressTableview: UITableView!
    var placeHolder = NSArray()
    var addressObj = AddressParamModel()
    lazy var viewModel: AddressVM = {
        return AddressVM()
    }()
    var deviceLat : Double?
    var deviceLong : Double?
    var locationManager: CLLocationManager!
    var addressPostResponse = AddressPostModel()
    var fullAddress : String = ""
    override func viewDidLoad(){
        super.viewDidLoad()
        self.headerSetup()
        self.addAddressTableview.register(UINib(nibName: "AddAddressCell", bundle: Bundle.main), forCellReuseIdentifier: "AddAddressCell")
        self.addAddressTableview.dataSource = self
        self.addAddressTableview.delegate = self
        placeHolder = ["Address Type","Full Address", "Phone Number"]
        self.initializeViewModel()
        self.addLoaderView()
        if (CLLocationManager.locationServicesEnabled()){
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
        if Localize.currentLanguage() == "en" {
            btnSubmitOutlet.setTitle("Save", for: .normal)
            useCurrentLocationBtnAction.setTitle("user current location", for: .normal)
            headerView.lblHeaderTitle.text = "My Address"
            placeHolder = ["Address Type","Full Address", "Phone Number"]
        }else{
            btnSubmitOutlet.setTitle("enregistrer", for: .normal)
            useCurrentLocationBtnAction.setTitle("emplacement actuel de l'utilisateur", for: .normal)
            headerView.lblHeaderTitle.text = "Mon adresse"
            placeHolder = ["Type d'adresse","Adresse complète", "Numéro de téléphone"]
        }
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
        
//        headerView.lblHeaderTitle.text = "My Address"
        headerView.imgProfileIcon.isHidden = false
        headerView.menuButtonOutlet.isHidden = false
        headerView.imgViewMenu.isHidden = false
        headerView.menuButtonOutlet.tag = 1
        headerView.imgViewMenu.image = UIImage(named:"whiteback")
        headerView.notificationValueView.isHidden = true
        headerView.imgProfileIcon.isHidden = true
        tabBarView.isHidden = true
    }
    
    @IBAction func btnUserCurrentLocation(_ sender: Any) {
        addressObj.fulladress = fullAddress
        self.addAddressTableview.reloadData()
    }
    
    @IBAction func btnAddressSubmitAction(_ sender: Any) {
        if UserDefaults.standard.string(forKey: PreferencesKeys.userFirstName) != nil {
            addressObj.name = UserDefaults.standard.string(forKey: PreferencesKeys.userFirstName)! + " " + UserDefaults.standard.string(forKey: PreferencesKeys.userLastName)!
        }
        viewModel.sendAddAddressToAPIService(user: addressObj)
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
                
                if (self?.viewModel.addressPostResponse.status) == 200 {
                    self!.addressPostResponse = (self?.viewModel.addressPostResponse)!
                    
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message:(self?.viewModel.addressPostResponse.message)!, okButtonText: okText, completion: {
                    
                    self?.navigationController?.popViewController(animated: true)
                    })
                   
                }else{
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message:"", okButtonText: okText, completion: nil)
                }
            }
        }
    }
}

extension AddressAddVC : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
       return placeHolder.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Cell = tableView.dequeueReusableCell(withIdentifier: "AddAddressCell") as! AddAddressCell
        Cell.txtField.placeholder = (placeHolder[indexPath.row] as! String)
        Cell.txtField.tag = indexPath.row
        Cell.txtField.delegate = self
        Cell.initializeCellDetails(cellString: placeHolder[indexPath.row] as! String, indexPath: indexPath.row, value : addressObj)
        return Cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
extension AddressAddVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let txtAfterUpdate = textField.text! as NSString
        let updateText = txtAfterUpdate.replacingCharacters(in: range, with: string) as NSString
        print("Updated TextField:: \(updateText)")
        switch textField.tag {
        case 0:
            addressObj.title = updateText as String
        case 1:
            addressObj.fulladress = updateText as String
        case 2:
            addressObj.phone = updateText as String
        default:
            break
        }
        return true
    }
}

extension AddressAddVC : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        let location = locations.last! as CLLocation
        self.deviceLat = location.coordinate.latitude
        self.deviceLong = location.coordinate.longitude
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = self.deviceLat!
        center.longitude = self.deviceLong!
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        self.addressObj.latlong = String(self.deviceLat!) + "," + String(self.deviceLong!)
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil){
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = placemarks! as [CLPlacemark]
                if pm.count > 0 {
                    let pm = placemarks![0]
                    var addressString : String = ""
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
                        self.addressObj.zipcode = pm.postalCode!
                    }
                    self.fullAddress = addressString
                }
                self.removeLoaderView()
        })
    }
}



