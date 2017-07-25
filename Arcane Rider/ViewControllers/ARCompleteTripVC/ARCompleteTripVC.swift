//
//  ARCompleteTripVC.swift
//  Arcane Rider
//
//  Created by Apple on 24/12/16.
//  Copyright © 2016 Apple. All rights reserved.
//

import UIKit
import Firebase
import GeoFire
import Alamofire

class ARCompleteTripVC: UIViewController {

    @IBOutlet weak var buttonBackReceipt: UIButton!

    @IBOutlet weak var distanceLabelKM: UILabel!
    @IBOutlet weak var labelDriverName: UILabel!
    @IBOutlet weak var labelAmount: UILabel!
    @IBOutlet weak var labelSuccess: UILabel!
    @IBOutlet weak var smileimg: UIImageView!

    @IBOutlet weak var smile5swidth: NSLayoutConstraint!
    @IBOutlet weak var smile5sheight: NSLayoutConstraint!
    @IBOutlet weak var smile5sbottom: NSLayoutConstraint!
    @IBOutlet weak var imageViewDriverProfile: UIImageView!

    @IBOutlet weak var ratingView: HCSStarRatingView!

    @IBOutlet weak var ratingViewDriver: HCSStarRatingView!

    @IBOutlet weak var labelCurrentTime: UILabel!

    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    var complete = ""
    
    typealias jsonSTD = NSArray
    
    typealias jsonSTDAny = [String : AnyObject]
    let screenSize = UIScreen.main.bounds
    
    var tripDriverID:String! = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        let screenHeight = screenSize.height
        //smileimg.loadGif(name: "emoji_24")
//        if screenHeight == 568{
////            smile5swidth.constant = 50
////            smile5sheight.constant = 50
//        }
        // Do any additional setup after loading the view.
        
        labelSuccess.isHidden = true
        
        UIApplication.shared.isIdleTimerDisabled = false
        
        navigationController?.isNavigationBarHidden = true
        
        ratingView.maximumValue = 5
        ratingView.minimumValue = 0
//        ratingView.tintColor = UIColor(red: 251.0, green: 174.0, blue: 32.0, alpha: 1.0)
        ratingView.allowsHalfStars = true
        
        
        ratingViewDriver.maximumValue = 5
        ratingViewDriver.minimumValue = 0
//        ratingViewDriver.tintColor = UIColor(red: 251.0, green: 174.0, blue: 32.0, alpha: 1.0)
        ratingViewDriver.allowsHalfStars = true
        
      /*  self.buttonBackReceipt.backgroundColor = UIColor.white
        self.buttonBackReceipt.layer.borderWidth = 2.0
        self.buttonBackReceipt.layer.borderColor = UIColor.clear.cgColor
        self.buttonBackReceipt.layer.shadowColor = UIColor.lightGray.cgColor
        self.buttonBackReceipt.layer.shadowOpacity = 1.0
        self.buttonBackReceipt.layer.shadowRadius = 5.0
        self.buttonBackReceipt.layer.shadowOffset = CGSize(width: 0, height: 3)*/

        imageViewDriverProfile.layer.cornerRadius = imageViewDriverProfile.frame.size.width / 2
        imageViewDriverProfile.clipsToBounds = true
        
        let driverPhoto = UserDefaults.standard.object(forKey: "acceptedDriverName") as! String!
        
        if driverPhoto == nil{
            
            labelDriverName.text = ""
        }
        else{
            
            labelDriverName.text = driverPhoto 
            
        }
        let image = UserDefaults.standard.object(forKey: "acceptedDriverPhoto1")
        
        if image == nil
        {
            
            self.imageViewDriverProfile.image = UIImage(named : "Userpic.png")
        }
        else
        {
            
            let url = URL(string: image as! String)
        
            print(url)
            
            if(url == URL(string: "")){
                
                self.imageViewDriverProfile.image = UIImage(named : "Userpic.png")
                
            }
            else{
                
                self.imageViewDriverProfile.setImageWithUrl(url!)
                
            }
            
        }
        
        print(UserDefaults.standard.value(forKey: "tripDriverid") as Any)
        if UserDefaults.standard.value(forKey: "tripDriverid") != nil{
                self.tripDriverID = UserDefaults.standard.value(forKey: "tripDriverid") as! String
        }
        
            
        print(UserDefaults.standard.value(forKey: "trip_id") as Any)

//        UserDefaults.standard.setValue("" , forKey: "tripDriverid")
//        UserDefaults.standard.setValue("" , forKey: "trip_id")
//        UserDefaults.standard.setValue("" , forKey: "acceptedDriverPhoto")
//        UserDefaults.standard.setValue("" , forKey: "acceptedDriverName")
//        UserDefaults.standard.set("", forKey: "acceptedDriverCarCategoryName")
//        self.appDelegate.accepted_Driverid = ""
//        self.appDelegate.passAcceptedDriverCarCategory = ""
        
