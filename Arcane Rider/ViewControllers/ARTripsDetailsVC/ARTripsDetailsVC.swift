//
//  ARTripsDetailsVC.swift
//  Arcane Rider
//
//  Created by Apple on 13/01/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit
import Alamofire
import Firebase

class ARTripsDetailsVC: UIViewController,UIScrollViewDelegate {

    @IBOutlet weak var activityView: UIActivityIndicatorView!

    @IBOutlet weak var labelDriverName: UILabel!
    @IBOutlet weak var labelCarName: UILabel!
    @IBOutlet weak var labelDistance: UILabel!
    @IBOutlet weak var labelDrop: UILabel!
    @IBOutlet weak var labelPayment: UILabel!
    @IBOutlet weak var labelAmount: UILabel!
    @IBOutlet weak var labelpick: UILabel!
    @IBOutlet weak var tollfeelbl: UILabel!
    @IBOutlet weak var bookfeelbl: UILabel!
    @IBOutlet weak var taxpercentlbl: UILabel!
    @IBOutlet weak var multidestpricelbl: UILabel!
    @IBOutlet weak var multidestcountlbl: UILabel!
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var taxx: UILabel!

    @IBOutlet weak var imageDriver: UIImageView!

    @IBOutlet weak var ratingViewDriver: HCSStarRatingView!

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var viewAPIUrl = "\(live_url)requests/getTrips/trip_id/"

    typealias jsonSTD = NSArray
    
    typealias jsonSTDAny = [String : AnyObject]
    
    internal var tripId : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let screenSize: CGRect = UIScreen.main.bounds
        
        screenSize.origin
        
        let screenHeight = screenSize.height;
        
        if((screenSize.width == 320.00) && (screenSize.height == 480.00))
            
        {
            scrollview.contentSize.height=1050
        }
        
        if((screenSize.width == 320.00) && (screenSize.height == 568.00))
            
        {
            scrollview.contentSize.height=750
        }
        
        if((screenSize.width == 414) && (screenSize.height == 736))
        {
            //scrollview.contentSize.height=800
        }
        
        if((screenSize.width == 375) && (screenSize.height == 667))
            
        {
            //scrollview.contentSize.height=750
        }
        

        
        navigationController!.navigationBar.barStyle = .black
        
        navigationController!.isNavigationBarHidden = false
        
        ratingViewDriver.maximumValue = 5
        ratingViewDriver.minimumValue = 0
        ratingViewDriver.allowsHalfStars = true

