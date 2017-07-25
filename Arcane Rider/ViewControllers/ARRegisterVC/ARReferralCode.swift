//
//  ARReferralCode.swift
//  SIX Rider
//
//  Created by Apple on 08/03/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit
import Alamofire
import Firebase
import GeoFire
import CoreLocation
import libPhoneNumber_iOS

class ARReferralCode: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var agreeTermsLabel: UILabel!
    @IBOutlet weak var termsImageView: UIImageView!
    @IBOutlet weak var referalerror: UILabel!
    @IBOutlet weak var nextbutton: UIButton!
    @IBOutlet weak var skipbutton: UIButton!
    @IBOutlet weak var termsConditionLinklabel: UILabel!
    @IBOutlet weak var referalcodetextbox: HoshiTextField!
    @IBOutlet weak var errorAgreeLabel: UILabel!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    @IBOutlet weak var termsLineLabel: UILabel!
    @IBOutlet weak var checkboxLabel: UIButton!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var signInAPIUrl = live_rider_url
    var updatestatus = ""
    var timer = Timer()
    
    typealias jsonSTD = NSArray
    
    typealias jsonSTDAny = [String : AnyObject]
    
    let screenSize = UIScreen.main.bounds
 
    override func viewDidLoad() {
        super.viewDidLoad()
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        self.errorAgreeLabel.isHidden = true
        self.referalerror.isHidden = true
        UIApplication.shared.isIdleTimerDisabled = false
        activityView.isHidden = true
        self.termsImageView.image = UIImage(named : "unCheckBox.png")
        navigationController!.navigationBar.barStyle = .black
        
        navigationController!.isNavigationBarHidden = false
        
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "arrow-left.png")!, for: .normal)
        button.addTarget(self, action: #selector(ARReferralCode.profileBtn(_:)), for: .touchUpInside)
        //CGRectMake(0, 0, 53, 31)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        //(frame: CGRectMake(3, 5, 50, 20))
        let label = UILabel(frame: CGRect(x: 30, y: 5, width: 100, height: 20))
        // label.font = UIFont(name: "Arial-BoldMT", size: 13)
        label.text = "SIX Rider"
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.clear
        button.addSubview(label)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = barButton
        
        
        // Do any additional setup after loading the view.
        referalcodetextbox.delegate = self
        if screenHeight == 568{
        
 self.termsImageView.frame = CGRect(x:15,y:309,width:18,height:18)
 self.agreeTermsLabel.frame = CGRect(x:40,y:308,width:124,height:21)
 self.checkboxLabel.frame = CGRect(x:5,y:303,width:39,height:30)
 self.termsConditionLinklabel.frame = CGRect(x:166,y:308,width:133,height:21)
 self.termsLineLabel.frame = CGRect(x:171,y:326,width:127,height:1)
 self.errorAgreeLabel.frame = CGRect(x:22,y:330,width:253,height:21)
 self.skipbutton.frame = CGRect(x:236,y:183,width:60,height:40)
        }
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ARReferralCode.hidekeyboard))
        
        tapGesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGesture)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ARReferralCode.tapFunction))
        termsConditionLinklabel.isUserInteractionEnabled = true
        termsConditionLinklabel.addGestureRecognizer(tap)        // Do any additional setup after loading the view.
        timer = Timer.scheduledTimer(timeInterval: 1200, target: self, selector: #selector(ARReferralCode.terminateApp), userInfo: nil, repeats: true)
        let resetTimer = UITapGestureRecognizer(target: self, action: #selector(ARReferralCode.resetTimer));
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(resetTimer)
        }
    func resetTimer(){
        // invaldidate the current timer and start a new one
        print("User Interacted")
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1200, target: self, selector: #selector(ARReferralCode.terminateApp), userInfo: nil, repeats: true)
    }
    func terminateApp(){
        // Do your segue and invalidate the timer
        print("No User Interaction")
        timer.invalidate()
        let alertController = UIAlertController(title: "Time Out", message: "Please retry your registration", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
            print("Showing Alert")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let subContentsVC = storyboard.instantiateViewController(withIdentifier: "mainMenuVC") as! ViewController
            self.navigationController?.pushViewController(subContentsVC, animated: true)
        }))
        self.present(alertController, animated: true, completion: nil)

        
    }
    
    func tapFunction(sender:UITapGestureRecognizer) {
        print("tap working")
        /*let alertController = UIAlertController(title: "Terms and Conditions", message: "In order to ride in SIX, riders are asked to review and agree to SIX's terms and conditions. The partner app requires this to be completed.", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
            print("Showing Alert")
        }))
        self.present(alertController, animated: true, completion: nil)*/
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "popupVC") as! popupViewController
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = CGRect(x:0,y:-40,width:375,height:667)
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
        print("Showing Popup")
    }
    override func viewWillAppear(_ animated: Bool) {
        
        UIApplication.shared.isIdleTimerDisabled = false
        
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
    }
    
    @IBAction func termsConditionBtn(_ sender: Any) {
        
        print(self.termsImageView.image)
        if termsImageView.image == UIImage(named: "unCheckBox.png"){
            
            self.termsImageView.image = UIImage(named : "checkBox.png")
            self.errorAgreeLabel.isHidden = true
            
        }
        else if termsImageView.image == UIImage(named : "checkBox.png"){
            
            self.termsImageView.image = UIImage(named : "unCheckBox.png")
                 }
        else{
            
            
        }
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
    
    func errorField(){
        let referalcode = referalcodetextbox.text?.trimmingCharacters(in: .whitespaces)
        
        if(referalcode == ""){
            referalerror.isHidden=false
        }
        else {
            referalupdate()
            
        }
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == referalcodetextbox{
            referalerror.isHidden=true
            valid()
        }
        else{
            
            
        }
        return true
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        if(textField == referalcodetextbox){
            referalerror.isHidden=true
        }
        else{
            errorField()
        }
        return true
    }

    func referalupdate(){
        
       // self.appDelegate.referralcodevalue = self.referalcodetextbox.text
        print(self.referalcodetextbox.text)
        
        if(self.referalcodetextbox.text == "")
        {
            
        }
        else
        {
            activityView.isHidden = false
            activityView.startAnimating()            
            var urlstring:String = "\(signInAPIUrl)refrel_code/code/\(self.referalcodetextbox.text)"
            urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
            urlstring=(urlstring.replacingOccurrences(of: "Optional", with: "") as String as NSString!) as String
            
            urlstring=(urlstring.replacingOccurrences(of: "(", with: "") as String as NSString!) as String
            
            urlstring=(urlstring.replacingOccurrences(of: ")", with: "") as String as NSString!) as String
            
            urlstring=(urlstring.replacingOccurrences(of: "%22", with: "") as String as NSString!) as String
            
            
            print(urlstring)
            
            self.Referalurl(url: "\(urlstring)")
            
            
        }
        
    }
    func Referalurl(url : String)
    {
        Alamofire.request(url).responseJSON { (response) in
            
            self.callreferalparsedata(JSONData: response.data!)
            
        }
    }
    
    
    func callreferalparsedata(JSONData : Data){
        
        do{
            
            let readableJSon = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as! jsonSTD
            
            print(" !!! \(readableJSon[0])")
            
            let value = readableJSon[0] as AnyObject
            if let satus = value.object(forKey: "status"){
                print(satus)
                
                self.updatestatus = satus as! String
                if(self.updatestatus == "Success"){
                    self.referalerror.isHidden=true
                    activityView.startAnimating()
                    activityView.isHidden = false
                    self.appDelegate.referralcodevalue = self.referalcodetextbox.text
                    print(self.appDelegate.referralcodevalue)
                    signup()
                    //self.navigationController?.pushViewController(ARRegisterMobile(), animated: true)
                }
                else{
                    activityView.stopAnimating()
                    activityView.isHidden = true
                    self.referalerror.isHidden=false
                    self.referalerror.text = "Invalid Referral Code"
                    self.referalerror.isHidden = false
                    self.invalid()
                }
            }
            
        }
        catch{
            print(error)
        }
    }
    

    
    @IBAction func shipaction(_ sender: Any) {
        if termsImageView.image == UIImage(named : "checkBox.png"){
         self.errorAgreeLabel.isHidden = true
            self.referalcodetextbox.text = ""
        signup()
        }
       // self.navigationController?.pushViewController(ARRegisterMobile(), animated: true)
        else{
        self.errorAgreeLabel.isHidden = false
        }
        
        
    }
    

    @IBAction func nextaction(_ sender: Any) {
        
       if termsImageView.image == UIImage(named : "checkBox.png"){
        self.errorAgreeLabel.isHidden = true
        errorField()
        }
       else{
        self.errorAgreeLabel.isHidden = false
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField == referalcodetextbox){
            if(referalcodetextbox.text == ""){
                self.invalid()
            }
            else{
                referalcodetextbox.resignFirstResponder()
            }
            
        }
         return true
    }

    func valid(){
        self.referalerror.isHidden=true
        referalcodetextbox.borderActiveColor = UIColor.black
        referalcodetextbox.borderInactiveColor = UIColor.black
        referalcodetextbox.placeholderColor = UIColor.black
     
    }
   func invalid(){
        self.referalerror.isHidden=false
        referalcodetextbox.borderActiveColor = UIColor.red
        referalcodetextbox.borderInactiveColor = UIColor.red
        referalcodetextbox.placeholderColor = UIColor.red
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var result = true
        let str:NSString! = "\(textField.text!)" as NSString!
        
        let prospectiveText = (str).replacingCharacters(in: range, with: string)
        var limit = 30
        if(textField == referalcodetextbox){
            limit = 30
            if string.characters.count > 0 {
                valid()
                //     let disallowedCharacterSet = CharacterSet.whitespaces
                
                let disallowedCharacterSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890").inverted
                
                let replacementStringIsLegal = string.rangeOfCharacter(from: disallowedCharacterSet) == nil
                
                let resultingStringLengthIsLegal = prospectiveText.characters.count <= limit
                
                result = replacementStringIsLegal &&
                    
                resultingStringLengthIsLegal
                
            }
            
        }
        else{
            
        }
        
        return result
    }
    func signup(){
        
        activityView.startAnimating()
        activityView.isHidden = false
        print(self.appDelegate.firstname)
        print(self.appDelegate.lastname)
        print(self.appDelegate.email)
        print(self.appDelegate.password)
        print(self.appDelegate.countrycode)
        print(self.appDelegate.phonenumber)
        print(self.appDelegate.city)
        print(self.appDelegate.referralcodevalue)
        print(self.appDelegate.nickname)
         appDelegate.nickname=(appDelegate.nickname.replacingOccurrences(of: "%2522", with: "") as String as NSString!) as String
        
        if(self.appDelegate.referralcodevalue == ""){
            
            var urlstring:String = "\(signInAPIUrl)signUp/regid/5765/first_name/\(self.appDelegate.firstname!)/last_name/\(self.appDelegate.lastname!)/mobile/\(self.appDelegate.phonenumber!)/country_code/\(self.appDelegate.countrycode!)/password/\(self.appDelegate.password!)/nick_name/\(self.appDelegate.nickname)/city/null/email/\(self.appDelegate.email!)"
            
            urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
            urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        
            urlstring=(urlstring.replacingOccurrences(of: "%2522", with: "") as String as NSString!) as String
            
            urlstring=(urlstring.replacingOccurrences(of: "Optional", with: "") as String as NSString!) as String
            
            urlstring=(urlstring.replacingOccurrences(of: "(", with: "") as String as NSString!) as String
            
            urlstring=(urlstring.replacingOccurrences(of: ")", with: "") as String as NSString!) as String
            
            urlstring=(urlstring.replacingOccurrences(of: "%22", with: "") as String as NSString!) as String
            
            print(urlstring)
            
            print(urlstring)
            
            self.callSiginAPI1(url: "\(urlstring)")
        }
        else{
            var urlstring:String = "\(signInAPIUrl)signUp/regid/5765/first_name/\(self.appDelegate.firstname!)/last_name/\(self.appDelegate.lastname!)/mobile/\(self.appDelegate.phonenumber!)/country_code/\(self.appDelegate.countrycode!)/password/\(self.appDelegate.password!)/nick_name/\(self.appDelegate.nickname)/city/null/referral_code/\(self.appDelegate.referralcodevalue)/email/\(self.appDelegate.email!)/"
            
            urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
            
            
            urlstring=(urlstring.replacingOccurrences(of: "Optional", with: "") as String as NSString!) as String
            
            urlstring=(urlstring.replacingOccurrences(of: "(", with: "") as String as NSString!) as String
            
            urlstring=(urlstring.replacingOccurrences(of: ")", with: "") as String as NSString!) as String
            
            urlstring=(urlstring.replacingOccurrences(of: "%22", with: "") as String as NSString!) as String
            
            print(urlstring)
            
            self.callSiginAPI1(url: "\(urlstring)")
            
        }
    }
    
    
    func callSiginAPI1(url : String){
        
        Alamofire.request(url).responseJSON { (response) in
            
            self.parseData1(JSONData: response.data!)
            
        }
        
    }
    
    
    func parseData1(JSONData : Data){
        
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
                        
                        "Paymenttype" : "cash",
                        
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
                    activityView.isHidden = true
                    
                    
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
                    self.nextbutton.isEnabled = true
                    activityView.stopAnimating()
                    activityView.isHidden = true
                    
                }
            }
        }
        catch{
            
            activityView.stopAnimating()
            activityView.isHidden = true
            print(error)
            self.nextbutton.isEnabled = true
            
            
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
