//
//  popupViewController.swift
//  
//
//  Created by Apple on 16/05/17.
//
//

import UIKit
import Alamofire

class popupViewController: UIViewController {

let screenSize: CGRect = UIScreen.main.bounds
    @IBOutlet var wholeView: UIView!
    @IBOutlet weak var crossSymbolImage: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var termsView: UIView!
    @IBOutlet weak var termsLabel: UILabel!
 @IBOutlet weak var termstextView: UITextView!
   @IBOutlet weak var closeLabel: UIButton!
    typealias jsonSTD = NSArray
    override func viewDidLoad() {
        super.viewDidLoad()
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        if screenHeight == 568{
        
            self.termsView.frame = CGRect(x:32,y:80,width:260,height:381)
            self.termsLabel.frame = CGRect(x:23,y:19,width:217,height:21)
            self.closeLabel.frame = CGRect(x:125,y:358,width:13,height:13)
            self.crossSymbolImage.frame = CGRect(x:125,y:358,width:13,height:13)
            self.activityIndicator.frame = CGRect(x:120,y:170,width:20,height:20)
            self.termstextView.frame = CGRect(x:10,y:50,width:240,height:298)
        
        
        }
        self.activityIndicator.startAnimating()
        var urlstring:String = "\(live_request_url)Settings/termsconditions"
        
        //http://54.172.2.238/Settings/termsconditions
        
        urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        
        urlstring = urlstring.removingPercentEncoding!
        
        print(urlstring)
        
        self.callviewAPI(url: "\(urlstring)")

        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        termstextView.layer.cornerRadius = 5
        termsView.layer.cornerRadius = 5
               self.showAnimate()
      
        // Do any additional setup after loading the view.
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
                if(final as! String == "success"){
                    
                    var termsandconditions:String! = value.object(forKey: "value") as? String
                    print("Terms and Conditions:\(termsandconditions!)")
                    
                    
                    if termsandconditions != nil{
                        termsandconditions = termsandconditions?.replacingOccurrences(of: "Optional(", with: "")
                        termsandconditions = termsandconditions?.replacingOccurrences(of: "%40", with: "\n")
                        termsandconditions = termsandconditions?.replacingOccurrences(of: "%20", with: " ")
                        termsandconditions = termsandconditions?.replacingOccurrences(of: "\"", with: "")
                        termsandconditions = termsandconditions?.replacingOccurrences(of: "&amp;", with: "&")
                        termsandconditions = termsandconditions?.replacingOccurrences(of: "&rsquo;", with: "'")
                        termsandconditions = termsandconditions?.removingPercentEncoding!
                        print("Terms and Conditions Edited: \(termsandconditions!)")
                    }

                    else{
                        termsandconditions = ""
                    }
                    
                    
                    termstextView.text = termsandconditions
                    
                    
                    
                }
                    self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                    
              
            }
        }
        catch{
            
            print(error)
            
        }
        
    }
    @IBAction func closeButton(_ sender: Any) {
        
        self.removeAnimate()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
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
