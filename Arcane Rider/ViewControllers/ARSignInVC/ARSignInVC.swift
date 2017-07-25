//
//  ARSignInVC.swift
//  Arcane Rider
//
//  Created by Apple on 16/12/16.
//  Copyright © 2016 Apple. All rights reserved.
//

import UIKit
import Alamofire
import UserNotifications
import SwiftMessages
import Crashlytics


class ARSignInVC: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var emailtextField: HoshiTextField!
    @IBOutlet weak var passwordtextField: HoshiTextField!
    
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var password: UILabel!
    @IBOutlet weak var emailerror: UILabel!
    
    @IBOutlet weak var activityView: UIActivityIndicatorView!

    let alertView:UIAlertView = UIAlertView()
    let screenSize: CGRect = UIScreen.main.bounds

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var signInAPIUrl = live_rider_url
    
    typealias jsonSTD = NSArray
    
    typealias jsonSTDAny = [String : AnyObject]

    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UNUserNotificationCenter.current().delegate = self

        navigationController!.navigationBar.barStyle = .black
        
        navigationController!.isNavigationBarHidden = false
   
        emailerror.isHidden=true
        password.isHidden=true
        
        self.emailtextField.delegate = self
        self.passwordtextField.delegate = self
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        navigationController!.navigationBar.barStyle = .black
        
    //    self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Arcane Rider", style: UIBarButtonItemStyle.plain, target: nil, action: nil)

        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "arrow-left.png")!, for: .normal)
        button.addTarget(self, action: #selector(ARSignInVC.profileBtn(_:)), for: .touchUpInside)
        //CGRectMake(0, 0, 53, 31)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        //(frame: CGRectMake(3, 5, 50, 20))
        let label = UILabel(frame: CGRect(x: 10, y: 5, width: 100, height: 20))
        // label.font = UIFont(name: "Arial-BoldMT", size: 13)
        label.text = "Sign In"
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.clear
        button.addSubview(label)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = barButton

        
//        emailtextField.addTarget(self, action: #selector(ARSignInVC.textFieldDidChange), for: UIControlEvents.editingChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ARSignInVC.hidekeyboard))
        
        tapGesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGesture)

