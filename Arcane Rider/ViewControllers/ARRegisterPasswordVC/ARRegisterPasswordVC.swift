//
//  ARRegisterPasswordVC.swift
//  Arcane Rider
//
//  Created by Apple on 16/12/16.
//  Copyright © 2016 Apple. All rights reserved.
//

import UIKit
import Alamofire

class ARRegisterPasswordVC: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var password: HoshiTextField!
    @IBOutlet weak var confirmPassword: HoshiTextField!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var password1Label: UILabel!
    @IBOutlet weak var password2Label: UILabel!

var timer = Timer()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
   //     self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Arcane Rider", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        
        UIApplication.shared.isIdleTimerDisabled = false
        
        password1Label.isHidden=true
        password2Label.isHidden=true
        
        navigationController!.navigationBar.barStyle = .black
        
        navigationController!.isNavigationBarHidden = false
        
        password.delegate = self
        confirmPassword.delegate = self
        
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "arrow-left.png")!, for: .normal)
        button.addTarget(self, action: #selector(ARRegisterPasswordVC.profileBtn(_:)), for: .touchUpInside)
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
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ARRegisterPasswordVC.hidekeyboard))
        
        tapGesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGesture)
        timer = Timer.scheduledTimer(timeInterval: 1200, target: self, selector: #selector(ARRegisterPasswordVC.terminateApp), userInfo: nil, repeats: true)
        let resetTimer = UITapGestureRecognizer(target: self, action: #selector(ARRegisterPasswordVC.resetTimer));
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(resetTimer)
        
    }
    func resetTimer(){
        // invaldidate the current timer and start a new one
        print("User Interacted")
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1200, target: self, selector: #selector(ARRegisterPasswordVC.terminateApp), userInfo: nil, repeats: true)
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
    
        if(password.text == ""){
            password1Label.isHidden=false
        }
        else if(confirmPassword.text == ""){
            password2Label.isHidden=false
            self.password2Label.text = "Enter minimum 6 characters"

        }
        else {
            
        }
    }
    
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        if(textField == password){
            password1Label.isHidden = true
        }
        else if(textField == confirmPassword!){
            password2Label.isHidden = true
        }
        else{
            errorField()
        }
        
        
        return true
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func nextAction(_ sender: Any) {
        
        errorField()
        
        password.resignFirstResponder()
        confirmPassword.resignFirstResponder()
        
        if(password.text == "" && confirmPassword.text == ""){
            password1Label.isHidden=false
            password2Label.isHidden=false
            self.password2Label.text = "Enter minimum 6 characters"

        }
        if(password.text != "" && confirmPassword.text == ""){
            password1Label.isHidden=true
            password2Label.isHidden=false
            self.password2Label.text = "Enter minimum 6 characters"

        }

        if(password.text == "" && confirmPassword.text != ""){
            password1Label.isHidden=false
            password2Label.isHidden=true
        }

        else if((password.text?.characters.count)! <= 6){
            password1Label.isHidden=false
            
           // self.invalidPassword()
        }
        else if((confirmPassword.text?.characters.count)! <= 6){
            password2Label.isHidden=false
            self.password2Label.text = "Enter minimum 6 characters"

         //   self.invalidConfirmPassword()
        }
        else if(password.text! != confirmPassword.text!){
            
            self.doestNotMathc()
        }
        else{
            password1Label.isHidden=true
            password2Label.isHidden=true
            self.validPassword()
            print(password.text!)
            
            let passwordTrim = password.text?.trimmingCharacters(in: .whitespaces)
           
            print(passwordTrim!)
            
            let longstring = "\(passwordTrim!)"
            let data = (longstring).data(using: String.Encoding.utf8)
            var base64 = data!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
            print(longstring)
            
            print(base64)// dGVzdDEyMw==\n
            base64=(base64.replacingOccurrences(of: "=", with: "") as String as NSString!) as String;
            self.appDelegate.password = base64
            self.navigationController?.pushViewController(ARRegisterMobile(), animated: true)
        }
    }

    func invalidPassword(){
        
        password.borderActiveColor = UIColor.red
        password.borderInactiveColor = UIColor.red
        password.placeholderColor = UIColor.red

    }
    
    func invalidConfirmPassword(){
        
        confirmPassword.borderActiveColor = UIColor.black
        confirmPassword.borderInactiveColor = UIColor.black
        confirmPassword.placeholderColor = UIColor.black
        self.password2Label.isHidden = false
        self.password2Label.text = "Password Doesn't match"
    }
    
    func validPassword(){
        
        password.borderActiveColor = UIColor.black
        password.borderInactiveColor = UIColor.black
        password.placeholderColor = UIColor.black

        confirmPassword.borderActiveColor = UIColor.black
        confirmPassword.borderInactiveColor = UIColor.black
        confirmPassword.placeholderColor = UIColor.black

    }
    
    func doestNotMathc(){
        
       // self.invalidPassword()
        self.invalidConfirmPassword()
    }

    func profileBtn(_ Selector: AnyObject) {
        
        self.navigationController?.popViewController(animated: true)
        
        
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
        if(textField == password){
            password.resignFirstResponder()
            confirmPassword.becomeFirstResponder()
        }
        else{
            confirmPassword.resignFirstResponder()
            view.endEditing(true)
            self.nextAction(self.nextBtn)
        }
        return true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == password{

            self.password1Label.isHidden = true
        }
        else
        {
            self.password2Label.isHidden = true
        }
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var result = true
        let str:NSString! = "\(textField.text!)" as NSString!
        
  //      let prospectiveText = (str).replacingCharacters(in: range, with: string)
        if (textField == password){
        if string.characters.count > 0 {
            
            //let disallowedCharacterSet = CharacterSet.whitespaces
            
            let inverseSet = NSCharacterSet(charactersIn:"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ.!@$&*()_+-*/,:;[]{}|0123456789").inverted
            
            let components = string.components(separatedBy: inverseSet)
           
            let filtered = components.joined(separator: "")
            return string == filtered
            
            
            }
        }
        
        if (textField == confirmPassword){
            if string.characters.count > 0 {
    
    //let disallowedCharacterSet = CharacterSet.whitespaces
    
                let inverseSet = NSCharacterSet(charactersIn:"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ.!@$&*()_+-*/,:;[]{}|0123456789").inverted
    
                let components = string.components(separatedBy: inverseSet)
    
                let filtered = components.joined(separator: "")
                return string == filtered
    
    
            }
        }
        return result
    }
}
