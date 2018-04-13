//
//  HotsoptsScreen4VC.swift
//  ServeyTrackerApp
//
//  Created by Apple on 23/03/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import MagicalRecord

class HotsoptsScreen4VC: UIViewController {
    
    @IBOutlet weak var messageTXT:UITextView!
    @IBOutlet weak var btnCheck: UIButton!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    var latitude: Double = 0
    var longitude: Double = 0
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var locationManager: CLLocationManager?
    var lastLocation : CLLocation!
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        defaultConfigure()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.backButton(image: "back")
        _ = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.loadMapView), userInfo: nil, repeats: false)
        lblAddress.text = ""
        self.navigationItem.title = "Capture Location"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func defaultConfigure() {
        messageTXT.layer.borderWidth = 1
        messageTXT.layer.borderColor = UIColor.darkGray.cgColor
        btnCheck.tag = 1
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(keyboardresign))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        messageTXT.inputAccessoryView = keyboardToolbar
        messageTXT.text = "Enter Message"
        messageTXT.textColor = UIColor.lightGray
        messageTXT.delegate = self
        
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        let subView = UIView(frame: CGRect(x: 0, y: 90, width: 350.0, height: 45.0))
        subView.backgroundColor = UIColor.red
        subView.addSubview((searchController?.searchBar)!)
        view.addSubview(subView)
        // Put the search bar in the navigation bar.
        searchController?.searchBar.sizeToFit()
        //navigationItem.titleView = searchController?.searchBar
        
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true
        
        // Prevent the navigation bar from being hidden when searching.
        searchController?.hidesNavigationBarDuringPresentation = false
    }
    
    @IBAction func btnCheckBoxAction(sender:UIButton) {
        if btnCheck.tag == 1 {
            btnCheck.tag = 2
            btnCheck.setImage(#imageLiteral(resourceName: "check"), for: .normal)
        }else{
            btnCheck.tag = 1
            btnCheck.setImage(nil, for: .normal)
        }
    }
    
    func validation() -> Bool {
        if (messageTXT.text?.isEmpty)! {
            self.showAlert(title: "", message: "Enter message.")
            return false
        }
        if btnCheck.tag != 2 {
            self.showAlert(title: "", message: "Please check incident reported checkbox.")
            return false
        }
        return true
    }
    
    @IBAction func btnSaveAction(sender:UIButton) {
        if validation() {
            let dictuser = self.getAllServeyTrackerUser()
            
            ServeyTrackerManager.share.paramsTnxService[DictionaryKey.address] = lblAddress.text
            ServeyTrackerManager.share.paramsTnxService[DictionaryKey.note] = messageTXT.text
            ServeyTrackerManager.share.paramsTnxService[DictionaryKey.user_id] = dictuser?[DictionaryKey.user_id]
            ServeyTrackerManager.share.paramsTnxService[DictionaryKey.creationDate] = self.getCurrentTime()
            //let uuid = UUID().uuidString
            let id = "\(Date.init().ticks)"
            ServeyTrackerManager.share.paramsTnxService[DictionaryKey.id] = id
            var lat:Double!
            if latitude != 0.0 {
                lat = latitude
            }else{
                lat = appDelegate.lastLocation.coordinate.latitude
            }
            var log:Double!
            if longitude != 0.0 {
                log = longitude
            }else{
                log = appDelegate.lastLocation.coordinate.longitude
            }
            ServeyTrackerManager.share.paramsTnxService[DictionaryKey.latitude] = lat
            ServeyTrackerManager.share.paramsTnxService[DictionaryKey.longitude] = log
//            self.view.showHUD()
//            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
//
//            })
            //dataSave()
            let vc = self.storyboard?.instantiateViewController(withIdentifier: SurveySummaryVC.stringRepresentation) as! SurveySummaryVC
            vc.latitude = latitude
            vc.longitude = longitude
            vc.message = messageTXT.text
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func dataSave()  {
        self.view.showHUD()
        MagicalRecord.save({ (context : NSManagedObjectContext!) in
            MOBTXNSERVEYS.entityFromDictionaryInContext(aDictionary: ServeyTrackerManager.share.paramsTnxService as NSDictionary, localContext: context)
        }, completion: { (status, error) in
            if status {
                self.view.hideHUD()
                print("Data Save......")
                let arrgetMp = MOBTXNSERVEYS.mr_findAll() as! [MOBTXNSERVEYS]
                print(arrgetMp.first?.id ?? "")
                self.naviagtetToHomeScreen()
            }else{
                self.view.hideHUD()
                print(error.debugDescription)
            }
        })
    }
    
    @IBAction func btnCancelAction(sender:UIButton) {
        let Alertvc = UIAlertController(title: "", message: "Are you sure?", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "YES", style: .default) { (action) in
            self.naviagtetToHomeScreen()
        }
        
        let action2 = UIAlertAction(title: "NO", style: .cancel, handler: nil)
        
        Alertvc.addAction(action1)
        Alertvc.addAction(action2)
        
        self.present(Alertvc, animated: true, completion: nil)
    }
    
    @objc func keyboardresign()  {
        messageTXT.resignFirstResponder()
    }
    
    @objc func loadMapView()
    {
        
        if appDelegate.lastLocation != nil {
            latitude = appDelegate.lastLocation.coordinate.latitude
            longitude = appDelegate.lastLocation.coordinate.longitude
            let camera = GMSCameraPosition.camera(withLatitude: latitude , longitude: longitude, zoom: 15)
            mapView.camera = camera
            GMSMapView.map(withFrame: CGRect.zero, camera: camera)
            mapView.delegate = self
            
            let latitudeStr = String(latitude)
            let longitudeStr = String(longitude)
            self.getAddressForLatLng(latitude: latitudeStr, longitude: longitudeStr)
        }
    }
}

extension HotsoptsScreen4VC:UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter Message"
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Enter Message" {
            textView.text = ""
            textView.textColor = UIColor.lightGray
        }
    }
}

