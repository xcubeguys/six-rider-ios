//
//  ViewreferralUser.swift
//  SIX Rider
//
//  Created by Apple on 24/05/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit
import  Alamofire

class ViewreferralUser: UIViewController, UITableViewDelegate,UITableViewDataSource{

    @IBOutlet var referview: UITableView!
     let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet var topreferview: UIView!
    typealias jsonSTD = NSArray
    
    @IBOutlet weak var nouserlebel: UILabel!
    @IBOutlet weak var noreferraluser: UIView!
    @IBOutlet var backbtn: UIButton!
    var usernameArray:NSMutableArray=NSMutableArray()
    var userlastnameArray:NSMutableArray=NSMutableArray()
    var usertypeArray:NSMutableArray=NSMutableArray()
    var userImageArray:NSMutableArray=NSMutableArray()
    var usercategoryArray:NSMutableArray=NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        referview.delegate = self
        referview.dataSource = self
        self.noreferraluser.isHidden = true
        self.nouserlebel.isHidden = true
        
        referview.register((UINib(nibName: "referralcell",bundle: nil)), forCellReuseIdentifier: "referralcell")
        Userreferral()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func Userreferral(){
       // self.appDelegate.userid = "58e1cd5a192d2ebb0f7cc3da"
        var urlstring:String = "\(live_url)requests/getReferralUserList/user_id/\(self.appDelegate.userid!)"
        urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        
        //        urlstring = urlstring.removingPercentEncoding!
        
        print(urlstring)
        
        self.callviewPhAPI(url: "\(urlstring)")
        
    }
    func callviewPhAPI(url : String){
        
        
        Alamofire.request(url).responseJSON { (response) in
            print("url:\(url)")
            self.parseDataPh(JSONData: response.data!)
        }
        
    }
    
    
    func parseDataPh(JSONData : Data){
        
        
        
        do{
            
            
            
            let readableJSon = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as! jsonSTD
            print(" !!! \(readableJSon[0])")
            let value = readableJSon[0] as AnyObject
            for dataDict : Any in readableJSon
                
            {
                
                
                let status1: NSString? = (dataDict as AnyObject).object(forKey: "status") as? NSString
                
                if(status1 == "Fail"){
                    self.noreferraluser.isHidden = false
                    self.nouserlebel.isHidden = false
                    self.referview.isHidden = true
                    self.nouserlebel.text = "Your Referral Code Not used"
                   
                }
                else{
                    
                    let referral_users: NSString? = (dataDict as AnyObject).object(forKey: "first_name") as? NSString
                    
                    let referral_lastname: NSString? = (dataDict as AnyObject).object(forKey: "last_name") as? NSString
                    
                    let referral_pic: NSString? = (dataDict as AnyObject).object(forKey: "profile_pic") as? NSString
                    
                    let referral_category: NSString? = (dataDict as AnyObject).object(forKey: "category") as? NSString
                    
                    let referral_type: NSString? = (dataDict as AnyObject).object(forKey: "user_type") as? NSString
                    var name = "\(referral_users!) \(referral_lastname!)"
                    if (referral_users != "" || referral_users != nil)
                    {
                        print("referral_users\(referral_users)")
                        usernameArray.add(name as String)
                    }
                    else{
                        usernameArray.add("Unknown")
                    }
                    
                    if (referral_lastname != "" || referral_lastname != nil)
                    {
                        print("referral_lastname\(referral_lastname)")
                        userlastnameArray.add(referral_lastname! as String)
                        
                    }
                    else{
                        userlastnameArray.add("unknown")
                    }
                    
                    if (referral_pic != "" || referral_pic != nil)
                    {
                        print("referral_pic\(referral_pic)")
                        userImageArray.add(referral_pic! as String)
                    }
                    else{
                    }
                    
                    if (referral_category != "" || referral_category != nil)
                    {
                        print("referral_category\(referral_category)")
                        usercategoryArray.add(referral_category! as String)
                    }
                    else{
                        
                    }
                    
                    if (referral_type != "" || referral_type != nil)
                    {
                        print("referral_type\(referral_type)")
                        usertypeArray.add(referral_type! as String)
                    }
                    else{
                        
                    }

                    
                    
                }
                self.referview.reloadData()
                //JSON Valuue
                
            }
            
        }
        catch{
            
            print(error)
        }
        
    }


    @IBAction func backact(_ sender: Any) {
        let mainVC = self.storyboard!.instantiateViewController(withIdentifier: "mainMap") as! ARMainMapVC
        self.present(mainVC, animated: true)
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return usernameArray.count == 0 ? 0 : usernameArray.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 86
        
            }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       
            let cell:referralcell = tableView.dequeueReusableCell(withIdentifier: "referralcell") as! referralcell!
        
        
                let username = usernameArray.object(at: indexPath.row) as? String
                
                let userlastname = userlastnameArray.object(at: indexPath.row) as? String
                
                var userImage = userImageArray.object(at: indexPath.row) as? String
                
                let usercategory = usercategoryArray.object(at: indexPath.row) as? String
                
                let usertype = usertypeArray.object(at: indexPath.row) as? String
                
        
        
                if username == nil{
                    
                    cell.referralusername.text = "unknown"
                }
                else{
                    
                    cell.referralusername.text = "\(username!)"
                    
                }
                
                if userlastname == nil {
                    
                    print("null time")
                }
                else{
                    
                    //cell.userlastname.text = "\(userlastname!)"
                    
                }
                if usercategory == nil || usercategory == ""{
                    
                   // cell.usercategory.text = "unknow category"
                }
                else{
                    
                    //cell.usercategory.text = usercategory!
                }
        
                if usertype == nil{
                    
                    cell.usertype.text = ""
                }
                else{
                   
                    cell.usertype.text = usertype!
                }
                
                if userImage == nil{
                    
                    cell.referralimage.image = UIImage(named : "UserPic_old.png")
                }
                else if userImage == ""{
                    
                    cell.referralimage.image = UIImage(named : "UserPic_old.png")
                }
                else{
                    
                    cell.referralimage.sd_setImage(with: NSURL(string: (userImage! as String)) as URL!)
                    
                }
         
            return cell
    
            
        
    }
    

   
}
