//
//  ARSoSVC.swift
//  SIX Rider
//
//  Created by Apple on 08/03/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit
import libPhoneNumber_iOS
import Alamofire
import MessageUI
import SwiftMessages

class ARSoSVC: UIViewController,UITextFieldDelegate,MFMessageComposeViewControllerDelegate {

    @IBOutlet weak var cclabel1: UILabel!
    @IBOutlet weak var updateview: UIView!
    @IBOutlet weak var setting: UIButton!
    @IBOutlet weak var emergencysms: UIButton!
    @IBOutlet weak var cclabel2: UILabel!
    
    @IBOutlet weak var baseview: UIView!
    @IBOutlet var emglab: UILabel!
    @IBOutlet weak var mobileerr1: UILabel!
    let appDelegatestatus = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet weak var mobileerr2: UILabel!
    
    @IBOutlet weak var mobilenumber1: UITextField!
    @IBOutlet weak var mobilenumber2: UITextField!
    
    @IBOutlet weak var ccbutton2: UIButton!
    @IBOutlet weak var ccbutton1: UIButton!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var code1 = ""
    var code = ""
    var codeLength = 0
    var codeLength1 = 0
    var viewAPIUrl = live_rider_url
    
    typealias jsonSTD = NSArray
    
    typealias jsonSTDImage = NSDictionary
    
