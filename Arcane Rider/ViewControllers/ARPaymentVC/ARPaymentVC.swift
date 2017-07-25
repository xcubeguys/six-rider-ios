//
//  ARPaymentVC.swift
//  Arcane Rider
//
//  Created by Apple on 24/12/16.
//  Copyright © 2016 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SwiftMessages
import Firebase
import GeoFire
import UserNotifications

class ARPaymentVC: UIViewController,UNUserNotificationCenterDelegate {

    @IBOutlet weak var iamgeCash: UIImageView!
    @IBOutlet weak var imageCredit: UIImageView!
    @IBOutlet weak var buttonCash: UILabel!
    @IBOutlet weak var buttonCredit: UILabel!
    @IBOutlet weak var imagecorporate: UIImageView!
    @IBOutlet weak var corporateview: UIView!
    @IBOutlet weak var cashview: UIView!

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var viewAPIUrl = live_rider_url
    
    typealias jsonSTD = NSArray
    
    typealias jsonSTDAny = [String : AnyObject]

    var payValue = "0"
    
    /* override var preferredStatusBarStyle: UIStatusBarStyle {
     
     return .lightContent
        
     }*/
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.incomingNotification1()
        
        if(self.appDelegate.corpstatus == 1){
            corporateview.isHidden = false
        }
        else{
            corporateview.isHidden = true
        }
        // Do any additional setup after loading the view.
        
        navigationController!.navigationBar.barStyle = .black
        
