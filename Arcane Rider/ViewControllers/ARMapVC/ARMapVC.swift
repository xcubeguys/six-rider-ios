//
//  SampleVC.swift
//  Arcane Rider
//
//  Created by Apple on 18/12/16.
//  Copyright © 2016 Apple. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Firebase
import GeoFire
import CoreLocation
import Alamofire

let maplocStyle = "[\n  {\n    \"elementType\": \"geometry\",\n    \"stylers\": [\n      {\n        \"color\": \"#f5f5f5\"\n      }\n    ]\n  },\n  {\n    \"elementType\": \"labels.icon\",\n    \"stylers\": [\n      {\n        \"visibility\": \"off\"\n      }\n    ]\n  },\n  {\n    \"elementType\": \"labels.text.fill\",\n    \"stylers\": [\n      {\n        \"color\": \"#616161\"\n      }\n    ]\n  },\n  {\n    \"elementType\": \"labels.text.stroke\",\n    \"stylers\": [\n      {\n        \"color\": \"#f5f5f5\"\n      }\n    ]\n  },\n  {\n    \"featureType\": \"administrative.land_parcel\",\n    \"elementType\": \"labels.text.fill\",\n    \"stylers\": [\n      {\n        \"color\": \"#bdbdbd\"\n      }\n    ]\n  },\n  {\n    \"featureType\": \"poi\",\n    \"elementType\": \"geometry\",\n    \"stylers\": [\n      {\n        \"color\": \"#eeeeee\"\n      }\n    ]\n  },\n  {\n    \"featureType\": \"poi\",\n    \"elementType\": \"labels.text.fill\",\n    \"stylers\": [\n      {\n        \"color\": \"#757575\"\n      }\n    ]\n  },\n  {\n    \"featureType\": \"poi.park\",\n    \"elementType\": \"geometry\",\n    \"stylers\": [\n      {\n        \"color\": \"#e5e5e5\"\n      }\n    ]\n  },\n  {\n    \"featureType\": \"poi.park\",\n    \"elementType\": \"labels.text.fill\",\n    \"stylers\": [\n      {\n        \"color\": \"#9e9e9e\"\n      }\n    ]\n  },\n  {\n    \"featureType\": \"road\",\n    \"elementType\": \"geometry\",\n    \"stylers\": [\n      {\n        \"color\": \"#ffffff\"\n      }\n    ]\n  },\n  {\n    \"featureType\": \"road.arterial\",\n    \"elementType\": \"labels.text.fill\",\n    \"stylers\": [\n      {\n        \"color\": \"#757575\"\n      }\n    ]\n  },\n  {\n    \"featureType\": \"road.highway\",\n    \"elementType\": \"geometry\",\n    \"stylers\": [\n      {\n        \"color\": \"#dadada\"\n      }\n    ]\n  },\n  {\n    \"featureType\": \"road.highway\",\n    \"elementType\": \"labels.text.fill\",\n    \"stylers\": [\n      {\n        \"color\": \"#616161\"\n      }\n    ]\n  },\n  {\n    \"featureType\": \"road.local\",\n    \"elementType\": \"labels.text.fill\",\n    \"stylers\": [\n      {\n        \"color\": \"#9e9e9e\"\n      }\n    ]\n  },\n  {\n    \"featureType\": \"transit.line\",\n    \"elementType\": \"geometry\",\n    \"stylers\": [\n      {\n        \"color\": \"#e5e5e5\"\n      }\n    ]\n  },\n  {\n    \"featureType\": \"transit.station\",\n    \"elementType\": \"geometry\",\n    \"stylers\": [\n      {\n        \"color\": \"#eeeeee\"\n      }\n    ]\n  },\n  {\n    \"featureType\": \"water\",\n    \"elementType\": \"geometry\",\n    \"stylers\": [\n      {\n        \"color\": \"#c9c9c9\"\n      }\n    ]\n  },\n  {\n    \"featureType\": \"water\",\n    \"elementType\": \"labels.text.fill\",\n    \"stylers\": [\n      {\n        \"color\": \"#9e9e9e\"\n      }\n    ]\n  }\n]"

class ARMapVC: UIViewController,UISearchBarDelegate , LocateOnTheMap,GMSAutocompleteFetcherDelegate,CLLocationManagerDelegate,GMSMapViewDelegate {
    
    /**
     * Called when an autocomplete request returns an error.
     * @param error the error that was received.
     */
    public func didFailAutocompleteWithError(_ error: Error) {
        //        resultText?.text = error.localizedDescription
    }
    
    /**
     * Called when autocomplete predictions are available.
     * @param predictions an array of GMSAutocompletePrediction objects.
     */
    public func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
        //self.resultsArray.count + 1
        
        for prediction in predictions {
            
            if let prediction = prediction as GMSAutocompletePrediction!{
                self.resultsArray.append(prediction.attributedFullText.string)
            }
        }
        self.searchResultController.reloadDataWithArray(self.resultsArray)
        //   self.searchResultsTable.reloadDataWithArray(self.resultsArray)
        print(resultsArray)
    }
    
    
    @IBOutlet weak var googleMapsContainer: UIView!
    
    var googleMapsView: GMSMapView!
    var searchResultController: SearchResultsController!
    var resultsArray = [String]()
    var gmsFetcher: GMSAutocompleteFetcher!
    
    @IBOutlet weak var viewAAA: GMSMapView!

    
    @IBOutlet weak var btttonasd: UIButton!
    
    @IBOutlet weak var btttonDestination: UIButton!

    @IBOutlet weak var viewTop: UIView!

    @IBOutlet weak var viewSecond: UIView!

    @IBOutlet weak var viewRequest: UIView!

    @IBOutlet weak var viewCancel: UIView!

    @IBOutlet weak var labelPickup: UILabel!
    @IBOutlet weak var labelDestination: UILabel!
    
    @IBOutlet weak var lastTripView: UIView!
    @IBOutlet weak var btnRequest: UIButton!
    @IBOutlet weak var btnCancelProgress: UIButton!
    @IBOutlet weak var priceView: UIView!

    @IBOutlet var progressViewOutlet: UIProgressView!
    
    @IBOutlet weak var labelDivider: UILabel!
    
    // Driver Details view 
    @IBOutlet var driverDetail: UIView!
    @IBOutlet var driverPhoto: UIImageView!
    
    @IBOutlet var statusView: UIView!
    @IBOutlet var statusLabel: UILabel!
    
    
    @IBOutlet var setPickupView: UIView!
    @IBOutlet var setPickupBtn: UIButton!
    
    @IBOutlet var menuBtion: UIButton!
    
    
    var loadingFirst = true
    
    

    var progressLabel: UILabel?

    let locationTracker = LocationTracker(threshold: 10.0)
    
    var locationManager = CLLocationManager()
    
    var didFindMyLocation = false
    
    let screenSize: CGRect = UIScreen.main.bounds
    
    var currentLocation = CLLocation()
    var pickupLocation = CLLocation()
    
    var trip_status = "nil"
    var trip_id = "nil"

    
    
    var latMutArray = NSMutableArray()
    var longMutArray = NSMutableArray()
    var states:NSMutableArray = NSMutableArray()
    var driverNamesArray:NSMutableArray = NSMutableArray()

    var dynamicLocation = CLLocation()
    var tapLocation = CLLocation()
    
    typealias jsonSTD = NSArray
    
    typealias jsonSTDAny = [String : AnyObject]
    @IBOutlet weak var viewwwww: UIButton!

    var check = true
    
    var timer = Timer()
    var poseDuration = 20
    var indexProgressBar = 0
    var currentPoseIndex = 0
    
    var firstTime:Int = 1
    
    
    var drivers = 0
    var fCount = 0
    var url:String! = "https://demo.cogzidel.com/arcane_lite/"
    
    var update_Marker = true // to update first time marker in map for current location
    
    let manager:AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()

    var accepted = "no"
    
    
