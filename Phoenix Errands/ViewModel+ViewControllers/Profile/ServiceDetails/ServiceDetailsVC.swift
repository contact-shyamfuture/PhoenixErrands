//
//  ServiceDetailsVC.swift
//  Phoenix Errands
//
//  Created by Raghav Beriwala on 11/09/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import UIKit
import MapKit
import Localize_Swift
import CoreLocation

class CustomPointAnnotation: MKPointAnnotation {
    var pinCustomImageName:String!
}

class ServiceDetailsVC: BaseViewController , UIScrollViewDelegate , MKMapViewDelegate{

    @IBOutlet weak var lblServiceTime: UILabel!
    @IBOutlet weak var serviceMapView: MKMapView!
    @IBOutlet weak var fullImageView: UIImageView!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblServiceDes: UILabel!
    @IBOutlet weak var lblServiceName: UILabel!
    @IBOutlet weak var lblBidAmount: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
//    var addressString : String = ""
    @IBOutlet weak var tableView: UITableView!
    var detailsArr = [String]()
    var serviceArr = [String]()
    var requestid: Int?
    var bidAmount : String?
    var addressString : String = ""
    lazy var viewModel: ServiceDetailsVM = {
        return ServiceDetailsVM()
    }()
    var serviceDetailsModel = ServiceDetailsModel()
    var serviceDetails : Service?
    var questionset : [Questionset]?
    var currentIndex : Int?
    
