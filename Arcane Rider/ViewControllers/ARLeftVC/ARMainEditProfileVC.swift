//
//  ARMainEditProfileVC.swift
//  Arcane Rider
//
//  Created by Apple on 22/12/16.
//  Copyright © 2016 Apple. All rights reserved.
//

import UIKit
import Alamofire
import libPhoneNumber_iOS

class ARMainEditProfileVC: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var nicknametextfield: UITextField!
    
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var nicknameerror: UILabel!
    @IBOutlet weak var countrycodeLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var viewCircleEdit: UIView!
    
    @IBOutlet weak var btnSave: UIButton!

    @IBOutlet weak var referaltextfield: UITextField!
    @IBOutlet weak var textFieldFirstName: UITextField!
    @IBOutlet weak var textFieldLastName: UITextField!
    @IBOutlet weak var textFieldPhone: UITextField!
    @IBOutlet weak var textFieldEmail: UITextField!

    //@IBOutlet weak var picload: UIActivityIndicatorView!
    @IBOutlet weak var viewActivity: UIView!

    @IBOutlet weak var mobileerrLabel: UILabel!
    internal var passEditProfile : String!
    var viewAPIUrl = live_rider_url
    
    typealias jsonSTD = NSArray
    
    typealias jsonSTDImage = NSDictionary

    typealias jsonSTDAny = [String : AnyObject]

    var selectedPic : String!
    
    var tCBValid : String!

    var code = ""
    var codeLength = 0
    var codeCheck = 10

    override var prefersStatusBarHidden: Bool {
                return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // picload.isHidden = true
        nicknameerror.isHidden=true
        // Do any additional setup after loading the view.
        
        textFieldFirstName.isEnabled = false
        textFieldLastName.isEnabled = false
        
        navigationController!.navigationBar.barStyle = .black
      //  picload.startAnimating()
        navigationController!.isNavigationBarHidden = false
        
        self.viewActivity.isHidden = true
        
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "arrow-left.png")!, for: .normal)
        button.addTarget(self, action: #selector(ARMainEditProfileVC.profileBtn(_:)), for: .touchUpInside)
        //CGRectMake(0, 0, 53, 31)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        //(frame: CGRectMake(3, 5, 50, 20))
        let label = UILabel(frame: CGRect(x: 10, y: 5, width: 150, height: 20))
        // label.font = UIFont(name: "Arial-BoldMT", size: 13)
        label.text = "Edit Profile"
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.clear
        button.addSubview(label)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = barButton

        viewCircleEdit.layer.cornerRadius = viewCircleEdit.frame.size.width / 2
        viewCircleEdit.clipsToBounds = true
        
        self.activityView.startAnimating()
        
        var urlstring:String = "\(viewAPIUrl)editProfile/user_id/\(self.appDelegate.userid!)"
        
        urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        
        urlstring = urlstring.removingPercentEncoding!
        
        print(urlstring)
        
        self.callviewAPI(url: "\(urlstring)")

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ARMainEditProfileVC.hidekeyboard))
        
        tapGesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGesture)
        self.mobileerrLabel.isHidden = true
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
    
    func hidekeyboard()
    {
        self.view.endEditing(true)
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
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    func profileBtn(_ Selector: AnyObject) {
        
       // self.dismiss(animated: true, completion: nil)
        
        self.navigationController?.popViewController(animated: true)
        
    }
    func tCBPhoneNumberValidation()
    {
        let phoneUtil = NBPhoneNumberUtil()
        
        do {
            
            let phNumber = textFieldPhone.text!
            let phoneNumber: NBPhoneNumber = try phoneUtil.parse("\(phNumber)", defaultRegion: "\(self.tCBValid!)")
            let formattedString: String = try phoneUtil.format(phoneNumber, numberFormat: .E164)
            
            
            
            NSLog("[%@]", formattedString)
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == textFieldPhone{
            
            self.mobileerrLabel.isHidden=true
        }
        else if textField == textFieldLastName{
            
            self.mobileerrLabel.isHidden=true

        }
        else{
            
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var result = true
        let str:NSString! = "\(textField.text!)" as NSString!
        
        let prospectiveText = (str).replacingCharacters(in: range, with: string)
        
        // var disallowedCharacterSet = CharacterSet.whitespaces
        var limit = 30
        
        
        if(textField == textFieldEmail){
            if string.characters.count > 0 {
                
                let disallowedCharacterSet = CharacterSet(charactersIn: "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ.@_-!#$%(){}^&*+").inverted
                
                let replacementStringIsLegal = string.rangeOfCharacter(from: disallowedCharacterSet) == nil
                
                let resultingStringLengthIsLegal = prospectiveText.characters.count <= limit
                
                result = replacementStringIsLegal &&
                    
                resultingStringLengthIsLegal
                
            }
        }
            
        else if(textField == textFieldFirstName){
            limit = 25
            if string.characters.count > 0 {
                
                let disallowedCharacterSet = CharacterSet(charactersIn: "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ").inverted
                
                let replacementStringIsLegal = string.rangeOfCharacter(from: disallowedCharacterSet) == nil
                
                let resultingStringLengthIsLegal = prospectiveText.characters.count <= limit
                
                result = replacementStringIsLegal &&
                    
                resultingStringLengthIsLegal
                
            }
        }
        else if (textField == textFieldLastName){
            limit = 25
            if string.characters.count > 0 {
                
                let disallowedCharacterSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ").inverted
                
                let replacementStringIsLegal = string.rangeOfCharacter(from: disallowedCharacterSet) == nil
                
                let resultingStringLengthIsLegal = prospectiveText.characters.count <= limit
                
                result = replacementStringIsLegal &&
                    
                resultingStringLengthIsLegal
                
            }
        }
        else if(textField == textFieldPhone){
            
            /*if string.characters.count > 0 {
                
                let disallowedCharacterSet = CharacterSet(charactersIn: "0123456789").inverted
                
                let replacementStringIsLegal = string.rangeOfCharacter(from: disallowedCharacterSet) == nil
                
                let resultingStringLengthIsLegal = prospectiveText.characters.count <= limit
                
                result = replacementStringIsLegal &&
                    
                resultingStringLengthIsLegal
                
            }*/
    
            if string.characters.count > 0 {
                
                let disallowedCharacterSet = CharacterSet(charactersIn: "0123456789").inverted
                
                let replacementStringIsLegal = string.rangeOfCharacter(from: disallowedCharacterSet) == nil
                
                if self.codeLength == 0{
                    
                    self.codeCheck = 10
                }
                else{
                    
                    self.codeCheck = self.codeLength
                }
                
                
                let resultingStringLengthIsLegal = prospectiveText.characters.count <= 15
                
                result = replacementStringIsLegal &&
                    
                resultingStringLengthIsLegal
                
            }
        }
        else{
            limit = 20
        }
        
        return result
    }

    @IBAction func btnImageAction(_ sender: Any) {
        
        optionsMenu()
    }
    @IBAction func btnCountryAction(_ sender: Any) {
        
        let picker = MICountryPicker { (name, code) -> () in
            print(code)
        }
        
        // Optional: To pick from custom countries list
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
                    self.codeLength = str.characters.count
                }
            }
            catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        
        
        navigationController?.pushViewController(picker, animated: true)
    }

    func callviewAPI(url : String){
        
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
                print(final)
                if(final as! String == "Success"){
                    
                    var firstname = value.object(forKey: "firstname") as? String
                    var lastname = value.object(forKey: "lastname") as? String
                    let mobile:String = value.object(forKey: "mobile") as! String
                    let cc:String = value.object(forKey: "country_code") as! String
                    let email:String = value.object(forKey: "email") as! String
                    let profilePic = value.object(forKey: "profile_pic") as! String
                    
                     var nick_name = value.object(forKey: "nick_name") as! String
                     let refrel_code = value.object(forKey: "refrel_code") as! String
                    
                    if firstname != nil{
                        firstname = firstname?.replacingOccurrences(of: "Optional(", with: "")
                        firstname = firstname?.replacingOccurrences(of: ")", with: "")
                        firstname = firstname?.replacingOccurrences(of: "%20", with: " ")
                        firstname = firstname?.replacingOccurrences(of: "\"", with: "")
                        
                    }
                    else{
                        firstname = ""
                    }
                    if nick_name != nil{
                        nick_name = nick_name.replacingOccurrences(of: "Optional(", with: "")
                        nick_name = nick_name.replacingOccurrences(of: ")", with: "")
                        nick_name = nick_name.replacingOccurrences(of: "%20", with: " ")
                        nick_name = nick_name.replacingOccurrences(of: "\"", with: "")
                        nick_name = nick_name.replacingOccurrences(of: "%2522", with: "")
                        
                    }
                    else{
                        nick_name = ""
                    }
                    if lastname != nil{
                        lastname = lastname?.replacingOccurrences(of: "Optional(", with: "")
                        lastname = lastname?.replacingOccurrences(of: ")", with: "")
                        lastname = lastname?.replacingOccurrences(of: "%20", with: " ")
                        lastname = lastname?.replacingOccurrences(of: "\"", with: "")
                        
                    }
                    else{
                        lastname = ""
                    }

                    textFieldFirstName.text = firstname
                    textFieldLastName.text = lastname
                    textFieldEmail.text = email
                    nicknametextfield.text=nick_name
                    referaltextfield.text=refrel_code
                    var ccValue = cc
                    
                    let value = profilePic
                    UserDefaults.standard.setValue(value, forKey: "profilePic")
                    
                    if ccValue != ""{
                        
                        countrycodeLabel.text = ccValue
//                        self.code = ccValue
                    }
                    else{
                        
                        countrycodeLabel.text = "cc"

                    }
                    
                    if mobile == "" {
                        self.codeLength = 10
                    }
                    else{
                        self.codeLength = mobile.characters.count
                    }
                    textFieldPhone.text = mobile
                    
                    
                    if profilePic == nil{
                        
                        imageView.image = UIImage(named: "UserPic_old.png")
                        
                    }
                    else if profilePic == ""{
                        
                        imageView.image = UIImage(named: "UserPic_old.png")
                        UserDefaults.standard.setValue(profilePic, forKey: "GProfilePic")
                    }
                    else{
                        
                        UserDefaults.standard.setValue(profilePic, forKey: "GProfilePic")
                        imageView.sd_setImage(with: NSURL(string: profilePic) as URL!)
                        
                    }

                   /* var valueProfile = UserDefaults.standard.object(forKey: "GProfilePic") as? String
                    valueProfile = valueProfile?.replacingOccurrences(of: "Optional(", with: "")
                    valueProfile = valueProfile?.replacingOccurrences(of: ")", with: "")
                    
                    if valueProfile == nil{
                        
                        if profilePic == nil{
                            
                            imageView.image = UIImage(named: "UserPic.png")
                            
                        }
                        else if profilePic == ""{
                            
                            imageView.image = UIImage(named: "UserPic.png")
                            
                        }
                        else{
                            
                            imageView.sd_setImage(with: NSURL(string: profilePic) as URL!)
                            
                        }
                        
                    }
                    else{
                        
                        imageView.sd_setImage(with: NSURL(string: valueProfile!) as URL!)
                        
                    }*/

                    self.activityView.stopAnimating()
                    
                    
                }
                else{
                    
                    
                    self.activityView.stopAnimating()
                    
                }
            }
        }
        catch{
            
            print(error)
            
            self.activityView.stopAnimating()
            
        }
        
    }
    @IBAction func btnSaveAction(_ sender: Any) {
        
        //self.btnSave.isEnabled = false

        textFieldEmail.resignFirstResponder()
        textFieldFirstName.resignFirstResponder()
        textFieldLastName.resignFirstResponder()
        textFieldPhone.resignFirstResponder()
        nicknametextfield.resignFirstResponder()
        let mobileTrim = textFieldPhone.text?.trimmingCharacters(in: .whitespaces)

        var code = self.codeLength
        if self.codeLength == 0{
            code = 10
        }
        else{
            code = self.codeLength
        }

        self.activityView.startAnimating()
        
        if textFieldFirstName.text == "" && textFieldLastName.text == "" && textFieldPhone.text
            == "" &&  textFieldEmail.text == "" &&  nicknametextfield.text == ""{
            
            self.activityView.stopAnimating()
            //self.btnSave.isEnabled = true

           /* firstnametextField.layer.borderColor = UIColor.red.cgColor
            lastnametextField.layer.borderColor = UIColor.red.cgColor
            mobilenotextField.layer.borderColor = UIColor.red.cgColor
            emailtextField.layer.borderColor = UIColor.red.cgColor*/
        }
        else if textFieldFirstName.text == "" {
            
            //self.btnSave.isEnabled = true
            self.activityView.stopAnimating()
            self.mobileerrLabel.isHidden=false
            self.mobileerrLabel.text = "Enter your first name"

           // firstnametextField.layer.borderColor = UIColor.red.cgColor
        }
        else if textFieldLastName.text == "" {
            
            self.activityView.stopAnimating()
            //self.btnSave.isEnabled = true
            self.mobileerrLabel.isHidden=false
            self.mobileerrLabel.text = "Enter your last name"

          //  lastnametextField.layer.borderColor = UIColor.red.cgColor
            
        }
        else if nicknametextfield.text == "" {
            
            self.activityView.stopAnimating()
            //self.btnSave.isEnabled = true
            self.nicknameerror.isHidden=false
            self.nicknameerror.text = "Enter your Nick name"
            
            //  lastnametextField.layer.borderColor = UIColor.red.cgColor
            
        }

        /*else if textFieldPhone.text == "" {
            
            self.activityView.stopAnimating()
            
           // mobilenotextField.layer.borderColor = UIColor.red.cgColor
        }*/
        else if textFieldEmail.text == ""{
            
            self.activityView.stopAnimating()
            //self.btnSave.isEnabled = true

           // emailtextField.layer.borderColor = UIColor.red.cgColor
        }
        else if((textFieldPhone.text?.characters.count)! == 0){
            
            //self.btnSave.isEnabled = true
            self.activityView.stopAnimating()
            self.mobileerrLabel.isHidden=false
            self.mobileerrLabel.text = "Enter a valid mobile number with country code"
        }
        else if (mobileTrim?.characters.count)! < 7{

            //self.btnSave.isEnabled = true
            self.activityView.stopAnimating()
            self.mobileerrLabel.isHidden = false
            self.mobileerrLabel.text = "Invalid Mobile Number"
        }
        else if (mobileTrim?.characters.count)! > 15{
            
            //self.btnSave.isEnabled = true
            self.activityView.stopAnimating()
            self.mobileerrLabel.isHidden = false
            self.mobileerrLabel.text = "Invalid Mobile Number"
        }
        else if countrycodeLabel.text == "" || countrycodeLabel.text == "cc"{
            
            //self.btnSave.isEnabled = true
            self.activityView.stopAnimating()
            self.mobileerrLabel.isHidden=false
            self.mobileerrLabel.text = "Enter valid country code"
            
        }

        else{
            
           // self.btnSave.isEnabled = false
            self.mobileerrLabel.isHidden=true
            callUrlMethod()
        }

    }
    
    func callUrlMethod(){
        
        self.activityView.startAnimating()
        
        let fname:String = textFieldFirstName.text! as String
        let lname:String = textFieldLastName.text! as String
        let mobile:String = textFieldPhone.text! as String
        let countryCode:String = countrycodeLabel.text! as String
        let email:String = textFieldEmail.text! as String
        let nickname:String = nicknametextfield.text! as String
        var urlString : String!
        
        if selectedPic == nil{
            
            urlString = "\(viewAPIUrl)updateDetails/user_id/\(self.appDelegate.userid!)/firstname/\(fname)/lastname/\(lname)/mobile/\(mobile)/country_code/\(countryCode)/nick_name/\(nickname)/city/null/email/\(email)/"
        }
        else{
            
            urlString = "\(viewAPIUrl)updateDetails/user_id/\(self.appDelegate.userid!)/firstname/\(fname)/lastname/\(lname)/mobile/\(mobile)/country_code/\(countryCode)/nick_name/\(nickname)/profile_pic/\(self.selectedPic!)/city/null/email/\(email)/"
            
        }
        urlString = urlString.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        
//        urlString = urlString.removingPercentEncoding!
        
        print("Edit profile\(urlString)")
        
        self.calleditAPI(url: "\(urlString!)")

    }
         func calleditAPI(url : String){
        
        self.activityView.startAnimating()
        print(url)
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
                    
                    
                    self.activityView.stopAnimating()
                    if passEditProfile == nil{
                        
                        let allVC = self.navigationController?.viewControllers
                        
                        if  let inventoryListVC = allVC![allVC!.count - 2] as? ARMainProfileVC {
                            
                            self.navigationController!.popToViewController(inventoryListVC, animated: true)
                            
                            // self.btnSave.isEnabled = true
                            
                        }
                        
                    }
                    else if passEditProfile == "No Phone Number Alert"{
                        
                        
                        self.appDelegate.leftMenu()
                        
                        //self.btnSave.isEnabled = true
                        
                    }
                    else{
                        
                        let allVC = self.navigationController?.viewControllers
                        
                        if  let inventoryListVC = allVC![allVC!.count - 2] as? ARMainProfileVC {
                            
                            self.navigationController!.popToViewController(inventoryListVC, animated: true)
                            
                            // self.btnSave.isEnabled = true
                            
                        }
                        
                    }

                    self.appDelegate.callProfileVC()
                    
//                    self.btnSave.isEnabled = true

                 //   self.dismiss(animated: true, completion: nil)
                    
                }
                else{
                    
                    //self.btnSave.isEnabled = true

                    self.activityView.stopAnimating()
                    
                }
            }
        }
        catch{
            
            print(error)
            //self.btnSave.isEnabled = true

            self.activityView.stopAnimating()
            
        }
        
    }
    
    func callImageUpload(){
        
   
        
        let viewImageUrl = "\(live_Driver_url)image_upload/"

        var value = self.selectedPic
        
        var urlstring:String = "\(viewImageUrl)\(value!)"
        
        urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        
        urlstring = urlstring.removingPercentEncoding!
        
        print("image profile\(urlstring)")
        
        self.callImageApi(url: "\(urlstring)")
    }

    func callImageApi(url : String){
        
        //self.activityView.startAnimating()
        
        Alamofire.request(url).responseJSON { (response) in
            
            self.parseDataImage(JSONData: response.data!)
        }
        
    }
    
    func parseDataImage(JSONData : Data){
        
        do{
            
            let readableJSon = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as! jsonSTDImage
            
            print(" !!! \(readableJSon[0])")
            
            let value = readableJSon[0] as AnyObject
            
            if let final = value.object(forKey: "status"){
                print(final)
                if(final as! String == "Success"){
                    
                    
                    self.activityView.stopAnimating()
                    
                    //    self.appDelegate.callProfileVC()
                    
                    self.dismiss(animated: true, completion: nil)
                    
                }
                else{
                    
                    self.activityView.stopAnimating()
                    
                }
            }
        }
        catch{
            
            print(error)
            
            self.activityView.stopAnimating()
            
        }
        
    }

}
extension ARMainEditProfileVC: MICountryPickerDelegate {
    
