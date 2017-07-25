//
//  SearchResultsController.swift
//  PlacesLookup
//
//  Created by Malek T. on 9/30/15.
//  Copyright © 2015 Medigarage Studios LTD. All rights reserved.
//

import UIKit


public let ErrorDomain: String! = "GooglePlacesAutocompleteErrorDomain"

public struct LocationBias {
    public let latitude: Double
    public let longitude: Double
    public let radius: Int
    
    public init(latitude: Double = 0, longitude: Double = 0, radius: Int = 20000000) {
        self.latitude = latitude
        self.longitude = longitude
        self.radius = radius
    }
    
    public var location: String {
        return "\(latitude),\(longitude)"
    }
}

enum PlaceType2: CustomStringConvertible {
    case all
    case geocode
    case address
    case establishment
    case regions
    case cities
    
    var description : String {
        switch self {
        case .all: return ""
        case .geocode: return "geocode"
        case .address: return "address"
        case .establishment: return "establishment"
        case .regions: return "regions"
        case .cities: return "cities"
        }
    }
}

struct Place2 {
    let id: String
    let description: String
    let place_id: String
}



protocol LocateOnTheMap{
    func locateWithLongitude(_ lon:Double, andLatitude lat:Double, andTitle title: String)
}

class SearchResultsController: UITableViewController {
    
    var places = [Place2]()
    var placetype = [PlaceType2]()
    var webservice8 = ""
    
    var placeid = ""
    
    var placeType: PlaceType2 = .all

    
    var searchResults: [String]!
    var delegate: LocateOnTheMap!
    
    
    var placeID = ""
    
    var googleKey = "AIzaSyDMqU_zWVuR0FziY_i69DyWHtiNZj0gjY8"
    
//    var googleKey = "AIzaSyCP7fWdMSHNzfDwJMicupFGSjKIBdfMHvM" // temporary

    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchResults = Array()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellIdentifier")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.searchResults.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath)
        
        cell.textLabel?.text = self.searchResults[indexPath.row]
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath){
        // 1
        //        let urlpath = "https://maps.googleapis.com/maps/api/geocode/json?address=\(self.searchResults[indexPath.row])&sensor=false".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        // old key ==> AIzaSyD_nwCI7RqGsWkwWeEoJb-KkdVaIfDhFxc
        let urlpath = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=\(self.searchResults[indexPath.row])&key=\(googleKey)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
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
                                    
                                    self.getLatLong(place_id: place_id,result:self.searchResults[indexPath.row])

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

                    
                    
                    
                    self.delegate.locateWithLongitude(lon, andLatitude: lat, andTitle: self.searchResults[indexPath.row])
                    }
                }
                
            }catch {
                print("Error")
            }


        }
        // 5
        task.resume()
        self.dismiss(animated: true, completion: nil)

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
                                print(lat!)
                                print(long!)
//                                let lat = Double(lat1)
//                                let long = Double(long1)
                                self.delegate.locateWithLongitude(long! as! Double, andLatitude: lat! as! Double, andTitle: result)

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
    
    
    func reloadDataWithArray(_ array:[String]){
        self.searchResults = array
        self.tableView.reloadData()
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     if editingStyle == .Delete {
     // Delete the row from the data source
     tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
     } else if editingStyle == .Insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    func getPlaces(_ searchString: String) {
        let request = requestForSearch(searchString)
        // let session = URLSession.shared
        //        let task = session.dataTask(with: request, completionHandler: { data, response, error in
        //           self.handleResponse(data, response: response as, error: Error?)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
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
        
        let serializationError: NSError! = error
        let json: NSDictionary = (try! JSONSerialization.jsonObject(
            with: data,
            options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
        
        if let error = serializationError {
            print("GooglePlacesAutocomplete Error: \(error.localizedDescription)")
            return
        }
        
        // Perform table updates on UI thread
        DispatchQueue.main.async(execute: {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            if let predictions = json["predictions"] as? Array<AnyObject>
            {
                self.places = predictions.map
                    { (prediction: AnyObject) -> Place2 in
                        return Place2(
                            id: prediction["id"] as! String,
                            description: prediction["description"] as! String,
                            place_id: prediction["place_id"] as! String
                        )
                }
                
            }
        })
        
    }
    
    
    func requestForSearch(_ searchString: String) -> URLRequest {
        
        let searchString = searchString.replacingOccurrences(of: "Optional", with: "")
        let place_type = self.placeType.description.replacingOccurrences(of: "Optional", with: "")
        let key_google = ""
        
        print("print1\(searchString)")
        print("print2\(place_type)")
        print("print3\(key_google)")
        
        let params = [
            "input": searchString,
            //"type": "(\(placeType.description))",
            //"type": "",
            "key": ""
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

    
    
}
