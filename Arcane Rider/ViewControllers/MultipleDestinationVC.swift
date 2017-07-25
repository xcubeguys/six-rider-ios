//
//  MultipleDestinationVC.swift
//  SIX Rider
//
//  Created by apple on 29/05/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation
import Alamofire
import Firebase
import SwiftMessages


class MultipleDestinationVC: UIViewController,UISearchBarDelegate,GMSAutocompleteFetcherDelegate,LocateOnTheMap,UITableViewDelegate,UITableViewDataSource {

    
    //searchbarfunction
    let geocorder:CLGeocoder = CLGeocoder()
    var places = [Place]()
    var placeType: PlaceType = .all
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newLength = (searchBar.text!).characters.count + text.characters.count - range.length
        return newLength <= 30
    }
    
    var searchResultController: SearchResultsController!
    var resultsArray = [String]()
    var gmsFetcher: GMSAutocompleteFetcher!
    
    var fetcher: GMSAutocompleteFetcher?
    var resultText: UITextView?
    var textField: UITextField?
    
    var currentLocation = CLLocation()
    
    var placeID = ""

    var googleKey = "AIzaSyDMqU_zWVuR0FziY_i69DyWHtiNZj0gjY8"
//    var googleKey = "AIzaSyCP7fWdMSHNzfDwJMicupFGSjKIBdfMHvM"  // temp

    var updatedropLocation = CLLocation()
    var updatedropLocation1 = CLLocation()
    var updatedropLocation2 = CLLocation()
    var updatedropLocation3 = CLLocation()
    var updatedropLocation4 = CLLocation()
    
    var dropCountry:String! = "None"
    var countryStatic:String! = "None"
    var dropCountry1:String! = "None"
    var dropCountry2:String! = "None"
    var dropCountry3:String! = "None"
    var dropCountry4:String! = "None"
    
    var waypointmerge:NSString = ""
    var waypointaddress:NSString = ""
    var waypointcountrycode:NSString = ""
    
    var selectedlocationfield = ""
    var count = 0
    var error = 0
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var updatedroploclbl: UILabel!
    @IBOutlet weak var buttontopupdatedrop: UIButton!
    @IBOutlet weak var addorhidedestinationlbl: UILabel!
    @IBOutlet weak var location1lbl: UILabel!
    @IBOutlet weak var location2lbl: UILabel!
    @IBOutlet weak var location3lbl: UILabel!
    @IBOutlet weak var location4lbl: UILabel!
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var lbl2: UILabel!
    @IBOutlet weak var additionallbl: UILabel!
    
    @IBOutlet weak var additionalview: UIView!
    
    @IBOutlet weak var searchTable: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchview: UIView!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //searchbarfunction
        searchview.isHidden = true
        self.searchBar?.delegate = self
        
        navigationController!.isNavigationBarHidden = false
        
        navigationController!.navigationBar.barStyle = .black
        
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "arrow-left.png")!, for: .normal)
        button.addTarget(self, action: #selector(MultipleDestinationVC.profileBtn(_:)), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let label = UILabel(frame: CGRect(x: 40, y: 5, width: 200, height: 20))
        label.text = "DESTINATION LOCATION"
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.clear
        button.addSubview(label)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = barButton

        searchResultController = SearchResultsController()
        searchResultController.delegate = self
        gmsFetcher = GMSAutocompleteFetcher()
        gmsFetcher.delegate = self
        
        self.buttontopupdatedrop.backgroundColor = UIColor.white
        self.buttontopupdatedrop.layer.cornerRadius = 3.0
        self.buttontopupdatedrop.layer.borderWidth = 2.0
        self.buttontopupdatedrop.layer.borderColor = UIColor.clear.cgColor
        self.buttontopupdatedrop.layer.shadowColor = UIColor.lightGray.cgColor
        self.buttontopupdatedrop.layer.shadowOpacity = 1.0
        self.buttontopupdatedrop.layer.shadowRadius = 3.0
        self.buttontopupdatedrop.layer.shadowOffset = CGSize(width: 0, height: 3)
        
        self.additionalview.isHidden = true
        self.lbl1.isHidden = true
        self.lbl2.isHidden = true
        self.additionallbl.isHidden = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backinsearch(_ sender: Any) {
        searchview.isHidden = true
        searchBar.resignFirstResponder()
        navigationController!.isNavigationBarHidden = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let place = self.places[(indexPath as NSIndexPath).row]
        cell.textLabel!.text = place.description
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.searchBar.resignFirstResponder()
        self.searchBar.text = self.places[(indexPath as NSIndexPath).row].description
        searchTable.isHidden = true
        searchview.isHidden = true
        
        
        let urlpath = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=\(self.places[(indexPath as NSIndexPath).row].description)&key=\(googleKey)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        // to get place id
        
        print(urlpath!)
        let url = URL(string: urlpath!)
        // print(url!)
        let task = URLSession.shared.dataTask(with: url! as URL) { (data, response, error) -> Void in
            // 3
            
            do {
                if data != nil{
                    
                    let dic = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves) as! NSDictionary
                    
                    print(dic)
                    print(dic["predictions"]!)  // array
                    if let placeArray:NSArray = dic["predictions"] as? NSArray{
                        
                        print(placeArray.count)
                        if(placeArray.count == 0)
                        {
                            
                        }
                        else
                        {
                            if let predictions:NSDictionary = placeArray[0] as? NSDictionary{
                                print(predictions)
                                
                                if let place_id:String = predictions["place_id"] as? String{
                                    print(place_id)
                                    if(place_id != ""){
                                        print("placeid is not empty")
                                        
                                        self.placeID = place_id
                                        
                                        self.getLatLong(place_id: place_id,result:self.places[(indexPath as NSIndexPath).row].description)
                                        
                                        // to get lat and long with address
                                        
                                        
                                    }
                                }
                            }
                        }
                    }
                    
                    
                    
                    
                    var place_id = ""
                    // 4
                    
                    if (place_id != ""){
                        // https://maps.googleapis.com/maps/api/place/details/json?placeid=ChIJ8YeFgYjFADsRgSwrS69ttKk&key=AIzaSyD_nwCI7RqGsWkwWeEoJb-KkdVaIfDhFxc
                        // to get address , lat and long
                        
                        
                        let dic = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves) as! NSDictionary
                        
                        let lat =   (((((dic.value(forKey: "results") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "geometry") as! NSDictionary).value(forKey: "location") as! NSDictionary).value(forKey: "lat")) as! Double
                        
                        let lon =   (((((dic.value(forKey: "results") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "geometry") as! NSDictionary).value(forKey: "location") as! NSDictionary).value(forKey: "lng")) as! Double
                        
                        
                        print("\(lat),\(lon)")
                        
                        self.locateWithLongitude(lon, andLatitude: lat, andTitle: self.places[(indexPath as NSIndexPath).row].description)
                    }
                }
                
            }catch {
                print("Error")
            }
            
            
        }
        // 5
        task.resume()
    }
    
    
    func getLatLong(place_id: String, result: String){
        
        
        let urlPlace = "https://maps.googleapis.com/maps/api/place/details/json?placeid=\(place_id)&key=\(googleKey)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        //AIzaSyD_nwCI7RqGsWkwWeEoJb-KkdVaIfDhFxc".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        // to get place id
        
        
        print(urlPlace!)
        let url = URL(string: urlPlace!)
        // print(url!)
        let task1 = URLSession.shared.dataTask(with: url! as URL) { (data, response, error) -> Void in
            // 3
            
            do {
                if data != nil{
                    
                    let dic = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves) as! NSDictionary
                    
                    print(dic)
                    if let result1:NSDictionary = dic["result"] as? NSDictionary{
                        // to get lat and long
                        if let geometry:NSDictionary = result1["geometry"] as? NSDictionary{
                            
                            if let location:NSDictionary = geometry["location"] as? NSDictionary{
                                
                                let lat = location["lat"]
                                let long = location["lng"]
                                
                                print("\(lat!),\(long!)")
                                self.locateWithLongitude(long! as! Double, andLatitude: lat! as! Double, andTitle: result)
                                
                            }
                        }
                    }
                    
                }
                
            }catch {
                print("Error")
            }
        }
        
        
        task1.resume()
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchText == "") {
            self.places = []
            self.searchTable.isHidden = true
        } else {
            self.searchTable.isHidden = false
            getPlaces(searchString: searchText)
        }
    }
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        // Stop doing the search stuff
        // and clear the text in the search bar
        searchBar.text = ""
        self.searchview.isHidden = true
        
    }
    
    func getPlaces(searchString: String) {
        var request = requestForSearch(searchString)
        
        var session = URLSession.shared
        var task = session.dataTask(with: request) { data, response, error in
            self.handleResponse(data, response: response as? HTTPURLResponse, error: error as NSError!)
            
        }
        
        task.resume()
    }
    
    func handleResponse(_ data: Data!, response: HTTPURLResponse!, error: NSError!) {
        if let error = error {
            print("GooglePlacesAutocomplete Error: \(error.localizedDescription)")
            return
        }
        if response == nil {
            print("GooglePlacesAutocomplete Error: No response from API")
            return
        }
        if response.statusCode != 200 {
            print("GooglePlacesAutocomplete Error: Invalid status code \(response.statusCode) from API")
            return
        }
        let serializationError: NSError? = error
        let json: NSDictionary = (try! JSONSerialization.jsonObject(
            with: data,
            options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
        if let error = serializationError {
            print("GooglePlacesAutocomplete Error: \(error.localizedDescription)")
            return
        }
        DispatchQueue.main.async(execute: {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if let predictions = json["predictions"] as? Array<AnyObject> {
                self.places = predictions.map { (prediction: AnyObject) -> Place in
                    return Place(
                        id: prediction["id"] as! String,
                        description: prediction["description"] as! String
                    )
                }
                self.searchTable.reloadData()
                self.searchTable.isHidden = false
            }
        })
    }
    
    func requestForSearch(_ searchString: String) -> URLRequest {
        
        let searchString = searchString.replacingOccurrences(of: "Optional", with: "")
        let place_type = placeType.description.replacingOccurrences(of: "Optional", with: "")
        let key_google = googleKey.replacingOccurrences(of: "Optional", with: "")
        
        print("print1\(searchString)")
        print("print2\(place_type)")
        print("print3\(key_google)")
        
        let params = [
            "input": searchString,
            //"type": "(\(placeType.description))",
            //"type": "",
            "key": googleKey
        ]
        
        print("Place url ->  https://maps.googleapis.com/maps/api/place/autocomplete/json?\(query(params as [String : Any] as [String : AnyObject]))")
        
        var url1 = "https://maps.googleapis.com/maps/api/place/autocomplete/json?\(query(params as [String : Any] as [String : AnyObject]))"
        print("Place->\(url1)")
        
        let url2 = url1.replacingOccurrences(of: "Optional", with: "")
        let url3 = url2.replacingOccurrences(of: "%28", with: "")
        let url4 = url3.replacingOccurrences(of: "%29", with: "")
        
        return NSMutableURLRequest(
            url: URL(string: url4)!
            ) as URLRequest
        
        
    }
    func query(_ parameters: [String: AnyObject]) -> String {
        var components: [(String, String)] = []
        for key in Array(parameters.keys).sorted(by: <) {
            let value: AnyObject! = parameters[key]
            components += [(escape(key), escape("\(value!)"))]
        }
        return (components.map{"\($0)=\($1)"} as [String]).joined(separator: "&")
    }
    func escape(_ string: String) -> String {
        let legalURLCharactersToBeEscaped: CFString = ":/?&=;+!@#$()',*" as CFString
        return CFURLCreateStringByAddingPercentEscapes(nil, string as CFString!, nil, legalURLCharactersToBeEscaped, CFStringBuiltInEncodings.UTF8.rawValue) as String
    }

    
    func profileBtn(_ Selector: AnyObject) {
        
        self.navigationController?.popViewController(animated: true)

    }
    @IBAction func btnupdatedrop(_ sender: Any) {
        
        self.selectedlocationfield = "1"
        
        navigationController!.isNavigationBarHidden = true
        
        searchview.isHidden = false
        searchBar.becomeFirstResponder()
        searchBar.text = ""
        searchTable?.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.searchTable?.isHidden = true
        /*let searchController = UISearchController(searchResultsController: searchResultController)
        
        searchController.searchBar.delegate = self
        
        self.present(searchController, animated:true, completion: nil)*/
        
    }
    @IBAction func btnlocation1(_ sender: Any) {
        
        self.selectedlocationfield = "2"
        
        navigationController!.isNavigationBarHidden = true
        
        searchview.isHidden = false
        searchBar.becomeFirstResponder()
        searchBar.text = ""
        searchTable?.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.searchTable?.isHidden = true
        /*let searchController = UISearchController(searchResultsController: searchResultController)
        
        searchController.searchBar.delegate = self
        
        self.present(searchController, animated:true, completion: nil)*/
    }
    @IBAction func btnlocation2(_ sender: Any) {
        
        self.selectedlocationfield = "3"
        
        navigationController!.isNavigationBarHidden = true
        
        searchview.isHidden = false
        searchBar.becomeFirstResponder()
        searchBar.text = ""
        searchTable?.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.searchTable?.isHidden = true
        /*let searchController = UISearchController(searchResultsController: searchResultController)
        
        searchController.searchBar.delegate = self
        
        self.present(searchController, animated:true, completion: nil)*/
    }
    @IBAction func btnlocation3(_ sender: Any) {
        
        self.selectedlocationfield = "4"
        
        navigationController!.isNavigationBarHidden = true
        
        searchview.isHidden = false
        searchBar.becomeFirstResponder()
        searchBar.text = ""
        searchTable?.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.searchTable?.isHidden = true
        /*let searchController = UISearchController(searchResultsController: searchResultController)
        
        searchController.searchBar.delegate = self
        
        self.present(searchController, animated:true, completion: nil)*/
    }
    @IBAction func btnlocation4(_ sender: Any) {
        
        self.selectedlocationfield = "5"
        
        navigationController!.isNavigationBarHidden = true
        
        searchview.isHidden = false
        searchBar.becomeFirstResponder()
        searchBar.text = ""
        searchTable?.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.searchTable?.isHidden = true
        /*let searchController = UISearchController(searchResultsController: searchResultController)
        
        searchController.searchBar.delegate = self
        
        self.present(searchController, animated:true, completion: nil)*/
    }
    
    @IBAction func doneact(_ sender: Any) {
        
        count = 0
        error = 0
        
        let countrypickup = UserDefaults.standard.value(forKey: "pickuplongname")
        
        if(countrypickup != nil)
        {
            self.countryStatic = String(describing: countrypickup!)
        }
        FIRDatabase.database().reference().child("riders_location").child(self.appDelegate.userid!).child("DestinationWaypoints").removeValue { (error, ref) in
            if error != nil {
                print("error \(error)")
            }
        }
        let ref111 = FIRDatabase.database().reference().child("riders_location").child(self.appDelegate.userid!)
        ref111.updateChildValues(["WayPointCount": 0])
        
        if(updatedroploclbl.text != "" && updatedroploclbl.text != "Update Drop Location"){
            if(self.dropCountry != self.countryStatic){
              
                let warning = MessageView.viewFromNib(layout: .CardView)
                warning.configureTheme(.warning)
                warning.configureDropShadow()
                let iconText = "" //"🤔"
                warning.configureContent(title: "", body: "Service not allowed for the destination in Update Drop Location", iconText: iconText)
                warning.button?.isHidden = true
                var warningConfig = SwiftMessages.defaultConfig
                warningConfig.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
                SwiftMessages.show(config: warningConfig, view: warning)
                self.error = 1
            }
            else{
            let ref1 = FIRDatabase.database().reference().child("riders_location").child(self.appDelegate.userid!).child("Updatelocation")
            ref1.updateChildValues(["0": String(self.updatedropLocation.coordinate.latitude)])
            ref1.updateChildValues(["1": String(self.updatedropLocation.coordinate.longitude)])
            }
        }
        if(self.addorhidedestinationlbl.text == "Hide & Discard Location"){
        if(location1lbl.text != "" && location1lbl.text != "Location 1"){
            if(self.dropCountry1 != self.countryStatic){
                
                let warning = MessageView.viewFromNib(layout: .CardView)
                warning.configureTheme(.warning)
                warning.configureDropShadow()
                let iconText = "" //"🤔"
                warning.configureContent(title: "", body: "Service not allowed for the destination in Location 1", iconText: iconText)
                warning.button?.isHidden = true
                var warningConfig = SwiftMessages.defaultConfig
                warningConfig.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
                SwiftMessages.show(config: warningConfig, view: warning)
                self.error = 1
            }
            else{
            count += 1
            let ref1 = FIRDatabase.database().reference().child("riders_location").child(self.appDelegate.userid!).child("DestinationWaypoints").child("WayPoint \(count)")
            ref1.updateChildValues(["Address": location1lbl.text!])
            ref1.updateChildValues(["CountryCode": "IN"])
            let ref2 = ref1.child("Coordinates")
            ref2.updateChildValues(["0": self.updatedropLocation1.coordinate.latitude])
            ref2.updateChildValues(["1": self.updatedropLocation1.coordinate.longitude])
            }
            if(self.waypointmerge == ""){
                self.waypointmerge =  "\(String(self.updatedropLocation1.coordinate.latitude))|\(String(self.updatedropLocation1.coordinate.longitude))" as NSString
                print(self.waypointmerge)
                self.waypointaddress = "\(location1lbl.text!)" as NSString
                print(self.waypointaddress)
                self.waypointcountrycode = "IN" as NSString
                print(self.waypointcountrycode)
                self.appDelegate.waypointaddress = self.waypointaddress
                self.appDelegate.waypointcountrycode = self.waypointcountrycode
                self.appDelegate.waypointmerge = self.waypointmerge
                
            }
            else{
               
                    self.waypointmerge =  "\(self.waypointmerge),\(String(self.updatedropLocation1.coordinate.latitude))|\(String(self.updatedropLocation1.coordinate.longitude))" as NSString
                    print(self.waypointmerge)
                
                    self.waypointaddress =  "\(self.waypointaddress)|\(location1lbl.text!)" as NSString
                    print(self.waypointmerge)
                
                    self.waypointcountrycode =  "\(self.waypointcountrycode),IN" as NSString
                    print(self.waypointcountrycode)
                
                self.appDelegate.waypointaddress = self.waypointaddress
                self.appDelegate.waypointcountrycode = self.waypointcountrycode
                self.appDelegate.waypointmerge = self.waypointmerge
               
            }
        }
        if(location2lbl.text != "" && location2lbl.text != "Location 2"){
            if(self.dropCountry2 != self.countryStatic){
                
                let warning = MessageView.viewFromNib(layout: .CardView)
                warning.configureTheme(.warning)
                warning.configureDropShadow()
                let iconText = "" //"🤔"
                warning.configureContent(title: "", body: "Service not allowed for the destination in Location 2", iconText: iconText)
                warning.button?.isHidden = true
                var warningConfig = SwiftMessages.defaultConfig
                warningConfig.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
                SwiftMessages.show(config: warningConfig, view: warning)
                self.error = 1
            }
            else{
            count += 1
            let ref1 = FIRDatabase.database().reference().child("riders_location").child(self.appDelegate.userid!).child("DestinationWaypoints").child("WayPoint \(count)")
            ref1.updateChildValues(["Address": location2lbl.text!])
            ref1.updateChildValues(["CountryCode": "IN"])
            let ref2 = ref1.child("Coordinates")
            ref2.updateChildValues(["0": self.updatedropLocation2.coordinate.latitude])
            ref2.updateChildValues(["1": self.updatedropLocation2.coordinate.longitude])
            }
            if(self.waypointmerge == ""){
                self.waypointmerge =  "\(String(self.updatedropLocation2.coordinate.latitude))|\(String(self.updatedropLocation2.coordinate.longitude))" as NSString
                print(self.waypointmerge)
                self.waypointaddress = "\(location2lbl.text!)" as NSString
                print(self.waypointaddress)
                self.waypointcountrycode = "IN" as NSString
                print(self.waypointcountrycode)
                self.appDelegate.waypointaddress = self.waypointaddress
                self.appDelegate.waypointcountrycode = self.waypointcountrycode
                self.appDelegate.waypointmerge = self.waypointmerge
                
            }
            else{
                
                self.waypointmerge =  "\(self.waypointmerge),\(String(self.updatedropLocation2.coordinate.latitude))|\(String(self.updatedropLocation2.coordinate.longitude))" as NSString
                print(self.waypointmerge)
                
                self.waypointaddress =  "\(self.waypointaddress)|\(location2lbl.text!)" as NSString
                print(self.waypointmerge)
                
                self.waypointcountrycode =  "\(self.waypointcountrycode),IN" as NSString
                print(self.waypointcountrycode)
                
                self.appDelegate.waypointaddress = self.waypointaddress
                self.appDelegate.waypointcountrycode = self.waypointcountrycode
                self.appDelegate.waypointmerge = self.waypointmerge
                
            }
        }
        if(location3lbl.text != "" && location3lbl.text != "Location 3"){
            if(self.dropCountry3 != self.countryStatic){
                
                let warning = MessageView.viewFromNib(layout: .CardView)
                warning.configureTheme(.warning)
                warning.configureDropShadow()
                let iconText = "" //"🤔"
                warning.configureContent(title: "", body: "Service not allowed for the destination in Location 3", iconText: iconText)
                warning.button?.isHidden = true
                var warningConfig = SwiftMessages.defaultConfig
                warningConfig.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
                SwiftMessages.show(config: warningConfig, view: warning)
                self.error = 1
            }
            else{
            count += 1
            let ref1 = FIRDatabase.database().reference().child("riders_location").child(self.appDelegate.userid!).child("DestinationWaypoints").child("WayPoint \(count)")
            ref1.updateChildValues(["Address": location3lbl.text!])
            ref1.updateChildValues(["CountryCode": "IN"])
            let ref2 = ref1.child("Coordinates")
            ref2.updateChildValues(["0": self.updatedropLocation3.coordinate.latitude])
            ref2.updateChildValues(["1": self.updatedropLocation3.coordinate.longitude])
            }
            if(self.waypointmerge == ""){
                self.waypointmerge =  "\(String(self.updatedropLocation3.coordinate.latitude))|\(String(self.updatedropLocation3.coordinate.longitude))" as NSString
                print(self.waypointmerge)
                self.waypointaddress = "\(location3lbl.text!)" as NSString
                print(self.waypointaddress)
                self.waypointcountrycode = "IN" as NSString
                print(self.waypointcountrycode)
                self.appDelegate.waypointaddress = self.waypointaddress
                self.appDelegate.waypointcountrycode = self.waypointcountrycode
                self.appDelegate.waypointmerge = self.waypointmerge
                
            }
            else{
                
                self.waypointmerge =  "\(self.waypointmerge),\(String(self.updatedropLocation3.coordinate.latitude))|\(String(self.updatedropLocation3.coordinate.longitude))" as NSString
                print(self.waypointmerge)
                
                self.waypointaddress =  "\(self.waypointaddress)|\(location3lbl.text!)" as NSString
                print(self.waypointmerge)
                
                self.waypointcountrycode =  "\(self.waypointcountrycode),IN" as NSString
                print(self.waypointcountrycode)
                self.appDelegate.waypointaddress = self.waypointaddress
                self.appDelegate.waypointcountrycode = self.waypointcountrycode
                self.appDelegate.waypointmerge = self.waypointmerge
            }
        }
        if(location4lbl.text != "" && location4lbl.text != "Location 4"){
            if(self.dropCountry4 != self.countryStatic){
                
                let warning = MessageView.viewFromNib(layout: .CardView)
                warning.configureTheme(.warning)
                warning.configureDropShadow()
                let iconText = "" //"🤔"
                warning.configureContent(title: "", body: "Service not allowed for the destination in Location 4", iconText: iconText)
                warning.button?.isHidden = true
                var warningConfig = SwiftMessages.defaultConfig
                warningConfig.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
                SwiftMessages.show(config: warningConfig, view: warning)
                self.error = 1
            }
            else{
            count += 1
            let ref1 = FIRDatabase.database().reference().child("riders_location").child(self.appDelegate.userid!).child("DestinationWaypoints").child("WayPoint \(count)")
            ref1.updateChildValues(["Address": location4lbl.text!])
            ref1.updateChildValues(["CountryCode": "IN"])
            let ref2 = ref1.child("Coordinates")
            ref2.updateChildValues(["0": self.updatedropLocation4.coordinate.latitude])
            ref2.updateChildValues(["1": self.updatedropLocation4.coordinate.longitude])
            }
            if(self.waypointmerge == ""){
                self.waypointmerge =  "\(String(self.updatedropLocation4.coordinate.latitude))|\(String(self.updatedropLocation4.coordinate.longitude))" as NSString
                print(self.waypointmerge)
                self.waypointaddress = "\(location4lbl.text!)" as NSString
                print(self.waypointaddress)
                self.waypointcountrycode = "IN" as NSString
                print(self.waypointcountrycode)
                self.appDelegate.waypointaddress = self.waypointaddress
                self.appDelegate.waypointcountrycode = self.waypointcountrycode
                self.appDelegate.waypointmerge = self.waypointmerge
            }
            else{
                
                self.waypointmerge =  "\(self.waypointmerge),\(String(self.updatedropLocation4.coordinate.latitude))|\(String(self.updatedropLocation4.coordinate.longitude))" as NSString
                print(self.waypointmerge)
                
                self.waypointaddress =  "\(self.waypointaddress)|\(location4lbl.text!)" as NSString
                print(self.waypointmerge)
                
                self.waypointcountrycode =  "\(self.waypointcountrycode),IN" as NSString
                print(self.waypointcountrycode)
                self.appDelegate.waypointaddress = self.waypointaddress
                self.appDelegate.waypointcountrycode = self.waypointcountrycode
                self.appDelegate.waypointmerge = self.waypointmerge
            }
        }
            

        
        }
        if(self.error == 0){
        print("total waypoints\(count)")
            let ref1 = FIRDatabase.database().reference().child("riders_location").child(self.appDelegate.userid!)
            ref1.updateChildValues(["WayPointCount": count])
            
        self.navigationController?.popViewController(animated: true)
        }
        
    
    }
    
    
    @IBAction func cancelact(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func addorhidedestination(_ sender: Any) {
        if(self.additionalview.isHidden == true){
            self.additionalview.isHidden = false
            self.lbl1.isHidden = false
            self.lbl2.isHidden = false
            self.additionallbl.isHidden = false
            self.addorhidedestinationlbl.text = "Hide & Discard Location"
        }
        else{
            self.additionalview.isHidden = true
            self.lbl1.isHidden = true
            self.lbl2.isHidden = true
            self.additionallbl.isHidden = true
            self.addorhidedestinationlbl.text = "Add Additional Location"
        }
    }
    /**
     * Called when an autocomplete request returns an error.
     * @param error the error that was received.
     */
    public func didFailAutocompleteWithError(_ error: Error) {
        //        resultText?.text = error.localizedDescription
        resultText?.text = error.localizedDescription
        
    }
    
    /**
     * Called when autocomplete predictions are available.
     * @param predictions an array of GMSAutocompletePrediction objects.
     */
    public func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
        //self.resultsArray.count + 1
        //self.placeAutocomplete()
        for prediction in predictions {
            
            if let prediction = prediction as GMSAutocompletePrediction!{
                self.resultsArray.append(prediction.attributedFullText.string)
            }
        }
        self.searchResultController.reloadDataWithArray(self.resultsArray)
        //   self.searchResultsTable.reloadDataWithArray(self.resultsArray)
        print("it is old")
        print(resultsArray)
        
        // for nearby
        
        let resultsStr = NSMutableString()
        print("it is new")
        
        for prediction in predictions {
            print(predictions)
            resultsStr.appendFormat("%@\n", prediction.attributedPrimaryText)
        }
        
        resultText?.text = resultsStr as String
        
    }
    
    
    func autoComplete(){
        
        let neBoundsCorner = CLLocationCoordinate2D(latitude: self.currentLocation.coordinate.latitude,
                                                    longitude: self.currentLocation.coordinate.longitude)
        let swBoundsCorner = CLLocationCoordinate2D(latitude: self.currentLocation.coordinate.latitude,
                                                    longitude: self.currentLocation.coordinate.longitude)
        let bounds = GMSCoordinateBounds(coordinate: neBoundsCorner,
                                         coordinate: swBoundsCorner)
        
        // Set up the autocomplete filter.
        let filter = GMSAutocompleteFilter()
        filter.type = .establishment
        
        // Create the fetcher.
        fetcher = GMSAutocompleteFetcher(bounds: bounds, filter: filter)
        fetcher?.delegate = self
        
        textField = UITextField(frame: CGRect(x: 5.0, y: 10.0,
                                              width: view.bounds.size.width - 5.0,
                                              height: 44.0))
        textField?.autoresizingMask = .flexibleWidth
        textField?.addTarget(self, action: #selector(textFieldDidChange(textField:)),
                             for: .editingChanged)
        
        resultText = UITextView(frame: CGRect(x: 0, y: 45.0,
                                              width: view.bounds.size.width,
                                              height: view.bounds.size.height - 45.0))
        resultText?.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        resultText?.text = "No Results"
        resultText?.isEditable = false
       
    }
    
    func textFieldDidChange(textField: UITextField) {
        fetcher?.sourceTextHasChanged(textField.text!)
    }
    
    /*func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        self.resultsArray.removeAll()
        gmsFetcher?.sourceTextHasChanged(searchText)
        
        
    }*/
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        navigationController!.isNavigationBarHidden = false
        
    }
    
    func locateWithLongitude(_ lon: Double, andLatitude lat: Double, andTitle title: String) {
        
        DispatchQueue.main.async {
            
            if(self.selectedlocationfield == "1"){
                self.updatedroploclbl.text = title
                
                let latitude = ("\(lat)" as NSString!)
                let longitude = ("\(lon)" as NSString!)
            
                self.updatedropLocation = CLLocation(latitude: lat, longitude: lon)
                
                self.getCountryForupdatedrop(myLocation: self.updatedropLocation)
           
                self.navigationController!.isNavigationBarHidden = false
                
            }
            if(self.selectedlocationfield == "2"){
                self.location1lbl.text = title
                
                let latitude = ("\(lat)" as NSString!)
                let longitude = ("\(lon)" as NSString!)
                
                self.updatedropLocation1 = CLLocation(latitude: lat, longitude: lon)
                
                self.getCountryForlocation1(myLocation: self.updatedropLocation1)
                
                self.navigationController!.isNavigationBarHidden = false
            }
            if(self.selectedlocationfield == "3"){
                self.location2lbl.text = title
                
                let latitude = ("\(lat)" as NSString!)
                let longitude = ("\(lon)" as NSString!)
                
                self.updatedropLocation2 = CLLocation(latitude: lat, longitude: lon)
                
                self.getCountryForlocation2(myLocation: self.updatedropLocation2)
                
                self.navigationController!.isNavigationBarHidden = false
            }
            if(self.selectedlocationfield == "4"){
                self.location3lbl.text = title
                
                let latitude = ("\(lat)" as NSString!)
                let longitude = ("\(lon)" as NSString!)
                
                self.updatedropLocation3 = CLLocation(latitude: lat, longitude: lon)
                
                self.getCountryForlocation3(myLocation: self.updatedropLocation3)
                
                self.navigationController!.isNavigationBarHidden = false
            }
            if(self.selectedlocationfield == "5"){
                self.location4lbl.text = title
                
                let latitude = ("\(lat)" as NSString!)
                let longitude = ("\(lon)" as NSString!)
                
                self.updatedropLocation4 = CLLocation(latitude: lat, longitude: lon)
                
                self.getCountryForlocation4(myLocation: self.updatedropLocation4)
                
                self.navigationController!.isNavigationBarHidden = false
            }
            
        }
        
    }
    
    func getCountryForupdatedrop(myLocation : CLLocation){
        
        var dynamicLocation1 = CLLocation()
        
        dynamicLocation1 = myLocation
        
        var urlstring:String = "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(dynamicLocation1.coordinate.latitude),\(dynamicLocation1.coordinate.longitude)&sensor=true&key=\(googleKey)"
        
        urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        print(urlstring)
        
        print(self.currentLocation.coordinate.latitude)
        
        
        self.getCountryWeb(url: "\(urlstring)", location: myLocation)
        
        
        
    }
    
    
    func getCountryWeb(url : String,location: CLLocation){
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
            print(url)
            //            print(response)
            do{
                
                let readableJSon:NSDictionary! = try JSONSerialization.jsonObject(with: response.data!, options: .mutableContainers) as! NSDictionary
                
                if let value = readableJSon["results"] as? [[String : AnyObject]] {
                    
                    for result in value{
                        if let addressComponents = result["address_components"] as? [[String : AnyObject]] {
                            let filteredItems = addressComponents.filter{ if let types = $0["types"] as? [String] {
                                return types.contains("country") } else { return false } }
                            if !filteredItems.isEmpty {
                                print("test_Tommy")
                                print(filteredItems[0]["short_name"] as! String)
                                
                                self.dropCountry = filteredItems[0]["long_name"] as! String
                                //self.getFirstCountry = self.countryStatic
                            }
                        }
                    }
                    
                    print(value[value.count - 1])
                    
                }
            }
            catch{
                
                print(error)
                
            }
            
        })
    }
    
    func getCountryForlocation1(myLocation : CLLocation){
            
            var dynamicLocation1 = CLLocation()
            
            dynamicLocation1 = myLocation
            
            var urlstring:String = "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(dynamicLocation1.coordinate.latitude),\(dynamicLocation1.coordinate.longitude)&sensor=true&key=\(googleKey)"
            
            urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
            print(urlstring)
            
            print(self.currentLocation.coordinate.latitude)
            
            
            self.getCountryWeb1(url: "\(urlstring)", location: myLocation)
            
        
    }
        
    func getCountryWeb1(url : String,location: CLLocation){
            
            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
                print(url)
                //            print(response)
                do{
                    
                    let readableJSon:NSDictionary! = try JSONSerialization.jsonObject(with: response.data!, options: .mutableContainers) as! NSDictionary
                    
                    if let value = readableJSon["results"] as? [[String : AnyObject]] {
                        
                        for result in value{
                            if let addressComponents = result["address_components"] as? [[String : AnyObject]] {
                                let filteredItems = addressComponents.filter{ if let types = $0["types"] as? [String] {
                                    return types.contains("country") } else { return false } }
                                if !filteredItems.isEmpty {
                                    print("test_Tommy")
                                    print(filteredItems[0]["short_name"] as! String)
                                    
                                    self.dropCountry1 = filteredItems[0]["long_name"] as! String
                                    //self.getFirstCountry = self.countryStatic
                                }
                            }
                        }
                        
                        print(value[value.count - 1])
                        
                    }
                }
                catch{
                    
                    print(error)
                    
                }
                
            })
    }
    
    func getCountryForlocation2(myLocation : CLLocation){
                
                var dynamicLocation1 = CLLocation()
                
                dynamicLocation1 = myLocation
                
                var urlstring:String = "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(dynamicLocation1.coordinate.latitude),\(dynamicLocation1.coordinate.longitude)&sensor=true&key=\(googleKey)"
                
                urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
                print(urlstring)
                
                print(self.currentLocation.coordinate.latitude)
                
                
                self.getCountryWeb2(url: "\(urlstring)", location: myLocation)
                
        
    }
    
    
    func getCountryWeb2(url : String,location: CLLocation){
                
                Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
                    print(url)
                    //            print(response)
                    do{
                        
                        let readableJSon:NSDictionary! = try JSONSerialization.jsonObject(with: response.data!, options: .mutableContainers) as! NSDictionary
                        
                        if let value = readableJSon["results"] as? [[String : AnyObject]] {
                            
                            for result in value{
                                if let addressComponents = result["address_components"] as? [[String : AnyObject]] {
                                    let filteredItems = addressComponents.filter{ if let types = $0["types"] as? [String] {
                                        return types.contains("country") } else { return false } }
                                    if !filteredItems.isEmpty {
                                        print("test_Tommy")
                                        print(filteredItems[0]["short_name"] as! String)
                                        
                                        self.dropCountry2 = filteredItems[0]["long_name"] as! String
                                        //self.getFirstCountry = self.countryStatic
                                    }
                                }
                            }
                            
                            print(value[value.count - 1])
                            
                        }
                    }
                    catch{
                        
                        print(error)
                        
                    }
                    
                })
    }
    
    func getCountryForlocation3(myLocation : CLLocation){
                    
                    var dynamicLocation1 = CLLocation()
                    
                    dynamicLocation1 = myLocation
                    
                    var urlstring:String = "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(dynamicLocation1.coordinate.latitude),\(dynamicLocation1.coordinate.longitude)&sensor=true&key=\(googleKey)"
                    
                    urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
                    print(urlstring)
                    
                    print(self.currentLocation.coordinate.latitude)
                    
                    
                    self.getCountryWeb3(url: "\(urlstring)", location: myLocation)
                    
        
    }
    
    
    func getCountryWeb3(url : String,location: CLLocation){
                        
                        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
                            print(url)
                            //            print(response)
                            do{
                                
                                let readableJSon:NSDictionary! = try JSONSerialization.jsonObject(with: response.data!, options: .mutableContainers) as! NSDictionary
                                
                                if let value = readableJSon["results"] as? [[String : AnyObject]] {
                                    
                                    for result in value{
                                        if let addressComponents = result["address_components"] as? [[String : AnyObject]] {
                                            let filteredItems = addressComponents.filter{ if let types = $0["types"] as? [String] {
                                                return types.contains("country") } else { return false } }
                                            if !filteredItems.isEmpty {
                                                print("test_Tommy")
                                                print(filteredItems[0]["short_name"] as! String)
                                                
                                                self.dropCountry3 = filteredItems[0]["long_name"] as! String
                                                //self.getFirstCountry = self.countryStatic
                                            }
                                        }
                                    }
                                    
                                    print(value[value.count - 1])
                                    
                                }
                            }
                            catch{
                                
                                print(error)
                                
                            }
                            
                        })
    }
    
    func getCountryForlocation4(myLocation : CLLocation){
                            
                            var dynamicLocation1 = CLLocation()
                            
                            dynamicLocation1 = myLocation
                            
                            var urlstring:String = "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(dynamicLocation1.coordinate.latitude),\(dynamicLocation1.coordinate.longitude)&sensor=true&key=\(googleKey)"
                            
                            urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
                            print(urlstring)
                            
                            print(self.currentLocation.coordinate.latitude)
                            
                            
                            self.getCountryWeb4(url: "\(urlstring)", location: myLocation)
                            
        
    }
    
    
    func getCountryWeb4(url : String,location: CLLocation){
                            
                            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
                                print(url)
                                //            print(response)
                                do{
                                    
                                    let readableJSon:NSDictionary! = try JSONSerialization.jsonObject(with: response.data!, options: .mutableContainers) as! NSDictionary
                                    
                                    if let value = readableJSon["results"] as? [[String : AnyObject]] {
                                        
                                        for result in value{
                                            if let addressComponents = result["address_components"] as? [[String : AnyObject]] {
                                                let filteredItems = addressComponents.filter{ if let types = $0["types"] as? [String] {
                                                    return types.contains("country") } else { return false } }
                                                if !filteredItems.isEmpty {
                                                    print("test_Tommy")
                                                    print(filteredItems[0]["short_name"] as! String)
                                                    
                                                    self.dropCountry4 = filteredItems[0]["long_name"] as! String
                                                    //self.getFirstCountry = self.countryStatic
                                                }
                                            }
                                        }
                                        
                                        print(value[value.count - 1])
                                        
                                    }
                                }
                                catch{
                                    
                                    print(error)
                                    
                                }
                                
                            })
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
