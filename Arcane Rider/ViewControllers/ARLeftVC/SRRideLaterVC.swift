//
//  SRRideLaterVC.swift
//  SIX Rider
//
//  Created by Apple on 06/03/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit
import SwiftMessages
import Alamofire
import DatePickerDialog
import GoogleMaps
import GooglePlaces
import CoreLocation
import Firebase
import GeoFire

class SRRideLaterVC: UIViewController,UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate,GMSAutocompleteFetcherDelegate,LocateOnTheMap {

    //searchbarfunction
    let geocorder:CLGeocoder = CLGeocoder()
    var places = [Place]()
    var placeType: PlaceType = .all
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newLength = (searchBar.text!).characters.count + text.characters.count - range.length
        return newLength <= 30
    }
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet weak var labelPickUpDate : UILabel!
    @IBOutlet weak var labelPickUpTime : UILabel!
    @IBOutlet weak var tableViewCarCategory : UITableView!
    @IBOutlet weak var labelPickUpAddress : UILabel!
    @IBOutlet weak var labelDropAddress : UILabel!
    @IBOutlet weak var viewCarCategory : UIView!

    @IBOutlet weak var labelCarCategory : UILabel!

    @IBOutlet weak var activityView: UIActivityIndicatorView!
    @IBOutlet weak var searchview: UIView!

    @IBOutlet weak var searchTable: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var totalArrayOfCars:NSMutableArray=NSMutableArray()

    var liveURL = live_url
    
    typealias jsonSTD = NSArray

    var searchResultController: SearchResultsController!
    var resultsArray = [String]()
    var gmsFetcher: GMSAutocompleteFetcher!
    
    var fetcher: GMSAutocompleteFetcher?
    var resultText: UITextView?
    var textField: UITextField?

    var currentLocation = CLLocation()

    var pickUp = ""
    var startLong = ""
    var startLat = ""
    var endLat = ""
    var endLong = ""
    var amountPass = ""
    var dropCountry:String! = "None"
    var pickupcountry:String! = "None"
    
    var pickupLocation = CLLocation()
    var dropLocation = CLLocation()
    
    var placeID = ""

    var googleKey = "AIzaSyDMqU_zWVuR0FziY_i69DyWHtiNZj0gjY8"
