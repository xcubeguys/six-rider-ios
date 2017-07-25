//
//  STEditContactsVC.swift
//  SendTxT
//
//  Created by Apple on 07/11/16.
//  Copyright © 2016 Apple. All rights reserved.
//

import UIKit

class STEditContactsVC: UIViewController {


    @IBOutlet var userName: UITextField!
    
    @IBOutlet var mobileNumber: UITextField!

    
    let alertView:UIAlertView = UIAlertView()
    let alertView1:UIAlertView = UIAlertView()
    var picker:UIImagePickerController?=UIImagePickerController()
    let manager = AFHTTPRequestOperationManager()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var live_url = demo_url
    
    
    
   var user_id:NSString!=""
    
    var passimgurl:NSString=""
    var imageselected = false
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {

        
        super.viewDidLoad()
        self.title = "Edit Contact"
        self.navigationController?.isNavigationBarHidden = false
        
        self.userName.text = "\(self.appDelegate.name!)"
        self.mobileNumber.text = "\(self.appDelegate.mobilenumber!)"
      
        
        
        addsaveButton()
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
       // navigationController!.isNavigationBarHidden = false
        
        if let value : String =  UserDefaults.standard.object(forKey: "userid") as! String!{
            user_id = value as NSString

        
        
        print("edit contact\(live_url)contacts/viewContact/contact_id/\(user_id!)")
        
        manager.get( "\(live_url)contacts/viewContact/contact_id/\(user_id!)",
                parameters: nil,
            success: { (operation: AFHTTPRequestOperation?,responseObject: Any?) in
                
                let jsonObjects=responseObject as! NSArray
                
                for dataDict : Any in jsonObjects {
                    
                    
                    let status: String? = (dataDict as AnyObject).object(forKey: "status") as? String
                    let tmp: String? = "Success"
                    
                    
                    if(status == tmp)
                    {
                   
                        let name:NSString? = (dataDict as AnyObject).object(forKey: "contact_name") as? NSString
                        let uname: NSString! = "\(name!)" as NSString!
                        let contactid:NSString? = (dataDict as AnyObject).object(forKey: "contact_id") as? NSString
                        let contact_id: NSString! = "\(contactid!)" as NSString!
                        
                        let mobno:NSString? = (dataDict as AnyObject).object(forKey: "contact_number") as? NSString
                        let cname: NSString! = "\(mobno!)" as NSString!

                       
                     //   self.contact_idarray.add(contact_id)
                        self.userName.text = uname as String?
                        self.mobileNumber.text = cname as String?
                        //
                        
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

    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var result=true
        if(textField == userName)
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
                let disallowedCharacterSet = CharacterSet(charactersIn: "0123456789._").inverted
                let replacementStringIsLegal = string.rangeOfCharacter(from: disallowedCharacterSet) == nil
                result = replacementStringIsLegal
            }
        }
        
        
        return result
        
    }

    
    func saveclicked() {
        
        
        
        userName.isUserInteractionEnabled = false
        mobileNumber.isUserInteractionEnabled = false
        
        var usernameString:NSString = userName.text! as NSString
        var mobilenoString:NSString = mobileNumber.text! as NSString
        
        
        if (mobilenoString.isEqual(to: "") && usernameString.isEqual(to: "")) {
            self.alertView.title = NSLocalizedString("Fill all fields",comment:"Must Fill all fields")
            alertView.message = NSLocalizedString("Invalid info", comment: "Invalid info")
            alertView.delegate = self
            alertView.addButton(withTitle: "OK")
            alertView.show()
        }
        else if (usernameString.isEqual(to: "")) {
            self.alertView.title = NSLocalizedString("Fill name fields",comment:"Must Fill Username")
            alertView.message = NSLocalizedString("Invalid info", comment: "Invalid info")
            alertView.delegate = self
            alertView.addButton(withTitle: "OK")
            alertView.show()
        }
            
        else if (mobilenoString.isEqual(to: "")){
            self.alertView.title = NSLocalizedString("Fill mobile number field", comment: "Must Fill mobile number")
            alertView.message = NSLocalizedString("Invalid info", comment: "Invalid info")
            alertView.delegate = self
            alertView.addButton(withTitle: "OK")
            alertView.show()
        }
        else
        {
            
            if let value : String =  UserDefaults.standard.object(forKey: "userid") as! String!{
                user_id = value as NSString
            
//            let trimid:NSString! = "\(self.appDelegate.userid!)" as NSString!
//            let id: NSString = "\(trimid!)" as NSString
            
            usernameString = usernameString.replacingOccurrences(of: " ", with: "+") as NSString
            mobilenoString = mobilenoString.replacingOccurrences(of: " ", with: "+") as NSString
            //contacts/updateContact/contact_id/
            
            print("edit profile\(live_url)contacts/updateContact/contact_id/\(user_id)/contact_name/\(usernameString)/contact_number/\(mobilenoString)")
            
            manager.get( "\(live_url)contacts/updateContact/contact_id/\(user_id)/contact_name/\(usernameString)/contact_number/\(mobilenoString)",
                parameters: nil,
                success: { (operation: AFHTTPRequestOperation?,responseObject: Any?) in
                    
                    let jsonObjects=responseObject as! NSArray
                    
                    for dataDict : Any in jsonObjects {
       
                        let status: String? = (dataDict as AnyObject).object(forKey: "status") as? String
                        print("copy \(status)")
                        let tmp: String? = "Success"
                        
                        
                        if(status == tmp)
                        {
                            
                            self.view.makeToast("Contact added Successfully", duration: 15.0, position: .center)
                            
                            self.alertView.title = NSLocalizedString("Added Successfully",comment:"Added Successfully")
                            self.alertView.message = NSLocalizedString("Contact added Successfully", comment: "Contact added Successfully")
                            self.alertView.delegate = self
                            self.alertView.addButton(withTitle: "OK")
                            self.alertView.show()
                            
                            self.navigationController?.popToRootViewController(animated: true)
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
        self.navigationController?.popToRootViewController(animated: true)
        }
        
    }
    
       
    func gestureEqualsGesture(_ gesture: UIGestureRecognizer, compareGesture: UIGestureRecognizer?) -> Bool
    {
        if (compareGesture != nil) {
            
            if gesture == compareGesture! {
                
                return true
            }
            else {
                
                return false
            }
        }
        else {
            
            return false
        }
    }
    

    
    func addsaveButton(){
        
        let btnName: UIButton = UIButton()
        btnName.setImage(UIImage(named: "tick"), for: UIControlState())
        btnName.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
      
        btnName.addTarget(self, action: #selector(STEditContactsVC.saveclicked), for: .touchUpInside)
        let rightBarButton:UIBarButtonItem = UIBarButtonItem()
        rightBarButton.customView = btnName
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        let back: UIButton = UIButton()
        back.setImage(UIImage(named: "backWhite.png"), for: UIControlState())
        back.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        back.addTarget(self, action: #selector(STGroupChatVC.backToHome(_:)), for: .touchUpInside)
        let leftBarButton:UIBarButtonItem = UIBarButtonItem()
        leftBarButton.customView = back
        self.navigationItem.leftBarButtonItem = leftBarButton
        
    }
    
    func backToHome(_ Selector: AnyObject) {
       
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

}