//    var counter:Int = 1 {
//        didSet {
//            let fractionalProgress = Float(counter) / 500.0
//            //let animated = counter != 0
//            
//            //            progressView?.setProgress(fractionalProgress, animated: animated)
//            progressLabel?.text = ("\(counter)%")
//            
//            UIView.animate(withDuration: 2, animations: { () -> Void in
//                self.progressViewOutlet.setProgress(fractionalProgress, animated: true)
//            })
//        }
//    }

    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    var requestStatus:Int = 0
    
    override func viewDidAppear(_ animated: Bool) {
        // This padding will be observed by the mapView
        self.viewAAA.padding = UIEdgeInsetsMake(64, 0, 64, 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        marker.map = nil

        self.requestFB()
        // Do any additional setup after loading the view.
        
        /*let camera = GMSCameraPosition.camera(withLatitude: self.currentLocation.coordinate.latitude,
                                              longitude: self.currentLocation.coordinate.longitude,
                                            zoom: 15) */
        
        do {
            // Set the map style by passing a valid JSON string.
            self.viewAAA.mapStyle = try GMSMapStyle(jsonString: maplocStyle)
            
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
      //  self.viewAAA.camera = camera
        
        UISearchBar.appearance().backgroundColor = UIColor.black
        UISearchBar.appearance().tintColor = UIColor.black
      //  UISearchBar.appearance().alpha = 15.0
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()

        if(CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways)
        {
            if let loc = locationManager.location {
                currentLocation = loc
            }
            
        }
        
    //    self.updateLocationLabel(withText: "Unknown")
        
        self.locationTracker.addLocationChangeObserver { (result) -> () in
            switch result {
            case .success(let location):
                let coordinate = location.physical.coordinate
                let locationString = "\(coordinate.latitude), \(coordinate.longitude)"
                
                self.dynamicLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)

                let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude,
                                                      longitude: coordinate.longitude,
                                                      zoom: 15)
                
                let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
                mapView.isMyLocationEnabled = true
                mapView.delegate = self
                
                // to avoid infinite loop method camera position in google map view
                
                if(self.firstTime == 1){
                    
                    
                    self.currentLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
                    
                    self.getCurrnentAddress(myLocation: self.currentLocation)
                    
                    self.updateLocation()
                    
                    
                    do {
                        // Set the map style by passing a valid JSON string.
                        self.viewAAA.mapStyle = try GMSMapStyle(jsonString: maplocStyle)
                        
                    } catch {
                        NSLog("One or more of the map styles failed to load. \(error)")
                    }

                    self.viewAAA.camera = camera

                    self.firstTime = 2
                }
                
                
                //  mapView.animate(toZoom: 15)
                
             //   self.viewAAA = mapView
                
             /*   let circleView = UIView()
                circleView.backgroundColor = UIColor.red.withAlphaComponent(0.5)
                self.testView.addSubview(circleView)
                self.testView.bringSubview(toFront: circleView)
                circleView.translatesAutoresizingMaskIntoConstraints = false
                
                let heightConstraint = NSLayoutConstraint(item: circleView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)
                let widthConstraint = NSLayoutConstraint(item: circleView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)
                let centerXConstraint = NSLayoutConstraint(item: circleView, attribute: .centerX, relatedBy: .equal, toItem: self.testView, attribute: .centerX, multiplier: 1, constant: 0)
                let centerYConstraint = NSLayoutConstraint(item: circleView, attribute: .centerY, relatedBy: .equal, toItem: self.testView, attribute: .centerY, multiplier: 1, constant: 0)
                NSLayoutConstraint.activate([heightConstraint, widthConstraint, centerXConstraint, centerYConstraint])
                
                self.testView.updateConstraints()
                
                UIView.animate(withDuration: 1.0, animations: {
                    self.view.layoutIfNeeded()
                    circleView.layer.cornerRadius = circleView.frame.width/2
                    circleView.clipsToBounds = true
                })
                */
                self.nearBy()
                
             //   self.updateLocationLabel(withText: locationString)
                
            case .failure:
                
                //  self.updateLocationLabel(withText: "Failure")

                break
                
            }
        }
        


        viewAAA.delegate = self
        viewAAA.isMyLocationEnabled = true
        self.viewAAA.settings.rotateGestures = false;
        self.viewAAA.settings.compassButton = true
        viewAAA.settings.myLocationButton = true
        viewAAA.settings.indoorPicker = true
        viewAAA.isIndoorEnabled = true
        
        
        viewCancel.layer.cornerRadius = viewCancel.frame.size.height / 2
        viewCancel.clipsToBounds = true
        
        navigationController!.isNavigationBarHidden = true
        
        UINavigationBar.appearance().backgroundColor = UIColor.clear
        
        navigationController!.isNavigationBarHidden = true
        UINavigationBar.appearance().backgroundColor = UIColor.clear
        
        
      /*  self.googleMapsView = GMSMapView(frame: self.googleMapsContainer.frame)
        
        self.view.addSubview(self.googleMapsView)
        // self.view.addSubview(btttonasd)
        self.googleMapsView.addSubview(viewTop)*/
    
        searchResultController = SearchResultsController()
        searchResultController.delegate = self
        gmsFetcher = GMSAutocompleteFetcher()
        gmsFetcher.delegate = self
        
     /*   do {
            // Set the map style by passing the URL of the local file.
            if let styleURL = Bundle.main.url(forResource: "style", withExtension: "json") {
                
                viewAAA.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
                
            } else {
                
                NSLog("Unable to find style.json")
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
        */
        
      /*  do {
            // Set the map style by passing the URL of the local file. Make sure style.json is present in your project
            if let styleURL = Bundle.main.url(forResource: "mapStyle", withExtension: "json") {
         
                viewAAA.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                print("Unable to find style.json")
            }
        } catch {
            print("The style definition could not be loaded: \(error)")
        }
        */
        

        
        
        self.driverDetail.isHidden = true
        self.statusView.isHidden = true
        self.setPickupView.isHidden = false
        self.setPickupBtn.layer.cornerRadius = 20
        

        self.viewAAA.addSubview(viewTop)
        self.viewAAA.addSubview(viewSecond)
        self.viewAAA.addSubview(labelDivider)
        self.viewAAA.addSubview(viewRequest)
        self.viewAAA.addSubview(progressViewOutlet)
        self.viewAAA.addSubview(viewCancel)
        self.viewAAA.addSubview(viewwwww)
        self.viewAAA.addSubview(driverDetail)
        self.viewAAA.addSubview(statusView)
        self.viewAAA.addSubview(setPickupView)
        self.viewAAA.addSubview(menuBtion)
        progressViewOutlet.transform = progressViewOutlet.transform.scaledBy(x: 1, y: 5)

        if(labelPickup.text != ""){
            self.locateWithLongitude(self.currentLocation.coordinate.longitude, andLatitude: self.currentLocation.coordinate.latitude,andTitle: labelPickup.text!)
        }
        
        self.cardView()

        
    }
    
    

    @IBAction func menuAction(_ sender: Any) {
        
        
    }
    
    
    @IBAction func setPickupAction(_ sender: Any) {
        self.setPickupView.isHidden = true
        self.btttonasd.tag = 0
        if(labelPickup.text != ""){
            self.locateWithLongitude(self.currentLocation.coordinate.longitude, andLatitude: self.currentLocation.coordinate.latitude,andTitle: labelPickup.text!)
        }
        // call pickup location selection item and visible drop location
        
    }
    
    
    
    /**
     action for search location by address
     
     - parameter sender: button search location
     */
    
  /*  override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
      /*  navigationController!.isNavigationBarHidden = true
        UINavigationBar.appearance().backgroundColor = UIColor.clear
        
        self.googleMapsView = GMSMapView(frame: self.googleMapsContainer.frame)
        self.view.addSubview(self.googleMapsView)
       // self.view.addSubview(btttonasd)
        self.view.addSubview(viewTop)
        searchResultController = SearchResultsController()
        searchResultController.delegate = self
        gmsFetcher = GMSAutocompleteFetcher()
        gmsFetcher.delegate = self*/
        
    } */
    
    @IBAction func btnactionwith(_ sender: AnyObject) {
        
        btttonasd.tag = 0
        
        navigationController!.isNavigationBarHidden = true
        
        
        let searchController = UISearchController(searchResultsController: searchResultController)
        
        searchController.searchBar.delegate = self
        
        
        
        self.present(searchController, animated:true, completion: nil)
        
    }
    
    @IBAction func btnactionRequest(_ sender: AnyObject) {

        
//        self.navigationItem.titleView = setTitle(title: "Requesting")
        self.getNextPoseData()


        viewRequest.isHidden = true
        self.progressViewOutlet.isHidden = false
        
        viewAAA.settings.myLocationButton = true
        viewAAA.settings.indoorPicker = true
        viewAAA.isIndoorEnabled = true
        
        viewCancel.isHidden = false
        
        self.progressViewOutlet.setProgress(0, animated: false)
        
        progressLabel?.text = "0%"
//        self.counter = 0
//        for i in 0..<500 {
//            DispatchQueue.global(priority: .background).async(execute: { () -> Void in
//                sleep(1)
//                DispatchQueue.main.async(execute: {
//                    self.counter=self.counter + 1
//                    if(self.counter == 500){
//                    }
//                    return
//                })
//            })
//        }
        
        self.requesting()

        
    }
    
    func requesting(){
        //call Json
        print(self.appDelegate.pickupLocation.coordinate.latitude)
        print(self.appDelegate.pickupLocation.coordinate.longitude)
        print(self.appDelegate.dropLocation.coordinate.latitude)
        print(self.appDelegate.dropLocation.coordinate.longitude)

        
        self.requestStatus = 1
    
        //self.setRequestStatus()
        self.requestJson()
        
    }
    
    func requestJson(){
        
        //changed to requestStatus as 2 by accepting by the driver.
        
        self.requestStatus = 2
        
        var urlstring:String = "\(url!)requests/setRequest/userid/\(self.appDelegate.userid!)/start_lat/\(self.appDelegate.pickupLocation.coordinate.latitude)/start_long/\(self.appDelegate.pickupLocation.coordinate.longitude)/end_lat/\(self.appDelegate.dropLocation.coordinate.latitude)/end_long/\(self.appDelegate.dropLocation.coordinate.longitude)/payment_mode/cash"
        
        urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        print(urlstring)
        

        Alamofire.request(urlstring).responseJSON { (response) in
            print(urlstring)
            //            print(response)
            do{
                
                let readableJSon:NSArray! = try JSONSerialization.jsonObject(with: response.data!, options: .mutableContainers) as! NSArray
                
                print(" !!! \(readableJSon[0])")
                
                if let value:NSDictionary = readableJSon[0] as? NSDictionary{
                    
//                    print(value["destination"]!)        // dictionary
//                    print(value["pickup"]!)             // dictionary
//                    print(value["request_id"]!)         // String
//                    print(value["request_status"]!)     // String
//                    print(value["rider_id"]!)           // String
                    
                    if let pickup:NSDictionary = value["pickup"] as? NSDictionary{
                        let pickupLat:String = pickup["lat"] as! String
                        let pickupLong:String = pickup["long"] as! String
                        
                        self.appDelegate.pickup_lat = pickupLat
                        self.appDelegate.pickup_long = pickupLong
                        
                        
                    }
                    if let dest:NSDictionary = value["destination"] as? NSDictionary{
                        let destLat:String = dest["lat"] as! String
                        let destLong:String = dest["long"] as! String
                        
                        self.appDelegate.dest_lat = destLat
                        self.appDelegate.dest_long = destLong

                    }
                    
                    self.appDelegate.request_id = value["request_id"] as! String
                    self.appDelegate.request_status = value["request_status"] as! String
                    print("Requesting")
                    
                    self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ARMapVC.setProgressBar), userInfo: nil, repeats: true)

                    self.processURL()
                    
                }
            }
            catch{
                
                print(error)
                
            }
            
        }

        

    }
    
    
    
    func setProgressBar()
    {
        if indexProgressBar == poseDuration
        {
            getNextPoseData()
            
            // reset the progress counter
            indexProgressBar = 0
        }
        
        // update the display
        // use poseDuration - 1 so that you display 20 steps of the the progress bar, from 0...19
        progressViewOutlet.progress = Float(indexProgressBar) / Float(poseDuration - 1)
        
        // increment the counter
        indexProgressBar += 1
        
        if(indexProgressBar % 3 == 0){
            if(accepted == "no"){
                self.getRequestURL()
            }
            else{
                self.btnactionCancelProgress(self.btnCancelProgress)
            }
        }
        
        if(indexProgressBar == 15){
            //
        }
//        print(indexProgressBar)
//        print(timer.timeInterval)
//        print(timer.description)
    }
    
    
    func getNextPoseData()
    {
        // do next pose stuff
        currentPoseIndex += 1
        print(currentPoseIndex)
    }
    
    
    @IBAction func destinatonBtnAction(_ sender: AnyObject) {
        
        btttonDestination.tag = 1
        
        navigationController!.isNavigationBarHidden = true
        
        
        let searchController = UISearchController(searchResultsController: searchResultController)
        
        searchController.searchBar.delegate = self
        
        
        
        self.present(searchController, animated:true, completion: nil)
        
    }
    @IBAction func btnactionCancelProgress(_ sender: AnyObject) {

        self.viewRequest.isHidden = false
        self.viewCancel.isHidden = true
        viewAAA.settings.myLocationButton = false
        progressViewOutlet.isHidden = true
        indexProgressBar = 0
        timer.invalidate()
        
        self.cancelRequest()
        
    }
    
    // request cancelled by close action and timeup action
    
    func cancelRequest(){
        
        
        var urlstring:String = "https://demo.cogzidel.com/arcane_lite/requests/cancelRequest/request_id/\(self.appDelegate.request_id!)"
        
        self.appDelegate.accepted_Driverid = ""
        
        urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        print(urlstring)
        
        let manager : AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
        
        manager.responseSerializer.acceptableContentTypes =  Set<AnyHashable>(["application/json", "text/json", "text/javascript", "text/html"])
        
        manager.get( "\(urlstring)",
            parameters: nil,
            success: { (operation: AFHTTPRequestOperation?,responseObject: Any?) in
                let jsonObjects=responseObject as! NSArray
                //                var dataDict: NSDictionary?
                for dataDict : Any in jsonObjects {
                    let message: NSString! = (dataDict as AnyObject).object(forKey: "status") as! NSString
                    
                    //define and get the accept statust
                    if(message == "accept"){
                        // handle arrivenow view.
                    }
                    else{
                        // cancel action and get back to request view.
                        self.btnactionCancelProgress(self.btnCancelProgress)
                        
                    }
                    
                }
        },
            failure: { (operation: AFHTTPRequestOperation?,error: Error) in
                print("Error: " + error.localizedDescription)
                //let alertview = UIAlertView()
                //  alertview.title = "Error!"
                //  alertview.message = "\(error.localizedDescription)"
                //  alertview.addButton(withTitle: "OK")
                //  alertview.show()
        })
    }
    /**
     Locate map with longitude and longitude after search location on UISearchBar
     
     - parameter lon:   longitude location
     - parameter lat:   latitude location
     - parameter title: title of address location
     */
    func locateWithLongitude(_ lon: Double, andLatitude lat: Double, andTitle title: String) {
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()

        self.pickupLocation = CLLocation(latitude: lat, longitude: lon)
        
        DispatchQueue.main.async { () -> Void in
            
            let position = CLLocationCoordinate2DMake(lat, lon)
            let marker = GMSMarker(position: position)
            
            
            if self.btttonasd.tag == 0{
                
                print(lat)
                print(lon)
                
                self.appDelegate.pickupLocation = CLLocation(latitude: lat, longitude: lon)
                
                let camera = GMSCameraPosition.camera(withLatitude: self.pickupLocation.coordinate.latitude, longitude: self.pickupLocation.coordinate.longitude, zoom: 12)
                self.viewAAA.camera = camera
                
                marker.title = "Address : \(title)"
                marker.map = self.viewAAA
                self.labelPickup.text = "\(title)"

                if(self.loadingFirst == true){
                    self.loadingFirst = false
                }
                else{
                    self.viewSecond.isHidden = false
                    self.labelDivider.isHidden = false
                    self.btttonasd.tag = 1

                }
                
            }
            else{
                
                
                self.appDelegate.dropLocation = CLLocation(latitude: lat, longitude: lon)

                self.labelDestination.text = "\(title)"
                
                self.viewRequest.isHidden = false

                self.viewAAA.settings.myLocationButton = false
                self.viewAAA.settings.indoorPicker = false
                self.viewAAA.isIndoorEnabled = false

                
            }
        
        }
        
    }
    
    /**
     Searchbar when text change
     
     - parameter searchBar:  searchbar UI
     - parameter searchText: searchtext description
     */
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        //        let placeClient = GMSPlacesClient()
        //
        //
        //        placeClient.autocompleteQuery(searchText, bounds: nil, filter: nil)  {(results, error: Error?) -> Void in
        //           // NSError myerr = Error;
        //            print("Error @%",Error.self)
        //
        //            self.resultsArray.removeAll()
        //            if results == nil {
        //                return
        //            }
        //
        //            for result in results! {
        //                if let result = result as? GMSAutocompletePrediction {
        //                    self.resultsArray.append(result.attributedFullText.string)
        //                }
        //            }
        //
        //            self.searchResultController.reloadDataWithArray(self.resultsArray)
        //
        //        }
        
        
        self.resultsArray.removeAll()
        gmsFetcher?.sourceTextHasChanged(searchText)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    let marker = GMSMarker()

    func multipleMarker(){
        
        
//        viewAAA.clear()
        print(self.latMutArray.count)
        print(fCount)
        if(self.latMutArray.count == fCount){
            
            if(update_Marker == true){
                if(latMutArray.count != 0){
                    for i in 0..<latMutArray.count {
                        marker.position = CLLocationCoordinate2DMake(latMutArray[i] as! CLLocationDegrees, longMutArray[i] as! CLLocationDegrees)
                        marker.title = "\(driverNamesArray[i])"
                        marker.snippet = "Drivers"
                        marker.icon = UIImage(named: "Drivers.png")
                        marker.map = viewAAA
                        
                    }
                    
                }
                update_Marker = false
            }
            else{
            }
        }
        else{
            
            self.fCount = self.latMutArray.count
            self.viewAAA.clear()
            self.markerPosition()
            if(latMutArray.count != 0){
                for i in 0..<latMutArray.count {
                    marker.position = CLLocationCoordinate2DMake(latMutArray[i] as! CLLocationDegrees, longMutArray[i] as! CLLocationDegrees)
                    marker.title = "\(driverNamesArray[i])"
                    marker.snippet = "Drivers"
                    marker.icon = UIImage(named: "Drivers.png")
                    marker.map = viewAAA
                    
                }
                if(self.drivers == 0){
                    self.drivers = 1
                    
                }
                else{
                    self.drivers = 0

                }
            }
        }

    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        
        let camera = GMSCameraPosition.camera(withLatitude: (self.currentLocation.coordinate.latitude),longitude: (self.currentLocation.coordinate.longitude),zoom: 15)
        
        self.viewAAA.camera = camera
        self.firstTime = 1
        return true
        
    }
    
    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {

        self.firstTime = 1

    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            
            locationManager.startUpdatingLocation()
            
            viewAAA.isMyLocationEnabled = true
            viewAAA.settings.myLocationButton = true
        }
    }
    
    // MARK: GMSMapViewDelegate method implementation
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        
        
    }
    
    // 6
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
      
        if let location = locations.first {
            
            let ref = FIRDatabase.database().reference()
            // for rider
            let geoRider = GeoFire(firebaseRef: ref.child("riders_location").child(self.appDelegate.userid!))
            
            geoRider!.setLocation(CLLocation(latitude: self.currentLocation.coordinate.latitude, longitude: self.currentLocation.coordinate.longitude), forKey: "geolocation") { (error) in
                
                if (error != nil) {
                    
                    
                }
                else{
                    
                    print("Saved location successfully!")

                }
            }
        
            // for driver availability
            
            let geoFire = GeoFire(firebaseRef: ref.child("drivers_location").child("585a29d2da71b40b128b4567"))
            
           // let geoFire = GeoFire(firebaseRef: ref.child("drivers_location/5857c2bada71b4d9708b4567/"))

        //    print(geoFire!.firebaseRef(forLocationKey: "geolocation"))
            // 5857a775da71b456718b4567
           // geoFire!.getLocationForKey("firebase-hq-android", withCallback: { (location, error) in
            geoFire!.getLocationForKey("geolocation", withCallback: { (location, error) in
                if (error != nil) {
                    
                    print("An error occurred getting the location for \"firebase-hq-iOS\": \(error!.localizedDescription)")
                    
                }
                else if (location != nil) {
                    
                 //   print("Location for \"firebase-hq-android\" is [\(location!.coordinate.latitude), \(location!.coordinate.longitude)]")
                    
                    ref.child("drivers_location").observeSingleEvent(of: .value, with: { (snapshot) in
                        
                        self.states.removeAllObjects()
                        self.latMutArray.removeAllObjects()
                        self.longMutArray.removeAllObjects()
                        self.driverNamesArray.removeAllObjects()
                        
                        let dict = snapshot.value as! NSDictionary
                        if let result = snapshot.children.allObjects as? [FIRDataSnapshot] {
                            for childTest in result {
                                //do your logic and validation here
                                //print("res \(result)")                  // 1 by 1 for loop
                                // child.value["meanAcc"] as! String
                                
                                let meanAcc = childTest.key
                                
                                print("maenKey \(meanAcc)")             // inside key access
                                
                                
                                if let gandoValues = dict["\(meanAcc)"] as? NSDictionary{
                                  //  print("g and l values \(gandoValues)")


//                                    let email = gandoValues["email"] as! NSString

                                    
                                    //                                print("l values \(email) \(name)")
                                    
                                    if let geo_location = gandoValues["geolocation"] as? NSDictionary{
                                      //  print(geo_location)
                                        if let latLong = geo_location["l"] as? NSArray{
                                           // print(latLong)
                                            if(latLong.count == 0){
                                                
                                            }
                                            else{
                                                
                                                let lat = latLong[0]
                                                let long = latLong[1]
                                               // print(lat)
                                               // print(long)
                                                if let name = gandoValues["name"] as? NSString{
                                                    self.driverNamesArray.add(name)
                                                  //  print(name)
                                                }
                                                else{
                                                    self.driverNamesArray.add("\(lat),\(long)")
                                                }
                                                
                                                
                                                
                                                self.latMutArray.add(lat)
                                                self.longMutArray.add(long)
                                                self.states.add("\(lat),\(long)")
                                                
                                                
                                            }
                                            
                                            
                                        }
                                        
                                        if let acceptStatus = gandoValues["accept"] as? NSDictionary{
                                            if let status = acceptStatus["status"] as? Any{
                                                print(status)
                                                self.trip_status = status as! String
                                                
                                            }
                                            if let tripid = acceptStatus["trip_id"] as? Any{
                                                print(tripid)
                                                self.trip_id = tripid as! String
                                                
                                            }
                                            
                                            if(self.trip_status == "nil"){
                                                
                                            }
                                            else if(self.trip_status == "1"){
                                                
                                            }
                                            else if(self.trip_status == "2"){
                                                
                                            }
                                            else if(self.trip_status == "3"){
                                                
                                            }
                                            else if(self.trip_status == "4"){
                                                
                                            }

                                            
                                        }
                                    }
                                }

//
//                                let firstValue = weather[0]
//
//                                let secondValue = weather[1]
//                                
//                                print("meanAcc \(meanAcc)")
//                                
//                                print("frist \(firstValue)")
//                                
//                                print("second \(secondValue)")
//                                
//                                self.states.add(meanAcc)
//                                
//                                self.latMutArray.add(firstValue)
//                                
//                                self.longMutArray.add(secondValue)
                                
                          //      var coordinatesToAppend = CLLocationCoordinate2D(latitude: firstValue as! CLLocationDegrees, longitude: secondValue as! CLLocationDegrees)
                                
                                //
                                //                                let marker = GMSMarker()
                                //                                marker.position = CLLocationCoordinate2D(latitude: firstValue as! CLLocationDegrees, longitude: secondValue as! CLLocationDegrees)
                                //
                                //                                marker.snippet = "Users"
                                //                                marker.appearAnimation = kGMSMarkerAnimationPop
                                //                                marker.icon = UIImage(named: "addLoc.png")
                                //                                marker.map = self.testView
                                
                                //                                var coordinatesToAppend1 = CLLocationCoordinate2D(latitude: self.latMutArray[1] as! CLLocationDegrees, longitude: self.longMutArray[1] as! CLLocationDegrees)
                                //
                                //
                                //                                let marker1 = GMSMarker()
                                //                                marker1.position = CLLocationCoordinate2D(latitude: self.latMutArray[1] as! CLLocationDegrees, longitude: self.longMutArray[1] as! CLLocationDegrees)
                                //
                                //                                marker1.snippet = "Users1"
                                //                                marker1.appearAnimation = kGMSMarkerAnimationPop
                                //                                marker1.icon = UIImage(named: "addLoc.png")
                                //                                marker1.map = self.testView
                                
                                //mapView.animate(to: GMSCameraPosition.camera(withLatitude: firstValue as! CLLocationDegrees, longitude: secondValue as! CLLocationDegrees, zoom: 15))
                                
                                
                            }
                            print(self.longMutArray.count)
                            print(self.latMutArray.count)
                            print(self.states.count)
                            print(self.driverNamesArray.count)
                            if(self.longMutArray.count != 0 ){
                                self.multipleMarker()
                                if(self.drivers == 0){
                                    self.drivers = 1
                                    self.fCount = self.latMutArray.count
                                    
                                }
                            }
                            
                            
                            /*   for child in snapshot.children {
                             
                             // total 2 Combine
                             print("child \(child)")
                             
                             print("sanpshot \(snapshot)")
                             }*/
                            
                            
                        } else {
                            
                            print("no results")
                        }
                    }) { (error) in
                        
                        print(error.localizedDescription)
                    }
                    
                    
                    
                }
                else {
                    
                    print("GeoFire does not contain a location for \"firebase-hq\"")
                }
            })

        }
    }
    
    

    
    func getCurrnentAddress(myLocation : CLLocation){
        
        var dynamicLocation1 = CLLocation()

        dynamicLocation1 = myLocation
        
       // https://maps.googleapis.com/maps/api/geocode/json?latlng=9.9239,78.1140&sensor=true
        
        var urlstring:String = "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(dynamicLocation1.coordinate.latitude),\(dynamicLocation1.coordinate.longitude)&sensor=true/"
        
        urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        print(urlstring)
        
        self.callSiginAPI(url: "\(urlstring)")

        
    }
    
    func callSiginAPI(url : String){
        
        Alamofire.request(url).responseJSON { (response) in
            print(url)
//            print(response)
            do{
                
                let readableJSon:NSDictionary! = try JSONSerialization.jsonObject(with: response.data!, options: .mutableContainers) as! NSDictionary
                
                //print(" !!! \(readableJSon["results"]!)")
                
                if let value:NSArray = readableJSon["results"]! as? NSArray{
                    
                    //print(value[1])
                    if(value.count == 0){
                        
                    }
                    else{
                        if let zipArray: NSDictionary = value[0] as? NSDictionary{
                            //   print(zipArray)
                            if let zip:String = zipArray["formatted_address"] as? String{
                                // print(zip)
                                self.labelPickup.text = zip
                                
                                //self.nearBy()

                            }
                        }
                    }
                }
            }
            catch{
                
                print(error)
                
            }
            
        }
    }
    
    func mapView(_ mapView:GMSMapView,idleAt position:GMSCameraPosition)
    {
        
        let point:CGPoint = mapView.center;
        let coor:CLLocationCoordinate2D = mapView.projection.coordinate(for: point)
        
        self.tapLocation = CLLocation(latitude: coor.latitude, longitude: coor.longitude)
        //to get street address
        let longitude :CLLocationDegrees = coor.longitude
        let latitude :CLLocationDegrees = coor.latitude
        
        print(longitude)
        print(latitude)
        self.getCurrnentAddress(myLocation: self.tapLocation)
    }
    
    func requestFB(){
        
        let ref = FIRDatabase.database().reference()
        
        
//        let geoFire = GeoFire(firebaseRef: ref.child("drivers_location").child("\(self.appDelegate.accepted_Driverid!)").child("accept"))
        let geoFire = GeoFire(firebaseRef: ref.child("drivers_location").child("585a72e0da71b4cd228b4567").child("accept"))
        
        // let geoFire = GeoFire(firebaseRef: ref.child("drivers_location/5857c2bada71b4d9708b4567/"))
        
        print(geoFire!.firebaseRef(forLocationKey: "geolocation"))
        
         ref.child("drivers_location").child("585a72e0da71b4cd228b4567").child("accept").observe(.childChanged, with: { (snapshot) in
            
            print("updating")
            let status1 = snapshot.value as Any
            print(status1)
            var status = "\(status1)"
            status = status.replacingOccurrences(of: "Optional(", with: "")
            status = status.replacingOccurrences(of: ")", with: "")
            print(status)
            if(status == "1"){
                //accept
                //
            }
            else if(status == "2"){
                //arrive
                // topLabel.text = "ARRIVING"
            }
            else if(status == "3"){
                // begin
                // topLabel.text = "START TRRIP"

            }
            else if(status == "4"){
                // end
                // topLabel.text = "COMPLETE TRIP"

            }
            else{
                // empty
            }

            
            
            })
        
        if ((geoFire?.didChangeValue(forKey: "status")) != nil){
            
        }

    }
    
    func setRequestStatus(){
        
        
        let ref1 = FIRDatabase.database().reference()
        
        var userId = self.appDelegate.userid!
        var email = self.appDelegate.loggedEmail!
        var request_status = 0
        let newUser = [
            
            "name": "\(self.appDelegate.fname!) \(self.appDelegate.lname!)",
            "email"      : "",
            //  "request" : "",
            
            ]
        
        
  /*      let requestArray = [
            
            "req_id"      : "",
            "status" : "",
            
            ]
        
        let acceptArray = [
            
            "status"      : "",
            "trip_id" : "",
            
            ] */
        
        var appendingPath = ref1.child(byAppendingPath: "riders_location")
        
     //   var appendingPath1 = ref1.child(byAppendingPath: "riders_location")

     
        appendingPath.child(byAppendingPath: userId).setValue(newUser)
        
     //   appendingPath.child(byAppendingPath: userId).child(byAppendingPath: "request").setValue(requestArray)
        
     //   appendingPath1.child(byAppendingPath: userId).child(byAppendingPath: "accept").setValue(acceptArray)

        
        //to update geo fire database
        // ref.child("yourKey").child("yourKey").updateChildValues(["yourKey": yourValue])
        
     /*   ref1.child(byAppendingPath: "riders_location")
         .child(byAppendingPath: userId)
         .setValue(newUser) */
        

        var age: Void  = ref1.child(byAppendingPath: "riders_location/\(userId)/email").setValue("\(email)")
///     var location: Void  = ref1.child(byAppendingPath: "riders_location/\(userId)/request/").setValue("\(request_status)")
        
        //     var About : Void = ref1.child(byAppendingPath: "drivers_location/\(userid)/geo_location").setValue("aboutme")
        
        let geoFire = GeoFire(firebaseRef: ref1.child(byAppendingPath: "riders_location/\(userId)"))
        
        geoFire!.setLocation(CLLocation(latitude: (currentLocation.coordinate.latitude), longitude: (currentLocation.coordinate.longitude)), forKey: "geolocation") { (error) in
            
            if (error != nil) {
                
                print("An error occured: \(error)")
                
            } else {
                
                print("Saved location successfully!")
                
            }
        }

    }
    
    
    func nearBy(){
        
        let ref1 = FIRDatabase.database().reference()
        let userId = self.appDelegate.userid!

        
        let geoFire = GeoFire(firebaseRef: ref1.child(byAppendingPath: "drivers_location/"))

        let center = CLLocation(latitude: self.currentLocation.coordinate.latitude, longitude: self.currentLocation.coordinate.longitude)
        // Query locations at [37.7832889, -122.4056973] with a radius of 600 meters
        let circleQuery = geoFire?.query(at: center, withRadius: 0.6)
        
        // Query location by region
        let span = MKCoordinateSpanMake(0.001, 0.001)
        let region = MKCoordinateRegionMake(center.coordinate, span)
        let regionQuery = geoFire?.query(with: region)
        
        print(circleQuery!)
        print(regionQuery!)
        
//        let ref1 = FIRDatabase.database().reference()
//        let userId = self.appDelegate.userid!
//
//        
//        let geoFire = GeoFire(firebaseRef: ref1.child(byAppendingPath: "drivers_location"))
        
        let query = geoFire?.query(at: currentLocation, withRadius: 0.6)
        
        ref1.queryOrdered(byChild: "geolocation")
        //query?.observeEventType(GFEventTypeKeyEntered, withBlock: {

        query?.observe(.keyEntered, with: { (key: String?, location: CLLocation?) in
            
            print("+ + + + Key '\(key)' entered the search area and is at location '\(location)'")
            
//            self.userCount++
//            
//            self.refreshUI()
            
        })
        
        
        
//        circleQuery.
        
    }
    @IBAction func viewprofile(_ sender: Any) {
        self.navigationController?.pushViewController(ARProfileVC(), animated: true)
    }
    
    // 1 normal update location // updateLocation() ,riderURL(url : String) , riderParseData(JSONData : Data)
    
    
    func updateLocation(){
        
        
        self.markerPosition()
        var urlstring:String = "http://demo.cogzidel.com/arcane_lite/rider/updateLocation/userid/\(self.appDelegate.userid!)/lat/\(self.currentLocation.coordinate.latitude)/long/\(self.currentLocation.coordinate.longitude)"
        
        urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        print(urlstring)
        
        self.riderURL(url: "\(urlstring)")
        
        
    }
    
    
    
    func riderURL(url : String){
        
        self.markerPosition()
        
        Alamofire.request(url).responseJSON { (response) in
            
            self.riderParseData(JSONData: response.data!)
            
        }
        
    }
    
    
    func riderParseData(JSONData : Data){
        
        do{
            
            let readableJSon = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as! jsonSTD
            
            print(" !!! \(readableJSon[0])")
            
            let value = readableJSon[0] as AnyObject
            
            let final = value.object(forKey: "status")
            print(final!)
           // self.setRequestStatus()
            
            
        }
        catch{
            
            print(error)
            
        }
        
    }
    
    
    func markerPosition(){
        
        let camera = GMSCameraPosition.camera(withLatitude: (self.currentLocation.coordinate.latitude), longitude:self.currentLocation.coordinate.longitude, zoom:12)
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: self.currentLocation.coordinate.latitude, longitude: self.currentLocation.coordinate.longitude)
        
        //camera.target
        //   marker.position = CLLocationCoordinate2D(latitude: 41.887, longitude: -87.622)
        
        //marker.snippet = "My Location"
        //marker.map = nil
        //marker.appearAnimation = kGMSMarkerAnimationPop
        //marker.icon = UIImage(named: "pinImage.png")
        marker.map = self.viewAAA
        marker.map = nil
        
        
    
       // viewAAA.animate(to: GMSCameraPosition.camera(withLatitude: self.currentLocation.coordinate.latitude, longitude: self.currentLocation.coordinate.longitude, zoom: 15))

    }
    
    
    // use af networking for this process
    // 1.processRequest URL, 2.getRequest URL 3.
    
    
    // 2 process url // processURL(),

    func processURL(){
        
        //https://demo.cogzidel.com/arcane_lite/requests/processRequest/request_id/58563e7eda71b4f30f8b4567
        
        var urlstring:String = "https://demo.cogzidel.com/arcane_lite/requests/processRequest/request_id/\(self.appDelegate.request_id!)"
        
        urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        print(urlstring)
        
        
//        Alamofire.request(url).responseJSON { (response) in
//            
//            self.processParse(JSONData: response.data!)
//            
//        }
        let manager : AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()

        manager.responseSerializer.acceptableContentTypes =  NSSet(objects: "text/plain", "text/html", "application/json", "audio/wav", "application/octest-stream") as Set<NSObject>

        manager.get( "\(urlstring)",
            parameters: nil,
            success: { (operation: AFHTTPRequestOperation?,responseObject: Any?) in
                let jsonObjects:NSArray = responseObject as! NSArray
                //                var dataDict: NSDictionary?
                let value = jsonObjects[0] as AnyObject
                
                print(value)
                
             /*   if let request_status:String = value["request_status"] as? String{
                    if(request_status == "processing"){
                        self.appDelegate.req_status = request_status
                        
                    }
                    else if(request_status == "no_driver"){
                        self.appDelegate.req_status = request_status
                        self.btnactionCancelProgress(self.btnCancelProgress)
                        
                    }
                    else if(request_status == "accept"){
                        
                        self.appDelegate.req_status = request_status
                        let driver_id:String = (value["driver_id"] as? String)!
                        self.appDelegate.accepted_Driverid = driver_id
                        if let driver_location:NSDictionary = (value["driver_location"] as? NSDictionary){
                            print(driver_location["lat"]!)
                            print(driver_location["long"]!)
                        }
                        
                        self.progressViewOutlet.isHidden = true
                        self.viewSecond.isHidden = true
                        self.viewTop.isHidden = true
                        self.labelPickup.isHidden = false
                        self.driverDetail.isHidden = false
                    }
                    else{
                        
                    }
                }  */
        },
            failure: { (operation: AFHTTPRequestOperation?,error: Error) in
                print("Error: " + error.localizedDescription)
                //let alertview = UIAlertView()
                //  alertview.title = "Error!"
                //  alertview.message = "\(error.localizedDescription)"
                //  alertview.addButton(withTitle: "OK")
                //  alertview.show()
        })
        
        

    }
    
   // var timer2 = Timer()
   // var rep = 1
    
    // if processurl is using in alamofire then use this funciton

    func processParse(JSONData : Data){
        
        do{
            
            let readableJSon = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as! jsonSTD
            
            print(" !!! \(readableJSon[0])")
            
            let value = readableJSon[0] as AnyObject
            
            let final = value.object(forKey: "status")
            print(final!)
            
            // self.setRequestStatus()
            
            
        }
        catch{
            
            print(error)
            
        }
       // timer2 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ARMapVC.setProgressBar), userInfo: nil, repeats: true)
        
    }
    
    // dont use above function if you using afnetworking
    
    // 3.get Request status from driver is accepted or not using call back and timer
    // 3.1 getRequestURL() , option => 3.2 getRequestParse(JSONData : Data)
    
    func getRequestURL(){
        
        //https://demo.cogzidel.com/arcane_lite/requests/getRequest/request_id/58563e7eda71b4f30f8b4567
        var urlstring:String = "https://demo.cogzidel.com/arcane_lite/requests/getRequest/request_id/\(self.appDelegate.request_id!)"
        
        urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        print(urlstring)
        
        
       /* Alamofire.request(url).responseJSON { (response) in
            
            print(response)
            self.getRequestParse(JSONData: response.data!)
            
        } */
        
        let manager : AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
        
        manager.responseSerializer.acceptableContentTypes =  Set<AnyHashable>(["application/json", "text/json", "text/javascript", "text/html"])
        
        manager.get( "\(urlstring)",
            parameters: nil,
            success: { (operation: AFHTTPRequestOperation?,responseObject: Any?) in
                let jsonObjects=responseObject as! NSArray
                //                var dataDict: NSDictionary?
                
                let value = jsonObjects[0] as AnyObject
                
                print(value)
                
                
                
                if let request_status:String = value["request_status"] as? String{
                    if(request_status == "processing"){
                      //  self.appDelegate.req_status = request_status

                    }
                    else if(request_status == "no_driver"){
                    //    self.appDelegate.req_status = request_status
                    //    self.btnactionCancelProgress(self.btnCancelProgress)

                    }
                    else if(request_status == "accept"){
                        
                        self.accepted = "yes"
                        self.timer.invalidate()
                        self.progressViewOutlet.setProgress(0, animated: false)
                        self.appDelegate.req_status = request_status
                        let driver_id:String = (value["driver_id"] as? String)!
                        self.appDelegate.accepted_Driverid = driver_id
                        if let driver_location:NSDictionary = (value["driver_location"] as? NSDictionary){
                            print(driver_location["lat"]!)
                            print(driver_location["long"]!)
                            
                            self.timer.invalidate()
                            
                            self.appDelegate.driverLat = driver_location["lat"]! as! String
                            self.appDelegate.driverLong = driver_location["long"]! as! String
                            
                            self.progressViewOutlet.isHidden = true
                            self.viewSecond.isHidden = true
                            self.viewTop.isHidden = false
                            //self.labelPickup.isHidden = false
                            self.driverDetail.isHidden = false
                            self.statusLabel.isHidden = false
                            
                        }
                        
                        self.getDriverDetails()


                    }
                    else{
                        
                    }
                    
                }
                

                
        },
            failure: { (operation: AFHTTPRequestOperation?,error: Error) in
                print("Error: " + error.localizedDescription)
                //let alertview = UIAlertView()
                //  alertview.title = "Error!"
                //  alertview.message = "\(error.localizedDescription)"
                //  alertview.addButton(withTitle: "OK")
                //  alertview.show()
        })
        
        

    }
    
    /* func getRequestParse(JSONData : Data){
        
        do{
            
            let readableJSon = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as! jsonSTD
            
            print(" !!! \(readableJSon[0])")
            
            let value = readableJSon[0] as AnyObject
            
            let final = value.object(forKey: "status")
            print(final!)
            // self.setRequestStatus()
            
            
        }
        catch{
            
            print(error)
            
        }
        
        
    }  */
    
    
    func getDriverDetails(){
        // calling driver profile url 
        // self.appDelegate.accepted_Driverid
        
        self.btnactionCancelProgress(self.btnCancelProgress)

        var urlstring:String = "https://demo.cogzidel.com/arcane_lite/Driver/editProfile/user_id/\(self.appDelegate.accepted_Driverid!)"
        
//        self.appDelegate.accepted_Driverid = ""
        
        urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        print(urlstring)
        
        let manager : AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
        
        manager.responseSerializer.acceptableContentTypes =  Set<AnyHashable>(["application/json", "text/json", "text/javascript", "text/html"])
        
        manager.get( "\(urlstring)",
            parameters: nil,
            success: { (operation: AFHTTPRequestOperation?,responseObject: Any?) in
                let jsonObjects=responseObject as! NSArray
                //                var dataDict: NSDictionary?
                if let request_status:NSDictionary = jsonObjects[0] as? NSDictionary{
                    print(request_status)
                }
 

 
                
        },
            failure: { (operation: AFHTTPRequestOperation?,error: Error) in
                print("Error: " + error.localizedDescription)
                //let alertview = UIAlertView()
                //  alertview.title = "Error!"
                //  alertview.message = "\(error.localizedDescription)"
                //  alertview.addButton(withTitle: "OK")
                //  alertview.show()
        })

        self.requestFB()
    }
    

    func cardView(){
        
        
        
    }

    
    
}
