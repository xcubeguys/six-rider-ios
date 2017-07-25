//
//  ARRegisterEmailVC.swift
//  Arcane Rider
//
//  Created by Apple on 16/12/16.
//  Copyright © 2016 Apple. All rights reserved.
//

import UIKit
import Alamofire
class ARRegisterEmailVC: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailText: HoshiTextField!
    @IBOutlet weak var nextBtn: UIButton!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var signInAPIUrl = live_rider_url
    var timer = Timer()
    typealias jsonSTD = NSArray
    
    typealias jsonSTDAny = [String : AnyObject]
    
    let alertView:UIAlertView = UIAlertView()
    
    @IBOutlet weak var activityView: UIActivityIndicatorView!

    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        UIApplication.shared.isIdleTimerDisabled = false
        
        navigationController!.navigationBar.barStyle = .black
        
        navigationController!.isNavigationBarHidden = false

        emailLabel.isHidden=true
        
        // Do any additional setup after loading the view.
    //    self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Arcane Rider", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        emailText.delegate = self

        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "arrow-left.png")!, for: .normal)
        button.addTarget(self, action: #selector(ARRegisterEmailVC.profileBtn(_:)), for: .touchUpInside)
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

        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ARRegisterEmailVC.hidekeyboard))
        
        tapGesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGesture)
        
        timer = Timer.scheduledTimer(timeInterval: 1200, target: self, selector: #selector(ARRegisterEmailVC.terminateApp), userInfo: nil, repeats: true)
        let resetTimer = UITapGestureRecognizer(target: self, action: #selector(ARRegisterEmailVC.resetTimer));
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(resetTimer)
        
    }
    func resetTimer(){
        // invaldidate the current timer and start a new one
        print("User Interacted")
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1200, target: self, selector: #selector(ARRegisterEmailVC.terminateApp), userInfo: nil, repeats: true)
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
    
    func errorField(){
        
        let trimmedString = emailText.text?.trimmingCharacters(in: .whitespaces)
        if(trimmedString == ""){
            emailLabel.isHidden=false
            emailLabel.text = "Enter valid email"
        }
        else {
            
        }
    }
    
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        if(textField == emailText){
            emailLabel.isHidden = true
        }
        else{
             errorField()
        }
        
        
        return true
        
    }

    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var result = true
        let str:NSString! = "\(textField.text!)" as NSString!
        
        let prospectiveText = (str).replacingCharacters(in: range, with: string)
        
        if string.characters.count > 0 {
            
     //       let disallowedCharacterSet = CharacterSet.whitespaces
            
            let disallowedCharacterSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ.@1234567890_-!#$%(){}^&*+").inverted
            
            let replacementStringIsLegal = string.rangeOfCharacter(from: disallowedCharacterSet) == nil
            
            let resultingStringLengthIsLegal = prospectiveText.characters.count <= 64
            
            result = replacementStringIsLegal &&
                
            resultingStringLengthIsLegal
            
        }
        return result
    }
    
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func nextAction(_ sender: Any) {
        
        errorField()
        
        emailText.resignFirstResponder()
        
        let trimmedString = emailText.text?.trimmingCharacters(in: .whitespaces)

        if(trimmedString == ""){
            emailLabel.isHidden=false
            emailLabel.text = "Enter valid email"
           // self.invalidEmail()
        }
        else if(!isValidEmail(testStr: trimmedString!)){
            self.invalidEmail()
        }
        
        else{
            emailLabel.isHidden=true
//            emailText.forLastBaselineLayout.backgroundColor = UIColor.black
            self.valid()
            self.appDelegate.email = trimmedString
            registeremail()
            //self.navigationController?.pushViewController(ARRegisterPasswordVC(), animated: true)
        }

    }
    
    func registeremail(){
        
        activityView.startAnimating()
        
        var email1 = emailText.text! as String
        
        email1 = email1.replacingOccurrences(of: "Optional(", with: "")
        email1 = email1.replacingOccurrences(of: ")", with: "")
        print("eee\(email1)")
        
        
        var urlstring:String = "\(signInAPIUrl)emailExist/email/\(email1)/"
        
        urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        
        urlstring = urlstring.removingPercentEncoding!
        
        print(urlstring)
        
        self.callSiginAPI(url: "\(urlstring)")
    }
    
    func invalidEmail(){
        
        emailText.borderActiveColor = UIColor.red
        emailText.borderInactiveColor = UIColor.red
        emailText.placeholderColor = UIColor.red

    }
    
    func valid(){
        emailText.borderActiveColor = UIColor.black
        emailText.borderInactiveColor = UIColor.black
        emailText.placeholderColor = UIColor.black

    }
    
    
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func profileBtn(_ Selector: AnyObject) {
        
        self.navigationController?.popViewController(animated: true)
        
        
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if(!(isValidEmail(testStr: textField.text!))){
            self.invalidEmail()
        }
        else{
            
            emailText.resignFirstResponder()
            view.endEditing(true)
            self.nextAction(self.nextBtn)

        }
        return true
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == emailText{
            
            self.emailLabel.isHidden = true

        }
        else{
            
            
        }
        return true
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
      
                   self.emailLabel.isHidden = true
                   
                    self.activityView.stopAnimating()
                    
                   self.navigationController?.pushViewController(ARRegisterPasswordVC(), animated: true)
                   
                }
                else{
                    
                   /* let toastLabel = UILabel(frame: CGRect(x: 20.0, y: 150, width: 335, height: 30))
                    toastLabel.backgroundColor = UIColor.black
                    toastLabel.textColor = UIColor.white
                    toastLabel.textAlignment = NSTextAlignment.center;
                    self.view.addSubview(toastLabel)
                    toastLabel.text = "Email already exist"
                    toastLabel.alpha = 1.0
                    toastLabel.layer.cornerRadius = 0;
                    toastLabel.clipsToBounds  =  true
                    
                    UIView.animate(withDuration: 4.0, delay: 0.1, options: UIViewAnimationOptions.curveEaseOut, animations: {
                        
                        toastLabel.alpha = 0.0
                        
                    })*/
                    
                    self.activityView.stopAnimating()
                    
                    self.emailLabel.isHidden = false
                    self.emailLabel.text = "Email already exist"
                    
                }
            }
        }
        catch{
            
            
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
