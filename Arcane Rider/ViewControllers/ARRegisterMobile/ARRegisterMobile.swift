//
//  ARRegisterMobile.swift
//  Arcane Rider
//
//  Created by Apple on 16/12/16.
//  Copyright © 2016 Apple. All rights reserved.
//

import UIKit
import Alamofire
import Firebase
import GeoFire
import CoreLocation
import libPhoneNumber_iOS

class ARRegisterMobile: UIViewController,UITextFieldDelegate,CLLocationManagerDelegate {

    @IBOutlet weak var mobileText: HoshiTextField!
    @IBOutlet weak var countryCode: HoshiTextField!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var mobileerrLabel: UILabel!
    @IBOutlet weak var countrycodeLabel: UILabel!

    @IBOutlet weak var labelCcValue: UILabel!

    var timer = Timer()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var activityView: UIActivityIndicatorView!

    var signInAPIUrl = live_rider_url

    typealias jsonSTD = NSArray
    
    typealias jsonSTDAny = [String : AnyObject]
    
    let alertView:UIAlertView = UIAlertView()
    
    var locationManager = CLLocationManager()
    let locationTracker = LocationTracker(threshold: 10.0)
    
    var didFindMyLocation = false
    var currentLocation = CLLocation()

    var tCBValid : String!

    var code = ""
    var codeLength = 0
    var codeCheck = 10

    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.labelCcValue.text="+65"
        UIApplication.shared.isIdleTimerDisabled = false
        
        navigationController!.navigationBar.barStyle = .black
        
        navigationController!.isNavigationBarHidden = false
        
        mobileerrLabel.isHidden=true
//        countrycodeLabel.isHidden=true
        