        navigationController!.isNavigationBarHidden = false
        
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "arrow-left.png")!, for: .normal)
        button.addTarget(self, action: #selector(ARPaymentVC.profileBtn(_:)), for: .touchUpInside)
        //CGRectMake(0, 0, 53, 31)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        //(frame: CGRectMake(3, 5, 50, 20))
        let label = UILabel(frame: CGRect(x: 10, y: 5, width: 150, height: 20))
        // label.font = UIFont(name: "Arial-BoldMT", size: 13)
        label.text = "PAYMENT"
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.clear
        button.addSubview(label)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = barButton
        
        
        let value = UserDefaults.standard.object(forKey: "cashMode") as! String!
        let cash = "cash"
        let credit = "credit"
        let corporate = "corporate id"
        if value == nil{
            
            iamgeCash.image = UIImage(named : "check.png")
            imageCredit.image = nil
            imagecorporate.image = nil

        }
        else if value == cash{
            
            iamgeCash.image = UIImage(named : "check.png")
            imageCredit.image = nil
            imagecorporate.image = nil
        }
        else if value == corporate{
            
            imagecorporate.image = UIImage(named : "check.png")
            imageCredit.image = nil
            iamgeCash.image = nil
        }
        else{
            
            imageCredit.image = UIImage(named : "check.png")
            iamgeCash.image = nil
            imagecorporate.image = nil
        }
        
       //// cardStatus()
    }

    override func viewWillAppear(_ animated: Bool) {
        
        UIApplication.shared.isIdleTimerDisabled = false
        
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
        navigationController!.navigationBar.barStyle = .black
        
        UNUserNotificationCenter.current().delegate = self
        
        cashoption()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func cashoption(){
        let ref = FIRDatabase.database().reference()
        
        //let geoFire = GeoFire(firebaseRef: ref.child("drivers_data/\(self.appDelegate.userid!)"))
        let geoFire = GeoFire(firebaseRef: ref.child("cashoption").child("status"))
        
        
        //accept
        //get values from firebase after accepting
        ref.child("cashoption").child("status").observe(.value, with: { (snapshot) in
            
            
            print("updating")
            let status1 = snapshot.value as Any
            print(status1)
            var status = "\(status1)"
            status = status.replacingOccurrences(of: "Optional(", with: "")
            status = status.replacingOccurrences(of: ")", with: "")
            
            print(status)
            
            if(status == "off"){
                
                self.cashview.isHidden = true
                
            }
            else{
                self.cashview.isHidden = false
            }
        }) { (error) in
            
            print(error.localizedDescription)
        }
        
    }

    
    func incomingNotification1(){
        
        let ref = FIRDatabase.database().reference()
        
        let geoFire = GeoFire(firebaseRef: ref.child("cashoption"))
        
        // let geoFire = GeoFire(firebaseRef: ref.child("drivers_data/5857c2bada71b4d9708b4567/"))
        
        // print(geoFire!.firebaseRef(forLocationKey: "geolocation"))
        
        // updated
        
        ref.child("cashoption").observe(.childChanged, with: { (snapshot) in
            
            print("updating")
            let status1 = snapshot.value as Any
            print(status1)
            var status = "\(status1)"
            status = status.replacingOccurrences(of: "Optional(", with: "")
            status = status.replacingOccurrences(of: ")", with: "")
            print(status)
            if(status == "off"){
                
               self.cashview.isHidden = true
                
            }
            else{
                self.cashview.isHidden = false
            }
            
            
            //
            
            
        })
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func btnCashAction(_ sender: Any) {
        
        iamgeCash.image = UIImage(named : "check.png")
        imageCredit.image = nil
        let value = "cash"
        UserDefaults.standard.set(value, forKey: "cashMode")
        if(imagecorporate.isHidden == false){
            imagecorporate.image = nil
        }
        
    }
    @IBAction func btnCardAction(_ sender: Any) {
        
        let value = UserDefaults.standard.object(forKey: "payValue") as! String
        if value == "pay"{
            
            iamgeCash.image = nil
            imageCredit.image = UIImage(named : "check.png")
            let value = "credit"
            UserDefaults.standard.set(value, forKey: "cashMode")
            if(imagecorporate.isHidden == false){
                imagecorporate.image = nil
            }
            
        }
        else{
            
            let warning = MessageView.viewFromNib(layout: .CardView)
            warning.configureTheme(.warning)
            warning.configureDropShadow()
            let iconText = "" //"🤔"
            warning.configureContent(title: "", body: "Click Add payment to select Credit or Debit Card", iconText: iconText)
            warning.button?.isHidden = true
            var warningConfig = SwiftMessages.defaultConfig
            warningConfig.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
            SwiftMessages.show(config: warningConfig, view: warning)

        }

        
    }
    @IBAction func btncorporateact(_ sender: Any) {
        
        imagecorporate.image = UIImage(named : "check.png")
        imageCredit.image = nil
        iamgeCash.image = nil
        let value = "corporate id"
        UserDefaults.standard.set(value, forKey: "cashMode")
    }
    
    @IBAction func btnAddPaymentAction(_ sender: Any) {
        
        let value = UserDefaults.standard.object(forKey: "payValue") as! String
        if value == "pay"{
            
            let iconText = "" //"🤔"
            let success = MessageView.viewFromNib(layout: .CardView)
            success.configureTheme(.success)
            success.configureDropShadow()
            success.configureContent(title: "", body: "You Have added your card Already!", iconText: iconText)
            success.button?.isHidden = true
            var successConfig = SwiftMessages.defaultConfig
            successConfig.presentationStyle = .top
            successConfig.presentationContext = .window(windowLevel: UIWindowLevelNormal)
            
            SwiftMessages.show(config: successConfig, view: success)
        }
        else{
            
            
           
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let subContentsVC = storyboard.instantiateViewController(withIdentifier: "scancard") as! ScanormanualViewController
            self.navigationController?.pushViewController(subContentsVC, animated: true)
           
            //self.navigationController?.pushViewController(ScanormanualViewController(), animated: true)
            
        }
        
    }
    
    func profileBtn(_ Selector: AnyObject) {
        
        self.navigationController?.popViewController(animated: true)
        self.appDelegate.backfrompayment = "1"
    }

    func cardStatus(){
        
        var urlstring:String = "\(viewAPIUrl)editProfile/user_id/\(self.appDelegate.userid!)"
        
        urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        
        urlstring = urlstring.removingPercentEncoding!
        
        print(urlstring)
        
        self.callStatusAPI(url: "\(urlstring)")
    }
    
    func callStatusAPI(url : String){
                
        Alamofire.request(url).responseJSON { (response) in
            
            self.parseData(JSONData: response.data!)
        }
        
    }
    
    func parseData(JSONData : Data){
        
        do{
            
            let readableJSon = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as! jsonSTD
            
            print(" !!! \(readableJSon[0])")
            
            let value = readableJSon[0] as AnyObject
            
            if let final = value.object(forKey: "card_status"){
                print(final)
                if(final as! String == "1"){
                    
                    
                    self.payValue = "1"
                    
                }
                else{
                    
                    self.payValue = "0"
                    
                }
            }
        }
        catch{
            
            print(error)
            
            
        }
        
    }

    
}
