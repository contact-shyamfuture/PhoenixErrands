//
//  NewRequestDetailsVC.swift
//  Phoenix Errands
//
//  Created by Raghav Beriwala on 09/08/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import Localize_Swift
import MapKit

class NewRequestDetailsVC: BaseViewController ,  MKMapViewDelegate
{
    @IBOutlet weak var lblProviderName: UILabel!
    @IBOutlet weak var lblProviderServiceName: UILabel!
    @IBOutlet weak var lblHint : UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    
    
    @IBOutlet weak var mapViewDetails: MKMapView!
    @IBOutlet weak var imgthumb: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: GMSMapView!
    private let locationManager = CLLocationManager()
    var detailsArr = [String]()
    var serviceArr = [String]()
    var serviceID : String = ""
    var providerID : String = ""
    var addressString : String = ""
    
    lazy var viewModel: ProviderDetailsVM = {
        return ProviderDetailsVM()
    }()
    
    var providerDetails = ProviderDetailsModel()
    var questionsetListArray : [ProviderQuestionSetModel]?
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "RequestCell", bundle: Bundle.main), forCellReuseIdentifier: "RequestCell")
        setupLocationManager()
        detailsArr = ["Haircut","As soon as possible","Little tax", "No"]
        serviceArr = ["Desired type of hairstyle","Desired date of service","Availability","Is it for a company"]
        imgthumb.layer.cornerRadius = imgthumb.frame.size.width/2
        imgthumb.clipsToBounds = true
        imgthumb.layer.borderColor = UIColor(red:17/255, green:136/255, blue:255/255, alpha: 1).cgColor
        imgthumb.layer.borderWidth = 1
        headerSetup()
        self.initializeViewModel()
        self.getProviderDetails()
        
        if Localize.currentLanguage() == "en"{
             headerView.lblHeaderTitle.text = "provider details"
            lblHint.text = "1 applications still possible. 4 Phoenix Errands are viewing this request. Got for it"
        }else{
             headerView.lblHeaderTitle.text = "détails du fournisseur"
            lblHint.text = "1 applications encore possibles. 4 courses de Phoenix consultent cette demande. Got for it"
        }
    }
    
    func headerSetup()
    {
        //UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear//Constants.App.statusBarColor
        
        if #available(iOS 13.0, *) {
            let statusBar = UIView(frame: UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
             statusBar.backgroundColor = UIColor.clear
             UIApplication.shared.keyWindow?.addSubview(statusBar)
        } else {
             UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
        }
        headerView.imgProfileIcon.isHidden = false
        headerView.menuButtonOutlet.isHidden = false
        headerView.imgViewMenu.isHidden = false
        headerView.menuButtonOutlet.tag = 1
        headerView.imgViewMenu.image = UIImage(named:"whiteback")
        headerView.notificationValueView.isHidden = true
        headerView.imgProfileIcon.isHidden = true
        self.tabBarView.imgArray = ["NewHome","ServiceNewDark","ActivityNewDark","ApplySelected","ProfileNewDark"]
        self.tabBarView.tabCollection.reloadData()
    }
    
    func setupLocationManager()
    {
        locationManager.delegate = self
        //locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.distanceFilter = 50
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    @IBAction func detailsBtnTapped(_ sender: Any)
    {
//        let vc = UIStoryboard.init(name: "Request", bundle: Bundle.main).instantiateViewController(withIdentifier: "RequestDetailsVC") as? RequestDetailsVC
//        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    @IBAction func btnApplySerivce(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Dashboard", bundle: Bundle.main).instantiateViewController(withIdentifier: "AskForServiceOrProvder") as? AskForServiceOrProvder
        vc!.serviceID = serviceID
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func getProviderDetails(){
        
        viewModel.getProviderDetailsToAPIService(serviceID: serviceID, providerID: providerID)
    }
    
    func initializeViewModel() {
        
        viewModel.showAlertClosure = {[weak self]() in
            DispatchQueue.main.async {
                if let message = self?.viewModel.alertMessage {
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message: message, okButtonText: okText, completion: {
                    
                        self!.navigationController?.popViewController(animated: true)
                    })
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
                
                if (self?.viewModel.providerDetails.status) == 200 {
                    
                    if self?.viewModel.providerDetails.contactImage != nil {
                        let urlMain = APIConstants.baseImageURL + (self?.viewModel.providerDetails.contactImage)!
                        self!.imgthumb.sd_setImage(with: URL(string: urlMain))
                    }else{
                        self!.imgthumb.image = UIImage(named: "download")
                    }
                    
                    self!.providerDetails = (self?.viewModel.providerDetails)!
                    self!.lblProviderName.text = self?.viewModel.providerDetails.contactName
                    self!.lblAddress.text = self?.viewModel.providerDetails.contactAddress
                    self!.questionsetListArray = self?.viewModel.providerDetails.questionsetListArray
                    
                    if (self?.viewModel.providerDetails.latlong) != nil{
                        self!.getAddressFromLatLon(lat3 : (self?.viewModel.providerDetails.latlong)!)
                    }
                    self?.tableView.reloadData()
                }else{
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message:"", okButtonText: okText, completion: {
                        self!.navigationController?.popViewController(animated: true)
                    })
                }
            }
        }
    }
    
    func getAddressFromLatLon(lat3 : String) {
            
            let latlog = lat3.components(separatedBy: ",")
            let lat1    = latlog[0]
            let long1 = latlog[1]
            
            
            var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
            let lat: Double = Double("\(lat1)")!
            //21.228124
            let lon: Double = Double("\(long1)")!
            //72.833770
            let ceo: CLGeocoder = CLGeocoder()
            center.latitude = lat
            center.longitude = lon

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
                            self.addressString = self.addressString + pm.subLocality! + ", "
                        }
                        if pm.thoroughfare != nil {
                            self.addressString = self.addressString + pm.thoroughfare! + ", "
                        }
                        if pm.locality != nil {
                            self.addressString = self.addressString + pm.locality! + ", "
                        }
                        if pm.country != nil {
                            self.addressString = self.addressString + pm.country! + ", "
                        }
                        if pm.postalCode != nil {
                            self.addressString = self.addressString + pm.postalCode! + " "
                        }
                        print(self.addressString)
                        
                        self.loadServiceMapView(lat: lat3 , address : self.addressString)
                  }
            })
        }
        
        
        func loadServiceMapView(lat : String , address : String){
            
            mapViewDetails.delegate = self
            mapViewDetails.mapType = MKMapType.standard
            mapViewDetails.showsUserLocation = true
            
            print("latlong==>",lat)
            let latlog = lat.components(separatedBy: ",")
             let lat    = latlog[0]
             let long = latlog[1]
                    
            let CLLCoordType = CLLocationCoordinate2D(latitude: Double(lat)!, longitude: Double(long)!)
            
            let viewRegion = MKCoordinateRegion(center: CLLCoordType, latitudinalMeters: 50, longitudinalMeters: 50)
            mapViewDetails.setRegion(viewRegion, animated: false)            
            let london = MKPointAnnotation()
            london.coordinate =  CLLCoordType
            mapViewDetails.addAnnotation(london)
        }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

            let identifier = "Annotation"

            var annotationView: MKPinAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView

            if annotationView == nil {

                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true

                let label1 = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
                label1.text = self.addressString //annotation.title!//"Some text1 some text2 some text2 some text2 some text2 some text2 some text2"
                 label1.numberOfLines = 0
                  annotationView!.detailCalloutAccessoryView = label1;

                let width = NSLayoutConstraint(item: label1, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.lessThanOrEqual, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 200)
                label1.addConstraint(width)


                let height = NSLayoutConstraint(item: label1, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 90)
                label1.addConstraint(height)

            } else {
                annotationView!.annotation = annotation
            }
            return annotationView
        }
}