extension HotsoptsScreen4VC:CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations.last
        UserDefaults.standard.set((userLocation!.coordinate.latitude), forKey: "LATVALUE")
        UserDefaults.standard.set((userLocation!.coordinate.longitude), forKey: "LONVALUE")
        lastLocation = locations.last! as CLLocation
    }
}

extension HotsoptsScreen4VC: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        // Do something with the selected place.
        print("Place name: \(place.name)")
        print("Place address: \(String(describing: place.formattedAddress))")
        print("Place attributions: \(String(describing: place.attributions))")
        lblAddress.text = place.formattedAddress ?? ""
        latitude = place.coordinate.latitude
        longitude = place.coordinate.longitude
        let camera = GMSCameraPosition.camera(withLatitude: latitude , longitude: longitude, zoom: 15)
        mapView.camera = camera
        GMSMapView.map(withFrame: CGRect.zero, camera: camera)
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

extension HotsoptsScreen4VC:GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        latitude = mapView.camera.target.latitude
        longitude = mapView.camera.target.longitude
        let latitudeStr = String(latitude)
        let longitudeStr = String(longitude)
        self.getAddressForLatLng(latitude: latitudeStr, longitude: longitudeStr)
    }
    
    
    func getAddressForLatLng(latitude: String, longitude: String) -> String {
        
        let url = NSURL(string: "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(latitude),\(longitude)&key=AIzaSyCSpJtQgzUN1MMbt_OXwVE9H37Cg7WyWXQ")
        let data = NSData(contentsOf: url! as URL)
        if data != nil {
            let json = try! JSONSerialization.jsonObject(with: data! as Data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
            if let result = json["results"] as? NSArray   {
                if result.count > 0 {
                    if let addresss:NSDictionary = result[0] as! NSDictionary {
                        if let address = addresss["address_components"] as? NSArray {
                            var newaddress = ""
                            var number = ""
                            var street = ""
                            var city = ""
                            var state = ""
                            var zip = ""
                            
                            if(address.count > 1) {
                                number =  (address.object(at: 0) as! NSDictionary)["short_name"] as! String
                            }
                            if(address.count > 2) {
                                street = (address.object(at: 1) as! NSDictionary)["short_name"] as! String
                            }
                            if(address.count > 3) {
                                city = (address.object(at: 2) as! NSDictionary)["short_name"] as! String
                            }
                            if(address.count > 4) {
                                state = (address.object(at: 4) as! NSDictionary)["short_name"] as! String
                            }
                            if(address.count > 6) {
                                zip =  (address.object(at: 6) as! NSDictionary)["short_name"] as! String
                            }
                            newaddress = "\(number) \(street), \(city), \(state) \(zip)"
                            print(newaddress)
                            lblAddress.text = newaddress
                            return newaddress
                        }
                        else {
                            return ""
                        }
                    }
                } else {
                    return ""
                }
            }
            else {
                return ""
            }
            
        }   else {
            return ""
        }
        
    }
}