        imageDriver.layer.cornerRadius = imageDriver.frame.size.width / 2
        imageDriver.clipsToBounds = true
        
        
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "arrow-left.png")!, for: .normal)
        button.addTarget(self, action: #selector(ARTripsDetailsVC.profileBtn(_:)), for: .touchUpInside)
        //CGRectMake(0, 0, 53, 31)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        //(frame: CGRectMake(3, 5, 50, 20))
        let label = UILabel(frame: CGRect(x: 10, y: 5, width: 150, height: 20))
        // label.font = UIFont(name: "Arial-BoldMT", size: 13)
        label.text = "Trips Details"
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.clear
        button.addSubview(label)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = barButton
        

        self.activityView.startAnimating()
        
        var urlstring:String = "\(viewAPIUrl)\(self.tripId!)"
        
        urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        
        urlstring = urlstring.removingPercentEncoding!
        
        print(urlstring)
        
        self.callRideDetailsAPI(url: "\(urlstring)")
        
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

    func profileBtn(_ Selector: AnyObject) {
        
        self.navigationController?.popViewController(animated: true)
        
    }

    func callRideDetailsAPI(url : String){
        
        self.activityView.startAnimating()
        
        Alamofire.request(url).responseJSON { (response) in
            
            self.parseData(JSONData: response.data!)
        }
        
    }
    
    func parseData(JSONData : Data){
        
        do{
            
            let readableJSon = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as! jsonSTD
            
            print(" !!! \(readableJSon[0])")
            
            let value = readableJSon[0] as AnyObject
            
            if value.count == 0{
                
                self.activityView.stopAnimating()
                
                print("no Value")
            }
            else{
                
                let payment = value.object(forKey: "payment_mode") as? String
                
                if payment == nil || payment == ""{
                    
                    labelPayment.text = ""
                }
                else{
                    
                    labelPayment.text = payment!
                }
                
                let carType = value.object(forKey: "car_category") as? String

                if carType == nil || carType == ""{
                    
                    labelCarName.text = ""
                }
                else{
                    
                    labelCarName.text = carType!
                }
                
                let totalDistance = value.object(forKey: "total_distance") as? String

                if totalDistance == nil || totalDistance == ""{
                    
                    labelDistance.text = ""
                }
                else{
                    
                    labelDistance.text = "\(totalDistance!) km"
                }
                
                let pickUpAddress = value.object(forKey: "pickup_address") as? String

                if pickUpAddress == nil || pickUpAddress == ""{
                    
                    labelpick.text = "Pickup Location"
                    labelpick.textColor = UIColor.lightGray
                }
                else{
                    
                    labelpick.text = pickUpAddress!
                    labelpick.textColor = UIColor.black
                }
                
                let dropAddress = value.object(forKey: "drop_address") as? String

                if dropAddress == nil || dropAddress == ""{
                    
                    labelDrop.text = "Drop Location"
                    labelDrop.textColor = UIColor.lightGray
                }
                else{
                    
                    labelDrop.text = dropAddress!
                    labelDrop.textColor = UIColor.black

                }
                //self.ratingViewDriver.value = CGFloat(some)
                let ref = FIRDatabase.database().reference()
                print(self.tripId)
                ref.child("trips_data").child("\(self.tripId!)").child("rider_rating").observeSingleEvent(of: .value, with: { (snapshot) in
                    if(snapshot.exists()){
                        print("updating distance \(snapshot.value!)")
                        let dict = (snapshot.value! as! NSString).doubleValue
                        self.ratingViewDriver.value = CGFloat(dict)
                    }
                    //print(dict)
                 })
                let ref1 = FIRDatabase.database().reference()
                ref1.child("trips_data").child("\(self.tripId!)").child("tollfee").observeSingleEvent(of: .value, with: { (snapshot) in
                if(snapshot.exists()){
                print("update toll_fee \(String(describing: snapshot.value))")
                var dictinory = snapshot.value!
                    dictinory = (dictinory as AnyObject).replacingOccurrences(of: "Optional(", with: "")
                    dictinory = (dictinory as AnyObject).replacingOccurrences(of: ")", with: "")
                    self.tollfeelbl.text = "+$\(String(describing: dictinory))"
                }
                })
                
                    
                let price = value.object(forKey: "total_price") as? Double

                if price == nil{
                    
                    labelAmount.text = "$"
                }
                else{
                    
                    labelAmount.text = "$\(price!)"
                    labelAmount.textColor = UIColor.black
                    
                }

                let driverName = value.object(forKey: "driver_name") as? String

                if driverName == nil{
                    
                    labelDriverName.text = ""
                }
                else{
                    
                    labelDriverName.text = "\(driverName!)"
                    
                }
                
                let profilePic  = value.object(forKey: "driver_profile") as? String

                if profilePic == nil || profilePic == ""{
                    
                    imageDriver.image = UIImage(named: "UserPic.png")

                }
                else
                {
                    
                    imageDriver.sd_setImage(with: NSURL(string: profilePic!) as URL!)

                }
                
                var book_fee: Any = value.object(forKey: "book_fee") as! Any!
                var tax_percentage: String = value.object(forKey: "tax_percentage") as! String!
                
                if(book_fee != nil){
                    self.bookfeelbl.text = "$\(book_fee)"
                }
                if(tax_percentage != nil){
                    
                    self.taxx.text = "Tax(\((tax_percentage))%)"
                    var taxcalc = Double(Double(tax_percentage)! / 100)
                    print(taxcalc)
                    self.taxpercentlbl.text = "+ $\(taxcalc)"
                }
                
                var DestinationWaypoints: Any = value.object(forKey: "DestinationWaypoints") as! Any!
                
                if(DestinationWaypoints != nil){
                    
                    if((DestinationWaypoints as? String) == "None"){
                        self.multidestpricelbl.isHidden = true
                        self.multidestcountlbl.isHidden = true
                    }
                    else{
                        var jsonObjects:NSDictionary = (DestinationWaypoints as! NSDictionary)
                        var count = 0
                        for dataDict : Any in jsonObjects
                        {
                            count += 1
                            print(count)
                            self.multidestcountlbl.text = "\(count) Additional Stop"
                            var totalpricemultidest = count * 5
                            self.multidestpricelbl.text = "+ $\(totalpricemultidest)"
                        }
                        
                        print(DestinationWaypoints)
                        
                    }
                }


                self.activityView.stopAnimating()

                print(value)
                
            }
            
        }
        catch{
            
            print(error)
            
            self.activityView.stopAnimating()
            
        }
        
    }

}
