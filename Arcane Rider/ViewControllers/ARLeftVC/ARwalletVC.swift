//
//  ARwalletVC.swift
//  SIX Rider
//
//  Created by Apple on 08/03/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit
import Alamofire

extension Int
{
    func toString() -> String
    {
        let myString = String(self)
        return myString
    }
}
class ARwalletVC: UIViewController {

    @IBOutlet weak var walletamount: UILabel!
    @IBOutlet weak var profilepic: UIImageView!
    
    @IBOutlet weak var amounterr: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var amounttextbox: UITextField!
    @IBOutlet weak var addmoney: UIButton!
    
    typealias jsonSTD = NSArray
    
    typealias jsonSTDAny = [String : AnyObject]
    
    
     var viewAPIUrl = live_rider_url
  
     let appDelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController!.isNavigationBarHidden = true
        self.amounterr.isHidden = true
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ARwalletVC.dismissKeyboard))
        view.addGestureRecognizer(tap)
        webservice()
        
        
    }
    func dismissKeyboard() {
        view.endEditing(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBOutlet weak var backaction: UIButton!
    
    @IBAction func backfunction(_ sender: Any) {
        appDelegate.leftMenu()
    }
 override func viewWillAppear(_ animated: Bool) {
    
    navigationController!.isNavigationBarHidden = true
    if self.appDelegate.walletstatus == 1{
        self.amounttextbox.text = ""
    }
    
        webservice()

    }
    
    @IBAction func addmoneyaction(_ sender: Any) {
        
        if (amounttextbox.text == "")
        {
             self.amounterr.isHidden = false
        }
        else{
            
          self.appDelegate.addmoneyvalue =   self.amounttextbox.text
            
            print(self.appDelegate.addmoneyvalue)
            //self.amounttextbox.text = ""
            self.amounterr.isHidden = true
             self.appDelegate.stripepaymentstatus = "1"
            self.navigationController?.pushViewController(ARStripeVC(), animated: true)
        }
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == amounttextbox{
            
            amounterr.isHidden=true
        }
        else{
            
        }
return true
    }
    
    func webservice(){
      
        var urlstring:String = "\(viewAPIUrl)editProfile/user_id/\(self.appDelegate.userid!)"
        
        urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        
        urlstring = urlstring.removingPercentEncoding!
        
        print(urlstring)
        
        self.callviewAPI(url: "\(urlstring)")
    }
    func callviewAPI(url : String){
        
        
        
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
                    let profilePic1 = value.object(forKey: "profile_pic") as! String
                    
                    var nick_name = value.object(forKey: "nick_name") as! String
                    
                    let refrel_code = value.object(forKey: "refrel_code") as! String
                    
                    var wallet_amount = value.object(forKey: "wallet_amount") as! String
                    
                    
                    if wallet_amount != nil {
                        
                        
                        self.appDelegate.wallet_amount = wallet_amount
                        self.walletamount.text! = "$\(self.appDelegate.wallet_amount!)"
                        print(self.appDelegate.wallet_amount)
                        //self.amounttextbox.text! = ""
                        
                    }
                    else{
                       self.walletamount.text! = ""
                    }
                    print(self.appDelegate.wallet_amount)
                    
                   
                    
//                    print(walletint)
//                    
//                    
//                    var myNumber = walletint
//                    var myNumberAsString = myNumber?.toString()
//                    
//                    var myNumber1 = self.appDelegate.wallet_amount
//                    var myNumberAsString1 = myNumber1?.toString()
//                    
//                    var stringValue = myNumberAsString
//                    
//                    
//                    var stringValue1 = myNumberAsString1
//                    
//                    print(myNumberAsString1)
//                    print(myNumberAsString)
//                    
//                    
//                    
//                    
//                    if myNumber1 != nil
//                    {
//                        self.walletamount.text = "$\(stringValue1)"
//                    }
//                    else{
//                        self.walletamount.text = ""
//                    }
//                    
                    
                    let value = profilePic1
                    
                    UserDefaults.standard.setValue(value, forKey: "profilePic")
                    
                    if firstname != nil{
                        firstname = firstname?.replacingOccurrences(of: "Optional(", with: "")
                        firstname = firstname?.replacingOccurrences(of: ")", with: "")
                        firstname = firstname?.replacingOccurrences(of: "%20", with: " ")
                        firstname = firstname?.replacingOccurrences(of: "\"", with: "")
                        
                        self.appDelegate.firstnamewallet = firstname
                        self.username.text = self.appDelegate.firstnamewallet!
                        print(self.appDelegate.firstnamewallet)
                        
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
                        lastname = lastname?.replacingOccurrences(of: "%2522", with: "")
                        
                        
                        
                    }
                    else{
                        lastname = ""
                    }
                    
                    
                   
                    self.username.text = self.appDelegate.firstnamewallet!
                    
                    var ccValue = cc
                   
                    let userValue = "\(firstname) \(lastname)"
                    UserDefaults.standard.setValue(userValue, forKey: "userName")
                    
                    
                    print(profilePic1)
                    
                    if profilePic1 == nil{
                        
                        profilepic.image = UIImage(named: "UserPic.png")
                        
                    }
                    else if profilePic1 == ""{
                        
                        profilepic.image = UIImage(named: "UserPic.png")
                        UserDefaults.standard.setValue(profilePic1, forKey: "GProfilePic")
                        
                    }
                    else{
                        
                        
                        self.appDelegate.userprofilepic = profilePic1
                        
                        profilepic.layer.cornerRadius = profilepic.frame.size.width / 2;
                        profilepic.clipsToBounds = true;
                        
                        profilepic.layer.borderWidth = 1.0
                        
                        profilepic.layer.borderColor = UIColor.white.cgColor
                        
                      
                        
                        
                        profilepic.sd_setImage(with: NSURL(string: profilePic1) as URL!)
                        UserDefaults.standard.setValue(profilePic1, forKey: "GProfilePic")
                    }
                    
                    /* if profilePic == "http://demo.cogzidel.com/arcane_lite/images/yy.png"{
                     
                     
                     imageViewProfile.image = UIImage(named: "UserPic.png")
                     
                     
                     }
                     else if profilePic != ""{
                     
                     let imageURL = profilePic
                     
                     let url = URL(string: imageURL)
                     
                     imageViewProfile.setImageWithUrl(url!)
                     
                     }
                     else{
                     
                     imageViewProfile.image = UIImage(named: "UserPic.png")
                     
                     }*/
                    
                    /*  var valueProfile = UserDefaults.standard.object(forKey: "GProfilePic") as? String
                     valueProfile = valueProfile?.replacingOccurrences(of: "Optional(", with: "")
                     valueProfile = valueProfile?.replacingOccurrences(of: ")", with: "")
                     
                     if valueProfile == nil{
                     
                     if profilePic == nil{
                     
                     imageViewProfile.image = UIImage(named: "UserPic.png")
                     
                     }
                     else if profilePic == ""{
                     
                     imageViewProfile.image = UIImage(named: "UserPic.png")
                     
                     }
                     else{
                     
                     imageViewProfile.sd_setImage(with: NSURL(string: profilePic) as URL!)
                     
                     }
                     
                     }
                     else{
                     
                     imageViewProfile.sd_setImage(with: NSURL(string: valueProfile!) as URL!)
                     
                     }*/
                    
                   
                    
                    
                }
                else{
                    
                    
                    
                    
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