    func countryPicker(_ picker: MICountryPicker, didSelectCountryWithName name: String, code: String) {
        // picker.navigationController?.popToRootViewController(animated: true)
        // label.text = "Selected Country: \(name)"
    }
    
    func countryPicker(_ picker: MICountryPicker, didSelectCountryWithName name: String, code: String, dialCode: String) {
        
        //  picker.navigationController?.popToRootViewController(animated: true)
        
        textFieldEmail.resignFirstResponder()
        textFieldPhone.resignFirstResponder()
        textFieldFirstName.resignFirstResponder()
        textFieldLastName.resignFirstResponder()
        
        //  navigationController!.isNavigationBarHidden = true
        picker.navigationController?.popViewController(animated: true)
        
        countrycodeLabel.text = "\(dialCode)"
        self.mobileerrLabel.isHidden=true
        countrycodeLabel.textColor = UIColor.black
        
    }
    
    
}

extension ARMainEditProfileVC
: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func optionsMenu() {
        
        let camera = Camera(delegate_: self)
        
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        optionMenu.popoverPresentationController?.sourceView = self.view
        
        let takePhoto = UIAlertAction(title: "Camera", style: .default) { (alert : UIAlertAction!) in
            camera.presentPhotoCamera(target: self, canEdit: true)
            
            
        }
        let sharePhoto = UIAlertAction(title: "Library", style: .default) { (alert : UIAlertAction) in
            camera.presentPhotoLibrary(target: self, canEdit: true)
            
            
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (alert : UIAlertAction) in
            
            
            
        }
        
        optionMenu.addAction(takePhoto)
        optionMenu.addAction(sharePhoto)
        
        optionMenu.addAction(cancel)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        imageView.image = image
        if let data = UIImagePNGRepresentation(image!) {
            
            let filename = getDocumentsDirectory().appendingPathComponent("profile.png")
            try? data.write(to: filename)
            
            print("im \(filename)")
            self.selectedPic = String(describing: filename)
        }
        self.dismiss(animated: true, completion: nil)
    //    callImageUpload()
        
        self.viewActivity.isHidden = false
        
        LoadingIndicatorView.show(self.viewActivity, loadingText: "Uploading...")
        
        let rimage:UIImage = self.imageRotatedByDegrees(0.0,image: image!)
        
        let imgdata:Data = UIImageJPEGRepresentation(rimage,90)!
        
        var viewImageUrl = "\(live_Driver_url)imageUpload/"
        
        viewImageUrl = viewImageUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        var request:NSMutableURLRequest = NSMutableURLRequest(url: URL(string:"\(viewImageUrl)\(self.selectedPic!)")!)

        print("\(request)")

        request.httpMethod = "POST"
        
        let boundary = NSString(format: "---------------------------14737809831466499882746641449")
        
        let contentType = NSString(format: "multipart/form-data; boundary=%@",boundary)
        
        request.addValue(contentType as String, forHTTPHeaderField: "Content-Type")
        
        let body = NSMutableData()
        
        body.append(NSString(format: "\r\n--%@\r\n",boundary).data(using: String.Encoding.utf8.rawValue)!)
        
        body.append(NSString(format:"Content-Disposition: form-data; name=\"title\"\r\n\r\n").data(using: String.Encoding.utf8.rawValue)!)
        
        body.append("Hello World".data(using: String.Encoding.utf8, allowLossyConversion: true)!)
        
        body.append(NSString(format: "\r\n--%@\r\n", boundary).data(using: String.Encoding.utf8.rawValue)!)
        
        body.append(NSString(format:"Content-Disposition: form-data; name=\"uploadedfile\"; filename=\"bklblk.jpg\"\r\n").data(using: String.Encoding.utf8.rawValue)!)
        
        body.append(NSString(format: "Content-Type: application/octet-stream\r\n\r\n").data(using: String.Encoding.utf8.rawValue)!)
        
        body.append(imgdata)
        
        body.append(NSString(format: "\r\n--%@\r\n", boundary).data(using: String.Encoding.utf8.rawValue)!)
        
        request.httpBody = body as Data
        
        let operation : AFHTTPRequestOperation = AFHTTPRequestOperation(request: request as URLRequest!)
        
//        operation.responseSerializer.acceptableContentTypes = NSSet(object: "text/html") as Set<NSObject>
//        operation.responseSerializer.acceptableContentTypes = NSSet(object: "application/json") as Set<NSObject>
        
        operation.responseSerializer.acceptableContentTypes =  Set<AnyHashable>(["application/json", "text/json", "text/javascript", "text/html"])
        
        operation.setCompletionBlockWithSuccess(
            
            { (operation : AFHTTPRequestOperation?, responseObject: Any?) in
                
                
                let response : NSString = operation!.responseString as NSString
                let data:Data = response.data(using: String.Encoding.utf8.rawValue)!
                
                let json = try! JSONSerialization.jsonObject(with: data, options: []) as AnyObject
                
                let imageurl = json.value(forKey: "imageurl")
                
                let imageName = json.value(forKey: "image_name")
                
                var tmpstr:NSString="\(imageName!)" as NSString
                tmpstr=tmpstr.replacingOccurrences(of: "(", with: "") as NSString
                tmpstr=tmpstr.replacingOccurrences(of: ")", with: "") as NSString
                tmpstr=tmpstr.replacingOccurrences(of: "\"", with: "") as NSString
                tmpstr=tmpstr.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) as NSString
                
                print(" !! \(imageurl)")
                
                print(" final \(tmpstr)")
                
                print("image uploaded")
                
                self.selectedPic = tmpstr as String!
                
                LoadingIndicatorView.hide()
                
                self.viewActivity.isHidden = true
                
                

        }, failure: { (operation, error) -> Void in
            print("image uploaded failed")
            print(error?.localizedDescription)
            
            LoadingIndicatorView.hide()
            
            self.viewActivity.isHidden = true

        })
        
        operation.start()

    }
    func imageRotatedByDegrees(_ degrees: CGFloat, image: UIImage) -> UIImage{
        
        let size = image.size
        
        
        
        UIGraphicsBeginImageContext(size)
        
        let context = UIGraphicsGetCurrentContext()
        
        
        
        context?.translateBy(x: 0.5*size.width, y: 0.5*size.height)
        
        context?.rotate(by: CGFloat(DegreesToRadians(Double(degrees))))
        
        
        
        image.draw(in: CGRect(origin: CGPoint(x: -size.width*0.5, y: -size.height*0.5), size: size))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        
        
        return newImage!
        
    }
    func DegreesToRadians(_ degrees: Double) -> Double {
        
        return degrees * M_PI / 180.0
        
    }
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
}
