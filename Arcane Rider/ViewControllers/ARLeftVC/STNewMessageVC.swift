//
//  STNewMessageVC.swift
//  SendTxT
//
//  Created by Apple on 22/10/16.
//  Copyright © 2016 Apple. All rights reserved.
//

import UIKit

class STNewMessageVC: UIViewController,UITextViewDelegate {
    
    
    @IBOutlet weak var messageField: UITextView!
    var keyboardheight:CGFloat=0.0
    let screenSize: CGRect = UIScreen.main.bounds
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var searchTextView: UITextView!
    @IBOutlet weak var contactnamelabel: UILabel!
    @IBOutlet var contactnumberLabel: UILabel!
    var gety = 0
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let manager : AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
    var url = demo_url
    var user_id:NSString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = "New Message"
        messageField.delegate = self
        searchTextView.delegate = self
        
        
        
        navigationController!.isNavigationBarHidden = false
        
        let btnName: UIButton = UIButton()
        btnName.setImage(UIImage(named: "backaarow"), for: UIControlState())
        btnName.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btnName.addTarget(self, action: #selector(STNewMessageVC.backToHome(_:)), for: .touchUpInside)
        
        let leftBarButton:UIBarButtonItem = UIBarButtonItem()
        leftBarButton.customView = btnName
        self.navigationItem.leftBarButtonItem = leftBarButton
        
        // Keyboard
      //  self.searchTextView.text = "\(self.appDelegate.mobilenumber!)"
        self.contactnumberLabel.text = "\(self.appDelegate.mobilenumber!)"
        self.contactnamelabel.text = "\(self.appDelegate.name!)"
//        self.appDelegate.mobilenumber
//        self.appDelegate.name
        
        NotificationCenter.default.addObserver(self, selector: #selector(STNewMessageVC.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(STNewMessageVC.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let tap:UITapGestureRecognizer=UITapGestureRecognizer(target: self, action: #selector(STNewMessageVC.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: UIBarButtonItemStyle.plain, target: nil, action: nil)

        

    }
    
    public override func viewDidLayoutSubviews() {
        
        messageField.layer.cornerRadius = 5;
        messageField.clipsToBounds = true;
 
        
    }
    
    func webservice(){
        
        //http://demo.cogzidel.com/chitchathelm/message/sendMessage/sender/0280498204/receiver/23994729374/message/hai%20this%20is%20pooja/is_group/0/group_id/0
        if let value : String =  UserDefaults.standard.object(forKey: "userid") as! String!{
            user_id = value as NSString
            print("\(url)message/sendMessage/sender/\(self.appDelegate.ownMobile)/receiver/\(self.appDelegate.mobilenumber)/message/\(messageField.text)/is_group/0/group_id/0")
            

            var urlstring:NSString! = "\(url)message/sendMessage/sender/\(self.appDelegate.ownMobile!)/receiver/\(self.appDelegate.mobilenumber!)/message/\(messageField.text!)/is_group/0/group_id/0"  as NSString!
            
            urlstring = urlstring.addingPercentEscapes(using: String.Encoding.utf8.rawValue)! as NSString!
            print("\(urlstring!)")
            manager.get("\(urlstring)",
                parameters: nil,
                success: { (operation: AFHTTPRequestOperation?,responseObject: Any?) in
                    if let jsonObjects=responseObject as? NSArray {
                        for dataDict : Any in jsonObjects {
                            let status: String? = (dataDict as AnyObject).object(forKey: "status") as? String
                            print("object: %@", status)
                            let tmp: String? = "Success"
                            if(status == tmp)
                            {
                                
//  self.navigationController?.pushViewController(STChatVC(), animated: true)
                                self.navigationController?.pushViewController(STChatVC(), animated: true)
                                self.appDelegate.receivername = "\(self.appDelegate.name!)"

                            }
                            
                        }
                    }
                },
                failure: { (operation: AFHTTPRequestOperation?,error: Error?) in
            })
        }
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
    func backToHome(_ Selector: AnyObject) {
        
     //  self.navigationController?.pushViewController(FCFakeCallerIdVC(), animated: true)
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn shouldChangeTextInRange: NSRange, replacementText: String) -> Bool {
        
        
        if(replacementText.isEqual("\n")) {
            textView.resignFirstResponder()
            return false
       
        }
        return true
    }
    
    
    @IBAction func sendMessage(_ sender: AnyObject) {
         self.messageView.frame = CGRect(x: 0,  y: messageView.superview!.frame.size.height - 65 , width: screenSize.width, height: 68);
        messageField.resignFirstResponder()
        if(self.appDelegate.mobilenumber == ""){
            
        }
        else if(self.appDelegate.ownMobile == ""){
            
        }
        else if(self.messageField.text! == ""){
            
        }
        else{
            self.webservice()

        }
        
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
      //  myTextView.text = ""
        print("textViewDidBeginEditing")
        if(textView == messageField)
        {
            NotificationCenter.default.addObserver(self, selector: #selector(STNewMessageVC.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
       animateViewMoving(up: true, moveValue: 50)
        }
            }
    
    func keyboardWillShow(notification:NSNotification) {
        
        animateViewMoving(up: true, moveValue: 0)
        print("keyboardWillShow")
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        keyboardheight = keyboardRectangle.height
        print("keyboardheight\(keyboardheight)")
        self.messageView.frame = CGRect(x: 0, y: screenSize.height , width: screenSize.width, height: 68)
       // print("messageField Y \(height)")
        
    }

    func animateViewMoving (up:Bool, moveValue :CGFloat){
      print("animateViewMoving")
        if((screenSize.width == 375) && (screenSize.height == 667)) {
            
            let movementDuration:TimeInterval = 1.15
            var movement:CGFloat = ( up ? -moveValue : moveValue)
            UIView.beginAnimations( "animateView", context: nil)            
            UIView.setAnimationBeginsFromCurrentState(true)
            UIView.setAnimationDuration(movementDuration )
            let height = Int(screenSize.height) - gety
            self.messageView.frame = CGRect(x: 0, y: 340, width: screenSize.width, height: 68)
            print("messageField Y \(height)")
            UIView.commitAnimations()
        }
    }
    
    func dismissKeyboard()
    {
        
        messageField.resignFirstResponder()
        searchTextView.resignFirstResponder()
       
        self.messageView.frame = CGRect(x: 0,  y: messageView.superview!.frame.size.height - 65 , width: screenSize.width, height: 68);
       
    }

}
