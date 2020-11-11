//
//  RequestVC.swift
//  Phoenix Errands
//
//  Created by Raghav Beriwala on 09/08/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class RequestVC: BaseViewController
{
    @IBOutlet weak var imgThumb: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: GMSMapView!
    private let locationManager = CLLocationManager()
    var detailsArr = [String]()
    var serviceArr = [String]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "RequestCell", bundle: Bundle.main), forCellReuseIdentifier: "RequestCell")
        setupLocationManager()
        
        detailsArr = ["2 hours","Less than 50 m2","No, I have everything i nneed", "Once a week"]
        serviceArr = ["Duration","Surface to clean","Equipment to provider","Household frequency desired"]
        imgThumb.layer.cornerRadius = imgThumb.frame.size.width/2
        imgThumb.clipsToBounds = true
        imgThumb.layer.borderColor = UIColor(red:17/255, green:136/255, blue:255/255, alpha: 1).cgColor
        imgThumb.layer.borderWidth = 1
        headerSetup()
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
        
        headerView.lblHeaderTitle.text = "Request"
        headerView.imgProfileIcon.isHidden = false
        headerView.menuButtonOutlet.isHidden = false
        headerView.imgViewMenu.isHidden = false
        headerView.menuButtonOutlet.tag = 1
        headerView.imgViewMenu.image = UIImage(named:"whiteback")
        headerView.notificationValueView.isHidden = true
        headerView.imgProfileIcon.isHidden = true
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
    
}
extension RequestVC : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return serviceArr.count
    }
    //"leftmenu-icon-messages.png"
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let Cell = tableView.dequeueReusableCell(withIdentifier: "RequestCell") as! RequestCell
        Cell.lblService.text = serviceArr[indexPath.row]
        Cell.lblDetails.text = detailsArr[indexPath.row]
        
        return Cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 92
    }
}
extension RequestVC: CLLocationManagerDelegate, GMSMapViewDelegate {
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
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
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
