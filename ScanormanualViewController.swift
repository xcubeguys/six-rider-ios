//
//  ScanormanualViewController.swift
//  SIX Rider
//
//  Created by apple on 18/03/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit
import Stripe
import SVProgressHUD
import Alamofire


class ScanormanualViewController: UIViewController, STPPaymentCardTextFieldDelegate, CardIOPaymentViewControllerDelegate {

    var paymentTextField: STPPaymentCardTextField!
    
    @IBOutlet weak var activityview: UIView!
    @IBOutlet weak var activityspin: UIActivityIndicatorView!
    typealias jsonSTD = NSArray
    
    typealias jsonSTDAny = [String : AnyObject]
    
    var cardnumber:String = ""
    var viewAPIUrl = "\(live_rider_url)updateStripeToken/userid/"
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

       self.activityview.isHidden = true
        
       /* let frame1 = CGRect(x: 20, y: 150, width: self.view.frame.size.width - 40, height: 40)
        /*paymentTextField = STPPaymentCardTextField(frame: frame1)
         paymentTextField.center = view.center
         paymentTextField.delegate = self
         view.addSubview(paymentTextField)*/
        //disable payButton if there is no card information
        //paybtn.isEnabled = false
        navigationController!.navigationBar.barStyle = .black
        navigationController!.isNavigationBarHidden = false
        
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "arrow-left.png")!, for: .normal)
        button.addTarget(self, action: #selector(ScanormanualViewController.profileBtn(_:)), for: .touchUpInside)
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
        self.navigationItem.leftBarButtonItem = barButton*/
        // Do any additional setup after loading the view.
        CardIOUtilities.preload()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //super.viewWillAppear(animated)
       
        
        CardIOUtilities.preload()
    }
    
    func profileBtn(_ Selector: AnyObject) {
        
     //   self.navigationController?.popViewController(animated: true)
        
    }
   
    @IBAction func cardio(_ sender: Any) {
        //self.navigationController?.pushViewController(ScancardioViewController(), animated: true)
        let cardIOVC = CardIOPaymentViewController(paymentDelegate: self)
        cardIOVC?.modalPresentationStyle = .formSheet
        present(cardIOVC!, animated: true, completion: nil)
    }
   
    
    @IBAction func stripeact(_ sender: Any) {
        self.navigationController?.pushViewController(ARStripeVC(), animated: true)
    }
   
    
    //MARK: - CardIO Methods
    
    //Allow user to cancel card scanning
    func userDidCancel(_ paymentViewController: CardIOPaymentViewController!) {
        print("user canceled")
        paymentViewController?.dismiss(animated: true, completion: nil)
    }
    
    //Callback when card is scanned correctly
    func userDidProvide(_ cardInfo: CardIOCreditCardInfo!, in paymentViewController: CardIOPaymentViewController!) {
        
        if let info = cardInfo {
            let str = NSString(format: "Received card info.\n Number: %@\n expiry: %02lu/%lu\n cvv: %@.", info.redactedCardNumber, info.expiryMonth, info.expiryYear, info.cvv)
            print("mouni\(str)")
            
            //dismiss scanning controller
            paymentViewController?.dismiss(animated: true, completion: nil)
            
            //create Stripe card
           let card: STPCardParams = STPCardParams()
            card.number = info.cardNumber
            card.expMonth = info.expiryMonth
            card.expYear = info.expiryYear
            card.cvc = info.cvv
            
            //Send to Stripe
            getStripeToken(card)
            print(card.number)
            
            self.cardnumber = card.number!
            
            self.activityview.isHidden = false
            self.activityspin.startAnimating()
            
        }
    }
    
    
    func getStripeToken(_ card:STPCardParams) {
        // get stripe token for current card
        STPAPIClient.shared().createToken(withCard: card) { token, error in
            if let token = token {
                print(token)
              //  SVProgressHUD.showSuccess(withStatus: "Stripe token successfully received: \(token)")
                
                let card = self.cardnumber
                
                print("card \(self.cardnumber)")
                
                
                    let value = self.cardnumber
                    
                    print("card \(value)")
                    print("\(self.viewAPIUrl)\(self.appDelegate.userid!)/token/\(token)/card_number/\(value)")
                    
                    var urlstring:String = "\(self.viewAPIUrl)\(self.appDelegate.userid!)/token/\(token)/card_number/\(value)"
                    
                    urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
                    
                    urlstring = urlstring.removingPercentEncoding!
                    
                    print("view profile\(urlstring)")
                    
                    self.callviewAPI(url: "\(urlstring)")
                    
                self.postStripeToken(token)
            } else {
                print(error)
                // SVProgressHUD.showError(errorwithStatus: ?.localizedDescription)
            }
        }
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
                    
                    self.activityview.isHidden = true
                    self.activityspin.stopAnimating()
                    
                    let alertController = UIAlertController(title: "", message: "Card Added Successfully", preferredStyle: .alert)
                    
                   
                    
                    // Create the actions
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                        UIAlertAction in
                        NSLog("OK Pressed")
                        
                        //           self.navigationController?.popViewController(animated: true)
                        
                        //       self.appDelegate.leftMenu()
                        
                        self.navigationController?.popToRootViewController(animated: true)
                        
                    }
                    let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
                        UIAlertAction in
                        NSLog("Cancel Pressed")
                    }
                    
                    // Add the actions
                    alertController.addAction(okAction)
                    //   alertController.addAction(cancelAction)
                    
                    // Present the controller
                    self.present(alertController, animated: true, completion: nil)
                    
                    //    self.dismiss(animated: true, completion: nil)
                    
                }
                else{
                    self.activityview.isHidden = true
                    self.activityspin.stopAnimating()
                    
                    let alertController = UIAlertController(title: "", message: "Sorry! Something went wrong, Can't add your card details", preferredStyle: .alert)
                    
                    // Create the actions
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                        UIAlertAction in
                        NSLog("OK Pressed")
                        
                        //           self.navigationController?.popViewController(animated: true)
                        
                        //       self.appDelegate.leftMenu()
                        
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                    alertController.addAction(okAction)
                    //   alertController.addAction(cancelAction)
                    
                    // Present the controller
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
        catch{
            
            print(error)
            
            //  self.activityView.stopAnimating()
            
        }
        
    }
    
    // charge money from backend
    func postStripeToken(_ token: STPToken) {
        //Set up these params as your backend require
        let params: [String: NSObject] = ["stripeToken": token.tokenId as NSObject, "amount": 10 as NSObject]
        
        //TODO: Send params to your backend to process payment
        
    }
    
    func paymentCardTextFieldDidChange(textField: STPPaymentCardTextField) {
        if textField.valid{
           // paybtn.isEnabled = true
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
