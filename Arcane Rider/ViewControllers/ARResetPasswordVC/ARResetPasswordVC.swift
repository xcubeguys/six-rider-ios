//
//  ARResetPasswordVC.swift
//  Arcane Rider
//
//  Created by Apple on 16/12/16.
//  Copyright © 2016 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SwiftMessages

class ARResetPasswordVC: UIViewController {
    @IBOutlet var resetBtnOutlet: UIButton!

   
    @IBOutlet weak var emailerrLabel: UILabel!
    @IBOutlet var emailtextField: HoshiTextField!
    @IBOutlet var label: UILabel!

    @IBOutlet weak var activityView: UIActivityIndicatorView!

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var signInAPIUrl = live_rider_url
    
    typealias jsonSTD = NSArray
    
    typealias jsonSTDAny = [String : AnyObject]
    

    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UIApplication.shared.isIdleTimerDisabled = false
        
        navigationController!.navigationBar.barStyle = .black
        
        navigationController!.isNavigationBarHidden = false
        
        emailerrLabel.isHidden=true
        
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "arrow-left.png")!, for: .normal)
        button.addTarget(self, action: #selector(ARResetPasswordVC.profileBtn(_:)), for: .touchUpInside)
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
        self.label.adjustsFontSizeToFitWidth = true
      
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ARResetPasswordVC.hidekeyboard))
        
        tapGesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGesture)
    }
    
    func profileBtn(_ Selector: AnyObject) {
        
        self.navigationController?.popViewController(animated: true)
        
        
    }
    func hidekeyboard()
    {
        self.view.endEditing(true)
    }
    
    func errorField(){
        
        let emailTrim = emailtextField.text?.trimmingCharacters(in: .whitespaces)
        
        
        if(emailTrim == ""){
            emailerrLabel.isHidden=false
        }

        else {
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if(emailtextField == textField)
        {
            self.keyboardDoneCall()
        }
        textField.resignFirstResponder()
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        if(textField == emailtextField){
            emailerrLabel.isHidden = true
        }
        else{
            errorField()
        }
        
        
        return true
        
    }

  
    @IBAction func loginBtn(_ sender: Any) {
        self.navigationController?.pushViewController(ARSignInVC(), animated: true)
    }

    @IBAction func resetBtnAction(_ sender: Any) {
        
        self.keyboardDoneCall()
    }
    
    func keyboardDoneCall(){
        
        self.activityView.startAnimating()
        
        errorField()
        
        emailtextField.resignFirstResponder()
        
        let emailTrim = emailtextField.text?.trimmingCharacters(in: .whitespaces)
        
        if(emailTrim == ""){
            
            self.activityView.stopAnimating()
            
            emailerrLabel.isHidden=false
            // self.invalidEmail()
        }
        else if (!(isValidEmail(testStr: emailTrim!))){
            
            self.activityView.stopAnimating()
            
            self.validData()
            self.invalidEmail()
        }
        else{
            
            emailerrLabel.isHidden=true
            self.validData()
            self.appDelegate.email = emailTrim
            resetpassword()
        }

    }
    func invalidEmail(){
        emailtextField.borderActiveColor = UIColor.red
        emailtextField.borderInactiveColor = UIColor.red
        emailtextField.placeholderColor = UIColor.red
        
    }
    
    func validData(){
        emailtextField.borderActiveColor = UIColor.black
        emailtextField.borderInactiveColor = UIColor.black
        emailtextField.placeholderColor = UIColor.black
    }

    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }

    func resetpassword(){
        
            self.activityView.startAnimating()
        
            self.resetBtnOutlet.isEnabled = false
            
         
            var email1 = emailtextField.text! as String
            
            email1 = email1.replacingOccurrences(of: "Optional(", with: "")
            email1 = email1.replacingOccurrences(of: ")", with: "")
            print("eee\(email1)")
        
            
            var urlstring:String = "\(signInAPIUrl)forgotPassword/email/\(email1)/"
            
            urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
            
            urlstring = urlstring.removingPercentEncoding!
 
            print(urlstring)
            
            self.callResetAPI(url: "\(urlstring)")


    }
    
    func callResetAPI(url : String){
        
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
                    
                    
                  //  self.navigationController?.pushViewController(ARSignInVC(), animated: true)
           //     self.appDelegate.setRootViewController()
                    
                 self.activityView.stopAnimating()
                 
                    let iconText = "" //"🤔"
                    let success = MessageView.viewFromNib(layout: .CardView)
                    success.configureTheme(.success)
                    success.configureDropShadow()
                    success.configureContent(title: "", body: "Reset link successfully sent to the email", iconText: iconText)
                    success.button?.isHidden = true
                    var successConfig = SwiftMessages.defaultConfig
                    successConfig.presentationStyle = .top
                    successConfig.presentationContext = .window(windowLevel: UIWindowLevelNormal)
                    
                    SwiftMessages.show(config: successConfig, view: success)
                    
                 self.appDelegate.callSignInVC()
                    
                 self.resetBtnOutlet.isEnabled = true
                    
                }
                else{
                      
                  /*  let toastLabel = UILabel(frame: CGRect(x: 20.0, y: 410, width: 343, height: 35))
                    toastLabel.backgroundColor = UIColor.black
                    toastLabel.textColor = UIColor.white
                    toastLabel.textAlignment = NSTextAlignment.center;
                    self.view.addSubview(toastLabel)
                    toastLabel.text = "Email does not exist"
                    toastLabel.alpha = 1.0
                    toastLabel.layer.cornerRadius = 0;
                    toastLabel.clipsToBounds  =  true
                    
                    UIView.animate(withDuration: 4.0, delay: 0.1, options: UIViewAnimationOptions.curveEaseOut, animations: {
                        
                        toastLabel.alpha = 0.0
                        
                    })*/
                    
                    self.resetBtnOutlet.isEnabled = true
                    
                    self.activityView.stopAnimating()
                    
                    let warning = MessageView.viewFromNib(layout: .CardView)
                    warning.configureTheme(.warning)
                    warning.configureDropShadow()
                    let iconText = "" //"🤔"
                    warning.configureContent(title: "", body: "Email has not registered!!", iconText: iconText)
                    warning.button?.isHidden = true
                    var warningConfig = SwiftMessages.defaultConfig
                    warningConfig.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
                    
                    SwiftMessages.show(config: warningConfig, view: warning)
                    
                }
            }
        }
        catch{
            
            self.resetBtnOutlet.isEnabled = true
            
            self.activityView.stopAnimating()
            
            print(error)
            
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

}