//    var googleKey = "AIzaSyCP7fWdMSHNzfDwJMicupFGSjKIBdfMHvM" // temporary

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //searchbarfunction
        searchview.isHidden = true
        self.searchBar?.delegate = self
        
        self.tableViewCarCategory.isHidden = true
        
        self.labelPickUpDate.text = "Pickup Date"
        self.labelDropAddress.text = "Drop Address"
        self.labelPickUpTime.text = "Pickup Time"
        self.labelPickUpAddress.text = "Pickup Address"
        
        self.labelPickUpTime.textColor = UIColor.lightGray
        self.labelDropAddress.textColor = UIColor.lightGray
        self.labelPickUpAddress.textColor = UIColor.lightGray
        self.labelPickUpDate.textColor = UIColor.lightGray
        
        

        navigationController!.isNavigationBarHidden = false
        
        navigationController!.navigationBar.barStyle = .black
        
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "arrow-left.png")!, for: .normal)
        button.addTarget(self, action: #selector(SRRideLaterVC.profileBtn(_:)), for: .touchUpInside)
        //CGRectMake(0, 0, 53, 31)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        //(frame: CGRectMake(3, 5, 50, 20))
        let label = UILabel(frame: CGRect(x: 20, y: 5, width: 100, height: 20))
        // label.font = UIFont(name: "Arial-BoldMT", size: 13)
        label.text = "Ride Later"
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.clear
        button.addSubview(label)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = barButton
        
        self.viewCarCategory.layer.borderColor = UIColor.black.cgColor
        self.viewCarCategory.layer.borderWidth = 1.0
        
        searchResultController = SearchResultsController()
        searchResultController.delegate = self
        gmsFetcher = GMSAutocompleteFetcher()
        gmsFetcher.delegate = self

        tableViewCarCategory.register((UINib(nibName: "UploadCell", bundle: nil)), forCellReuseIdentifier: "uploadCell")

        self.callCarsList()
        
    }

    
    override func viewWillAppear(_ animated: Bool) {
        
        UIApplication.shared.isIdleTimerDisabled = false
        
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
        navigationController!.navigationBar.barStyle = .black
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
        navigationController!.navigationBar.barStyle = .black
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func backinsearch(_ sender: Any) {
        searchview.isHidden = true
        searchBar.resignFirstResponder()
        navigationController!.isNavigationBarHidden = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    func profileBtn(_ Selector: AnyObject) {
        
        appDelegate.leftMenu()
        
    }
    @IBAction func btnCarCategoryAction(_ sender: Any) {
        
        self.tableViewCarCategory.isHidden = false
        
    }
    
    
    @IBAction func btnPickUpDateAction(_ sender: Any) {
        
        let currentDate = Date()
        
        DatePickerDialog().show(title: "Pickup Date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", minimumDate: currentDate, datePickerMode: .dateAndTime) {
            (date) -> Void in
            var datePass = "\(date)"
            
            print(datePass)
            if datePass == "nil"{
                
                self.labelPickUpDate.textColor = UIColor.clear

            }
            else{
                
                datePass = datePass.replacingOccurrences(of: "Optional(", with: "")
                datePass = datePass.replacingOccurrences(of: ")", with: "")

                let timestamp = "\(datePass)"
                let formatter = DateFormatter()
                formatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
                let date = formatter.date(from: timestamp)
                formatter.dateFormat = "dd-MM-yyyy"
                let st = formatter.string(from: date!)
                print(st)

                
               // print("\(dateString)")
                
                
                self.labelPickUpDate.text = "\(st)"
                self.labelPickUpDate.textColor = UIColor.black
                
                let timestamp1 = "\(datePass)"
                let formatter1 = DateFormatter()
                // formatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
                formatter1.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
                let time = formatter1.date(from: timestamp1)
                // formatter.dateFormat = "dd-MM-yyyy"
                // formatter.dateFormat = "h:mm a 'on' MMMM dd, yyyy"
                formatter1.dateFormat = "h:mm a"
                formatter1.amSymbol = "AM"
                formatter1.pmSymbol = "PM"
                let st1 = formatter1.string(from: time!)
                print(st1)
                
                self.labelPickUpTime.text = "\(st1)"
                self.labelPickUpTime.textColor = UIColor.black
            }
            
        }
        
    }
    @IBAction func btnPickUpTimeAction(_ sender: Any) {
        
        let currentDate = Date()
        
        
        DatePickerDialog().show(title: "Pickup Time", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", minimumDate: currentDate, datePickerMode: .dateAndTime) {
            (time) -> Void in
            
            var timePass = "\(time)"
            
            if timePass == "nil"{
             
                self.labelPickUpTime.textColor = UIColor.clear
            }
            else{
                
                timePass = timePass.replacingOccurrences(of: "Optional(", with: "")
                timePass = timePass.replacingOccurrences(of: ")", with: "")
                
                let timestamp = "\(timePass)"
                let formatter = DateFormatter()
                formatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
                let date = formatter.date(from: timestamp)
                formatter.dateFormat = "dd-MM-yyyy"
                let st = formatter.string(from: date!)
                print(st)
                
                
                // print("\(dateString)")
                
                
                self.labelPickUpDate.text = "\(st)"
                self.labelPickUpDate.textColor = UIColor.black
                
                let timestamp1 = "\(timePass)"
                let formatter1 = DateFormatter()
                // formatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
                formatter1.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
                let time = formatter1.date(from: timestamp1)
                // formatter.dateFormat = "dd-MM-yyyy"
                // formatter.dateFormat = "h:mm a 'on' MMMM dd, yyyy"
                formatter1.dateFormat = "h:mm a"
                formatter1.amSymbol = "AM"
                formatter1.pmSymbol = "PM"
                let st1 = formatter1.string(from: time!)
                print(st1)
                
                self.labelPickUpTime.text = "\(st1)"
                self.labelPickUpTime.textColor = UIColor.black
            }
            
        }
    }
    @IBAction func btnPickUpAddrAction(_ sender: Any) {
        
        navigationController!.isNavigationBarHidden = true

        /*let searchController = UISearchController(searchResultsController: searchResultController)
        
        searchController.searchBar.delegate = self
        
        self.present(searchController, animated:true, completion: nil)*/
        searchview.isHidden = false
        searchBar.becomeFirstResponder()
        searchBar.text = ""
        searchTable?.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.searchTable?.isHidden = true
        
        self.pickUp = "1 select"
    }
    @IBAction func btnDropAddrAction(_ sender: Any) {
        
        navigationController!.isNavigationBarHidden = true

        /*let searchController = UISearchController(searchResultsController: searchResultController)
        
        searchController.searchBar.delegate = self
        
        self.present(searchController, animated:true, completion: nil)*/
        searchview.isHidden = false
        searchBar.becomeFirstResponder()
        searchBar.text = ""
        searchTable?.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.searchTable?.isHidden = true
        
        self.pickUp = "2 select"
    }
    
    @IBAction func btnScheduleAction(_ sender: Any) {
    
        print("pickupCountry \(self.pickupcountry!)")
        print("dropCountry \(self.dropCountry!)")
        
        if labelPickUpDate.text == "Pickup Date"{
            
            self.showError(errorMSG: "Pickup Date")
        }
        else if labelPickUpTime.text == "Pickup Time"{
            
            self.showError(errorMSG: "Pickup Time")

        }
        else if labelPickUpAddress.text == "Pickup Address"{
            
            self.showError(errorMSG: "Pickup Address")
        }
        else if labelDropAddress.text == "Drop Address"{
            
            self.showError(errorMSG: "Drop Address")
        }
        else if labelCarCategory.text == "Select Car Category"{
            
            self.showError(errorMSG: "Select Car Category")
        }
        else if self.pickupcountry != self.dropCountry{
            
            let warning = MessageView.viewFromNib(layout: .CardView)
            warning.configureTheme(.warning)
            warning.configureDropShadow()
            let iconText = "" //"🤔"
            warning.configureContent(title: "", body: "Service not allowed for this destination", iconText: iconText)
            warning.button?.isHidden = true
            var warningConfig = SwiftMessages.defaultConfig
            warningConfig.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
            SwiftMessages.show(config: warningConfig, view: warning)
            
        }
        else{
            
            self.scheduleTripAPI()
            
        }
        
    }
    
    
    
    func showError(errorMSG : String){
        
        let warning = MessageView.viewFromNib(layout: .CardView)
        warning.configureTheme(.warning)
        warning.configureDropShadow()
        let iconText = "" //"🤔"
        warning.configureContent(title: "", body: "\(errorMSG)", iconText: iconText)
        warning.button?.isHidden = true
        var warningConfig = SwiftMessages.defaultConfig
        warningConfig.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
        SwiftMessages.show(config: warningConfig, view: warning)

    }
    
    func scheduleTripAPI(){
        
        
        //http://demo.cogzideltemplates.com/tommy/requests/rideLater/userid/5854c286da71b4d6308b4567/start_lat/32.2/start_long/33.3/end_lat/43.3/end_long/44.4/pickup_address/madurai tamil nadu/drop_address/chennai tamil nadu/category/xx/date_time/10-03-2017 11:00 AM/payment_mode/stripe
        
        let value = UserDefaults.standard.object(forKey: "cashMode") as! String!
        if value == nil{
            
            self.amountPass = "cash"
        }
        else if value == "cash"{
            
            self.amountPass = "cash"
        }
        else if value == "corporate id"{
            
            self.amountPass = "corpID"
        }
        else{
            
            self.amountPass = "stripe"
        }
        
        
        let pickupTime = self.labelPickUpTime.text
        let pickUpDate = self.labelPickUpDate.text
        let carCategory = labelCarCategory.text
        let startAddress = self.labelPickUpAddress.text
        let endAddress = self.labelDropAddress.text
        print(endAddress)
        
        
        
        activityView.startAnimating()
        
        var urlstring:String = "\(liveURL)requests/rideLater/userid/\(self.appDelegate.userid!)/start_lat/\(self.startLat)/start_long/\(self.startLong)/end_lat/\(self.endLat)/end_long/\(self.endLong)/pickup_address/\(startAddress)/drop_address/\(endAddress)/category/\(carCategory)/date_time/\(pickUpDate) \(pickupTime)/payment_mode/\(self.amountPass)"
        
        urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        
        urlstring = urlstring.removingPercentEncoding!
        
        urlstring = urlstring.replacingOccurrences(of: "Optional(", with: "")
        
        urlstring = urlstring.replacingOccurrences(of: ")", with: "")

        urlstring = urlstring.replacingOccurrences(of: "\"", with: "")

        urlstring = urlstring.replacingOccurrences(of: ",", with: "")

        urlstring = urlstring.replacingOccurrences(of: " ", with: "%20")

        //   urlstring = UTF8.decode(urlstring)
        print(urlstring)
        
        self.callRideLaterAPI(url: "\(urlstring)")
        
        
    }
    
    
    func callRideLaterAPI(url : String){
        
        activityView.startAnimating()
        
        Alamofire.request(url).responseJSON { (response) in
            
            self.parseData(JSONData: response.data!)
            
        }
        
    }
    
    
    func parseData(JSONData : Data){
        
        do{
            
            let readableJSon = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as! jsonSTD
            
            print(" !!! \(readableJSon[0])")
            
            let value = readableJSon[0] as AnyObject
            
            if let final = value.object(forKey: "status"){
                print(final)
                if(final as! String == "Success"){
                    
                    self.showSuccessAlert(successMSG: "Saved Successfully")

                    activityView.stopAnimating()

                    appDelegate.leftMenu()
                    
                    let req_id:NSString = value.object(forKey: "request_id") as! NSString!
                    
                    if(req_id != "" || req_id != "null" || req_id != nil){
                        self.appDelegate.ridelaterreqid = req_id as String!
                    }
                    var ref1 = FIRDatabase.database().reference()
                    
                    var userId = self.appDelegate.userid!
                    
                    var ridelaterreid = self.appDelegate.ridelaterreqid!
                    
                    let newUser = [
                        
                        "status": "0",
                       
                    ]
                    
                    
                    
                    var appendingPath = ref1.child(byAppendingPath: "ride_later")
                    
                    var appendingPath1 = ref1.child(byAppendingPath: "ride_later")
                    
                    
                    var appendingPath2 = appendingPath.child(byAppendingPath: userId)
                    
                    appendingPath2.child(byAppendingPath: ridelaterreid).setValue(newUser)
                }
                else{
                    
                    activityView.stopAnimating()

                    let message = value.object(forKey: "status") as? String
                    
                    print("\(message)")
                    
                    self.showError(errorMSG: "\(message!)")
                }
            }
        }
        catch{
            
            activityView.stopAnimating()
            
            print(error)
            
        }
        
    }
    
    func showSuccessAlert(successMSG : String){
        
        
        let iconText = "" //"🤔"
        let success = MessageView.viewFromNib(layout: .CardView)
        success.configureTheme(.success)
        success.configureDropShadow()
        success.configureContent(title: "", body: "\(successMSG)", iconText: iconText)
        success.button?.isHidden = true
        var successConfig = SwiftMessages.defaultConfig
        successConfig.presentationStyle = .top
        successConfig.presentationContext = .window(windowLevel: UIWindowLevelNormal)
        
        SwiftMessages.show(config: successConfig, view: success)
    }
    
    
    func callCarsList(){
        
        totalArrayOfCars.removeAllObjects()
                
        var urlstring:String = "\(liveURL)settings/getCategory"
        
        
        urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        
        print(urlstring)
        
        let manager : AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
        
        manager.responseSerializer.acceptableContentTypes =  NSSet(objects: "text/plain", "text/html", "application/json", "audio/wav", "application/octest-stream") as Set<NSObject>
        
        manager.get("\(urlstring)",
            parameters: nil,
            success: { (operation: AFHTTPRequestOperation?,responseObject: Any?) in
                
                let jsonObjects:NSArray = responseObject as! NSArray
                
                if jsonObjects.count == 0{
                    
                    
                }
                for dataDict : Any in jsonObjects
                {
                    
                    if jsonObjects.count == 0{
                        
                        
                    }
                    else{
                        
                        
                        let carList = (dataDict as AnyObject).object(forKey: "categoryname") as? String
                        print("carList\(carList)")
                        
                        self.totalArrayOfCars.add(carList! as String)
                    }
                    
                    
                }
                
                self.tableViewCarCategory.reloadData()
        },
            failure: { (operation: AFHTTPRequestOperation?,error: Error) in
                print("Error: " + error.localizedDescription)
                
        })
        
    }
    
    // MARK: UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(tableView == searchTable){
            return 44.0
        }
        else{
            return 25.0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == searchTable){
            return places.count
        }
        else{
            return totalArrayOfCars.count;
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(tableView == searchTable){
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            let place = self.places[(indexPath as NSIndexPath).row]
            cell.textLabel!.text = place.description
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            return cell
        }
        else{
            let cell:UploadCell = tableView.dequeueReusableCell(withIdentifier: "uploadCell") as! UploadCell!
        
            let cars = totalArrayOfCars.object(at: indexPath.row) as? String
        
            if cars == nil || cars == ""{
            
            
            }
            else{
            
                cell.labelCar.text = "  \(cars!)"
            }
        
            return cell
        }
    }
    
    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(tableView == searchTable){
            
            self.searchBar.resignFirstResponder()
            self.searchBar.text = self.places[(indexPath as NSIndexPath).row].description
            searchTable.isHidden = true
            searchview.isHidden = true
            
            navigationController!.isNavigationBarHidden = false
            
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
        else{
            tableView.deselectRow(at: indexPath, animated: false)
            labelCarCategory.text = totalArrayOfCars.object(at: indexPath.row) as? String
            tableView.isHidden = true
        }
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

   /* func placeAutocomplete() {
        
        let visibleRegion = viewMapArcane.projection.visibleRegion()
        let bounds = GMSCoordinateBounds(coordinate: (CLLocationCoordinate2DMake(9.9239, 78.1140)), coordinate: (CLLocationCoordinate2DMake(9.9239, 78.1140)))
        
        let filter = GMSAutocompleteFilter()
        //GMSPlacesClient.provideAPIKey("AIzaSyCuhsdolQuBDwCyapB9fhqgw_ZIhlGAzBk")
        filter.type = .establishment
        placesClient.autocompleteQuery("Madurai", bounds: bounds, filter: filter, callback: {
            (results, error) -> Void in
            guard error == nil else {
                print("Autocomplete error \(error)")
                return
            }
            if let results = results {
                for result in results {
                    print("Result \(result.attributedFullText) with placeID \(result.placeID)")
                }
            }
        })
    }*/
    
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
        
        //view.addSubview(textField!)
        //view.addSubview(resultText!)
        
        
        
    }
    
    func textFieldDidChange(textField: UITextField) {
        fetcher?.sourceTextHasChanged(textField.text!)
    }
    
    /*func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // getPlaces(searchText)
        //tableoutlet.reloadData()
        self.resultsArray.removeAll()
        gmsFetcher?.sourceTextHasChanged(searchText)
        
        
    }*/
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        navigationController!.isNavigationBarHidden = false

    }
    
    func locateWithLongitude(_ lon: Double, andLatitude lat: Double, andTitle title: String) {
        
        DispatchQueue.main.async {
            
            if self.pickUp == "1 select"{
                
                self.labelPickUpAddress.text = title
                
                let latitude = ("\(lat)" as NSString!)
                let longitude = ("\(lon)" as NSString!)
                self.startLat = "\(latitude)"
                self.startLong = "\(longitude)"
                
                self.labelPickUpAddress.textColor = UIColor.black
            
                self.pickupLocation = CLLocation(latitude: lat, longitude: lon)
                
                self.getCountryForpickup(myLocation: self.pickupLocation)
            }
            else{
                
                self.labelDropAddress.text = title
                
                let latitude = ("\(lat)" as NSString!)
                let longitude = ("\(lon)" as NSString!)
                
                self.endLat = "\(latitude)"
                self.endLong = "\(longitude)"
                
                self.labelDropAddress.textColor = UIColor.black
                
                self.dropLocation = CLLocation(latitude: lat, longitude: lon)
                
                self.getCountryForDrop(myLocation: self.dropLocation)
            }
          
            
            
            self.navigationController!.isNavigationBarHidden = false

        }
        
    }
    
    func getCountryForpickup(myLocation : CLLocation){
        
        var dynamicLocation1 = CLLocation()
        
        dynamicLocation1 = myLocation
        
        
        
        var urlstring:String = "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(dynamicLocation1.coordinate.latitude),\(dynamicLocation1.coordinate.longitude)&sensor=true&key=\(googleKey)"
        
        urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        print(urlstring)
        
        print(self.currentLocation.coordinate.latitude)
        
        
        self.getCountryWeb(url: "\(urlstring)", location: myLocation)
        
        
        
    }
    
    func getCountryForDrop(myLocation : CLLocation){
        
        var dynamicLocation1 = CLLocation()
        
        dynamicLocation1 = myLocation
        
        
        
        var urlstring:String = "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(dynamicLocation1.coordinate.latitude),\(dynamicLocation1.coordinate.longitude)&sensor=true&key=\(googleKey)"
        
        urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        print(urlstring)
        
        print(self.currentLocation.coordinate.latitude)
        
        
        self.getCountryWeb1(url: "\(urlstring)", location: myLocation)
        
        
        
    }
    
    func getCountryWeb(url : String,location: CLLocation){
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
            print(url)
            //            print(response)
            do{
                
                let readableJSon:NSDictionary! = try JSONSerialization.jsonObject(with: response.data!, options: .mutableContainers) as! NSDictionary
                
                //print(" !!! \(readableJSon["results"]!)")
                
                
                
                if let value = readableJSon["results"] as? [[String : AnyObject]] {
                    
                    for result in value{
                        if let addressComponents = result["address_components"] as? [[String : AnyObject]] {
                            let filteredItems = addressComponents.filter{ if let types = $0["types"] as? [String] {
                                return types.contains("country") } else { return false } }
                            if !filteredItems.isEmpty {
                                print("test_Tommy")
                                print(filteredItems[0]["short_name"] as! String)
                                self.pickupcountry = filteredItems[0]["short_name"] as! String
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
    
    func getCountryWeb1(url : String,location: CLLocation){
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
            print(url)
            //            print(response)
            do{
                
                let readableJSon:NSDictionary! = try JSONSerialization.jsonObject(with: response.data!, options: .mutableContainers) as! NSDictionary
                
                //print(" !!! \(readableJSon["results"]!)")
                
                
                
                if let value = readableJSon["results"] as? [[String : AnyObject]] {
                    
                    for result in value{
                        if let addressComponents = result["address_components"] as? [[String : AnyObject]] {
                            let filteredItems = addressComponents.filter{ if let types = $0["types"] as? [String] {
                                return types.contains("country") } else { return false } }
                            if !filteredItems.isEmpty {
                                print("test_Tommy")
                                print(filteredItems[0]["short_name"] as! String)
                                self.dropCountry = filteredItems[0]["short_name"] as! String
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

}
