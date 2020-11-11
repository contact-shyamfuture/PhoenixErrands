//
//  ServiceSearchVC.swift
//  Phoenix Errands
//
//  Created by Shyam Future Tech on 09/08/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import UIKit
import MapKit
import NVActivityIndicatorView
import CoreLocation
import Localize_Swift

class ServiceSearchVC: BaseViewController,NVActivityIndicatorViewable {

    @IBOutlet weak var providerCheckView: UIView!
    let datePicker = UIDatePicker()
    @IBOutlet weak var txtDatePicker: UITextField!
    
    @IBOutlet weak var addressTableView: UITableView!
    @IBOutlet weak var addAddressBtnOutlet: UIButton!
    @IBOutlet weak var lblSelectdate : UILabel!
    @IBOutlet var mapView: MKMapView!
    
    let location:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522)
    
    var questionSetUserArr : [QuestionAnswerUserList]?
    var questionSetProviderArr : [QuestionAnswerProviderList]?
    var requestParam = RequestParam()
    
    var serviceID : String?
    var isprovider : Bool?
    var postalCode : String?
    var imageList = [String]()
    var closeVw = UIView()
    
    lazy var viewModel: SearchingServiceVM = {
        return SearchingServiceVM()
    }()
    
    
    lazy var viewModelAddress: AddressVM = {
        return AddressVM()
    }()
    var addressResponse = AddressListModel()
    var AddressListArray : [AddressList]?
    
    
    var responseDetails = CommonResponseModel()
    var addressID : String?
    var deviceLat : Double?
    var deviceLong : Double?
    var locationManager: CLLocationManager!
    var serviceImage = String()
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.headerSetup()
        self.setText()
        self.showDatePicker()
        let anotation = MKPointAnnotation()
        anotation.coordinate = location
        mapView.addAnnotation(anotation)
        self.initializeViewModel()
        
        self.view.addSubview(closeVw)
        closeVw.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        closeVw.backgroundColor = .white
        
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
        
    }
    
    func setText(){
        
        if Localize.currentLanguage() == "en"{
            datePicker.locale = Locale.init(identifier: "en")
        }else{
            datePicker.locale = Locale.init(identifier: "fr")
        }
        
        lblSelectdate.text = Localize.currentLanguage() == "en" ? "Select your delivery date" : "Sélectionnez votre date de livraison"
    }
    
    func getProviderServicePost(){
        
        if imageList.count > 0 {
            serviceImage = imageList.joined(separator: ",")
        }
            
        requestParam.serviceid = questionSetProviderArr![0].service_id
        requestParam.zipcode = postalCode
        requestParam.image = serviceImage
        
        for obj in questionSetProviderArr! {
            let reqObj = QuestionAnswerParam()
            reqObj.questionid = String(obj.id!)
            if obj.selectedCheckBox != "" {
                reqObj.answerList = obj.selectedCheckBox
                requestParam.QuestionAnswer.append(reqObj)
            }
            if obj.selectedIndex != nil {
                reqObj.answerList = String((obj.selectedIndex)!)
                requestParam.QuestionAnswer.append(reqObj)
            }
            if obj.type == "text" {
                reqObj.answerList = obj.array_answer
                requestParam.QuestionAnswer.append(reqObj)
            }
        }
        viewModel.sendServicePostToAPIService(user: requestParam)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if isprovider == true {
            self.providerCheckView.isHidden = false
            self.addressTableView.isHidden = true
            closeVw.isHidden = false
            let reqObj = QuestionAnswerParam()
            reqObj.questionid = ""
            reqObj.answerList = "No, I am a provider, I offer my service"
            requestParam.QuestionAnswer.append(reqObj)
           // self.getProviderServicePost()
        }else{
            self.providerCheckView.isHidden = true
            self.addressTableView.isHidden = true
            closeVw.isHidden = true
            self.addressTableView.register(UINib(nibName: "AddressListCell", bundle: Bundle.main), forCellReuseIdentifier: "AddressListCell")
            self.addressTableView.dataSource = self
            self.addressTableView.delegate = self
            self.getAddressList()
            let reqObj = QuestionAnswerParam()
            reqObj.questionid = ""
            reqObj.answerList = "Yes"
            self.initializeViewAddressModel()
        }
    }
    
    func getUserServicePost(){
        if imageList.count > 0 {
            serviceImage = imageList.joined(separator: ",")
        }
        requestParam.serviceid = questionSetUserArr![0].service_id
        requestParam.address = addressID
        requestParam.delivery_date = txtDatePicker.text
        requestParam.zipcode = postalCode
        requestParam.image = serviceImage
        let reqObj1 = QuestionAnswerParam()
        reqObj1.questionid = ""
        reqObj1.answerList = "Yes"
        requestParam.QuestionAnswer.append(reqObj1)
        for obj in questionSetUserArr! {
            let reqObj = QuestionAnswerParam()
            if obj.type == "checkbox" {
                if obj.selectedCheckBox != "" {
                    reqObj.questionid = String(obj.id!)
                    reqObj.answerList = obj.selectedCheckBox
                    requestParam.QuestionAnswer.append(reqObj)
                }
            }
            if obj.type == "radio" {
                if obj.selectedIndex != nil {
                    reqObj.questionid = String(obj.id!)
                    //let answerArray = obj.answerArrayList
                    reqObj.answerList = String((obj.selectedIndex)!)
                    requestParam.QuestionAnswer.append(reqObj)
                }
            }
            if obj.type == "text" {
                reqObj.questionid = String(obj.id!)
                reqObj.answerList = obj.array_answer
                requestParam.QuestionAnswer.append(reqObj)
            }
        }
        viewModel.sendServicePostToAPIService(user: requestParam)
    }
    
    func timerAction() {
        
        let vc = UIStoryboard.init(name: "Dashboard", bundle: Bundle.main).instantiateViewController(withIdentifier: "ThankYouVC") as? ThankYouVC
        vc!.isprovider = isprovider
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func getAddressList(){
        viewModelAddress.getAddressListToAPIService()
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
                print(self?.viewModel.CommonResponse.status as Any)
                if (self?.viewModel.CommonResponse.status) == 200 {
                    
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message: (self?.viewModel.CommonResponse.message)!, okButtonText: okText, completion: {
                     self!.timerAction()
                    })
                }else{
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message: (self?.viewModel.CommonResponse.erroString![0])!, okButtonText: okText, completion: nil)
                }
            }
        }
    }
    
    
    func initializeViewAddressModel() {
        
        viewModelAddress.showAlertClosure = {[weak self]() in
            DispatchQueue.main.async {
                if let message = self?.viewModel.alertMessage {
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message: message, okButtonText: okText, completion: nil)
                }
            }
        }
        
        viewModelAddress.updateLoadingStatus = {[weak self]() in
            DispatchQueue.main.async {
                
                let isLoading = self?.viewModel.isLoading ?? false
                if isLoading {
                    self?.addLoaderView()
                } else {
                    self?.removeLoaderView()
                }
            }
        }
        
        viewModelAddress.refreshViewClosure = {[weak self]() in
            DispatchQueue.main.async {
                
                if (self?.viewModelAddress.addressResponse.status) == 200 {
                    self!.addressTableView.isHidden = false
                    self!.AddressListArray = (self?.viewModelAddress.addressResponse.AddressListArray)!
                    if (self!.AddressListArray?.count)! < 1 {
                        let title = Localize.currentLanguage() == "en" ? "Add Address" : "Ajoutez l'adresse"
                        self!.addAddressBtnOutlet.setTitle(title, for: .normal)
                    }else{
                        let title = Localize.currentLanguage() == "en" ? "Submit" : "Soumettre"
                        self!.addAddressBtnOutlet.setTitle(title, for: .normal)
                    }
                    self!.addressTableView.reloadData()
                }else{
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message:"", okButtonText: okText, completion: nil)
                }
            }
        }
    }
    
    func headerSetup()
    {
//        UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
//
//
        if #available(iOS 13.0, *) {
            let statusBar = UIView(frame: UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
             statusBar.backgroundColor = UIColor.clear
             UIApplication.shared.keyWindow?.addSubview(statusBar)
        } else {
             UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
        }
        
        headerView.lblHeaderTitle.text = Localize.currentLanguage() == "en" ? "Select your address" : "Sélectionnez votre adresse"
        headerView.imgProfileIcon.isHidden = false
        headerView.menuButtonOutlet.isHidden = false
        headerView.imgViewMenu.isHidden = false
        headerView.menuButtonOutlet.tag = 1
        headerView.imgViewMenu.image = UIImage(named:"whiteback")
        headerView.notificationValueView.isHidden = true
        headerView.imgProfileIcon.isHidden = true
        tabBarView.isHidden = true
    }
    
    @IBAction func btnPostServiceAction(_ sender: Any) {
        if (self.AddressListArray?.count)! < 1 {
            let vc = UIStoryboard.init(name: "Profile", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddressAddVC") as? AddressAddVC
            self.navigationController?.pushViewController(vc!, animated: true)
        }else{
//            let reqObj = QuestionAnswerParam()
//            reqObj.questionid = ""
//            reqObj.answerList = "Yes"
//            requestParam.QuestionAnswer.append(reqObj)
            if addressID == nil {
                let msg = Localize.currentLanguage() == "en" ? "Please select address" : "Veuillez sélectionner une adresse"
                self.showAlertWithSingleButton(title: commonAlertTitle, message:msg, okButtonText: okText, completion: nil)
            }else if txtDatePicker.text == "" {
                let msg = Localize.currentLanguage() == "en" ? "Please select Date" : "Veuillez sélectionner la date"
                self.showAlertWithSingleButton(title: commonAlertTitle, message:msg, okButtonText: okText, completion: nil)
            }else{
                self.getUserServicePost()
            }
        }
    }
}