    var pointAnnotation:CustomPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "RequestCell", bundle: Bundle.main), forCellReuseIdentifier: "RequestCell")

        let recognizer = UITapGestureRecognizer(target: self, action: #selector(ServiceDetailsVC.fullImageViewMethod))
        scrollView.addGestureRecognizer(recognizer)
        
        let recognizerImg = UITapGestureRecognizer(target: self, action: #selector(ServiceDetailsVC.HideImageViewMethod))
        fullImageView.isUserInteractionEnabled = true
        fullImageView.addGestureRecognizer(recognizerImg)
        
        if Localize.currentLanguage() == "en" {
            headerView.lblHeaderTitle.text = "Service Details"
            if bidAmount != nil {
               // self.lblBidAmount.text = ""//"Your bid amount : " + bidAmount!
            }else{
                //self.lblBidAmount.text = ""//"Your bid amount : Nill"
            }
        }else{
             headerView.lblHeaderTitle.text = "Détails du service"
            if bidAmount != nil {
                //self.lblBidAmount.text = ""//"Le montant de votre enchère : " + bidAmount!
            }else{
                //self.lblBidAmount.text = ""//"Le montant de votre enchère : Nill"
            }
        }
        fullImageView.isHidden = true
        scrollView.delegate = self
        headerSetup()
        initializeViewModel()
        getServiceDetails()
    }
    
    func headerSetup()
    {
        if #available(iOS 13.0, *) {
            let statusBar = UIView(frame: UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
             statusBar.backgroundColor = UIColor.clear
             UIApplication.shared.keyWindow?.addSubview(statusBar)
        } else {
             UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
        }
        
        //headerView.lblHeaderTitle.text = "Service Details"
        headerView.imgProfileIcon.isHidden = false
        headerView.menuButtonOutlet.isHidden = false
        headerView.imgViewMenu.isHidden = false
        headerView.menuButtonOutlet.tag = 1
        headerView.imgViewMenu.image = UIImage(named:"whiteback")
        headerView.notificationValueView.isHidden = true
        headerView.imgProfileIcon.isHidden = true
        self.tabBarView.imgArray = ["NewHome","ServiceNewDark","ActivitySelected","ApplyNewDark","ProfileNewDark"]
        self.tabBarView.tabCollection.reloadData()
    }
    
    func getServiceDetails(){
        viewModel.getServiceDetailsToAPIService(requestID: self.requestid!)
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
                
                if (self?.viewModel.serviceDetails.status) == 200 {
                    if (self?.viewModel.serviceDetails) != nil {
                        self!.serviceDetailsModel = (self?.viewModel.serviceDetails)!
                    }
                    
                    if (self?.viewModel.serviceDetails.service) != nil {
                        self!.serviceDetails = (self?.viewModel.serviceDetails.service)!
                    }
                    
                    if (self?.viewModel.serviceDetails.Questionset) != nil {
                        self!.questionset = (self?.viewModel.serviceDetails.Questionset)!
                    }
                    if (self?.viewModel.serviceDetails.latlong) != nil{
                        
                        self!.getAddressFromLatLon(lat3 : (self?.viewModel.serviceDetails.latlong)!)
                    }
                    
                    if (self?.viewModel.serviceDetails.created_at) != nil{
                        
                        let dateTime = self?.viewModel.serviceDetails.service!.created_at
                        if dateTime != nil {
                            let utcTime = self!.localToUTC(dateStr: dateTime!)
                            let localTime = self!.utcToLocal(dateStr: utcTime!)
                            self!.lblAddress.text = "Service Require Date : \(localTime ?? "")"
                        }else{
                            self!.lblAddress.text = "Service Require Date: "
                        }
                        
//                        let fullDateTimeArr = dateTime!.components(separatedBy: " ")
//                        if fullDateTimeArr[0] != nil && fullDateTimeArr[1] != nil {
//                            self!.lblAddress.text = "Date : \(localTime)"//"Date:  \(fullDateTimeArr[0]) at \(fullDateTimeArr[1])"
//                        }else{
//                            self!.lblAddress.text = "Date: "
//                        }
                    }
                    self?.tableView.reloadData()
                    self?.showInitialImage()
                    self?.displayData()
                }else{
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message: (self?.viewModel.serviceDetails.message)!, okButtonText: okText, completion: nil)
                }
            }
        }
    }
    
    func displayData()
    {
        self.lblServiceName.text = serviceDetails!.serviceName
        self.lblServiceDes.text = serviceDetails!.serviceDescription
        
    }
    
    @IBAction func btnBackTapped(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func showInitialImage() {
 
        if  let url = serviceDetailsModel.image {
            
            let fullNameArr = url.components(separatedBy: ",")
            
            for obj in fullNameArr {
                let urlMain = APIConstants.baseImageURL + obj
                let url1 = URL(string:urlMain)
                if let data = try? Data(contentsOf: url1!)
                {
                    let image: UIImage = UIImage(data: data)!
                    scrollView.auk.show(image: image, accessibilityLabel: "")
                }
            }
        }
    }
    
    @objc func fullImageViewMethod(){
        
        
        fullImageView.isHidden = false
        guard let pageIndex = scrollView.auk.currentPageIndex else { return }
        
        if  let url = serviceDetailsModel.image {
            
            let fullNameArr = url.components(separatedBy: ",")
            
            let urlMain = APIConstants.baseImageURL + fullNameArr[pageIndex]
            let url1 = URL(string:urlMain)
            if let data = try? Data(contentsOf: url1!)
            {
                fullImageView.image = UIImage(data: data)!
            }
            
        }
    }
    @objc func HideImageViewMethod(){
        fullImageView.isHidden = true
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
        
        serviceMapView.delegate = self
        serviceMapView.mapType = MKMapType.standard
        serviceMapView.showsUserLocation = true
        
        print("latlong==>",lat)
        let latlog = lat.components(separatedBy: ",")
         let lat    = latlog[0]
         let long = latlog[1]
                
        let CLLCoordType = CLLocationCoordinate2D(latitude: Double(lat)!, longitude: Double(long)!)
        
        let viewRegion = MKCoordinateRegion(center: CLLCoordType, latitudinalMeters: 50, longitudinalMeters: 50)
        serviceMapView.setRegion(viewRegion, animated: false)
        
        
//        pointAnnotation = CustomPointAnnotation()
//        pointAnnotation.pinCustomImageName = "locationIcon"
//        pointAnnotation.coordinate = CLLCoordType
//        pointAnnotation.title = "POKéSTOP"
//        pointAnnotation.subtitle = "Pick up some Poké Balls"
//
//        pinAnnotationView = MKPinAnnotationView(annotation: pointAnnotation, reuseIdentifier: "Annotation")
//        serviceMapView.addAnnotation(pinAnnotationView.annotation!)
        
        let london = MKPointAnnotation()
        //london.title = address//addressString
        london.coordinate =  CLLCoordType // CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275)
        serviceMapView.addAnnotation(london)
    }
    
//   func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        let reuseIdentifier = "pin"
//        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
//
//        if annotationView == nil {
//            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
//            annotationView?.canShowCallout = true
//        } else {
//            annotationView?.annotation = annotation
//        }
//       // let customPointAnnotation = annotation as! CustomPointAnnotation
//        annotationView?.image = UIImage(named: "locationIcon")
//
//        return annotationView
//    }
    
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        guard annotation is MKPointAnnotation else { return nil }
//
//        let identifier = "Annotation"
//        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
//
//        if annotationView == nil {
//            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//            annotationView!.canShowCallout = true
//        } else {
//            annotationView!.annotation = annotation
//        }
//
//        return annotationView
//    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        let identifier = "Annotation"

//        if annotation.isKind(of: MKUserLocation.self) {
//            return nil
//        }

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
}


extension ServiceDetailsVC : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if questionset != nil  && (self.questionset?.count)! > 0{
            return (self.questionset?.count)!
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let Cell = tableView.dequeueReusableCell(withIdentifier: "RequestCell") as! RequestCell
        Cell.lblService.text = questionset![indexPath.row].question
        let answer = Int(questionset![indexPath.row].answer ?? "")
        let answeList = questionset![indexPath.row].answer_Array
        if answer != nil && answeList!.count >= answer! {
            Cell.lblDetails.text =  answeList![answer!]
        }else{
            Cell.lblDetails.text = questionset![indexPath.row].answer!
        }
        return Cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
