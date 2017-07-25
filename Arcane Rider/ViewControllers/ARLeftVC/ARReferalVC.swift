//
//  ARReferalVC.swift
//  SIX Rider
//
//  Created by Apple on 08/03/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit
import Alamofire

class ARReferalVC: UIViewController,UIScrollViewDelegate{
    
    
let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var totalcount: UILabel!
    
    @IBOutlet weak var dailycount: UILabel!
  
    @IBOutlet weak var weeklycount: UILabel!
    
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var monthlycount: UILabel!
    
    @IBOutlet weak var yearlycount: UILabel!
    
    @IBOutlet weak var usersusedcount: UILabel!
    
    var viewAPIUrl = live_rider_url
    
    typealias jsonSTD = NSArray
    
    typealias jsonSTDImage = NSDictionary
    
    typealias jsonSTDAny = [String : AnyObject]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollview.delegate = self
        navigationController!.isNavigationBarHidden = false
        
        navigationController!.navigationBar.barStyle = .black
        
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "arrow-left.png")!, for: .normal)
        button.addTarget(self, action: #selector(ARReferalVC.profileBtn(_:)), for: .touchUpInside)
        //CGRectMake(0, 0, 53, 31)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        //(frame: CGRectMake(3, 5, 50, 20))
        let label = UILabel(frame: CGRect(x: 40, y: 5, width: 160, height: 20))
        // label.font = UIFont(name: "Arial-BoldMT", size: 13)
        label.text = "Referral Earning"
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.clear
        button.addSubview(label)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = barButton
        
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        if screenHeight == 568{
            self.scrollview.contentSize = CGSize(width: 320, height: self.view.frame.height)
        }
        
        self.Referralearning()
        // Do any additional setup after loading the view.
        
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.x>0 {
            scrollView.contentOffset.x = 0
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func profileBtn(_ Selector: AnyObject) {
        
        appDelegate.leftMenu()
        
    }

    func Referralearning()
    {
        
        print(self.appDelegate.userid)
        
        //http://demo.cogzideltemplates.com/tommy/rider/refrel_detail/user_id/58b69164da71b494448b4567
        
        var urlstring:NSString = "\(live_rider_url)refrel_detail/user_id/\(self.appDelegate.userid)" as NSString
        
        
        
        print(urlstring)
        
        
        
        urlstring = urlstring.replacingOccurrences(of: "Optional", with: "") as NSString
        
        urlstring = urlstring.replacingOccurrences(of: "(", with: "") as NSString
        
        urlstring = urlstring.replacingOccurrences(of: ")", with: "") as NSString
         urlstring = urlstring.replacingOccurrences(of: "\"", with: "") as NSString
       
        
        urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)! as NSString
        
        
        
        urlstring = urlstring.removingPercentEncoding! as NSString
        
        
        
        //   urlstring = UTF8.decode(urlstring)
        
        print(urlstring)
        
        
        
        self.callTotalReferral(url: "\(urlstring)")
        

    }
    func callTotalReferral(url : String){
        
        
        Alamofire.request(url).responseJSON { (response) in
            
            
            
            self.parseData(JSONData: response.data!)
            
            
            
        }
        
        
        
    }
    
    func parseData(JSONData : Data){
        
        
        
        do{
            
            
            
            let readableJSon = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as! jsonSTD
            
            
            
            print(" !!! \(readableJSon[0])")
            
            
            
            let value = readableJSon[0] as AnyObject
            
            
            
            
            for dataDict : Any in readableJSon
                
            {
                
                
                let status1: NSString? = (dataDict as AnyObject).object(forKey: "status") as? NSString
                
                if(status1 == "Success"){
                    
                    
                   let referd_users: NSString? = (dataDict as AnyObject).object(forKey: "referd_users") as? NSString
                    
                    let referd_amount: NSString? = (dataDict as AnyObject).object(forKey: "referd_amount") as? NSString
                    
                    let referd_amount_date: NSString? = (dataDict as AnyObject).object(forKey: "referd_amount_date") as? NSString
                    
                    let referd_amount_week: NSString? = (dataDict as AnyObject).object(forKey: "referd_amount_week") as? NSString
                    
                    let referd_amount_month: NSString? = (dataDict as AnyObject).object(forKey: "referd_amount_month") as? NSString
                    
                    let referd_amount_year: NSString? = (dataDict as AnyObject).object(forKey: "referd_amount_year") as? NSString
                    
                    if (referd_users != "" || referd_users != nil)
                    {
                        self.usersusedcount.text = "\(referd_users!)" as String?
                    }
                    else{
                        
                    }
                    
                    if (referd_amount != "" || referd_amount != nil)
                    {
                        self.totalcount.text = "$\(referd_amount!)" as String?

                    }
                    else{
                        
                    }
                    
                    if (referd_amount_date != "" || referd_amount_date != nil)
                    {
                        self.dailycount.text = "$\(referd_amount_date!)" as String?
                    }
                    else{
                        
                    }
                    
                    if (referd_amount_week != "" || referd_amount_week != nil)
                    {
                        self.weeklycount.text = "$\(referd_amount_week!)" as String?
                    }
                    else{
                        
                    }
                    
                    if (referd_amount_month != "" || referd_amount_month != nil)
                    {
                         self.monthlycount.text = "$\(referd_amount_month!)" as String?
                    }
                    else{
                        
                    }
                    
                    if (referd_amount_year != "" || referd_amount_year != nil)
                    {
                        self.yearlycount.text = "$\(referd_amount_year!)" as String?
                    }
                    else{
                        
                    }
                    
                }
                else{
                    
                }
                
                //JSON Valuue
                
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
