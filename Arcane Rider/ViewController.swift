//
//  ViewController.swift
//  Arcane Rider
//
//  Created by Apple on 16/12/16.
//  Copyright © 2016 Apple. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn
import Alamofire
import Stripe
import Firebase


class ViewController: UIViewController,GIDSignInDelegate,GIDSignInUIDelegate,FBSDKLoginButtonDelegate,STPPaymentCardTextFieldDelegate {
 

    @IBOutlet weak var btnSiginIn: UIButton!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var btnGoogle: UIButton!
    @IBOutlet weak var btnFacebook: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!

    var signIn : GIDSignIn?
    
    var signInAPIUrl = live_rider_url
    
    var url:String = live_url
    
    typealias jsonSTD = NSArray
    
    typealias jsonSTDAny = [String : AnyObject]

    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    var autologin = false

    var paymentTextField: STPPaymentCardTextField! = nil
    var submitButton: UIButton! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       // self.navigationController?.isNavigationBarHidden = true
        
        
        
    /*    paymentTextField = STPPaymentCardTextField(frame: CGRect(x: 15, y: 30, width: view.frame.width - 30, height: 44))
        paymentTextField.delegate = self
        view.addSubview(paymentTextField)
        submitButton = UIButton(type: UIButtonType.system)
        submitButton.frame = CGRect(x: 15, y: 100, width: 100, height: 44)
        submitButton.isEnabled = false
        submitButton.setTitle("Submit", for: UIControlState.normal)
        submitButton.addTarget(self, action: #selector(ViewController.profileBtn(_:)), for: .touchUpInside)
        view.addSubview(submitButton)*/

        
        
        btnSiginIn.layer.borderColor = UIColor(hex: "#6F511F").cgColor
        btnSiginIn.layer.borderWidth = 1.0
        
      //  navigationController?.navigationBar.barStyle = .default

        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default

