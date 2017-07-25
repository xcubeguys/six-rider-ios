//
//  STAddContactsVC.swift
//  SendTxT
//
//  Created by Apple on 07/11/16.
//  Copyright © 2016 Apple. All rights reserved.
//

import UIKit

class STAddContactsVC: UIViewController {

    @IBOutlet var mobileNumber: UITextField!
    @IBOutlet var username: UITextField!
    @IBOutlet weak var countrylab: UILabel!
    
   // @IBOutlet weak var countrylabel: UILabel!
    @IBOutlet weak var countryview: UIView!
    
    
    @IBOutlet var profileImageLabel: UILabel!
    
    @IBOutlet var username1: UILabel!
    @IBOutlet var profileIcon: UIImageView!
    
    let alertView:UIAlertView = UIAlertView()
    let alertView1:UIAlertView = UIAlertView()
//    var picker:UIImagePickerController?=UIImagePickerController()
  
    var user_id:NSString = ""
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var live_url = demo_url

    let manager = AFHTTPRequestOperationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Add Contact"
        
       // countrylabel.isHidden = false
        
        countrylab.isHidden = false
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        
        let locale = Locale.current
        let code = (locale as NSLocale).object(forKey: NSLocale.Key.countryCode) as! String
        
        
                
        if let value : String =  UserDefaults.standard.object(forKey: "userid") as! String!{
            let userid = value
            print(userid)
            if(userid != nil){
                self.user_id = userid as NSString
                
               
            }
        }
               addSaveButton()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {

                    //    self.username.text = ""
                     //   self.mobileNumber.text = ""
                        

        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var result=true
        if(textField == username)
        {
            let prospectiveText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            let temp = string.characters.count
            if temp > 0 {
                let disallowedCharacterSet = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghiijklmnopqrstuvwxyz0123456789._").inverted
                let replacementStringIsLegal = string.rangeOfCharacter(from: disallowedCharacterSet) == nil
                result = replacementStringIsLegal
            }
        }
        if(textField == mobileNumber)
        {
            let prospectiveText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            let temp = string.characters.count
            if temp > 0 {
                let disallowedCharacterSet = CharacterSet(charactersIn: "0123456789").inverted
                let replacementStringIsLegal = string.rangeOfCharacter(from: disallowedCharacterSet) == nil
                result = replacementStringIsLegal
            }
        }
        
        
        return result
        
    }

    
    @IBOutlet weak var cancel: UIButton!
    @IBOutlet weak var done: UIButton!
    
    @IBOutlet weak var countryaction: UIButton!
    @IBAction func countryaction(_ sender: AnyObject) {
        
        let picker = MICountryPicker { (name, code) -> () in
            print(code)
        }
        
        // Optional: To pick from custom countries list
        picker.customCountriesCode = ["EG", "US", "AF", "AQ", "AX", "IN","AL","DZ","AS","AD","AO","AI","AG","AR","AM","AW","AU","AT","AZ","BS","BH","BD","BB","BY","BE","BZ","BJ","BM","BT","BO"]
        
        // delegate
        picker.delegate = self
        
        // Display calling codes
        picker.showCallingCodes = true
        
        // or closure
        picker.didSelectCountryClosure = { name, code in
            
            //      picker.navigationController?.popToRootViewController(animated: true)
            
            //  picker.navigationController?.popViewController(animated: true)
            
            
            
            print(code)
        }
        
        navigationController?.pushViewController(picker, animated: true)
        
        //   navigationController?.present(picker, animated: true, completion: nil)
    }
    