//          self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Sign in", style: UIBarButtonItemStyle.plain, target: nil, action: nil)

        // Do any additional setup after loading the view.
        if screenHeight == 667{
        
      //  self.forgetPasswordBtn.frame = CGRect(x: 0, y: 25, width: screenWidth, height: 30)
            self.nextBtn.frame = CGRect(x:0, y:2000, width:screenWidth, height:2000)
        }
    
        
    
    }
    
    @IBAction func btnNotifyMe(_ sender: Any) {
        
        // Request Notification Settings
        UNUserNotificationCenter.current().getNotificationSettings { (notificationSettings) in
            switch notificationSettings.authorizationStatus {
            case .notDetermined:
                self.requestAuthorization(completionHandler: { (success) in
                    guard success else { return }
                    
                    // Schedule Local Notification
                    self.scheduleLocalNotification()
                })
            case .authorized:
                // Schedule Local Notification
                self.scheduleLocalNotification()
            case .denied:
                print("Application Not Allowed to Display Notifications")
            }
        }

        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        UIApplication.shared.isIdleTimerDisabled = false
        
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent

    }
    // MARK: - Private Methods
    
    private func requestAuthorization(completionHandler: @escaping (_ success: Bool) -> ()) {
        // Request Authorization
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (success, error) in
            if let error = error {
                print("Request Authorization Failed (\(error), \(error.localizedDescription))")
            }
            
            completionHandler(success)
        }
    }
    
    func errorField(){
        
        let emailTrim = emailtextField.text?.trimmingCharacters(in: .whitespaces)
        let passwordTrim = passwordtextField.text?.trimmingCharacters(in: .whitespaces)
        
        if(emailTrim == ""){
             emailerror.isHidden=false
        }
        else if(passwordTrim == ""){
            password.isHidden = false
        }
        else {
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if(emailtextField == textField)
        {
            passwordtextField.becomeFirstResponder()
        }
        else if(passwordtextField == textField)
        {
            self.keyboardDoneCall()
            
        }
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        if(textField == emailtextField){
            emailerror.isHidden = true
        }
        else if(textField == passwordtextField!){
            password.isHidden = true
        }
        else{
             errorField()
        }
        
        
        return true
        
    }
    
    private func scheduleLocalNotification() {
        // Create Notification Content
        let notificationContent = UNMutableNotificationContent()
        
        // Configure Notification Content
        notificationContent.title = "SIX Rider"
        notificationContent.subtitle = "Local Notifications"
        notificationContent.body = "User Signed Successfully"
        
        
        // Add Trigger
        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 2.0, repeats: false)
        
        // Create Notification Request
        let notificationRequest = UNNotificationRequest(identifier: "cocoacasts_local_notification", content: notificationContent, trigger: notificationTrigger)
        
        // Add Request to User Notification Center
        UNUserNotificationCenter.current().add(notificationRequest) { (error) in
            if let error = error {
                print("Unable to Add Notification Request (\(error), \(error.localizedDescription))")
            }
        }
    }

    func hidekeyboard()
    {
        self.view.endEditing(true)
    }
    

    func profileBtn(_ Selector: AnyObject) {
        
      //  self.navigationController?.popViewController(animated: true)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.setRootViewController()
        
    }

    @IBAction func nextBtn(_ sender: Any) {
        
        self.keyboardDoneCall()
        
       // Crashlytics.sharedInstance().crash()
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == emailtextField{
            
            self.emailerror.isHidden = true
        }
        else
        {
            
            self.password.isHidden = true
        }
        
        return true
    }
    func keyboardDoneCall(){
        
        activityView.startAnimating()
        
        self.emailtextField.resignFirstResponder()
        self.passwordtextField.resignFirstResponder()
        
        
        let emailTrim = emailtextField.text?.trimmingCharacters(in: .whitespaces)
        var passwordTrim = passwordtextField.text?.trimmingCharacters(in: .whitespaces)
        errorField()
        if(emailTrim == "" && passwordTrim == ""){
            activityView.stopAnimating()
            emailerror.isHidden=false
            password.text = "Enter minimum 6 characters"
            password.isHidden=false
            //self.invalidbothfields()
        }
        else if(emailTrim == ""){
            
            activityView.stopAnimating()
            emailerror.isHidden=false
            //self.invalidEmail()
        }
        else if(emailTrim != "" && passwordTrim == ""){
            activityView.stopAnimating()
            emailerror.isHidden=true
            password.text = "Enter minimum 6 characters"
            password.isHidden=false
            //  self.invalidPwd()
        }
        else if(emailTrim == "" && passwordTrim != ""){
            activityView.stopAnimating()
            emailerror.isHidden=false
            password.isHidden=true
            //self.invalidEmail()
        }
        else if (!(isValidEmail(testStr: emailTrim!))){
            self.validData()
            self.invalidEmail()
        }
            
        else if (passwordTrim == ""){
            activityView.stopAnimating()
            password.text = "Enter minimum 6 characters"
            password.isHidden=false
            self.validData()
            // self.invalidPwd()
        }
        else if((passwordTrim?.characters.count)! < 8){
            password.text = "Enter minimum 6 characters"
            password.isHidden=false
            self.validData()
            self.invalidPwd()
        }
        else{
            
            emailerror.isHidden=true
            password.isHidden=true
            
            activityView.startAnimating()
            
            self.validData()
            self.appDelegate.userName = emailTrim
          //  self.appDelegate.passWord = passwordTrim
            print(passwordTrim!)
            var paswd = "\(passwordTrim!)"
            paswd = paswd.replacingOccurrences(of: "[ |@!#$&+-/;:,()_.]", with: "", options: [.regularExpression])
            paswd=(paswd.replacingOccurrences(of: "[", with: "") as String as NSString!) as String
            paswd=(paswd.replacingOccurrences(of: "]", with: "") as String as NSString!) as String
            paswd=(paswd.replacingOccurrences(of: "*", with: "") as String as NSString!) as String
            print("mouni\(paswd)") // +14084561234
            self.appDelegate.passWord = paswd
            print(passwordTrim!)
            let longstring = "\(passwordTrim!)"
            let data = (longstring).data(using: String.Encoding.utf8)
            var base64 = data!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
            print(longstring)//T3B0aW9uYWwoInBhc3N3b3JkQCEiKQ
            
            print(base64)// dGVzdDEyMw==\n  cGFzc3dvcmRAIQ==
            base64=(base64.replacingOccurrences(of: "=", with: "") as String as NSString!) as String
            self.appDelegate.encpws = base64
            
            self.signin()
            
        }
 
    }
    func signin(){
        
        
       
        activityView.startAnimating()
        
        var urlstring:String = "\(signInAPIUrl)signIn/password/\(self.appDelegate.passWord!)/email/\(self.appDelegate.userName!)/encrypt_password/\(self.appDelegate.encpws!)"
        
        //urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        
       // urlstring = urlstring.removingPercentEncoding!
            urlstring=(urlstring.replacingOccurrences(of: "Optional", with: "") as String as NSString!) as String
            urlstring=(urlstring.replacingOccurrences(of: "(", with: "") as String as NSString!) as String
            urlstring=(urlstring.replacingOccurrences(of: ")", with: "") as String as NSString!) as String
        
     //   urlstring = UTF8.decode(urlstring)
        print(urlstring)
        
        self.callSiginAPI(url: "\(urlstring)")
    }
    
    func invalidPwd(){
        passwordtextField.borderActiveColor = UIColor.red
        passwordtextField.borderInactiveColor = UIColor.red
        passwordtextField.placeholderColor = UIColor.red
        activityView.stopAnimating()
   
//        passwordtextField.borderActiveColor = UIColor.red
//        passwordtextField.borderInactiveColor = UIColor.red
//        passwordtextField.placeholderColor = UIColor.red


    }
    
    func invalidEmail(){

      
        emailtextField.borderActiveColor = UIColor.red
        emailtextField.borderInactiveColor = UIColor.red
        emailtextField.placeholderColor = UIColor.red

        activityView.stopAnimating()
   
        passwordtextField.borderActiveColor = UIColor.red
        passwordtextField.borderInactiveColor = UIColor.red
        passwordtextField.placeholderColor = UIColor.red

    }
    func invalidbothfields()
    {

        emailtextField.borderActiveColor = UIColor.red
        emailtextField.borderInactiveColor = UIColor.red
        emailtextField.placeholderColor = UIColor.red

        activityView.stopAnimating()

      

    }
    
    func validData(){
        
        activityView.stopAnimating()

        emailtextField.borderActiveColor = UIColor.black
        emailtextField.borderInactiveColor = UIColor.black
        emailtextField.placeholderColor = UIColor.black
        
        passwordtextField.borderActiveColor = UIColor.black
        passwordtextField.borderInactiveColor = UIColor.black
        passwordtextField.placeholderColor = UIColor.black
    }
    @IBAction func forgetPasswordBtn(_ sender: Any) {
        
        self.navigationController?.pushViewController(ARResetPasswordVC(), animated: true)
        emailerror.isHidden=true
        password.isHidden=true
    }
 
    @IBAction func createAccountBtn(_ sender: Any) {
        
        self.navigationController?.pushViewController(ARRegisterVC(), animated: true)
        emailerror.isHidden=true
        password.isHidden=true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
  
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
     
     
     
     //    let parameters = [
     //                "email": self.appDelegate.userName, //email
     //                "password": self.appDelegate.passWord //password
     //            ]
     
     //              let url = "http://demo.cogzidel.com/arcane_lite/rider/signIn/password/\(self.appDelegate.passWord!)/email/\(self.appDelegate.userName!)"
     //            print("url1\(url)")
     //                Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
     //                    .responseJSON { response in
     //                        print(response)
     //                        //to get status code  response?
     //                        if let status = response.result.value{
     //                            print("1234\(status)")
     //                           self.navigationController?.pushViewController(ARMapVC(), animated: true)
     //                        }
     //                        //to get JSON return value
     //                        if let result = response.result.value {
     //                            let JSON = result as! NSDictionary
     //                            print(JSON)
     //                        }
     //                        
     //                }
    */
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var result = true
        let str:NSString! = "\(textField.text!)" as NSString!
        
        let prospectiveText = (str).replacingCharacters(in: range, with: string)
        var limit = 30
        if(textField == emailtextField){
            limit = 30
            if string.characters.count > 0 {
                
                //     let disallowedCharacterSet = CharacterSet.whitespaces
                
                let disallowedCharacterSet = CharacterSet(charactersIn: "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ.@_-!#$%(){}^&*+").inverted
                
                
                
                let replacementStringIsLegal = string.rangeOfCharacter(from: disallowedCharacterSet) == nil
                
                let resultingStringLengthIsLegal = prospectiveText.characters.count <= 64
                
                result = replacementStringIsLegal &&
                    
                resultingStringLengthIsLegal
                
            }
        }
        else if (textField == passwordtextField){
            limit = 20
            if string.characters.count > 0 {
                
                //     let disallowedCharacterSet = CharacterSet.whitespaces
                
                let disallowedCharacterSet = CharacterSet(charactersIn: "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ.!@$&*()_+-*/,:;[]{}|").inverted
                
                
                
                let replacementStringIsLegal = string.rangeOfCharacter(from: disallowedCharacterSet) == nil
                
                let resultingStringLengthIsLegal = prospectiveText.characters.count <= limit
                
                result = replacementStringIsLegal &&
                    
                resultingStringLengthIsLegal
                
            }
        }
        else{}
        
        return result
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
                    
                    self.password.isHidden = true
                    
                    let email:String = value.object(forKey: "email") as! String
                    let first_name:String = value.object(forKey: "first_name") as! String
                    let last_name:String = value.object(forKey: "last_name") as! String
                    //let mobile:String = value.object(forKey: "mobile") as! String
                    let userid:String = value.object(forKey: "userid") as! String
                    print("email is \(email)")
                    
                    let combine = "\(first_name) \(last_name)"
                    
                    self.appDelegate.userid = userid
                    self.appDelegate.fname = first_name
                    self.appDelegate.lname = last_name
                    self.appDelegate.loggedEmail = email

                    
                    // session started using NSUserDefaults
                    UserDefaults.standard.setValue(userid, forKey: "userid")
                    
                    UserDefaults.standard.setValue(combine, forKey: "userName")
                    
                    print("\(UserDefaults.standard.value(forKey: "userid")!)")

                    
                    activityView.stopAnimating()
                    
             //       appDelegate.callMapVC()
                    
                     appDelegate.leftMenu()

                    
                //    self.navigationController?.pushViewController(ARMapVC(), animated: true)

                    
                    
                    
                }
                else{
//                    
                    
//                    let toastLabel = UILabel(frame: CGRect(x: 15.0, y: 188, width: 300, height: 30))
//                    toastLabel.backgroundColor = UIColor.black
//                    toastLabel.textColor = UIColor.white
//                    toastLabel.textAlignment = NSTextAlignment.center;
//                    self.view.addSubview(toastLabel)
//                    toastLabel.text = "Invalid emaill address"
//                    toastLabel.alpha = 1.0
//                    toastLabel.layer.cornerRadius = 0;
//                    toastLabel.clipsToBounds  =  true
//                    
//                    UIView.animate(withDuration: 4.0, delay: 0.1, options: UIViewAnimationOptions.curveEaseOut, animations: {
//                        
//                        toastLabel.alpha = 0.0
//                        
//                    })
                    
                    activityView.stopAnimating()
                    
                  /*  let warning = MessageView.viewFromNib(layout: .CardView)
                    warning.configureTheme(.warning)
                    warning.configureDropShadow()
                    let iconText = "" //"🤔"
                    warning.configureContent(title: "", body: "Invalid User name or Password", iconText: iconText)
                    warning.button?.isHidden = true
                    var warningConfig = SwiftMessages.defaultConfig
                    warningConfig.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
                    SwiftMessages.show(config: warningConfig, view: warning)*/
                    
                    self.password.isHidden = false
                    self.password.text = "Invalid User name or Password"
                }
            }
        }
        catch{
            
            activityView.stopAnimating()

            print(error)
            
        }
        
    }
    
    @IBAction func btnPayment(_ sender: Any) {
        
        self.navigationController?.pushViewController(ARStripeVC(), animated: true)
        
    }
    
}
extension ARSignInVC: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert])
    }
    
}
