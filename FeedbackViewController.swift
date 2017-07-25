//
//  FeedbackViewController.swift
//  SIX Rider
//
//  Created by Apple on 15/05/17.
//  Copyright © 2017 Apple. All rights reserved.
//


import UIKit
import SwiftMessages
import Alamofire

class FeedbackViewController: UIViewController,UITextViewDelegate{
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    typealias jsonSTD = NSArray
    var urlString : String!
    var subjecturl : String!
    let screenSize = UIScreen.main.bounds
  
    @IBOutlet var Dropdownbtn: UIButton!
    @IBOutlet var Dropdown: EDropdownList!
    @IBOutlet var subjectview: UIView!
    @IBOutlet weak var staticTextViewLabel: UITextView!
    @IBOutlet weak var messageBody: UITextView!
    
    @IBOutlet weak var sendUsSomeFeedbackLabel: UILabel!
    @IBOutlet weak var submitBtnLabel: UIButton!
    var feedbackContent = ""
    var subjectArray:NSMutableArray = NSMutableArray()
    let driverDropDown = DropDown()
    var subjecttile = ""
    lazy var dropDowns: [DropDown] = {
        return [
            self.driverDropDown
        ]
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
       

        if screenHeight == 568{
            self.staticTextViewLabel.text = "Found a bug? Have a suggestion? Fill out the form below and we will take a look"
            self.staticTextViewLabel.frame = CGRect(x: 10, y: 50, width: 300, height: 80)
            self.messageBody.frame = CGRect(x: 16, y: 177, width: 285, height: 201)
            self.submitBtnLabel.frame = CGRect(x: 16, y: 390, width: 285, height: 47)
            self.sendUsSomeFeedbackLabel.frame = CGRect(x: 13, y: 13, width: 203, height: 33)
            
        }
        if screenHeight == 667 {
            self.staticTextViewLabel.text = "Found a bug? Have a suggestion? Fill out the form below and we will take a look"
        }
        if screenHeight == 736{
            
            self.staticTextViewLabel.text = "Found a bug? Have a suggestion? Fill out the form below and we will take a look"
            self.staticTextViewLabel.frame = CGRect(x: 10, y: 50, width: 382, height: 80)
            self.messageBody.frame = CGRect(x: 16, y: 177, width: 382, height: 201)
            self.submitBtnLabel.frame = CGRect(x: 16, y: 390, width: 382, height: 47)
        }
        navigationController!.isNavigationBarHidden = false
        
        navigationController!.navigationBar.barStyle = .black
        
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "arrow-left.png")!, for: .normal)
        button.addTarget(self, action: #selector(FeedbackViewController.backBtn(_:)), for: .touchUpInside)
        //CGRectMake(0, 0, 53, 31)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        //(frame: CGRectMake(3, 5, 50, 20))
        let label = UILabel(frame: CGRect(x: 20, y: 5, width: 100, height: 20))
        // label.font = UIFont(name: "Arial-BoldMT", size: 13)
        label.text = "Feedback"
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.clear
        button.addSubview(label)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = barButton
        // Do any additional setup after loading the view.r
        self.messageBody.text = "Write your Feedback Here...!"
        messageBody.textColor = UIColor.lightGray
        messageBody.delegate = self
        messageBody.layer.borderWidth = 1
        messageBody.layer.borderColor = UIColor.black.cgColor
        messageBody.layer.cornerRadius = 5
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(FeedbackViewController.hidekeyboard))
        subjectview.layer.borderWidth = 1
        Dropdown.layer.borderWidth = 1
        tapGesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGesture)
        let Title = "Select Title"
         self.Dropdownbtn.setTitle(Title, for: .normal)
         self.getsubject()
       
    }
    func getsubject()
    {
        urlString = "\(live_request_url)home/getsubject"
        urlString = urlString.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        print("FeedBack subject:\(urlString)")
        self.callsubject(url: "\(urlString!)")
    }
    func setupAmountDropDown1() {
        driverDropDown.anchorView = Dropdownbtn
        driverDropDown.bottomOffset = CGPoint(x: 0, y: Dropdownbtn.bounds.height)
        driverDropDown.dataSource = subjectArray as! [String]
        // Action triggered on selection
        let subcontent = driverDropDown.selectionAction = { [unowned self] (index, item) in
            self.Dropdownbtn.setTitle(item, for: .normal)
        }
         print("subcontent\(subcontent)")
    }


    func hidekeyboard()
    {
        self.view.endEditing(true)
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if messageBody.textColor == UIColor.lightGray {
            messageBody.text = nil
            messageBody.textColor = UIColor.black
            
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if messageBody.text.isEmpty {
            messageBody.text = "Write your Feedback Here...!"
            messageBody.textColor = UIColor.lightGray
        }
        
    }
    @IBAction func backBtn(_ sender: Any) {
        appDelegate.leftMenu()
    }
    
    @IBAction func Dropdownbtn(_ sender: Any) {
        driverDropDown.show()
    }
    
    
    
    
    @IBAction func submitButton(_ sender: Any) {
        
        feedbackContent = self.messageBody.text
        //subject = self.Dropdown
        
        print("FeedbackContent:\(feedbackContent)")
    
        
        if self.Dropdownbtn.currentTitle! != nil {
              subjecttile = self.Dropdownbtn.currentTitle!
              print("subjecttile\(subjecttile)")
            let Title = "Select Title"
            self.Dropdownbtn.setTitle(Title, for: .normal)
             //subjectupload()
        }else{
            let warning = MessageView.viewFromNib(layout: .CardView)
            warning.configureTheme(.info)
            warning.configureDropShadow()
            let iconText = "" //"🤔"
            warning.configureContent(title: "", body: "Please Choose Title for development", iconText: iconText)
            warning.button?.isHidden = true
            var warningConfig = SwiftMessages.defaultConfig
            warningConfig.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
            SwiftMessages.show(config: warningConfig, view: warning)

        }
        
      
        
        // let submitClick = 1
        
        

        dataUpload()
        
    }
    func dataUpload(){
        
        if self.feedbackContent != "" {
            
            
            urlString = "\(live_rider_url)feedback?user_id=\(self.appDelegate.userid!)&feedback=\(feedbackContent)&subject=\(subjecttile)"
            urlString = urlString.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
            print("FeedBack Upload:\(urlString)")
            self.calleditAPI(url: "\(urlString!)")
            // urlString = urlString.removingPercentEncoding!
        }
        else{
            print("Feedback Content is NIL")
            message()
        }
        
        
    }
    func subjectupload() {
        
        
        if (subjecttile == "Select Title"){
            let warning = MessageView.viewFromNib(layout: .CardView)
            warning.configureTheme(.info)
            warning.configureDropShadow()
            let iconText = "" //"🤔"
            warning.configureContent(title: "", body: "Please Choose Title for development", iconText: iconText)
            warning.button?.isHidden = true
            var warningConfig = SwiftMessages.defaultConfig
            warningConfig.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
            SwiftMessages.show(config: warningConfig, view: warning)
            
        }else{
            subjecturl = "\(live_rider_url)feedback?user_id=\(self.appDelegate.userid!)&feedback=\(subjecttile)"
            subjecturl = subjecturl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            print("subjecturl\(subjecturl)")
            self.callsubject(url: "\(subjecturl)")
            
        }
    }

    
    func calleditAPI(url : String){
        
        print("URL:\(url)")
        Alamofire.request(url).responseJSON { (response) in
            
            self.parseData1(JSONData: response.data!)
        }
        
    }
    func callsubject(url : String){
        
        print("URL:\(url)")
        Alamofire.request(url).responseJSON { (response) in
            
            self.parseData2(JSONData: response.data!)
        }
        
    }
    
    func parseData2(JSONData : Data){
        
        do{
            
            let readableJSon = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as! jsonSTD
            
            print(" !!! \(readableJSon[0])")
            
            let value = readableJSon[0] as AnyObject
            
            for dataDict : Any in readableJSon
                
            {
                
                
                let status1: NSString? = (dataDict as AnyObject).object(forKey: "status") as? NSString
                
                if(status1 == "Success"){
                    
                    let subject: NSString? = (dataDict as AnyObject).object(forKey: "subject") as? NSString
                    subjectArray.add(subject!)
                    
                }
                
            }
            print(subjectArray)
            self.setupAmountDropDown1()
        }
        catch{
            
            print(error)
            //self.btnSave.isEnabled = true
            
        }
        
    }

    
    func parseData1(JSONData : Data){
        
        do{
            
            let readableJSon = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as! jsonSTD
            
            print(" !!! \(readableJSon[0])")
            
            let value = readableJSon[0] as AnyObject
            
            if let final = value.object(forKey: "status"){
                print(final)
                if(final as! String == "Success"){
                    self.message()
                }
            }
        }
        catch{
            
            print(error)
            //self.btnSave.isEnabled = true
            
        }
    }
    
    
    func message(){
        
        if messageBody.textColor != UIColor.lightGray && messageBody.text != ""{
            let warning = MessageView.viewFromNib(layout: .CardView)
            warning.configureTheme(.success)
            warning.configureDropShadow()
            let iconText = "" //"🤔"
            warning.configureContent(title: "", body: "Thanks for submitting your feedback", iconText: iconText)
            warning.button?.isHidden = true
            var warningConfig = SwiftMessages.defaultConfig
            warningConfig.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
            SwiftMessages.show(config: warningConfig, view: warning)
            messageBody.text = "Write your Feedback Here...!"
            messageBody.textColor = UIColor.lightGray
            messageBody.text.removeAll()
            messageBody.text = "Write your Feedback Here...!"
            messageBody.textColor = UIColor.lightGray
            messageBody.resignFirstResponder()
            //messageBody.isUserInteractionEnabled = false
           // submitBtnLabel.isEnabled = false
            
        }
        else{
            let warning = MessageView.viewFromNib(layout: .CardView)
            warning.configureTheme(.info)
            warning.configureDropShadow()
            let iconText = "" //"🤔"
            warning.configureContent(title: "", body: "Please provide some feedback for development", iconText: iconText)
            warning.button?.isHidden = true
            var warningConfig = SwiftMessages.defaultConfig
            warningConfig.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
            SwiftMessages.show(config: warningConfig, view: warning)
        }
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
