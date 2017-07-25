//
//  AREditProfileVC.swift
//  Arcane Rider
//
//  Created by Apple on 20/12/16.
//  Copyright © 2016 Apple. All rights reserved.
//

import UIKit
import Alamofire

class AREditProfileVC: UIViewController {

    @IBOutlet weak var firstnametextField: HoshiTextField!
    @IBOutlet weak var lastnametextField: HoshiTextField!
    @IBOutlet weak var countrycodetextField: HoshiTextField!
    @IBOutlet weak var mobilenotextField: HoshiTextField!
    @IBOutlet weak var emailtextField: HoshiTextField!
    @IBOutlet weak var countrycodeBtnOutlet: UIButton!
    @IBOutlet weak var countrycodeLabel: UILabel!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var viewAPIUrl = "http://demo.cogzidel.com/arcane_lite/Rider/"
    
    typealias jsonSTD = NSArray
    
    typealias jsonSTDAny = [String : AnyObject]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstnametextField.text = self.appDelegate.fnametextField!
        lastnametextField.text = self.appDelegate.lnametextfield!
        mobilenotextField.text = self.appDelegate.mobilenotextField!
        countrycodeLabel.text = self.appDelegate.countrycodetextfield!
        emailtextField.text =  self.appDelegate.emailtextField!
    
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ARSignInVC.hidekeyboard))
        
        tapGesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGesture)
        
        navigationController!.navigationBar.barStyle = .black
        
        navigationController!.isNavigationBarHidden = false
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "arrow-left.png")!, for: .normal)
        button.addTarget(self, action: #selector(ARProfileVC.profileBtn(_:)), for: .touchUpInside)
      
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
     
        let label = UILabel(frame: CGRect(x: 20, y: 5, width: 150, height: 20))
     
        label.text = "Profile"
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.clear
        button.addSubview(label)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = barButton

        
    }
    
    func hidekeyboard()
    {
        self.view.endEditing(true)
    }
    
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    @IBAction func saveBtnAction(_ sender: Any) {
 
        let fname:String = firstnametextField.text! as String
        let lname:String = lastnametextField.text! as String
        let mobile:String = mobilenotextField.text! as String
        let countryCode:String = countrycodeLabel.text! as String
        let email:String = emailtextField.text! as String
        
        var urlstring:String = "\(viewAPIUrl)updateDetails/user_id/\(self.appDelegate.userid!)/firstname/\(fname)/lastname/\(lname)/mobile/\(mobile)/country_code/\(countryCode)/profile_pic/yy.png/city/null/email/\(email)/"
        
        urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        
        urlstring = urlstring.removingPercentEncoding!
        
        print("Edit profile\(urlstring)")
        
        self.calleditAPI(url: "\(urlstring)")
    }
    
    
    func calleditAPI(url : String){
        
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
                    
                 self.navigationController?.pushViewController(ARProfileVC(), animated: true)
                    
                    
                }
                else{
                    
                }
            }
        }
        catch{
            
            print(error)
            
        }
        
    }
    @IBAction func backtoViewprofile(_ sender: Any) {
        self.navigationController?.pushViewController(ARProfileVC(), animated: true)
    }
// country code

    @IBAction func countryCodeBtnAction(_ sender: Any) {
        
        countrycodeBtnOutlet.isHidden=true
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
            
            
            print(code)
        }
        
        
        navigationController?.pushViewController(picker, animated: true)
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
extension AREditProfileVC: MICountryPickerDelegate {
    
    func countryPicker(_ picker: MICountryPicker, didSelectCountryWithName name: String, code: String) {
        // picker.navigationController?.popToRootViewController(animated: true)
        // label.text = "Selected Country: \(name)"
    }
    
    func countryPicker(_ picker: MICountryPicker, didSelectCountryWithName name: String, code: String, dialCode: String) {
        
        //  picker.navigationController?.popToRootViewController(animated: true)
        
        //  navigationController!.isNavigationBarHidden = true
        picker.navigationController?.popViewController(animated: true)
        
        countrycodeLabel.text = "\(dialCode)"
        countrycodeLabel.textColor = UIColor.black
        
    }
}