        /*if self.appDelegate.distance != 0.0 {
            
//            var total  = String(format: "%.2f", (self.appDelegate.distance))
//            total = total.replacingOccurrences(of: "Optional(", with: "")
//            total = total.replacingOccurrences(of: ")", with: "")
//            total = total.replacingOccurrences(of: "\"", with: "")

            let total = self.appDelegate.distance

            var trimTotal = String(format: "%.2f", total)
            trimTotal = trimTotal.replacingOccurrences(of: "Optional(", with: "")
            trimTotal = trimTotal.replacingOccurrences(of: ")", with: "")
            trimTotal = trimTotal.replacingOccurrences(of: "\"", with: "")

            self.distanceLabelKM.text = "Total Distance : \(trimTotal) KM"
            let amount = (self.appDelegate.distance) * 4
            
            var trimAmount = String(format: "%.2f", amount)
            trimAmount = trimAmount.replacingOccurrences(of: "Optional(", with: "")
            trimAmount = trimAmount.replacingOccurrences(of: ")", with: "")
            trimAmount = trimAmount.replacingOccurrences(of: "\"", with: "")

            
            self.labelAmount.text = "$\(trimAmount)"
            
            
            
        } */
        
        self.distance()
        
        DispatchQueue.main.async { () -> Void in
            
            let vc = ARMainMapVC()
            vc.ref = FIRDatabase.database().reference()
            vc.ref.removeAllObservers()
            
        }
        