    typealias jsonSTDAny = [String : AnyObject]
     //var rippleView: SMRippleView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.rippleview.isHidden = false
//        let rippleView = SMRippleView(frame: baseview.frame, rippleColor: UIColor.black, rippleThickness: 0.2, rippleTimer: 0.8, fillColor: UIColor.black, animationDuration: 3, parentFrame: self.view.frame)
//        self.view.addSubview(rippleView)
//
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ARwalletVC.dismissKeyboard))
        view.addGestureRecognizer(tap)
        self.updateview.isHidden = true
        self.mobileerr1.isHidden = true
        self.mobileerr2.isHidden = true
        navigationController!.isNavigationBarHidden = true
        UINavigationBar.appearance().backgroundColor = UIColor.clear
        emglab.layer.borderWidth = 2.0
        emglab.layer.backgroundColor = UIColor.red.cgColor
        emglab.layer.borderColor = UIColor.red.cgColor

        // Do any additional setup after loading the view.
    }
    
    
    
    func dismissKeyboard() {
        view.endEditing(true)
        navigationController!.isNavigationBarHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
      
        navigationController!.isNavigationBarHidden = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func emergencysmsaction(_ sender: Any) {
       // self.appDelegate.emergencyno1
       // self.appDelegate.emergencyno2
        
      
            
            self.msgAction(msgNum: self.appDelegate.emergencyno1,msgNum1: self.appDelegate.emergencyno2)
            
       

        self.updateview.isHidden = true
        
        
    }
    func msgAction(msgNum : String,msgNum1 : String){
        
        
     
        
        
        if (MFMessageComposeViewController.canSendText()) {
            let message = "Emergency Contact in SIX"
            let controller = MFMessageComposeViewController()
            controller.body = message
            controller.recipients = [msgNum,msgNum1]
            
            print(controller.recipients)
            
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }else{
            
            self.callNotSupportAlert(error: "This device not support to message")
        }
    }
    func callNotSupportAlert(error : String){
        
        let warning = MessageView.viewFromNib(layout: .CardView)
        warning.configureTheme(.warning)
        warning.configureDropShadow()
        let iconText = "" //"🤔"
        warning.configureContent(title: "", body: "\(error)", iconText: iconText)
        warning.button?.isHidden = true
        var warningConfig = SwiftMessages.defaultConfig
        warningConfig.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
        SwiftMessages.show(config: warningConfig, view: warning)
        
    }
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        //... handle sms screen actions
        self.dismiss(animated: true, completion: nil)
        
        
    }

    
    @IBAction func settingaction(_ sender: Any) {
        
       // http://demo.cogzideltemplates.com/tommy/rider/getEmergencyDetails/user_id/\(self.appDelegate.userid)/
        
        var urlstring:String = "\(viewAPIUrl)getEmergencyDetails/user_id/\(self.appDelegate.userid)/"
        
        urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        
        urlstring = urlstring.removingPercentEncoding!
        
        urlstring = urlstring.replacingOccurrences(of: "Optional(", with: "")
        urlstring = urlstring.replacingOccurrences(of: ")", with: "")
        urlstring = urlstring.replacingOccurrences(of: "\"", with: "")
        
        print(urlstring)
        
        self.viewsosupdate(url: "\(urlstring)")
        self.updateview.isHidden = false
       // navigationController!.isNavigationBarHidden = false
    }
    func viewsosupdate(url : String){
        
        //  self.activityView.startAnimating()
        
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
                
                if(final as! String == "Success")
                {
                    print("Mobile number Viewed")
                    
                    self.appDelegate.emergencyno1 = value.object(forKey: "contact_number1") as? String
                    self.appDelegate.emergencyno2 = value.object(forKey: "contact_number2") as? String
                    
                    self.appDelegate.countrycode1 = (value.object(forKey: "contact_number1_code") as? String)!
                    self.appDelegate.countrycode2 = (value.object(forKey: "contact_number2_code") as? String)!
                    
                    
                    print(self.appDelegate.countrycode1)
                    print(self.appDelegate.countrycode2)
                    print(self.appDelegate.emergencyno1)
                    print(self.appDelegate.emergencyno2)
                    
                    if self.appDelegate.emergencyno1 == "" {
                        self.codeLength = 10
                    }
                    else{
                        self.codeLength = self.appDelegate.emergencyno1.characters.count
                    }
                    if self.appDelegate.emergencyno2 == "" {
                        self.codeLength1 = 10
                    }
                    else{
                        self.codeLength1 = self.appDelegate.emergencyno2.characters.count
                    }
                    
                    self.cclabel1.text = self.appDelegate.countrycode1
                    self.cclabel2.text = self.appDelegate.countrycode2
                    self.mobilenumber1.text = self.appDelegate.emergencyno1
                    self.mobilenumber2.text = self.appDelegate.emergencyno2
                }
                else{
                   
                    self.mobilenumber1.text = ""
                    self.mobilenumber2.text = ""
                    
                }
            }
            else{
               self.mobilenumber1.text = ""
                self.mobilenumber2.text = ""
            }
        }
        catch{
            print(error)
        }
    }
    @IBOutlet weak var backaction: UIButton!
    
    
    @IBAction func updateaction(_ sender: Any) {
        
        
        
        var code = self.codeLength
        if self.codeLength == 0{
            code = 10
        }
        else{
            code = self.codeLength
        }
        
        
        var code1 = self.codeLength1
        if self.codeLength1 == 0{
            code1 = 10
        }
        else{
            code1 = self.codeLength1
        }

        let mobileTrim = mobilenumber1.text?.trimmingCharacters(in: .whitespaces)
        
        let mobileTrim1 = mobilenumber2.text?.trimmingCharacters(in: .whitespaces)
        
         if mobilenumber1.text == "" && mobilenumber2.text == "" && mobilenumber1.placeholder == "Mobile Number 1" && mobilenumber2.placeholder == "Mobile Number 2"
         {
           self.mobileerr1.isHidden = false
            self.mobileerr2.isHidden = false
          self.mobileerr1.text = "Enter Mobile Number"
          self.mobileerr2.text = "Enter Mobile Number"
        }
        else if mobilenumber1.text == ""
        {
            self.mobileerr2.isHidden = true
            self.mobileerr1.isHidden = false
            self.mobileerr1.text = "Enter Mobile Number"
           
        }
        else if mobilenumber2.text == ""
        {
            self.mobileerr1.isHidden = true
             self.mobileerr2.isHidden = false
            self.mobileerr2.text = "Enter Mobile Number"
        }
       else if((mobilenumber1.text?.characters.count)! == 0){
            
            //self.btnSave.isEnabled = true
            
            self.mobileerr1.isHidden=false
            self.mobileerr1.text = "Enter a valid mobile number with country code"
        }
        else if (mobileTrim?.characters.count)! < code{
            let d = mobileTrim?.characters.count
            print("MobileTrim<code:\(d)")
            print("code:\(code)")
            //self.btnSave.isEnabled = true
            self.mobileerr2.isHidden = true
            self.mobileerr1.isHidden = false
            self.mobileerr1.text = "Invalid Mobile Number"
        }
         /*else if (mobileTrim?.characters.count)! < 7 || (mobileTrim?.characters.count)! > 13 {
            let d = mobileTrim?.characters.count
            print("MobileTrim<code:\(d)")
            //print("code:\(code)")
            //self.btnSave.isEnabled = true
            self.mobileerr2.isHidden = true
            self.mobileerr1.isHidden = false
            self.mobileerr1.text = "Invalid Mobile Number"
         }*/

       else if (mobileTrim?.characters.count)! > code{
            let  d = mobileTrim?.characters.count
            print("MobileTrim>code:\(d)")
            print("code:\(code)")
            //self.btnSave.isEnabled = true
           self.mobileerr2.isHidden = true
            self.mobileerr1.isHidden = false
            self.mobileerr1.text = "Invalid Mobile Number"
        }
        else if cclabel1.text == "" || cclabel1.text == "CC"{
            
            //self.btnSave.isEnabled = true
           self.mobileerr2.isHidden = true
            self.mobileerr1.isHidden=false
            self.mobileerr1.text = "Enter country code"
            
        }
            
        
       
        
        
       else if((mobilenumber2.text?.characters.count)! == 0){
            
            //self.btnSave.isEnabled = true
            self.mobileerr1.isHidden = true
            self.mobileerr2.isHidden=false
            self.mobileerr2.text = "Enter a valid mobile number with country code"
        }
        else if (mobileTrim1?.characters.count)! < code1{
            let f = mobileTrim1?.characters.count
            print("MobileTrim1<code1:\(f)")
            print("code1:\(code1)")
            //self.btnSave.isEnabled = true
             self.mobileerr1.isHidden = true
            self.mobileerr2.isHidden = false
            self.mobileerr2.text = "Invalid Mobile Number"
        }
            else if (mobileTrim1?.characters.count)! > code1{
            let f = mobileTrim1?.characters.count
            print("MobileTrim1>code1:\(f)")
            print("code1:\(code1)")
            //self.btnSave.isEnabled = true
             self.mobileerr1.isHidden = true
            self.mobileerr2.isHidden = false
            self.mobileerr2.text = "Invalid Mobile Number"
        }
            /*else if (mobileTrim?.characters.count)! < 7 || (mobileTrim?.characters.count)! > 13 {
             let d = mobileTrim?.characters.count
             print("MobileTrim<code:\(d)")
             //print("code:\(code)")
             //self.btnSave.isEnabled = true
             self.mobileerr1.isHidden = true
             self.mobileerr2.isHidden = false
             self.mobileerr2.text = "Invalid Mobile Number"
             }*/
        else if cclabel2.text == "" || cclabel2.text == "CC"{
            
            //self.btnSave.isEnabled = true
             self.mobileerr1.isHidden = true
            self.mobileerr2.isHidden=false
            self.mobileerr2.text = "Enter country code"
            
        }
            
       
            else{
            
                self.appDelegate.emergencyno1 = self.mobilenumber1.text
                self.appDelegate.emergencyno2 = self.mobilenumber2.text
            
            self.appDelegate.countrycode1 = self.cclabel1.text
            self.appDelegate.countrycode2 = self.cclabel2.text
                
                print(self.appDelegate.emergencyno1)
                print(self.appDelegate.emergencyno2)
            
                print(self.appDelegate.countrycode1)
                print(self.appDelegate.countrycode2)
                print(self.appDelegate.userid)
            
            //http://demo.cogzideltemplates.com/tommy/rider/addEmergencyDetails/user_id/58b10dbfda71b40f1b8b4560/contact_number1/+91985741526/contact_number2/+91987654321
            
            //http://demo.cogzideltemplates.com/tommy/rider/addEmergencyDetails/user_id/58b10dbfda71b40f1b8b4560/contact_number1/985741526/contact_number2/987654321/contact_number_1_country_code/+91/contact_number_2_country_code/+1
            
            
            var urlstring:String = "\(viewAPIUrl)addEmergencyDetails/user_id/\(self.appDelegate.userid)/contact_number1/\(self.appDelegate.emergencyno1)/contact_number2/\(self.appDelegate.emergencyno2)/contact_number1_code/\(self.appDelegate.countrycode1)/contact_number2_code/\(self.appDelegate.countrycode2)"
        
            urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
            
            urlstring = urlstring.removingPercentEncoding!
            
            urlstring = urlstring.replacingOccurrences(of: "Optional(", with: "")
            urlstring = urlstring.replacingOccurrences(of: ")", with: "")
             urlstring = urlstring.replacingOccurrences(of: "\"", with: "")
            
            print(urlstring)
            
            self.callsosupdate(url: "\(urlstring)")

            
            
                 self.mobileerr2.isHidden=true
                
                // self.btnSave.isEnabled = false
                self.mobileerr1.isHidden=true
                self.updateview.isHidden=true
            navigationController!.isNavigationBarHidden = true
            UINavigationBar.appearance().backgroundColor = UIColor.clear
                
            }

            // self.btnSave.isEnabled = false
        
            
       
        
    }
    func callsosupdate(url : String){
        
        //  self.activityView.startAnimating()
        
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
                
                if(final as! String == "Success")
                {
                    print("Mobile number updated Successfully")
                    navigationController!.isNavigationBarHidden = true
                    
                }
                else{
                    print("Mobile number not updated")
                }
            
            }
            else{
                print("Status fail")
            }
            
            
        }
        catch{
            print(error)
        }
    }
    
    @IBAction func cancelaction(_ sender: Any) {
        navigationController!.isNavigationBarHidden = true
        UINavigationBar.appearance().backgroundColor = UIColor.clear
        self.updateview.isHidden=true
        self.mobileerr1.isHidden = true
        self.mobileerr2.isHidden = true
    }
    
    @IBAction func backactionview(_ sender: Any) {
        navigationController!.isNavigationBarHidden = true
        UINavigationBar.appearance().backgroundColor = UIColor.clear
         self.updateview.isHidden = true
        self.mobileerr1.isHidden = true
        self.mobileerr2.isHidden = true
    }
    
    
    @IBAction func ccaction1(_ sender: Any) {
        let picker1 = MICountryPicker { (name, code) -> () in
            print(code)
            
        }
        self.appDelegate.ccstatus="1"
        
        picker1.customCountriesCode = ["EG", "US", "AF", "AQ", "AX", "IN","AL","DZ","AS","AD","AO","AI","AG","AR","AM","AW","AU","AT","AZ","BS","BH","BD","BB","BY","BE","BZ","BJ","BM","BT","BO","BA","BW","BR","IO","BN","BG","BF","BI","KH","CM","CA","CV","KY","CF","TD","CL","CN","CX","CC","CO","KM","CG","CD","CK","CR","CI","HR","CU","CY","CZ","DK","DJ","DM","DO","EC","EG","SV","GQ","ER","EE","ET","FK","FO","FJ","FI","FR","GF","PF","GA","GM","GE","DE","GH","GI","GR","GL","GD","GP","GU","GT","GG","GN","GW","GY","HT","VA","HN","HK","HU","IS","ID","IR","IQ","IE","IM","IL","IT","JM","JP","JE","JO","KZ","KE","KI","KP","KR","KW","KG","LA","LV","LB","LS","LR","LY","LI","LT","LU","MO","MK","MG","MW","MY","MV","ML","MT","MH","MQ","MR","MU","YT","MX","FM","MD","MC","MN","ME","MS","MA","MZ","MM","NA","NR","NP","NL","AN","NC","NZ","NI","NE","NZ","NU","NF","MP","NO","OM","PK","PW","PS","PA","PG","PY","PE","PH","PN","PL","PT","PR","QA","RO","RU","RW","RE","BL","SH","KN","LC","MF","PM","VC","WS","SM","ST","SA","SN","RS","SC","SL","SG","SK","SI","SB","SO","ZA","SS","GS","ES","LK","SD","SR","SJ","SZ","SE","CH","SY","TW","TJ","TZ","TH","TL","TG","TK","TO","TT","TN","TR","TM","TC","TV","UG","UA","AE","GB","US","UY","UZ","VU","VE","VN","VG","VI","WF","YE","ZM","ZW"]
        
        // delegate
        picker1.delegate = self
        
        // Display calling codes
        picker1.showCallingCodes = true
        
        // or closure
        picker1.didSelectCountryClosure = { name, code in
            
            
            print(code)
            self.code = code
            print(self.code)
            let phoneUtil = NBPhoneNumberUtil()
            
            do {
                if code != ""{
                    
                    let abc = try phoneUtil.getExampleNumber("\(self.code)")
                    print(abc)
                    print(abc.nationalNumber)
                    var str = "\(abc.nationalNumber!)"
                    print(str.characters.count)
                    self.codeLength = str.characters.count
                    print(self.codeLength)
                }
            }
            catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        
        
        navigationController?.pushViewController(picker1, animated: true)
        navigationController!.isNavigationBarHidden = true
    }
    
    
    
    @IBAction func ccaction2(_ sender: Any) {
        let picker = MICountryPicker { (name, code) -> () in
            print(code)
        
    }
       self.appDelegate.ccstatus="2"
        picker.customCountriesCode = ["EG", "US", "AF", "AQ", "AX", "IN","AL","DZ","AS","AD","AO","AI","AG","AR","AM","AW","AU","AT","AZ","BS","BH","BD","BB","BY","BE","BZ","BJ","BM","BT","BO","BA","BW","BR","IO","BN","BG","BF","BI","KH","CM","CA","CV","KY","CF","TD","CL","CN","CX","CC","CO","KM","CG","CD","CK","CR","CI","HR","CU","CY","CZ","DK","DJ","DM","DO","EC","EG","SV","GQ","ER","EE","ET","FK","FO","FJ","FI","FR","GF","PF","GA","GM","GE","DE","GH","GI","GR","GL","GD","GP","GU","GT","GG","GN","GW","GY","HT","VA","HN","HK","HU","IS","ID","IR","IQ","IE","IM","IL","IT","JM","JP","JE","JO","KZ","KE","KI","KP","KR","KW","KG","LA","LV","LB","LS","LR","LY","LI","LT","LU","MO","MK","MG","MW","MY","MV","ML","MT","MH","MQ","MR","MU","YT","MX","FM","MD","MC","MN","ME","MS","MA","MZ","MM","NA","NR","NP","NL","AN","NC","NZ","NI","NE","NZ","NU","NF","MP","NO","OM","PK","PW","PS","PA","PG","PY","PE","PH","PN","PL","PT","PR","QA","RO","RU","RW","RE","BL","SH","KN","LC","MF","PM","VC","WS","SM","ST","SA","SN","RS","SC","SL","SG","SK","SI","SB","SO","ZA","SS","GS","ES","LK","SD","SR","SJ","SZ","SE","CH","SY","TW","TJ","TZ","TH","TL","TG","TK","TO","TT","TN","TR","TM","TC","TV","UG","UA","AE","GB","US","UY","UZ","VU","VE","VN","VG","VI","WF","YE","ZM","ZW"]
        
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
                    self.codeLength1 = str.characters.count
                    print(self.codeLength1)
                }
            }
            catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        
        
        navigationController?.pushViewController(picker, animated: true)
        navigationController!.isNavigationBarHidden = true
        }


    
    
    @IBAction func mainback(_ sender: Any) {
        appDelegate.leftMenu()
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
extension ARSoSVC: MICountryPickerDelegate {
    
    func countryPicker(_ picker: MICountryPicker, didSelectCountryWithName name: String, code: String) {
        navigationController!.isNavigationBarHidden = true
        // picker.navigationController?.popToRootViewController(animated: true)
        // label.text = "Selected Country: \(name)"
    }
    
    func countryPicker(_ picker: MICountryPicker, didSelectCountryWithName name: String, code: String, dialCode: String) {
        
        //  picker.navigationController?.popToRootViewController(animated: true)
        navigationController!.isNavigationBarHidden = true
        mobilenumber1.resignFirstResponder()
        mobilenumber2.resignFirstResponder()
        
        
        //  navigationController!.isNavigationBarHidden = true
        picker.navigationController?.popViewController(animated: true)
        if(self.appDelegatestatus.ccstatus == "1")
       {
        navigationController!.isNavigationBarHidden = true
        cclabel1.text = "\(dialCode)"
        //self.mobileerrLabel.isHidden=true
        cclabel1.textColor = UIColor.black
        }
       if(self.appDelegatestatus.ccstatus == "2"){
        navigationController!.isNavigationBarHidden = true
        cclabel2.text = "\(dialCode)"
        //self.mobileerrLabel.isHidden=true
        cclabel2.textColor = UIColor.black
        }
        
    }
    
    
}