        func saveClicked() {

            username.isUserInteractionEnabled = false
            mobileNumber.isUserInteractionEnabled = false
            
            var userNameString:NSString = username.text! as NSString
            var mobileString:NSString = mobileNumber.text! as NSString
            let coutryCode = countrylab.text!
            
            if (mobileString.isEqual(to: "") && userNameString.isEqual(to: "")) {
                self.alertView.title = NSLocalizedString("Warning!",comment:"Warning!")
                alertView.message = NSLocalizedString("Enter all fields", comment: "Enter all fields")
                alertView.delegate = self
                alertView.addButton(withTitle: "OK")
                alertView.show()
            }
            else if coutryCode == "CC"{
                
                
                self.alertView.title = ""
                self.alertView.message = "Select your country code"
                self.alertView.delegate = self
                self.alertView.addButton(withTitle: "OK")
                self.alertView.show()
                
            }
            else if (userNameString.isEqual(to: "")) {
                 self.alertView.title = NSLocalizedString("Warning!",comment:"Warning!")
                alertView.message = NSLocalizedString("Enter a username", comment: "Enter a username")
                alertView.delegate = self
                alertView.addButton(withTitle: "OK")
                alertView.show()
            }
                
            else if (mobileString.isEqual(to: "")){
                 self.alertView.title = NSLocalizedString("Warning!",comment:"Warning!")
                alertView.message = NSLocalizedString("Enter a mobile number", comment: "Enter a mobile number ")
                alertView.delegate = self
                alertView.addButton(withTitle: "OK")
                alertView.show()
            }
            else
            {
                
                
                let trimid:NSString! = "\(self.user_id)" as NSString!
                let id: NSString = "\(trimid!)" as NSString
                

                userNameString = userNameString.replacingOccurrences(of: " ", with: "+") as NSString
                mobileString = mobileString.replacingOccurrences(of: " ", with: "+") as NSString
                
                var combine = "\(coutryCode)\(mobileString)"
                combine = combine.replacingOccurrences(of: "+", with: "")
                
                print(" !!! \(combine)")
                
                
                print("\(live_url)contacts/addContact/user_id/\(id)contact_name/\(userNameString)/contact_number/\(combine)")
                
                manager.get( "\(live_url)contacts/addContact/user_id/\(id)/contact_name/\(userNameString)/contact_number/\(combine)",
                    parameters: nil,
                    success: { (operation: AFHTTPRequestOperation?,responseObject: Any?) in
                        
                        let jsonObjects=responseObject as! NSArray
                        
                        for dataDict : Any in jsonObjects {
                            // let tuserid:String? = (dataDict as AnyObject).object(forKey: "id") as? String
                            // self.appDelegate.userid = tuserid
                            
                        let status: String? = (dataDict as AnyObject).object(forKey: "status") as? String
                            let tmp: String? = "Success"
                            
                       
                                
                                if(status == tmp)
                                {
                                    self.view.makeToast("Contact added Successfully", duration: 15.0, position: .center)
                                    
                                    self.alertView.title = NSLocalizedString("Added Successfully",comment:"Added Successfully")
                                    self.alertView.message = NSLocalizedString("Contact added Successfully", comment: "Contact added Successfully")
                                    self.alertView.delegate = self
                                    self.alertView.addButton(withTitle: "OK")
                                    self.alertView.show()
                                    
                                    self.navigationController?.popViewController(animated: true)
                                }
                     
 
                       
                           
                            else
                            {
                                print("Invalid Newuser")
                                
                            }
                        
                        }
                       
                    },
                    failure: { (operation: AFHTTPRequestOperation?,error: Error?) in
                        
                       
                })
                
            }
       

            
        }
    
    func addSaveButton(){
        
        let btnName: UIButton = UIButton()
        btnName.setImage(UIImage(named: "tick"), for: UIControlState())
        btnName.setTitle("CrazyGuys", for: UIControlState())
        btnName.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btnName.addTarget(self, action: #selector(STAddContactsVC.saveClicked), for: .touchUpInside)
        
        let rightBarButton:UIBarButtonItem = UIBarButtonItem()
        rightBarButton.customView = btnName
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setViewController(leftMenuViewController : UIViewController)
    {
        let appDelegate = AppDelegate.sharedInstance()
        appDelegate.setCenterViewController(viewController: leftMenuViewController)
        
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
extension STAddContactsVC: MICountryPickerDelegate {
    
    func countryPicker(_ picker: MICountryPicker, didSelectCountryWithName name: String, code: String) {
        // picker.navigationController?.popToRootViewController(animated: true)
        // label.text = "Selected Country: \(name)"
    }
    
    func countryPicker(_ picker: MICountryPicker, didSelectCountryWithName name: String, code: String, dialCode: String) {
        
        //  picker.navigationController?.popToRootViewController(animated: true)
        
        picker.navigationController?.popViewController(animated: true)
        
        
        countrylab.text = "\(dialCode)"
        countrylab.textColor = UIColor.darkGray
    }
    
    
}
