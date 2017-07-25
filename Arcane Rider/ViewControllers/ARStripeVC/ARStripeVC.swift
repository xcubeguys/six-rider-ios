//
//  ARStripeVC.swift
//  Arcane Rider
//
//  Created by Apple on 21/12/16.
//  Copyright © 2016 Apple. All rights reserved.
//

import UIKit
import Stripe
import CreditCardForm
import Alamofire


class ARStripeVC: UIViewController,STPPaymentCardTextFieldDelegate {

    //
    
    @IBOutlet weak var creditCardView: CreditCardFormView!
    
    var paymentTextField = STPPaymentCardTextField()
    
  //  var paymentTextField1: STPPaymentCardTextField! = nil
    
  //  var submitButton: UIButton! = nil

    @IBOutlet weak var submitButton: UIButton!

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var activityView: UIActivityIndicatorView!

    @IBOutlet weak var labelNotValid: UILabel!

    var viewAPIUrl = "\(live_rider_url)updateStripeToken/userid/"
    
    typealias jsonSTD = NSArray
    
    typealias jsonSTDAny = [String : AnyObject]

    var cardNumber : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        paymentTextField = STPPaymentCardTextField(frame: CGRect(x: 15, y: 30, width: view.frame.width - 30, height: 44))
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ARStripeVC.dismissKeyboard))
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
        
        navigationController!.navigationBar.barStyle = .black
        
        navigationController!.isNavigationBarHidden = false
        
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "arrow-left.png")!, for: .normal)
        button.addTarget(self, action: #selector(ARStripeVC.profileBtn(_:)), for: .touchUpInside)
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
        
        let value = UserDefaults.standard.object(forKey: "userName")
        if value != nil{
            
            var final = value as! String!
            final = final?.replacingOccurrences(of: "Optional(", with: "")
            final = final?.replacingOccurrences(of: ")", with: "")
            final = final?.replacingOccurrences(of: "\"", with: "")
            creditCardView.cardHolderString = final as String!
        }
        else{
            
            
            
        }
        submitButton.isEnabled = true
        self.submitButton.isHidden = true
        createTextField()
        
    }
    func dismissKeyboard() {
        view.endEditing(true)
    }
    override func viewWillAppear(_ animated: Bool) {
        
        UIApplication.shared.isIdleTimerDisabled = false
        
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
        navigationController!.navigationBar.barStyle = .black
        
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

    func profileBtn(_ Selector: AnyObject) {
        
        self.navigationController?.popViewController(animated: true)
        
    }

    func createTextField() {
        
        paymentTextField.frame = CGRect(x: 15, y: 199, width: self.view.frame.size.width - 30, height: 44)
        paymentTextField.delegate = self
        paymentTextField.translatesAutoresizingMaskIntoConstraints = false
        paymentTextField.borderWidth = 0
        
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.darkGray.cgColor
        border.frame = CGRect(x: 10, y: paymentTextField.frame.size.height - width, width:  paymentTextField.frame.size.width, height: paymentTextField.frame.size.height)
        border.borderWidth = width
        paymentTextField.layer.addSublayer(border)
        paymentTextField.layer.masksToBounds = true
        
        view.addSubview(paymentTextField)
        
        NSLayoutConstraint.activate([
//            paymentTextField.topAnchor.constraint(equalTo: creditCardView.bottomAnchor, constant: 20),
//            paymentTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            paymentTextField.widthAnchor.constraint(equalToConstant: self.view.frame.size.width-20),
//            paymentTextField.heightAnchor.constraint(equalToConstant: 44)
            ])
    }

    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
        
        creditCardView.paymentCardTextFieldDidChange(cardNumber: textField.cardNumber, expirationYear: textField.expirationYear, expirationMonth: textField.expirationYear, cvc: textField.cvc)
        
       // submitButton.isEnabled = textField.valid    //raj
        
        self.submitButton.isHidden = false
        
        labelNotValid.isHidden = true


    }
    
    func paymentCardTextFieldDidEndEditingExpiration(_ textField: STPPaymentCardTextField) {
        creditCardView.paymentCardTextFieldDidEndEditingExpiration(expirationYear: textField.expirationYear)
    }
    
    func paymentCardTextFieldDidBeginEditingCVC(_ textField: STPPaymentCardTextField) {
        creditCardView.paymentCardTextFieldDidBeginEditingCVC()
    }
    
    func paymentCardTextFieldDidEndEditingCVC(_ textField: STPPaymentCardTextField) {
        creditCardView.paymentCardTextFieldDidEndEditingCVC()
    }
    
    @IBAction func submitBTN(_ sender: Any) {
        
        // If you have your own form for getting credit card information, you can construct
        // your own STPCardParams from number, month, year, and CVV.
        
        if paymentTextField.isValid{
            print("\(self.appDelegate.stripepaymentstatus)")
            labelNotValid.isHidden = true
            if (self.appDelegate.stripepaymentstatus == "1")
            {
            addmoney()
            self.appDelegate.stripepaymentstatus = "0"
            }
            else{
               validCardAPI()
            }
            
            
        }
        else{
            
            labelNotValid.isHidden = false
            
        }
        
        
    }
    func addmoney(){
        
        let card = paymentTextField.card!
        
        print("card \(paymentTextField.card!)")
        
        STPAPIClient.shared().createToken(withCard: card) { token, error in
            guard let stripeToken = token else {
                NSLog("Error creating token: %@", error!.localizedDescription);
                return
            }
            
            // TODO: send the token to your server so it can create a charge
            /*    let alert = UIAlertController(title: "Welcome to Stripe", message: "Token created: \(stripeToken)", preferredStyle: .alert)
             alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
             self.present(alert, animated: true, completion: nil)*/
            
            let value = self.paymentTextField.cardNumber
            
            print("card \(value)")
            
            
           // http://demo.cogzideltemplates.com/tommy/rider/updateWalletAmount/payid/cus_A7POlqlkjPz9YV/user_id/58a43f62da71b481508b4567/payment_amount/100
            
            print("self.appDelegate.addmoneyvalue~~\(self.appDelegate.addmoneyvalue)")
            var urlstring:String = "\(live_rider_url)updateWalletAmount/user_id/\(self.appDelegate.userid!)/payid/\(stripeToken)/payment_amount/\(self.appDelegate.addmoneyvalue!)"
            
            
            urlstring=(urlstring.replacingOccurrences(of: "Optional", with: "") as String as NSString!) as String
            
            urlstring=(urlstring.replacingOccurrences(of: "(", with: "") as String as NSString!) as String
            
            urlstring=(urlstring.replacingOccurrences(of: ")", with: "") as String as NSString!) as String
            

            
            urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
            
            urlstring = urlstring.removingPercentEncoding!
            
            print("view wallet\(urlstring)")
            
            self.calladdmoneyAPI(url: "\(urlstring)")
            
            
        }
        
    }
    func calladdmoneyAPI(url : String){
        
        self.activityView.startAnimating()
        
        Alamofire.request(url).responseJSON { (response) in
            
            self.parseData1(JSONData: response.data!)
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
                    self.activityView.stopAnimating()
                    
                    
                    /*  let alert = UIAlertController(title: "", message: "Payment Completed Successfully", preferredStyle: .alert)
                     alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                     self.present(alert, animated: true, completion: nil)*/
                    
                    
                    let alertController = UIAlertController(title: "", message: "Money Added Successfully", preferredStyle: .alert)
                    
                    // Create the actions
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                        UIAlertAction in
                        NSLog("OK Pressed")
                        
                        //           self.navigationController?.popViewController(animated: true)
                        
                        //       self.appDelegate.leftMenu()
                        self.appDelegate.walletstatus = 1
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
                    

                    
                }
                else{
                    self.activityView.stopAnimating()
                    
                  
                    
                    let alertController = UIAlertController(title: "", message: "Sorry! Something went wrong", preferredStyle: .alert)
                    
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
            else{
                
            }
        }
        catch{
            print(error)
        }
    }

    
    func validCardAPI(){
        
        
        
        let card = paymentTextField.card!
        
        print("card \(paymentTextField.card!)")
        
        STPAPIClient.shared().createToken(withCard: card) { token, error in
            guard let stripeToken = token else {
                NSLog("Error creating token: %@", error!.localizedDescription);
                return
            }
            
            // TODO: send the token to your server so it can create a charge
            /*    let alert = UIAlertController(title: "Welcome to Stripe", message: "Token created: \(stripeToken)", preferredStyle: .alert)
             alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
             self.present(alert, animated: true, completion: nil)*/
            
            let value = self.paymentTextField.cardNumber
            
            print("card \(value)")
            print("\(self.viewAPIUrl)\(self.appDelegate.userid!)/token/\(stripeToken)/card_number/\(value!)")
            
            var urlstring:String = "\(self.viewAPIUrl)\(self.appDelegate.userid!)/token/\(stripeToken)/card_number/\(value!)"
            
            urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
            
            urlstring = urlstring.removingPercentEncoding!
            
            print("view profile\(urlstring)")
            
            self.callviewAPI(url: "\(urlstring)")
            
    
        }

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
                    
          
                    
                    self.activityView.stopAnimating()
                    
                    
                  /*  let alert = UIAlertController(title: "", message: "Payment Completed Successfully", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)*/
                    
                    
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
                    
                    self.activityView.stopAnimating()
                    
                }
            }
        }
        catch{
            
            print(error)
            
          //  self.activityView.stopAnimating()
            
        }
        
    }
}
