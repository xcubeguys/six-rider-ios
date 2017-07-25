//
//  ARMainYourTripsVC.swift
//  Arcane Rider
//
//  Created by Apple on 02/01/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

class ARMainYourTripsVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableViewTrips: UITableView!

    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    weak var delegateBack: LeftMenuProtocol?

    @IBOutlet weak var activityView: UIActivityIndicatorView!

    @IBOutlet weak var labelNoValues: UILabel!
    @IBOutlet weak var segmentedcontrol: UISegmentedControl!

    var arrayDates:NSMutableArray=NSMutableArray()
    var arrayCarType:NSMutableArray=NSMutableArray()
    var arrayPickUp:NSMutableArray=NSMutableArray()
    var arrayDrop:NSMutableArray=NSMutableArray()
    var arrayImages:NSMutableArray=NSMutableArray()
    var arrayOfPrice:NSMutableArray=NSMutableArray()
    var arrayOfPayRecord:NSMutableArray=NSMutableArray()
    var arrayOfTrips:NSMutableArray=NSMutableArray()
    
    var arrayupcomingDates:NSMutableArray=NSMutableArray()
    var arrayupcomingCarType:NSMutableArray=NSMutableArray()
    var arrayupcomingPickUp:NSMutableArray=NSMutableArray()
    var arrayupcomingDrop:NSMutableArray=NSMutableArray()

    var totalArrayOfValues:NSMutableArray=NSMutableArray()

    var valueTest : String!
    
    var tripsdetail:String! = "yourtrips"
    
    var passTripId : String!
    var yourtripstatus:NSNumber = 0
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .lightContent
    }

    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view....
        
        self.labelNoValues.isHidden = true
        
        navigationController!.isNavigationBarHidden = false
        
        navigationController!.navigationBar.barStyle = .black

        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "arrow-left.png")!, for: .normal)
        button.addTarget(self, action: #selector(ARMainYourTripsVC.profileBtn(_:)), for: .touchUpInside)
        //CGRectMake(0, 0, 53, 31)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        //(frame: CGRectMake(3, 5, 50, 20))
        let label = UILabel(frame: CGRect(x: 20, y: 5, width: 100, height: 20))
        // label.font = UIFont(name: "Arial-BoldMT", size: 13)
        label.text = "Your Trips"
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.clear
        button.addSubview(label)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = barButton
        segmentedcontrol.addUnderlineForSelectedSegment()
        
        
        tableViewTrips.register((UINib(nibName: "ARMainTripsCell", bundle: nil)), forCellReuseIdentifier: "tripsCell")
        
        callRidesList()
        
        self.valueTest = "noValues"
        
        self.tripsdetail = "yourtrips"
        
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
    
    @IBAction func segmentedcontrolaction(_ sender: UISegmentedControl){
        segmentedcontrol.changeUnderlinePosition()
        switch segmentedcontrol.selectedSegmentIndex
        {
        case 0:
            tableViewTrips.register((UINib(nibName: "ARMainTripsCell", bundle: nil)), forCellReuseIdentifier: "tripsCell")
           
            callRidesList()
            
            self.valueTest = "noValues"
            
            self.tripsdetail = "yourtrips"
            
        case 1:
            tableViewTrips.register((UINib(nibName: "ARUpcomingTripsCell", bundle: nil)), forCellReuseIdentifier: "UpcomingCell")
            
            self.tripsdetail = "upcoming"
            
            callupcomingrides()
            
        default:
            break;
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

    func profileBtn(_ Selector: AnyObject) {
        
        appDelegate.leftMenu()
        
      //  self.dismiss(animated: true, completion: nil)
        
        /*let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let mainViewController = storyboard.instantiateViewController(withIdentifier: "mainMap") as! ARMainMapVC
        let leftViewController = storyboard.instantiateViewController(withIdentifier: "LeftViewController") as! LeftViewController
        
        let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)
        
        leftViewController.mainViewController = nvc
        
        let slideMenuController = ExSlideMenuController(mainViewController:nvc, leftMenuViewController: leftViewController)
        slideMenuController.automaticallyAdjustsScrollViewInsets = true
        slideMenuController.delegate = mainViewController
        
        self.present(slideMenuController, animated: true, completion: nil)*/
        
    //    delegateBack?.changeViewController(LeftMenu.main)

        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
       /* if self.valueTest == "noValues"{
            
            self.activityView.stopAnimating()
            
            self.labelNoValues.isHidden = false
         
            self.labelNoValues.text = "No trips yet."
            
            return 0
            
        }
        else{
            
            self.labelNoValues.isHidden = true
            
            print("total count \(arrayOfRequest.count)")

            return arrayOfRequest.count

        }*/
        if(self.tripsdetail == "yourtrips"){
        return arrayOfPrice.count
        }
        else{
        return arrayupcomingCarType.count
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(self.tripsdetail == "yourtrips"){
        let cell:ARMainTripsCell = tableView.dequeueReusableCell(withIdentifier: "tripsCell") as! ARMainTripsCell!
        if(arrayPickUp.count > 0){
        let images = arrayImages.object(at: indexPath.row) as? String
        
        let pickUp = arrayPickUp.object(at: indexPath.row) as? String

        var dropLoc = arrayDrop.object(at: indexPath.row) as? String

        let tripId = arrayOfTrips.object(at: indexPath.row) as? String

        let timeFormat1 = arrayDates.object(at: indexPath.row) as? String
        
        print("mouni\(timeFormat1)")

        let carType:NSString! = arrayCarType.object(at: indexPath.row) as! NSString
        
        let priceValue : Double = arrayOfPrice.object(at: indexPath.row) as! Double
        
        if tripId == nil || tripId == ""{
            
            
        }
        else{
            
            self.passTripId = "\(tripId!)"
        }
        if priceValue == 0{
            
            cell.labelAmount.text = "$0"
        }
        else{
            
            cell.labelAmount.text = "$\(priceValue)"

        }
        
        if timeFormat1 == nil || String(describing: timeFormat1) == ""{
            
            print("null time")
        }
        else{
            
            cell.labelTime.text = "\(timeFormat1!)"

        }
        if pickUp == nil || pickUp == ""{
            
            cell.labelStart.text = ""
        }
        else{
            
            cell.labelStart.text = pickUp!
        }
        
        if dropLoc == nil || dropLoc == ""{
            
            cell.labelEnd.text = ""
        }
        else{
            
            if self.appDelegate.updatelocationstatus == 1{
                dropLoc = dropLoc?.replacingOccurrences(of: "%20", with: " ")
                print("self.appDelegate.updatelocationname\(self.appDelegate.updatelocationname)")
                cell.labelEnd.text =  self.appDelegate.updatelocationname
            }else{
                dropLoc = dropLoc?.replacingOccurrences(of: "%20", with: " ")
                cell.labelEnd.text = dropLoc!
            }
            
        }
    
        if images == nil{
            
            cell.imageViewProfile.image = UIImage(named : "Userpic.png")
        }
        else if images == ""{
            
            cell.imageViewProfile.image = UIImage(named : "Userpic.png")
        }
        else{
            
            cell.imageViewProfile.sd_setImage(with: NSURL(string: (images! as String)) as URL!)

        }
        
        cell.labelCar.text = carType as String!
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
            
        }else{
            print("else")
            }
            yourtripstatus = 1
        return cell
        }
        
        else{
            
            let cell:ARUpcomingTripsCell = tableView.dequeueReusableCell(withIdentifier: "UpcomingCell") as! ARUpcomingTripsCell!
           
            if(arrayupcomingPickUp.count > 0){
            let pickUp = arrayupcomingPickUp.object(at: indexPath.row) as? String
            
            var dropLoc = arrayupcomingDrop.object(at: indexPath.row) as? String
           
            let timeFormat1 = arrayupcomingDates.object(at: indexPath.row) as? String
            
            print("mouni\(timeFormat1)")
            
            let carType:NSString! = arrayupcomingCarType.object(at: indexPath.row) as! NSString
            
           
                
            if timeFormat1 == nil || String(describing: timeFormat1) == ""{
                
                print("null time")
            }
            else{
                
                cell.labelTime.text = "\(timeFormat1!)"
                
            }
            if pickUp == nil || pickUp == ""{
                
                cell.labelStart.text = ""
            }
            else{
                
                cell.labelStart.text = pickUp!
            }
            
            if dropLoc == nil || dropLoc == ""{
                
                cell.labelEnd.text = ""
            }
            else{
              
                    dropLoc = dropLoc?.replacingOccurrences(of: "%20", with: " ")
                    cell.labelEnd.text = dropLoc!
                
            }
            
            
            cell.labelCar.text = carType as String!
            
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            

            }
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(self.tripsdetail == "yourtrips"){
        return 155.0
        }
        else{
            return 155.0
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(self.tripsdetail == "yourtrips"){
        tableView.deselectRow(at: indexPath, animated: false)
        
        let tripId = arrayOfTrips.object(at: indexPath.row) as? String

        if tripId == nil || tripId == ""{
            
            self.passTripId = ""
        }
        else{
            
            self.passTripId = "\(tripId!)"
            print("\(self.passTripId)")
        }
        
        let detailsVC = ARTripsDetailsVC()
        detailsVC.tripId = passTripId
        self.navigationController?.pushViewController(detailsVC, animated: true)
        }
        
    }
    

    
    func callRidesList(){
         self.labelNoValues.text = ""
        self.activityView.startAnimating()
        
            arrayDates.removeAllObjects()
            arrayDates.remove("")
            arrayCarType.removeAllObjects()
            arrayCarType.remove("")
            arrayPickUp.removeAllObjects()
            arrayPickUp.remove("")
            arrayDrop.removeAllObjects()
            arrayDrop.remove("")
            arrayImages.removeAllObjects()
            arrayImages.remove("")
                
        var urlstring:String = "\(live_url)requests/yourtrips/userid/\(self.appDelegate.userid!)"
        urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        print(urlstring)
        let manager : AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
        manager.responseSerializer.acceptableContentTypes =  NSSet(objects: "text/plain", "text/html", "application/json", "audio/wav", "application/octest-stream") as Set<NSObject>
        manager.get("\(urlstring)",
            parameters: nil,
            success: { (operation: AFHTTPRequestOperation?,responseObject: Any?) in
                let jsonObjects:NSArray = responseObject as! NSArray
                
                
             /*   if jsonObjects.count == 0{
                    
                    self.valueTest = "noValues"
                    self.activityView.stopAnimating()
                    self.labelNoValues.isHidden = false
                    self.labelNoValues.text = "No trips yet."
                }
                else{
                    
                }*/
                for dataDict : Any in jsonObjects.reversed()
                {
                    var status: NSString = (dataDict as AnyObject).object(forKey: "status") as! NSString!
                    if(status == "Fail"){
                        
                        self.valueTest = "noValues"
                        self.activityView.stopAnimating()
                        self.labelNoValues.isHidden = false
                        self.labelNoValues.text = "No trips yet."
                        
                    }
                   /* if jsonObjects.count == 0{
                        
                        self.valueTest = "noValues"
                        self.activityView.stopAnimating()
                        self.labelNoValues.isHidden = false
                        self.labelNoValues.text = "No trips yet."
                        
                    }*/
                    else{
                        
                     //  let paymentStatus: NSString = (dataDict as AnyObject).object(forKey: "payment_status") as! NSString!

                       /* let paymentStatus = (dataDict as AnyObject).object(forKey: "total_price") as? Int
                        
                        if String(describing: paymentStatus) == "" || paymentStatus == nil || paymentStatus == 0  {
                         
                            self.arrayOfPayRecord.removeAllObjects()
                            
                        }
                        else{*/
                            
                        
                            
                            self.labelNoValues.isHidden = true
                            
                            self.valueTest = "values"
                            
                            let carType: NSString = (dataDict as AnyObject).object(forKey: "car_category") as! NSString!
                            
                            let tripId = (dataDict as AnyObject).object(forKey: "trip_id") as? String
                            
                            let totalPrice = (dataDict as AnyObject).object(forKey: "total_price") as? Double
                            
                            let timeFormat = (dataDict as AnyObject).object(forKey: "created") as? String
                            
                            let pickUpAddress = (dataDict as AnyObject).object(forKey: "pickup_address") as? String
                            
                            var dropAddress = (dataDict as AnyObject).object(forKey: "drop_address") as? String
                            
                            let images = (dataDict as AnyObject).object(forKey: "driver_profile") as? String
                            
                       //     let payStatus = (dataDict as AnyObject).object(forKey: "payment_status") as? String
                            
                         //   self.arrayOfPayRecord.add(paymentStatus as String!)
                      //  let floattotalprice = Double(totalPrice!)
                        print("\(totalPrice)")

                            if tripId == nil{
                                
                                self.arrayOfTrips.add("")
                            }
                            else{
                                
                                self.arrayOfTrips.add(tripId as String!)
                            }
                            if images == nil{
                                
                                self.arrayImages.add("")
                            }
                            else{
                                
                                self.arrayImages.add(images as String!)
                                
                                
                            }
                            
                            if totalPrice == nil{
                                
                                let value = 0
                                self.arrayOfPrice.add(value)
                                
                            }
                            else{
                                
                                self.arrayOfPrice.add(totalPrice! as Double)
                                
                            }
                            if pickUpAddress == nil{
                                
                                self.arrayPickUp.add("")
                            }
                            else{
                                
                                self.arrayPickUp.add(pickUpAddress as String!)
                            }
                            
                            if dropAddress == nil{
                                
                                self.arrayDrop.add("")
                            }
                            else{
                                dropAddress = dropAddress?.replacingOccurrences(of: "%20", with: " ")
                                self.arrayDrop.add(dropAddress as String!)
                            }
                            
                            if timeFormat == nil{
                                
                                self.arrayDates.add("")
                            }
                            else{
                                
                                self.arrayDates.add(timeFormat as String!)
                                
                            }
                            
                            self.arrayCarType.add(carType)
                            
                            self.activityView.stopAnimating()
                      //  }
                        
                    }
                    

                }
                print(self.arrayDates)
                
                self.tableViewTrips.reloadData()
        },
            failure: { (operation: AFHTTPRequestOperation?,error: Error) in
                print("Error: " + error.localizedDescription)
                
                self.activityView.stopAnimating()
        })
    
    }
    
    func callupcomingrides(){
         self.labelNoValues.text = ""
        self.activityView.startAnimating()
        
        arrayupcomingDates.removeAllObjects()
        arrayupcomingDates.remove("")
        arrayupcomingCarType.removeAllObjects()
        arrayupcomingCarType.remove("")
        arrayupcomingPickUp.removeAllObjects()
        arrayupcomingPickUp.remove("")
        arrayupcomingDrop.removeAllObjects()
        arrayupcomingDrop.remove("")
       

        
        var urlstring:String = "\(live_url)requests/rideLaterList/rider_id/\(self.appDelegate.userid!)"
        urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        print(urlstring)
        let manager : AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
        manager.responseSerializer.acceptableContentTypes =  NSSet(objects: "text/plain", "text/html", "application/json", "audio/wav", "application/octest-stream") as Set<NSObject>
        manager.get("\(urlstring)",
            parameters: nil,
            success: { (operation: AFHTTPRequestOperation?,responseObject: Any?) in
                let jsonObjects:NSArray = responseObject as! NSArray
               
                for dataDict : Any in jsonObjects.reversed()
                {
                    var status: NSString = (dataDict as AnyObject).object(forKey: "status") as! NSString!
                    if(status == "Fail"){
                        
                        self.valueTest = "noValues"
                        self.activityView.stopAnimating()
                        self.labelNoValues.isHidden = false
                        self.labelNoValues.text = "You have no future trips."
                        
                    }
                        
                    else{
                        
                        
                        self.labelNoValues.isHidden = true
                        
                       
                        
                        let carType: NSString = (dataDict as AnyObject).object(forKey: "category") as! NSString!
                        
                        
                        let timeFormat = (dataDict as AnyObject).object(forKey: "ride_date_time") as? String
                        
                        let pickUpAddress = (dataDict as AnyObject).object(forKey: "pickup_location") as? String
                        
                        var dropAddress = (dataDict as AnyObject).object(forKey: "dropup_location") as? String
                        
                       
                       if pickUpAddress == nil{
                            
                            self.arrayupcomingPickUp.add("")
                        }
                        else{
                            
                            self.arrayupcomingPickUp.add(pickUpAddress as String!)
                        }
                        
                        if dropAddress == nil{
                            
                            self.arrayupcomingDrop.add("")
                        }
                        else{
                            dropAddress = dropAddress?.replacingOccurrences(of: "%20", with: " ")
                            self.arrayupcomingDrop.add(dropAddress as String!)
                        }
                        
                        if timeFormat == nil{
                            
                            self.arrayupcomingDates.add("")
                        }
                        else{
                            
                            self.arrayupcomingDates.add(timeFormat as String!)
                            
                        }
                        
                        self.arrayupcomingCarType.add(carType)
                        
                        self.activityView.stopAnimating()
                        
                        
                    }
                    
                    
                }
                print(self.arrayupcomingDates)
                
                self.tableViewTrips.reloadData()
        },
            failure: { (operation: AFHTTPRequestOperation?,error: Error) in
                print("Error: " + error.localizedDescription)
                
                self.activityView.stopAnimating()
        })
        
    }

}
extension UISegmentedControl{
    func removeBorder(){
        let backgroundImage = UIImage.getColoredRectImageWith(color: UIColor.white.cgColor, andSize: self.bounds.size)
        self.setBackgroundImage(backgroundImage, for: .normal, barMetrics: .default)
        self.setBackgroundImage(backgroundImage, for: .selected, barMetrics: .default)
        self.setBackgroundImage(backgroundImage, for: .highlighted, barMetrics: .default)
        
        let deviderImage = UIImage.getColoredRectImageWith(color: UIColor.white.cgColor, andSize: CGSize(width: 1.0, height: self.bounds.size.height))
        self.setDividerImage(deviderImage, forLeftSegmentState: .selected, rightSegmentState: .normal, barMetrics: .default)
        self.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.gray], for: .normal)
        self.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0)], for: .selected)
    }
    
    func addUnderlineForSelectedSegment(){
        removeBorder()
        let underlineWidth: CGFloat = self.bounds.size.width / CGFloat(self.numberOfSegments)
        let underlineHeight: CGFloat = 2.0
        let underlineXPosition = CGFloat(selectedSegmentIndex * Int(underlineWidth))
        let underLineYPosition = self.bounds.size.height - 1.0
        let underlineFrame = CGRect(x: underlineXPosition, y: underLineYPosition, width: underlineWidth, height: underlineHeight)
        let underline = UIView(frame: underlineFrame)
        underline.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0)
        underline.tag = 1
        self.addSubview(underline)
        
        /* let segmentBottomBorder = CALayer()
         segmentBottomBorder.borderColor = UIColor.blue.cgColor
         segmentBottomBorder.borderWidth = 3
         let x = CGFloat(selectedSegmentIndex * Int(underlineWidth))
         let y = self.bounds.size.height - 1.0
         let width: CGFloat = self.bounds.size.width / CGFloat(self.numberOfSegments)
         segmentBottomBorder.frame = CGRect(x: x, y: y, width: width, height: (segmentBottomBorder.borderWidth))
         self.layer.addSublayer(segmentBottomBorder)*/
        // segmentCn.layer.addSublayer(segmentBottomBorder!)
    }
    
    func changeUnderlinePosition(){
        removeBorder()
        guard let underline = self.viewWithTag(1) else {return}
        let underlineFinalXPosition = (self.bounds.width / CGFloat(self.numberOfSegments)) * CGFloat(selectedSegmentIndex)
        UIView.animate(withDuration: 0.1, animations: {
            underline.frame.origin.x = underlineFinalXPosition
        })
    }
}
extension UIImage{
    
    class func getColoredRectImageWith(color: CGColor, andSize size: CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        let graphicsContext = UIGraphicsGetCurrentContext()
        graphicsContext?.setFillColor(color)
        let rectangle = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        graphicsContext?.fill(rectangle)
        let rectangleImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return rectangleImage!
    }
}