        self.navigationController?.isNavigationBarHidden = true
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "SIX Rider", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        


    }
    
    func profileBtn(_ Selector: AnyObject) {
        
        // If you have your own form for getting credit card information, you can construct
        // your own STPCardParams from number, month, year, and CVV.
        let card = paymentTextField.card!
        
        STPAPIClient.shared().createToken(withCard: card) { token, error in
            guard let stripeToken = token else {
                NSLog("Error creating token: %@", error!.localizedDescription);
                return
            }
            
            // TODO: send the token to your server so it can create a charge
            let alert = UIAlertController(title: "Welcome to Stripe", message: "Token created: \(stripeToken)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }

    }
    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
        submitButton.isEnabled = textField.valid
    }
    
    @IBAction func submitCard(sender: AnyObject?) {
        
    
    }

    @IBAction func signinBtn(_ sender: Any) {
        
         self.navigationController?.pushViewController(ARSignInVC(), animated: true)
    }

   
  /*  override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .lightContent
    }*/
    
    override func viewWillAppear(_ animated: Bool) {
        
        UIApplication.shared.isIdleTimerDisabled = false
        
        navigationController?.isNavigationBarHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func registerBtnAction(_ sender: Any) {
        self.navigationController?.pushViewController(ARRegisterVC(), animated: true)

    }

    func disabling(){
        
        self.btnGoogle.isEnabled = false
        self.btnFacebook.isEnabled = false
        self.btnSiginIn.isEnabled = false
        self.btnRegister.isEnabled = false
        
        self.spinner.isHidden = false
        self.spinner.startAnimating()
        
    }
    
    func enabling(){
        
        self.btnGoogle.isEnabled = true
        self.btnFacebook.isEnabled = true
        self.btnSiginIn.isEnabled = true
        self.btnRegister.isEnabled = true
        
        self.spinner.isHidden = true
        self.spinner.stopAnimating()
        
    }
    

    @IBAction func facebookAction(_ sender: Any) {
        FBSDKAccessToken.setCurrent(nil)
        
        self.disabling()

        if(FBSDKAccessToken.current() != nil) {
            FBSDKAccessToken.setCurrent(nil)
           // self.returnUserData()
            
        } else {
            FBSDKAccessToken.setCurrent(nil)
            let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
            fbLoginManager.loginBehavior = FBSDKLoginBehavior.web
            
            fbLoginManager.logIn(withReadPermissions: ["public_profile", "email", "user_friends"], from: self, handler:{ (result, error) -> Void in
//            fbLoginManager .logIn(withReadPermissions: ["public_profile", "email", "user_friends"], handler: { (result, error) -> Void in
                print(error)
                if (error != nil){
                    //self.returnUserData()
                    self.enabling()
                }
                else if (result?.isCancelled)! {
                    //handle cancellation
                    self.enabling()

                }
                else
                {
                    let fbloginresult : FBSDKLoginManagerLoginResult = result!
                    if(fbloginresult.grantedPermissions.contains("email"))
                    {
                        self.returnUserData()
                    }
                }
            })
            
            
//            fbLoginManager.logInWithReadPermissions(["email"],fromViewController: self) { (result:FBSDKLoginManagerLoginResult!, fberror) -> Void in
//                
//                print("Facebook login failed. Error \(fberror)")
//            }
        }
    }
    
    
    @IBAction func googleAction(_ sender: Any) {
        
        self.disabling()

        
        signIn = GIDSignIn.sharedInstance()
        signIn?.clientID = "920670843910-btrih14iai7nndf0h6fm7g2o32jl5l68.apps.googleusercontent.com"
        signIn!.shouldFetchBasicProfile=true
        signIn!.delegate=self
        signIn!.uiDelegate=self
        GIDSignIn.sharedInstance().signIn()
        GIDSignIn.sharedInstance().shouldFetchBasicProfile = true

    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,withError error: Error!) {
        if (error == nil) {
            // Perform any operations on signed in user here.
            let gpid = user.userID                  // For client-side use only!
            print("googleid \(gpid)")
            // let idToken = user.authentication.idToken // Safe to send to the server
            let GPName = user.profile.name
            let GPfname = user.profile.givenName
            let GPlname = user.profile.familyName
            let GPemail = user.profile.email
            
            if user.profile.hasImage{
                
                let GPProfilePic = user.profile.imageURL(withDimension: 200)
                
                let value = String(describing: GIDSignIn.sharedInstance().currentUser.profile.imageURL(withDimension: 100))
                
                print("tested ok \(value)")
                
              //  UserDefaults.standard.setValue(value, forKey: "GProfilePic")
                
                print(GPProfilePic!)
                var status_img = "\(GPProfilePic!)"
                status_img = status_img.replacingOccurrences(of: "/", with: "-__-")
                self.appDelegate.GProfileimg = status_img
            }
            else{
                self.appDelegate.GProfileimg = " "
            }
            
            self.appDelegate.GPEmail = GPemail
            self.appDelegate.GPFirstName = GPfname
            self.appDelegate.GPLastName = GPlname
            self.appDelegate.GPID = gpid
            
            print(self.appDelegate.GPEmail)
            print(self.appDelegate.GPFirstName)
            print(self.appDelegate.GPLastName)
            print(self.appDelegate.GPEmail)
            print(self.appDelegate.GPID)
            
            self.loginWithGoogle()
        }

    }
    
    func presentSignInViewController(_ viewController: UIViewController) {
        //googleoutlet.enabled=true
        self.present(viewController, animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user:GIDGoogleUser!,
              withError error: Error!) {
        //googleoutlet.enabled=true
        // Perform any operations when the user disconnects from app here.
        // ...
        self.enabling()

    }
    
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        //googleoutlet.enabled=true
        //  myActivityIndicator.stopAnimating()
        self.enabling()

    }
    
    // Present a view that prompts the user to sign in with Google
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!) {
        // googleoutlet.enabled=true
        self.present(viewController, animated: true, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!,
              dismiss viewController: UIViewController!) {
        
//        googleoutlet.isEnabled=true
//        self.spinner.isHidden=false
//        //self.spinnervi.hidden = false
//        self.spinner.startAnimating()
//        self.disablebutton()
        
        print("call dismiss \(NSStringFromClass(viewController.classForCoder))")
        
        if NSStringFromClass(viewController.classForCoder) == "SFSafariViewController" {
            self.dismiss(animated: true, completion: nil)
        }
        self.enabling()

    }
    
    
    func storeAccessToken(_ accessToken: String!) {
        UserDefaults.standard.set(accessToken, forKey: "SavedAccessHTTPBody")
    }
    
    func loadAccessToken() -> String! {
        return UserDefaults.standard.object(forKey: "SavedAccessHTTPBody") as? String
    }
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        //print("User Logged In")
        if ((error) != nil)
        {
            
        }
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email")
            {
                // Do work
                
            }
        }
    }
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }

    
    func returnUserData(){
        print("login successfull")
        
        var outstatus:NSString = ""
        
        var object = [[String:Any]]()
        
        let requestParameters1 = ["fields": "id, email, first_name, last_name, gender,name"]
        let graphRequest1 : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: requestParameters1)
        graphRequest1.start(completionHandler: { (connection, user, error) -> Void in
            
            let response = user as AnyObject?
            
            let userEmail:String? = response?.object(forKey: "email") as? String
            let firstname:String? = response?.object(forKey: "first_name") as? String
            let lastname:String? = response?.object(forKey: "last_name") as? String
            let facebookid:String? = response?.object(forKey: "id") as? String
            let userName:String? = response?.object(forKey: "name") as? String
            
            print(userEmail!)
            print(firstname!)
            print(lastname!)
            print(facebookid!)
            print(userName!)
            
            let value = "\(firstname) \(lastname)"
            UserDefaults.standard.setValue(value, forKey: "userName")
            
            self.appDelegate.fbEmail = userEmail
            self.appDelegate.fbFirstName = firstname
            self.appDelegate.fbLastName = lastname
            self.appDelegate.fbID = facebookid
            self.appDelegate.userName = userName
            
            self.loginWithFB()
            
            })

    }
    
    
    func loginWithFB(){
        print("Login With facebook")
        
     
        
        var urlstring:String = "\(signInAPIUrl)fbSignup/regid/5764/first_name/\(self.appDelegate.fbFirstName!)/last_name/\(self.appDelegate.fbLastName!)/mobile/null/country_code/+91/city/madurai/email/\(self.appDelegate.fbEmail!)/fb_id/\(self.appDelegate.fbID!)"
        
        urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        print(urlstring)
        
        self.callSiginAPI(url: "\(urlstring)")

        
        
    }
    func loginWithGoogle(){
        
        self.disabling()
        
        print("Login with google")
        
    
        var urlstring:String = "\(signInAPIUrl)googleSignup/first_name/\(self.appDelegate.GPFirstName!)/last_name/\(self.appDelegate.GPLastName!)/mobile/null/country_code/null/city/madurai/email/\(self.appDelegate.GPEmail!)/google_id/\(self.appDelegate.GPID!)/profile_pic/\(self.appDelegate.GProfileimg!)"
        
        urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        print(urlstring)
        
        self.callSiginAPI(url: "\(urlstring)")


    }
    
    func callSiginAPI(url : String){
        
        Alamofire.request(url).responseJSON { (response) in
            
            self.parseData(JSONData: response.data!)
            print(response)
            // http://demo.cogzidel.com/arcane_lite/rider/fbSignup/regid/5765/first_name/cogzidel/last_name/c/mobile/93376543212/country_code/91/password/cogzidel/city/madurai/email/cogzidel_new@gmail.com/fb_id/45754545
        //    http://demo.cogzidel.com/arcane_lite/rider/googleSignup/regid/5765/first_name/cogzidel/last_name/c/mobile/93376543212/country_code/91/password/cogzidel/city/madurai/email/cogzidel_new@gmail.com/google_id/45754545
        
            
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
                    var email:String! = ""
                    var first_name:String!=""
                    var last_name:String!=""
                    var userid:String!=""
                    var profilePicNew:String!=""
                    var profilePicNo:String!=""
                    var existStatus:String!=""

                    if(self.autologin == true){
                        email = value.object(forKey: "email") as! String
                        first_name = value.object(forKey: "firstname") as? String
                        last_name = value.object(forKey: "lastname") as? String
                        profilePicNew = value.object(forKey: "profile_pic") as? String
                        
                        if profilePicNew == nil{
                            
                            UserDefaults.standard.setValue(profilePicNo, forKey: "GProfilePic")

                        }
                        else if profilePicNew == ""{
                            
                            UserDefaults.standard.setValue(profilePicNo, forKey: "GProfilePic")

                        }
                        else{
                            
                            UserDefaults.standard.setValue(profilePicNew, forKey: "GProfilePic")

                        }
                        //                    let mobile:String = value.object(forKey: "mobile") as? String
                        //userid = value.object(forKey: "userid") as! String
                        print("email is \(email!)")
                        print("user id is \(self.appDelegate.userid!)")
                        
                        
                        //self.appDelegate.userid = userid
                        self.appDelegate.fname = first_name
                        self.appDelegate.lname = last_name
                        self.appDelegate.loggedEmail = email

                        // session started using NSUserDefaults
                        
                        let value = "\(first_name) \(last_name)"
                        UserDefaults.standard.setValue(value, forKey: "userName")
                        
                        UserDefaults.standard.setValue(self.appDelegate.userid!, forKey: "userid")
                        
                        print("\(UserDefaults.standard.value(forKey: "userid")!)")
                        
                        //self.navigationController?.pushViewController(ARMapVC(), animated: true)

                        appDelegate.leftMenu()
                        
                        
                    }
                    else{
                        
                        // sign in or sign up by google or facebook
                        
                        email = value.object(forKey: "email") as! String
                        first_name = value.object(forKey: "first_name") as? String
                        last_name = value.object(forKey: "last_name") as? String
                        //                    let mobile:String = value.object(forKey: "mobile") as? String
                        userid = value.object(forKey: "userid") as! String
                        
                        existStatus = value.object(forKey: "status_extra") as? String
                        profilePicNew = value.object(forKey: "profile_pic") as? String
                        
                        if profilePicNew == nil{
                            
                            UserDefaults.standard.setValue(profilePicNo, forKey: "GProfilePic")

                        }
                        else if profilePicNew == ""{
                            
                            UserDefaults.standard.setValue(profilePicNo, forKey: "GProfilePic")

                        }
                        else{
                            
                            UserDefaults.standard.setValue(profilePicNew, forKey: "GProfilePic")

                        }
                        
                        let value = "\(first_name) \(last_name)"
                        UserDefaults.standard.setValue(value, forKey: "userName")
                        
                        self.appDelegate.userid = userid
                        self.appDelegate.fname = first_name
                        self.appDelegate.lname = last_name
                        self.appDelegate.loggedEmail = email
                        
                        print("email is \(email)")
                        print("user id is \(userid)")
                        
                        // session started using NSUserDefaults
                        
                        UserDefaults.standard.setValue(userid, forKey: "userid")
                        
                        print("\(UserDefaults.standard.value(forKey: "userid")!)")
                        
                        if existStatus == nil {
                            
                            var ref1 = FIRDatabase.database().reference()
                            
                            var userId = self.appDelegate.userid!
                            
                            let newUser = [
                                
                                "name": "\(first_name!) \(last_name!)",
                                //  "location" : "",
                                "email"      : "\(email!)",
                                
                                "Paymenttype" : "cash",
                                
                                ]
                            
                            
                            
                            var appendingPath = ref1.child(byAppendingPath: "riders_location")
                            
                            var appendingPath1 = ref1.child(byAppendingPath: "riders_location")
                            
                            
                            appendingPath.child(byAppendingPath: userId).setValue(newUser)
                            
                        }
                        else if existStatus == "Exist"{
                            
                            
                            
                        }
                        else{
                            
                           
                            
                        }
                        
                        
                        appDelegate.leftMenu()
                        
                        //self.navigationController?.pushViewController(ARMapVC(), animated: true)
                        
                        
                    }
                    
                }
                else{
                   
                }
            }
        }
        catch{
            
            print(error)
            
        }
        
    }

    
    
    @IBAction func btnPay(_ sender: Any) {
        
        // If you have your own form for getting credit card information, you can construct
        // your own STPCardParams from number, month, year, and CVV.
        let card = paymentTextField.card!
        
        STPAPIClient.shared().createToken(withCard: card) { token, error in
            guard let stripeToken = token else {
                NSLog("Error creating token: %@", error!.localizedDescription);
                return
            }
            
            // TODO: send the token to your server so it can create a charge
            let alert = UIAlertController(title: "Welcome to Stripe", message: "Token created: \(stripeToken)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }

        
    }

}