extension NewRequestDetailsVC : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if questionsetListArray != nil && (self.questionsetListArray?.count)! > 0 {
            return (self.questionsetListArray?.count)!
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Cell = tableView.dequeueReusableCell(withIdentifier: "RequestCell") as! RequestCell
        Cell.lblService.text = questionsetListArray![indexPath.row].question?.localized()
        Cell.lblDetails.text = questionsetListArray![indexPath.row].answer
        return Cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //return 92
        return UITableView.automaticDimension
    }
}

extension NewRequestDetailsVC: CLLocationManagerDelegate, GMSMapViewDelegate {
    // 2
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // 3
        guard status == .authorizedWhenInUse else {
            return
        }
        // 4
        locationManager.startUpdatingLocation()
        
        //5
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        //mapView.UiSettings.ZoomControlsEnabled = true
        
    }
    
    func showCurrentLocationOnMap(){
       // mapView.settings.myLocationButton = true
       // mapView.isMyLocationEnabled = true
        //                let camera = GMSCameraPosition.camera(withLatitude: 11.11, longitude: 12.12, zoom: 5) //Set default lat and long
        //                mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: self.mapView.frame.size.width, height: self.mapView.frame.size.height), camera: camera)
        //self.view.addSubview(mapView)
    }
    // 6
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        showCurrentLocationOnMap()
        guard let location = locations.first else {
            return
        }
        
        // 7
        //mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 5)
        
        // 8
        locationManager.stopUpdatingLocation()
    }
}