extension ServiceSearchVC : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if AddressListArray != nil && (self.AddressListArray?.count)! > 0 {
            return (self.AddressListArray?.count)!
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let Cell = tableView.dequeueReusableCell(withIdentifier: "AddressListCell") as! AddressListCell
        Cell.cellInitializeCellDetails(cellDic: AddressListArray![indexPath.row])
        if AddressListArray![indexPath.row].isSelected == true {
            Cell.imgRadioCheck.image = UIImage(named: "RadioRed")!
        }else{
            Cell.imgRadioCheck.image = UIImage(named: "Radio")!
        }
        return Cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        for obj in AddressListArray!{
            obj.isSelected = false
        }
        if AddressListArray![indexPath.row].isSelected == false {
            AddressListArray![indexPath.row].isSelected = true
            addressID = String(AddressListArray![indexPath.row].id!)
        }else{
            AddressListArray![indexPath.row].isSelected = false
        }
        self.addressTableView.reloadData()
    }
}

extension ServiceSearchVC {
    
    
    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .dateAndTime
        
        datePicker.minimumDate = Date()
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        //done button & cancel button
        let cancelButton = UIBarButtonItem(title: "Cancel".localized(), style: .plain, target: self, action: #selector(cancelDatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneBtnLocalize = Localize.currentLanguage() == "en" ? "Done" : "Terminé"
        let doneButton = UIBarButtonItem(title: doneBtnLocalize, style: .plain, target: self, action: #selector(donedatePicker));
        
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        
        // add toolbar to textField
        txtDatePicker.inputAccessoryView = toolbar
        // add datepicker to textField
        txtDatePicker.inputView = datePicker
    }
    
    @objc func donedatePicker(){
        //For date formate
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy hh:mm:ss"
        txtDatePicker.text = formatter.string(from: datePicker.date)
        //dismiss date picker dialog
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        //cancel button dismiss datepicker dialog
        self.view.endEditing(true)
    }
}

extension ServiceSearchVC : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        let location = locations.last! as CLLocation
        self.deviceLat = location.coordinate.latitude
        self.deviceLong = location.coordinate.longitude
        requestParam.latlong = String(self.deviceLat!) + "," + String(self.deviceLong!)
        locationManager.stopUpdatingLocation()
        if isprovider == true {
            self.getProviderServicePost()
        }
    }
}
