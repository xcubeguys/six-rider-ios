//
//  ARRegisterVC.swift
//  Arcane Rider
//
//  Created by Apple on 16/12/16.
//  Copyright © 2016 Apple. All rights reserved.
//

import UIKit


class ARRegisterVC: UIViewController,UITextFieldDelegate {
    


    @IBOutlet weak var firstName: HoshiTextField!
//    @IBOutlet weak var lastName: HoshiTextField!
    
    @IBOutlet weak var nicknameerror: UILabel!
    @IBOutlet weak var nickname: HoshiTextField!
    @IBOutlet weak var lastName: HoshiTextField!
    @IBOutlet weak var nextOutlet: UIButton!
    @IBOutlet weak var firstnamelabel: UILabel!
    @IBOutlet weak var lastnameLabel: UILabel!
    
    var timer = Timer()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        UIApplication.shared.isIdleTimerDisabled = false
        
        navigationController!.navigationBar.barStyle = .black
        
        navigationController!.isNavigationBarHidden = false

        // Do any additional setup after loading the view.
        firstName.delegate = self
        lastName.delegate = self
        nickname.delegate = self
        
        firstnamelabel.isHidden=true
        lastnameLabel.isHidden=true
        nicknameerror.isHidden=true
        
        
      //  NotificationCenter.default.addObserver(self, selector: #selector(textFieldShouldReturn(_:)), name: NSNotification.Name.UITextFieldTextDidEndEditing, object: self)
      //  firstName.addTarget(self, action: #selector(ARRegisterVC.textFieldShouldReturn(_:)), for: UIControlEvents.editingDidEnd)
   //     self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Arcane Rider", style: UIBarButtonItemStyle.plain, target: nil, action: nil)

        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "arrow-left.png")!, for: .normal)
        button.addTarget(self, action: #selector(ARRegisterVC.profileBtn(_:)), for: .touchUpInside)
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
        

        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ARRegisterVC.hidekeyboard))
        
        tapGesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGesture)
        timer = Timer.scheduledTimer(timeInterval: 1200, target: self, selector: #selector(ARRegisterVC.terminateApp), userInfo: nil, repeats: true)
        let resetTimer = UITapGestureRecognizer(target: self, action: #selector(ARRegisterVC.resetTimer));
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(resetTimer)
    }
    func resetTimer(){
        // invaldidate the current timer and start a new one
        print("User Interacted")
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1200, target: self, selector: #selector(ARRegisterVC.terminateApp), userInfo: nil, repeats: true)
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
    override func viewWillAppear(_ animated: Bool) {
        
        UIApplication.shared.isIdleTimerDisabled = false
        
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
    }
    
    func hidekeyboard()
    {
        self.view.endEditing(true)
    }

    func profileBtn(_ Selector: AnyObject) {
        
        self.navigationController?.popViewController(animated: true)
        
        
    }

    func errorField(){
        
        let firstname = firstName.text?.trimmingCharacters(in: .whitespaces)
        let lastname = lastName.text?.trimmingCharacters(in: .whitespaces)
         let nickname = self.nickname.text?.trimmingCharacters(in: .whitespaces)
        
        if(firstname == ""){
            firstnamelabel.isHidden=false
        }
        else if(lastname == ""){
            
            lastnameLabel.isHidden=false
        }
        else if(nickname == ""){
            
            nicknameerror.isHidden=false
        }
        else {
            
        }
    }
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == firstName{

            firstnamelabel.isHidden=true
        }
        else if textField == nickname{
            
            nicknameerror.isHidden=true
        }
        else{
            
            lastnameLabel.isHidden=true
        }
        
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        if(textField == firstName){
            firstnamelabel.isHidden=true
        }
        else if(textField == lastName){
            lastnameLabel.isHidden=true
        }
        else if(textField == nickname){
            nicknameerror.isHidden=true
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
    
//    func textFieldShouldReturn(_ textField:HoshiTextField){
//        if(textField == firstName){
////            firstName.resignFirstResponder()
//        }
//        else{
////            lastName.resignFirstResponder()
//        }
//    }
    
//    func textFieldShouldReturn(_ textField: HoshiTextField) -> Bool {
//        
//        return true
//    }
    
    @IBAction func nextAction(_ sender: Any) {
        
        errorField()
        
        firstName.resignFirstResponder()
        lastName.resignFirstResponder()
        
        let firstname = firstName.text?.trimmingCharacters(in: .whitespaces)
        let lastname = lastName.text?.trimmingCharacters(in: .whitespaces)
        let nickname = self.nickname.text?.trimmingCharacters(in: .whitespaces)

        //|| ((firstname?.characters.count)! < 3)
        if(firstname == ""){
            
            firstnamelabel.text = "Enter First Name"
            firstnamelabel.isHidden=false
          //  lastnameLabel.isHidden=false
            //self.invalid()
        }
        //|| ((lastname?.characters.count)! < 3
        /*else if(firstname == ""){
            
            firstnamelabel.text = "Enter First Name"
            firstnamelabel.isHidden=false
            //self.invalid()
        }*/
        else if(lastname == ""){
            
            lastnameLabel.isHidden=false
            //self.invalid()
        }
        else if(nickname == ""){
            
            nicknameerror.isHidden=false
            //self.invalid()
        }
       /* else if ((firstname?.characters.count)! < 3){
            
            firstnamelabel.text = "Enter minimum 3 characters"
            firstnamelabel.isHidden=false
        }
        else if(firstname == "" && lastname == ""){
            
            firstnamelabel.isHidden=false
            lastnameLabel.isHidden=false
            //self.invalid()
        }
        else if(firstname != "" && lastname == ""){
            firstnamelabel.isHidden=true
            lastnameLabel.isHidden=false
            //self.invalid()
        }
        else if(firstname == "" && lastname != ""){
            firstnamelabel.isHidden=false
            lastnameLabel.isHidden=true
            //self.invalid()
        }*/
        else{
            
            firstnamelabel.isHidden=true
            lastnameLabel.isHidden=true
            nicknameerror.isHidden=true
            self.appDelegate.nickname = nickname
            self.appDelegate.firstname = firstname
            self.appDelegate.lastname = lastname
            self.valid()
            self.navigationController?.pushViewController(ARRegisterEmailVC(), animated: true)
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
    func invalid(){
        firstName.borderActiveColor = UIColor.red
        firstName.borderInactiveColor = UIColor.red
        firstName.placeholderColor = UIColor.red
        
        lastName.borderActiveColor = UIColor.red
        lastName.borderInactiveColor = UIColor.red
        lastName.placeholderColor = UIColor.red
        
        nickname.borderActiveColor = UIColor.red
        nickname.borderInactiveColor = UIColor.red
        nickname.placeholderColor = UIColor.red
    }
    
    func valid(){
        firstName.borderActiveColor = UIColor.black
        firstName.borderInactiveColor = UIColor.black
        firstName.placeholderColor = UIColor.black
        
        lastName.borderActiveColor = UIColor.black
        lastName.borderInactiveColor = UIColor.black
        lastName.placeholderColor = UIColor.black
        
        nickname.borderActiveColor = UIColor.black
        nickname.borderInactiveColor = UIColor.black
        nickname.placeholderColor = UIColor.black

    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField == firstName){
            if(firstName.text == ""){
                self.invalid()
            }
            else{
                firstName.resignFirstResponder()
                nickname.becomeFirstResponder()
            }
        }
       else if(textField == nickname){
            if(nickname.text == ""){
                self.invalid()
            }
            else{
                nickname.resignFirstResponder()
                lastName.becomeFirstResponder()
            }
        }

        else{
            lastName.resignFirstResponder()
            view.endEditing(true)
            self.nextAction(self.nextOutlet)
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var result = true
        let str:NSString! = "\(textField.text!)" as NSString!
        
        let prospectiveText = (str).replacingCharacters(in: range, with: string)
        var limit = 30
        if(textField == firstName){
            limit = 25
            if string.characters.count > 0 {
                
                //     let disallowedCharacterSet = CharacterSet.whitespaces
                
                let disallowedCharacterSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ").inverted
                
                let replacementStringIsLegal = string.rangeOfCharacter(from: disallowedCharacterSet) == nil
                
                let resultingStringLengthIsLegal = prospectiveText.characters.count <= limit
                
                result = replacementStringIsLegal &&
                    
                resultingStringLengthIsLegal
                
            }

        }
        else if(textField == nickname){
            limit = 25
            if string.characters.count > 0 {
                
                //     let disallowedCharacterSet = CharacterSet.whitespaces
                
                let disallowedCharacterSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ").inverted
                
                let replacementStringIsLegal = string.rangeOfCharacter(from: disallowedCharacterSet) == nil
                
                let resultingStringLengthIsLegal = prospectiveText.characters.count <= limit
                
                result = replacementStringIsLegal &&
                    
                resultingStringLengthIsLegal
                
            }
            
        }

        else if(textField == lastName){
            limit = 25
            if string.characters.count > 0 {
                
                //     let disallowedCharacterSet = CharacterSet.whitespaces
                
                let disallowedCharacterSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ").inverted
                
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

}
