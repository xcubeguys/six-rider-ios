//
//  ARProfileVC.swift
//  Arcane Rider
//
//  Created by Apple on 20/12/16.
//  Copyright © 2016 Apple. All rights reserved.
//

import UIKit
import Alamofire

class ARProfileVC: UIViewController {

    
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    @IBOutlet weak var labelFirst: UILabel!
    @IBOutlet weak var labelLast: UILabel!
    @IBOutlet weak var labelPhone: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
 
    
    var viewAPIUrl = "https://demo.cogzidel.com/arcane_lite/Rider/"
    
    typealias jsonSTD = NSArray
    
    typealias jsonSTDAny = [String : AnyObject]

    
    override func viewDidLoad() {
        super.viewDidLoad()

    
        navigationController!.navigationBar.barStyle = .black
        
        navigationController!.isNavigationBarHidden = false
        
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "arrow-left.png")!, for: .normal)
        button.addTarget(self, action: #selector(ARProfileVC.profileBtn(_:)), for: .touchUpInside)
        //CGRectMake(0, 0, 53, 31)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        //(frame: CGRectMake(3, 5, 50, 20))
        let label = UILabel(frame: CGRect(x: 20, y: 5, width: 150, height: 20))
        // label.font = UIFont(name: "Arial-BoldMT", size: 13)
        label.text = "SETTINGS"
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.clear
        button.addSubview(label)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = barButton
       // rightNaviCallBtn()
        self.activityView.startAnimating()
        
        
        viewprofile()
      
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .lightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
    }
    
    func profileBtn(_ Selector: AnyObject) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    func rightNaviCallBtn(){
        
        let btnName: UIButton = UIButton()
        btnName.setImage(UIImage(named: "pencil.png"), for: UIControlState())
        btnName.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btnName.addTarget(self, action: #selector(ARProfileVC.callHistoryBtn(_:)), for: .touchUpInside)
        
        let leftBarButton:UIBarButtonItem = UIBarButtonItem()
        leftBarButton.customView = btnName
        self.navigationItem.rightBarButtonItem = leftBarButton
        
    }
    
    
    func callHistoryBtn(_ Selector: AnyObject) {
        
          self.navigationController?.pushViewController(AREditProfileVC(), animated: true)
        
    }
    
    @IBAction func btnLogOut(_ sender: Any) {
        
        
        
        let alert = UIAlertController(title: "Confirm", message: "Are You Sure want to Log Out?",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "OK", style: .default)
        {
            (action : UIAlertAction!) -> Void in
            
            
              let prefs = UserDefaults.standard
             prefs.removeObject(forKey: "userid")
            
            self.appDelegate.setRootViewController()
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        {
            (action : UIAlertAction!) -> Void in
        }
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)

        
    }
    

    func viewprofile(){
        
        var urlstring:String = "\(viewAPIUrl)editProfile/user_id/\(self.appDelegate.userid!)"
        
        urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        
        urlstring = urlstring.removingPercentEncoding!
        
        print("view profile\(urlstring)")
        
        self.callviewAPI(url: "\(urlstring)")
        
    }
    
    func callviewAPI(url : String){
        
        self.activityView.startAnimating()

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
                    
                    let firstname:String = value.object(forKey: "firstname") as! String
                    let lastname:String = value.object(forKey: "lastname") as! String
                    let mobile:String = value.object(forKey: "mobile") as! String
                    let cc:String = value.object(forKey: "country_code") as! String
                    let email:String = value.object(forKey: "email") as! String
                    
                    labelFirst.text = firstname
                    labelLast.text = lastname
                    labelEmail.text = email
                    var ccValue = cc
                    labelPhone.text = "\(ccValue) \(mobile)"
                    
                self.appDelegate.fnametextField = labelFirst.text
                 self.appDelegate.lnametextfield = labelLast.text
                 self.appDelegate.emailtextField = labelEmail.text
                 self.appDelegate.mobilenotextField = labelPhone.text
               // self.appDelegate.countrycodetextfield = countrycodetextfield.text
          
                    print("email is \(email)")
                    
                    //  self.navigationController?.pushViewController(ARMapVC(), animated: true)
                    
                    self.activityView.stopAnimating()

                }
                else{
                    
                    self.activityView.stopAnimating()

                }
            }
        }
        catch{
            
            print(error)
            
            self.activityView.stopAnimating()

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