        self.callCurrentTime()

        
    }
    
    
    func distance(){
        
        let ref = FIRDatabase.database().reference()
        
        let tripId = self.appDelegate.trip_id!
        
        if(tripId != ""){
            
            
            ref.child("trips_data").child("\(tripId)").observe(.value, with: { (snapshot) in
                
                print("updating distance \(snapshot.value)")
                let status1 = snapshot.value as Any
                
                print("distance is \(status1)")
                if status1 != nil {
                    
                    print(status1)
                    
                    if (status1 as? NSDictionary) != nil{
                        
                        let dict:NSDictionary = (status1 as? NSDictionary)!
                        
                        print(dict)
                        let distance = dict["Distance"]
                        var price = dict["Price"]
                        let driverRated = dict["driver_rating"]
                        let priceamount = (price! as! NSString).doubleValue
                        
                        let tollamount = (self.appDelegate.total_tollfee! as! NSString).doubleValue
                        let total_price  = priceamount + tollamount
                        print("total_price~~\(total_price)")
                        print(driverRated)
//                        print(distance!)
//                        print(price!)
                       //  var newpriceamount = doubleValue(format:"%.2f", priceamount)
                        //var newpriceamount = doubleValue(priceamount).round(Place: 2)
                        print("newpriceamount::\(price)")
                        if distance == nil{
                            
                            self.distanceLabelKM.text = "Total Distance : 0 KM"

                        }
                        else{
                            
                            self.distanceLabelKM.text = "Total Distance : \(distance!) KM"

                        }
                        
                        if price == nil{
                            
                            self.labelAmount.text = "$0"  // temp hide

                        }
                        else{
                            
                            self.labelAmount.text = "$\(price!)"  // temp hide

                        }
                        
                        
                        
                        let value = UserDefaults.standard.set(driverRated, forKey: "driver_Rating_value")
                        
                        let some = UserDefaults.standard.double(forKey: "driver_Rating_value")
                        
                        self.ratingViewDriver.value = CGFloat(some)
                        
                        /*ref.child("trips_data").child("\(tripId)").child("Distance").observe(.childChanged, with: { (snapshot) in
                         
                         print("Distance is")
                         let status1 = snapshot.value as Any
                         print(status1)
                         })
                         
                         ref.child("trips_data").child("\(tripId)").child("Price").observe(.childChanged, with: { (snapshot) in
                         
                         print("Prices is")
                         let status1 = snapshot.value as Any
                         print(status1)
                         })*/
                        
                    }
                    else
                    {
                        
                    }

                    }
                else{
                    
                    
                }
            })
            
        }
        else{
            
            
        }
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
    @IBAction func btnMoveMapPageVC(_ sender: Any) {
        
//        appDelegate.leftMenu()
        
        complete = "complete"
        
        UserDefaults.standard.set(complete, forKey: "comp")
        
//        let ref = FIRDatabase.database().reference()
//        ref.removeAllObservers()
        
        let ref = FIRDatabase.database().reference().child("drivers_data")
        ref.removeAllObservers()
        
        let ref1 = FIRDatabase.database().reference().child("trips_data")
        ref1.removeAllObservers()
        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let controller = storyboard.instantiateViewController(withIdentifier: "mainMap") as! ARMainMapVC
//        self.present(controller, animated: true, completion: nil)
        
      //  self.appDelegate.leftMenu()
        UserDefaults.standard.setValue("" , forKey: "tripDriverid")
        UserDefaults.standard.setValue("" , forKey: "trip_id")
        UserDefaults.standard.setValue("" , forKey: "acceptedDriverPhoto")
        UserDefaults.standard.setValue("" , forKey: "acceptedDriverName")
        UserDefaults.standard.set("", forKey: "acceptedDriverCarCategoryName")
        self.appDelegate.accepted_Driverid = ""
        self.appDelegate.passAcceptedDriverCarCategory = ""
        self.appDelegate.trip_id = "empty"
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let mainViewController = storyboard.instantiateViewController(withIdentifier: "mainMap") as! ARMainMapVC
        let leftViewController = storyboard.instantiateViewController(withIdentifier: "LeftViewController") as! LeftViewController
        
        let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)
        
        leftViewController.mainViewController = nvc
        
        let slideMenuController = ExSlideMenuController(mainViewController:nvc, leftMenuViewController: leftViewController)
        slideMenuController.automaticallyAdjustsScrollViewInsets = true
        slideMenuController.delegate = mainViewController
        
        self.present(slideMenuController, animated: true, completion: nil)
    }
    
    @IBAction func ratingChangeAction(_ sender: HCSStarRatingView) {
        
        print(String(format: "Changed rider rating to %.1f", sender.value))
        
        self.appDelegate.riderRatToDriver = String(describing: sender.value)
        
        print("riderRatToDriver \(self.appDelegate.riderRatToDriver)")
        
        print("riderRatToDriver !! \(self.appDelegate.riderRatToDriver!)")
        
        let value = self.appDelegate.riderRatToDriver!
        
        if value == nil{
            
            self.appDelegate.riderRatToDriver = "0"
          //  self.labelSuccess.isHidden = true

        }
        else{
            
            self.appDelegate.riderRatToDriver = value
          //  self.labelSuccess.isHidden = false
          //  self.labelSuccess.text = "You have submitted your rating successfully"
            self.callApiRatings()
        }
        
        self.sendRiderRatingsToDriver()

    }
    

    func sendRiderRatingsToDriver(){
        let rate:Double = Double(self.appDelegate.riderRatToDriver)!
        print(rate)
        if(rate > 0.0 && rate < 1.1){
            smileimg.loadGif(name: "emoji_rate1")
        }
        if(rate > 1.0 && rate < 2.1){
            smileimg.loadGif(name: "emoji_rate2")
        }
        if(rate > 2.0 && rate < 3.1){
            smileimg.loadGif(name: "emoji_rate3")
        }
        if(rate > 3.0 && rate < 4.1){
            smileimg.loadGif(name: "emoji_rate4")
        }
        if(rate > 4.0 && rate <= 5.1){
            smileimg.loadGif(name: "emoji_rate5")
        }
//        let TestValue = UserDefaults.standard.object(forKey: "testValue") as! String
//        
//        print("\(TestValue)")
//        
        let ref = FIRDatabase.database().reference().child("trips_data").child("\(self.appDelegate.trip_id)")
//
//        if(TestValue != ""){

            ref.updateChildValues(["rider_rating" : "\(self.appDelegate.riderRatToDriver!)"])
            
//        }
//        else{
//            
//            print("raj no trip id")
//        }
    
    }
    
    func callCurrentTime()
    {
        
        let date = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
        dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
        //  dateFormatter.dateFormat = "dd/MM/yyyy" //Specify your format that you want
        let localDate = dateFormatter.string(from: date as Date)
        self.labelCurrentTime.text = "\(localDate)"
        print("date \(date)")
        print("our date \(localDate)")
    }
    
    func callApiRatings(){
        
        
        let driver_id:String! = UserDefaults.standard.value(forKey: "tripDriverid") as! String
        
        var urlstring:String = "\(live_rider_url)riderrating/userid/\(self.appDelegate.userid!)/rate/\(self.appDelegate.riderRatToDriver!)/driverid/\(self.tripDriverID!)"
       
     //   var urlstring:String = "\(live_rider_url)riderrating/userid/\(self.appDelegate.userid!)/rate/\(self.appDelegate.riderRatToDriver!)/driverid/587360bfda71b4f0758b4567"

        urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        
        urlstring = urlstring.removingPercentEncoding!
        
        print(urlstring)
        
        self.callSiginAPI(url: "\(urlstring)")
        
    }
    
    func callSiginAPI(url : String){
        
        
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
                if(final as! String == "Fail"){
                    
                    print("error")
                    
                }
                else{
                    
                    print("Success")
                    
                }
            }
        }
        catch{
            
            
            print(error)
            
        }
        
    }

}