        self.countryCode.text = "+65"
        
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "arrow-left.png")!, for: .normal)
        button.addTarget(self, action: #selector(ARRegisterMobile.profileBtn(_:)), for: .touchUpInside)
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
        
        mobileText.delegate = self
      //  countryCode.delegate = self
        
        
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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ARRegisterMobile.hidekeyboard))
        
        tapGesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGesture)
        timer = Timer.scheduledTimer(timeInterval: 1200, target: self, selector: #selector(ARRegisterMobile.terminateApp), userInfo: nil, repeats: true)
        let resetTimer = UITapGestureRecognizer(target: self, action: #selector(ARRegisterMobile.resetTimer));
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(resetTimer)
        
    }
    func resetTimer(){
        // invaldidate the current timer and start a new one
        print("User Interacted")
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1200, target: self, selector: #selector(ARRegisterMobile.terminateApp), userInfo: nil, repeats: true)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func tCBPhoneNumberValidation()
    {
        let phoneUtil = NBPhoneNumberUtil()
        
        do {
            
            let phNumber = mobileText.text!
            let phoneNumber: NBPhoneNumber = try phoneUtil.parse("\(phNumber)", defaultRegion: "\(self.tCBValid!)")
            let formattedString: String = try phoneUtil.format(phoneNumber, numberFormat: .E164)
            
            
            
            NSLog("[%@]", formattedString)
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
        
    }
    
    func errorField(){
        
       
        if(mobileText.text == ""){
            mobileerrLabel.isHidden=false
            self.mobileerrLabel.text = "Enter a valid mobile number with country code"
        }
        //else if(labelCcValue.text == "cc"){
            
//            countrycodeLabel.isHidden=false
        //}
            
        else {
            
        }
    }
    
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        if(textField == mobileText){
            mobileerrLabel.isHidden = true
        }
        else if(textField == countryCode){
            mobileerrLabel.isHidden=true
        }
        else{
            errorField()
        }
        
        
        return true
        
    }

    
    @IBAction func nextAction(_ sender: Any) {
        
        nextAction()
        
    
    }
    
    func nextAction(){
        
        
        errorField()
        let mobileTrim = mobileText.text?.trimmingCharacters(in: .whitespaces)
        var code = self.codeLength
        if self.codeLength == 0{
            code = 8
        }
        else{
            code = self.codeLength
        }

        mobileText.resignFirstResponder()
     //   countryCode.resignFirstResponder()
        
        if (mobileText.text == "") {
            
            mobileerrLabel.isHidden=false
            self.mobileerrLabel.text = "Enter a valid mobile number with country code"
            //            self.invalidMobile()
            //            self.invalidCC()
        }
            
      /*  else if (labelCcValue.text?.characters.count)! == 0{
            countrycodeLabel.isHidden=false
            //self.invalidCC()                          //raj
        }*/
        /*else if labelCcValue.text == "cc"{
            
            countrycodeLabel.isHidden=false
        }*/
        else if((mobileText.text?.characters.count)! == 0){
            mobileerrLabel.isHidden=false
            self.mobileerrLabel.text = "Enter a valid mobile number with country code"
        }
        else if (mobileTrim?.characters.count)! < 7{
            
            self.mobileerrLabel.isHidden = false
            self.mobileerrLabel.text = "Invalid Mobile Number"
        }
        else if (mobileTrim?.characters.count)! > 15{
            
            self.mobileerrLabel.isHidden = false
            self.mobileerrLabel.text = "Invalid Mobile Number"
        }
        else if countryCode.text == ""{
            
            mobileerrLabel.isHidden=false
            self.mobileerrLabel.text = "Enter a valid mobile number with country code"

        }

            
        else{
            
            self.nextBtn.isEnabled = false
            mobileerrLabel.isHidden=true
//            countrycodeLabel.isHidden=true
            self.appDelegate.phonenumber = mobileText.text
            self.appDelegate.countrycode = countryCode.text
            registermobile()
            
            //self.navigationController?.pushViewController(ARCityVC(), animated: true)
        }

    }

    
    func registermobile(){
        
        
        activityView.startAnimating()
        
   
        
//        var mobile1 = mobileText.text! as String
//        
//        mobile1 = mobile1.replacingOccurrences(of: "Optional(", with: "")
//        mobile1 = mobile1.replacingOccurrences(of: ")", with: "")
        //print("MMM\(mobile1)")
        
        
        var urlstring:String = "\(signInAPIUrl)mobileExist/mobile/\(mobileText.text!)/"
        
        urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        
        urlstring = urlstring.removingPercentEncoding!
        
        //   urlstring = UTF8.decode(urlstring)
        print(urlstring)
        
        self.callSiginAPI(url: "\(urlstring)")
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if(textField == countryCode){
            if(textField.text?.characters.count == 0){
                self.invalidCC()
            }
            else{
                
            //    countryCode.resignFirstResponder()
                mobileText.becomeFirstResponder()

            }
        }
        else{
            if(textField.text?.characters.count == 0){
            
                //                self.invalidMobile()
            }
            else{
                mobileText.resignFirstResponder()
                view.endEditing(true)
                self.nextAction(self.nextBtn)

            }
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == mobileText{

            self.mobileerrLabel.isHidden = true
        }
        else if textField == countryCode{
            
            
            ////  countrycodeBtnOutlet.isHidden=true
           /* let picker = MICountryPicker { (name, code) -> () in
                print(code)
            }
            
            // Optional: To pick from custom countries list
            picker.customCountriesCode = ["EG", "US", "AF", "AQ", "AX", "IN","AL","DZ","AS","AD","AO","AI","AG","AR","AM","AW","AU","AT","AZ","BS","BH","BD","BB","BY","BE","BZ","BJ","BM","BT","BO","BA","BW","BR","IO","BN","BG","BF","BI","KH","CM","CA","CV","KY","CF","TD","CL","CN","CX","CC","CO","KM","CG","CD","CK","CR","CI","HR","CU","CY","CZ","DK","DJ","DM","DO","EC","EG","SV","GQ","ER","EE","ET","FK","FO","FJ","FI","FR","GF","PF","GA","GM","GE","DE","GH","GI","GR","GL","GD","GP","GU","GT","GG","GN","GW","GY","HT","VA","HN","HK","HU","IS","ID","IR","IQ","IE","IM","IL","IT","JM","JP","JE","JO","KZ","KE","KI","KP","KR","KW","KG","LA","LV","LB","LS","LR","LY","LI","LT","LU","MO","MK","MG","MW","MY","MV","ML","MT","MH","MQ","MR","MU","YT","MX","FM","MD","MC","MN","ME","MS","MA","MZ","MM","NA","NR","NP","NL","AN","NC","NZ","NI","NE","NZ","NU","NF","MP","NO","OM","PK","PW","PS","PA","PG","PY","PE","PH","PN","PL","PT","PR","QA","RO","RU","RW","RE","BL","SH","KN","LC","MF","PM","VC","WS","SM","ST","SA","SN","RS","SC","SL","SG","SK","SI","SB","SO","ZA","SS","GS","ES","LK","SD","SR","SJ","SZ","SE","CH"]
            
            
            // delegate
            picker.delegate = self
            
            // Display calling codes
            picker.showCallingCodes = true
            
            // or closure
            picker.didSelectCountryClosure = { name, code in
                
                
                print(code)
                self.code = code
                let phoneUtil = NBPhoneNumberUtil()
                
                do {
                    if code != ""{
                        
                        let abc = try phoneUtil.getExampleNumber("\(self.code)")
                        print(abc)
                        print(abc.nationalNumber)
                        var str = "\(abc.nationalNumber!)"
                        print(str.characters.count)
                        self.codeLength = str.characters.count
                    }
                }
                catch let error as NSError {
                    print(error.localizedDescription)
                }
                
            }
            
            
            navigationController?.pushViewController(picker, animated: true)*/
        }
        else{
            
        }
     
        return true
    }
    func callSiginAPI(url : String){
        
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
           
                   
                    activityView.startAnimating()
                    
                    //signup()
                    self.navigationController?.pushViewController(ARReferralCode(), animated: true)
                   // self.navigationController?.pushViewController(ARCityVC(), animated: true)
                    
                    activityView.stopAnimating()
                    self.nextBtn.isEnabled = true
                }
                else{
                    
                    self.nextBtn.isEnabled = true
                    
                    activityView.stopAnimating()
                    
                    self.mobileerrLabel.isHidden = false
                    //Enter a valid mobile number with country code
                    self.mobileerrLabel.text = "Mobile number already exist"
                    
                   /* let toastLabel = UILabel(frame: CGRect(x: 16.0, y: 150, width: 300, height: 30))
                    toastLabel.backgroundColor = UIColor.black
                    toastLabel.textColor = UIColor.white
                    toastLabel.textAlignment = NSTextAlignment.center;
                    self.view.addSubview(toastLabel)
                    toastLabel.text = "Mobile number already exist"
                    toastLabel.alpha = 1.0
                    toastLabel.layer.cornerRadius = 0;
                    toastLabel.clipsToBounds  =  true
                    
                    UIView.animate(withDuration: 4.0, delay: 0.1, options: UIViewAnimationOptions.curveEaseOut, animations: {
                        
                        toastLabel.alpha = 0.0
                        
                    })*/
                    
                    
                }
            }
        }
        catch{
            
            activityView.stopAnimating()
            
            print(error)
            
        }
        
    }

    
    func invalidCC(){
        
      //  countryCode.borderActiveColor = UIColor.red
      //  countryCode.borderInactiveColor = UIColor.red
      //  countryCode.placeholderColor = UIColor.red

    }
    
    func invalidMobile(){
        
        mobileText.borderActiveColor = UIColor.red
        mobileText.borderInactiveColor = UIColor.red
        mobileText.placeholderColor = UIColor.red

    }
    
    func valid(){
        
     //   countryCode.borderActiveColor = UIColor.black
     //   countryCode.borderInactiveColor = UIColor.black
     //   countryCode.placeholderColor = UIColor.black
        
        mobileText.borderActiveColor = UIColor.black
        mobileText.borderInactiveColor = UIColor.black
        mobileText.placeholderColor = UIColor.black


    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var result = true
        let str:NSString! = "\(textField.text!)" as NSString!
        
        let prospectiveText = (str).replacingCharacters(in: range, with: string)
        
    //    let prospectiveText = (str).replacingCharacters(in: range, with: string)
     
       /* if(textField == countryCode){
            if string.characters.count > 0 {
                
         //       let disallowedCharacterSet = CharacterSet.whitespaces
                let inverseSet = NSCharacterSet(charactersIn:"0123456789").inverted
                
                let components = string.components(separatedBy: inverseSet)
                
                
                let filtered = components.joined(separator: "")
                return string == filtered
                
                if range.length + range.location > (textField.text?.characters.count)! {
                    return false
                }
                let newLength = (textField.text?.characters.count)! + string.characters.count - range.length
                return newLength <= 4
            }
        }*/
        
        if(textField == mobileText){
            
            if string.characters.count > 0 {
                
                let disallowedCharacterSet = CharacterSet(charactersIn: "0123456789").inverted
                
                let replacementStringIsLegal = string.rangeOfCharacter(from: disallowedCharacterSet) == nil
                if self.codeLength == 0{
                    
                    self.codeCheck = 8
                }
                else{
                    
                    self.codeCheck = self.codeLength
                }

                
                let resultingStringLengthIsLegal = prospectiveText.characters.count <= 15
                
                result = replacementStringIsLegal &&
                    
                resultingStringLengthIsLegal
                
            }
        }
        else
        {
            
            
        }
        
        return result
    }
    
    
    
    @IBAction func btnCountryPicker(_ sender: Any) {
        
        
      ////  countrycodeBtnOutlet.isHidden=true
        let picker = MICountryPicker { (name, code) -> () in
            print(code)
        }
        
        // Optional: To pick from custom countries list
        picker.customCountriesCode = ["EG", "US", "AF", "AQ", "AX", "IN","AL","DZ","AS","AD","AO","AI","AG","AR","AM","AW","AU","AT","AZ","BS","BH","BD","BB","BY","BE","BZ","BJ","BM","BT","BO","BA","BW","BR","IO","BN","BG","BF","BI","KH","CM","CA","CV","KY","CF","TD","CL","CN","CX","CC","CO","KM","CG","CD","CK","CR","CI","HR","CU","CY","CZ","DK","DJ","DM","DO","EC","EG","SV","GQ","ER","EE","ET","FK","FO","FJ","FI","FR","GF","PF","GA","GM","GE","DE","GH","GI","GR","GL","GD","GP","GU","GT","GG","GN","GW","GY","HT","VA","HN","HK","HU","IS","ID","IR","IQ","IE","IM","IL","IT","JM","JP","JE","JO","KZ","KE","KI","KP","KR","KW","KG","LA","LV","LB","LS","LR","LY","LI","LT","LU","MO","MK","MG","MW","MY","MV","ML","MT","MH","MQ","MR","MU","YT","MX","FM","MD","MC","MN","ME","MS","MA","MZ","MM","NA","NR","NP","NL","AN","NC","NZ","NI","NE","NZ","NU","NF","MP","NO","OM","PK","PW","PS","PA","PG","PY","PE","PH","PN","PL","PT","PR","QA","RO","RU","RW","RE","BL","SH","KN","LC","MF","PM","VC","WS","SM","ST","SA","SN","RS","SC","SL","SG","SK","SI","SB","SO","ZA","SS","GS","ES","LK","SD","SR","SJ","SZ","SE","CH"]

        
        // delegate
        picker.delegate = self
        
        // Display calling codes
        picker.showCallingCodes = true
        
        // or closure
        picker.didSelectCountryClosure = { name, code in
            
            
            print(code)
            self.code = code
            let phoneUtil = NBPhoneNumberUtil()
            
            do {
                if code != ""{
                    
                    let abc = try phoneUtil.getExampleNumber("\(self.code)")
                    print(abc)
                    print(abc.nationalNumber)
                    var str = "\(abc.nationalNumber!)"
                    print(str.characters.count)
                    self.codeLength = str.characters.count
                }
            }
            catch let error as NSError {
                print(error.localizedDescription)
            }

        }
        
        
        navigationController?.pushViewController(picker, animated: true)
    }

    
    



}
extension ARRegisterMobile: MICountryPickerDelegate {
    
    func countryPicker(_ picker: MICountryPicker, didSelectCountryWithName name: String, code: String) {
        // picker.navigationController?.popToRootViewController(animated: true)
        // label.text = "Selected Country: \(name)"
    }
    
    func countryPicker(_ picker: MICountryPicker, didSelectCountryWithName name: String, code: String, dialCode: String) {
        
        //  picker.navigationController?.popToRootViewController(animated: true)
        
        //  navigationController!.isNavigationBarHidden = true
        picker.navigationController?.popViewController(animated: true)
        
        countryCode.text = "\(dialCode)"
        countryCode.textColor = UIColor.black
        self.mobileerrLabel.isHidden = true
        
    }
}
