//
//  ARCityVC.swift
//  Arcane Rider
//
//  Created by Apple on 18/12/16.
//  Copyright © 2016 Apple. All rights reserved.
//

import UIKit
import Alamofire
import Firebase
import GeoFire
import CoreLocation


class ARCityVC: UIViewController,CLLocationManagerDelegate {

    @IBOutlet weak var cityText: HoshiTextField!
    @IBOutlet weak var nextBtn: UIButton!

    @IBOutlet weak var activityView: UIActivityIndicatorView!

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var signInAPIUrl = live_rider_url
    
    typealias jsonSTD = NSArray
    
    typealias jsonSTDAny = [String : AnyObject]
    
    
    var locationManager = CLLocationManager()
    let locationTracker = LocationTracker(threshold: 10.0)
    
    var didFindMyLocation = false
    var currentLocation = CLLocation()


    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationController!.navigationBar.barStyle = .black
        
        navigationController!.isNavigationBarHidden = false
        
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "arrow-left.png")!, for: .normal)
        button.addTarget(self, action: #selector(ARCityVC.profileBtn(_:)), for: .touchUpInside)
        //CGRectMake(0, 0, 53, 31)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        //(frame: CGRectMake(3, 5, 50, 20))
        let label = UILabel(frame: CGRect(x: 25, y: 5, width: 150, height: 20))
        // label.font = UIFont(name: "Arial-BoldMT", size: 13)
        label.text = "SIX RIDER"
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.clear
        button.addSubview(label)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = barButton
        
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        self.locationTracker.addLocationChangeObserver { (result) -> () in
            switch result {
            case .success(let location):
                let coordinate = location.physical.coordinate
                let locationString = "\(coordinate.latitude), \(coordinate.longitude)"
                
                self.currentLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
                print("location String\(locationString)")
                print("Success")
            case .failure:
                print("Failure")
            }
        }


        // Do any additional setup after loading the view.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ARCityVC.hidekeyboard))
        
        tapGesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGesture)
    }
    
    func hidekeyboard()
    {
        self.view.endEditing(true)
    }
    
    func profileBtn(_ Selector: AnyObject) {
        
        self.navigationController?.popViewController(animated: true)
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        var result = true
        let str:NSString! = "\(textField.text!)" as NSString!
        
        let prospectiveText = (str).replacingCharacters(in: range, with: string)
        var limit = 30
        if(textField == cityText){
            limit = 30
            if string.characters.count > 0 {
                
                //     let disallowedCharacterSet = CharacterSet.whitespaces
                
                let inverseSet = NSCharacterSet(charactersIn:"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ").inverted
                
                let components = string.components(separatedBy: inverseSet)
                
                
                let filtered = components.joined(separator: "")
                return string == filtered
                
            }
            
        }
    else{}
        return result
    }
     
    
    @IBAction func nextAction(_ sender: Any) {
        
        cityText.resignFirstResponder()
        activityView.startAnimating()

        let trimmedString = cityText.text?.trimmingCharacters(in: .whitespaces)
        
        if(trimmedString == ""){
            
            self.invalidEmail()
        }
        else{
            //            emailText.forLastBaselineLayout.backgroundColor = UIColor.black
            self.valid()
            self.appDelegate.city = trimmedString
            self.signup()
            
        }
        
    }

    func invalidEmail(){
        
        activityView.stopAnimating()

        cityText.borderActiveColor = UIColor.red
        cityText.borderInactiveColor = UIColor.red
        cityText.placeholderColor = UIColor.red
        
    }
    
    func valid(){
        
        cityText.borderActiveColor = UIColor.black
        cityText.borderInactiveColor = UIColor.black
        cityText.placeholderColor = UIColor.black
        
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if(textField.text! == ""){
            self.invalidEmail()
        }
        else{
            
            cityText.resignFirstResponder()
            view.endEditing(true)
            self.nextAction(self.nextBtn)
            
        }
        return true
    }
    

    func signup(){
        
        activityView.startAnimating()

        print(self.appDelegate.firstname)
        print(self.appDelegate.lastname)
        print(self.appDelegate.email)
        print(self.appDelegate.password)
        print(self.appDelegate.countrycode)
        print(self.appDelegate.phonenumber)
        print(self.appDelegate.city)
        
        
        var urlstring:String = "\(signInAPIUrl)signUp/regid/5765/first_name/\(self.appDelegate.firstname!)/last_name/\(self.appDelegate.lastname!)/mobile/\(self.appDelegate.phonenumber!)/country_code/\(self.appDelegate.countrycode!)/password/\(self.appDelegate.password!)/city/\(self.appDelegate.city!)/email/\(self.appDelegate.email!)"
        
        urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        
       
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
                if(final as! String == "Success"){
                    let email:String = value.object(forKey: "email") as! String
                    let first_name:String = value.object(forKey: "first_name") as! String
                    let last_name:String = value.object(forKey: "last_name") as! String
                   //let mobile:String = value.object(forKey: "mobile") as! String
                    let userid:String = value.object(forKey: "userid") as! String
                    print("email is \(email)")
                    
                    self.appDelegate.userid = userid
                    self.appDelegate.fname = first_name
                    self.appDelegate.lname = last_name
                    self.appDelegate.loggedEmail = email
                    
                    // session started using NSUserDefaults

                    UserDefaults.standard.setValue(userid, forKey: "userid")
                    
                    let value = "\(first_name) \(last_name)"
                    UserDefaults.standard.setValue(value, forKey: "userName")
                    
                    print("\(UserDefaults.standard.value(forKey: "userid")!)")
                    
                    var ref1 = FIRDatabase.database().reference()
                    
                    var userId = self.appDelegate.userid!
                    
                    let newUser = [
                        
                        "name": "\(first_name) \(last_name)",
                        //  "location" : "",
                        "email"      : "\(email)",
                        
                    ]
                    

                    
                    var appendingPath = ref1.child(byAppendingPath: "riders_location")
                    
                    var appendingPath1 = ref1.child(byAppendingPath: "riders_location")
                    
                    
                    appendingPath.child(byAppendingPath: userId).setValue(newUser)
                    

                  /*  let ref = FIRDatabase.database().reference()
                    
                    let geoFire = GeoFire(firebaseRef: ref.child("riders_location"))
                    
                    let newBookData = [
                        
                        "name": "\(first_name)\(last_name)"
                    ]
                    
                    // ref.setValue(newBookData)
                    
                    ref.child("riders_location/")
                    
                    //ref.child("\(newBookData)")
                    
                    geoFire!.setLocation(CLLocation(latitude: (currentLocation.coordinate.latitude), longitude: (currentLocation.coordinate.longitude)), forKey: "\(userid)") { (error) in
                        
                        if (error != nil) {
                            
                            print("An error occured: \(error)")
                            
                        } else {
                            
                            print("Saved location successfully!")
                            
                        }
                    } */

                    
                    
                    
               /*     let ref1 = FIRDatabase.database().reference()
                    
                    var userId = userid
                    
                    let newUser = [
                        
                        "name": "\(first_name) \(last_name)",
                        //  "location" : "",
                        "email"      : "",
                        
                        
                        ]
                    
                    ref1.child(byAppendingPath: "riders_location")
                        .child(byAppendingPath: userid)
                        .setValue(newUser)
                    
                    var age: Void  = ref1.child(byAppendingPath: "riders_location/\(userid)/email").setValue("\(email)")
                    //    var location: Void  = ref1.child(byAppendingPath: "drivers_location/\(userid)/location").setValue("my location")
                    //     var About : Void = ref1.child(byAppendingPath: "drivers_location/\(userid)/geo_location").setValue("aboutme")
                    
                    let geoFire = GeoFire(firebaseRef: ref1.child(byAppendingPath: "riders_location/\(userid)"))
                    
                    geoFire!.setLocation(CLLocation(latitude: (currentLocation.coordinate.latitude), longitude: (currentLocation.coordinate.longitude)), forKey: "geolocation") { (error) in
                        
                        if (error != nil) {
                            
                            print("An error occured: \(error)")
                            
                        } else {
                            
                            print("Saved location successfully!")
                            
                        }
                    } */
                    
                    activityView.stopAnimating()

                    
                    
                     appDelegate.leftMenu()
                    
                    //self.navigationController?.pushViewController(ARMapVC(), animated: true)
                    
                    
                }
                else{
                    
                    let toastLabel = UILabel(frame: CGRect(x: 20.0, y: 172, width: 300, height: 30))
                    toastLabel.backgroundColor = UIColor.black
                    toastLabel.textColor = UIColor.white
                    toastLabel.textAlignment = NSTextAlignment.center;
                    self.view.addSubview(toastLabel)
                    toastLabel.text = "Email address or Mobile number already exist"
                    toastLabel.alpha = 1.0
                    toastLabel.layer.cornerRadius = 0;
                    toastLabel.clipsToBounds  =  true
                    
                    UIView.animate(withDuration: 4.0, delay: 0.1, options: UIViewAnimationOptions.curveEaseOut, animations: {
                        
                        toastLabel.alpha = 0.0
                        
                    })
                    activityView.stopAnimating()

                }
            }
        }
        catch{
            
            activityView.stopAnimating()

            print(error)
            
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

}
