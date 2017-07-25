//
//  AppDelegate.swift
//  Arcane Rider
//
//  Created by Apple on 16/12/16.
//  Copyright © 2016 Apple. All rights reserved.
//

import UIKit
import MediaPlayer
import GoogleSignIn
import CoreData
import GoogleMaps
import GooglePlaces
import Firebase
import Fabric
import Stripe
import UserNotifications
import Alamofire
import FBSDKCoreKit
import FBSDKLoginKit
import CoreLocation
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var googleMaps  = "AIzaSyCd46h_0qRCIHxUDfNyFOOgksKQrylXHBY" // key for push notification
    
    var url:String = live_url

    //https://arcane-rider-ce6e6.firebaseio.com  // new database url arcane

    var window: UIWindow?
    // for register page
    var firstname:String! = ""
    var lastname:String! = ""
    var email:String! = ""
    var password:String! = ""
    var phonenumber:String! = ""
    var countrycode:String! = ""
    var city:String! = ""
    var referralcodevalue:String! = ""
    var nickname:String! = ""
    var ccstatus:String! = ""
    // for signin page
    var userName:String! = ""
    var passWord:String! = ""
    var encpws:String! = ""
    
    // fb signin
    var fbEmail:String! = ""
    var fbFirstName:String! = ""
    var fbLastName:String! = ""
    var fbMobile:String! = ""
    var fbID:String! = ""
    var billing:String! = ""
    
   
    // Bank details
    var holdername:String! = ""
    var banknaming:String! = ""
    var routingnumber:String! = ""
    var accountnum:String! = ""
    var billingadd:String! = ""
    var cityvalue:String! = ""
    var pincode:String! = ""
    var branchcode:String! = ""
    var walletstatus = 0
    
    var backfrompayment:String! = "0"
    
    // google signin
    var GPEmail:String! = ""
    var GPFirstName:String! = ""
    var GPLastName:String! = ""
    var GPMobile:String! = ""
    var GPID:String! = ""
    var GProfileimg:String! = ""
    var total_tollfee:String! = ""
    var emergencyno1:String! = ""
    var emergencyno2:String! = ""
    // Location
    var pickupLocation = CLLocation()
    var dropLocation = CLLocation()
    
    //nocashenabled
    var cashno:String! = ""
    
    var countrycode1:String! = ""
    var countrycode2:String! = ""
    
    // Static user id
    
    var userid:String! = ""
    var passAcceptedDriverCarCategory:String! = ""
    var loggedEmail:String! = ""
    var fname:String! = ""
    var lname:String! = ""

    //for getting additional location
    
    var waypointmerge:NSString! = ""
    var waypointcountrycode:NSString! = ""
    var waypointaddress:NSString! = ""
    
    // Edit Profile
    
    var fnametextField:String! = ""
    var lnametextfield:String! = ""
    var emailtextField:String! = ""
    var mobilenotextField:String! = ""
    var countrycodetextfield:String! = ""

    // request lat longs
    var pickup_long:String! = ""
    var pickup_lat:String! = ""
    var dest_long:String! = ""
    var dest_lat:String! = ""
    var request_id:String! = ""
    var request_status:String! = ""
    var referalcodeprofile:String! = ""
    // Stripe Payment
    var stripepaymentstatus:String! = "0"
    var addmoneyvalue:String! = ""
    // from getRequestURL
    var req_status:String!=""
    var accepted_Driverid:String!=""
    
    var isridelaterreq:String! = "0"
    
    var driverLat:String!=""
    var driverLong:String!=""
    var userprofilepic:String!=""
    var distance = 0.0
    var wallet_amount:String!=""
    typealias jsonSTD = NSArray
    //update location 
    var updatelocationstatus:NSNumber = 0
    var updatelocationname:String = ""
    
    //ridelater requestid
    var ridelaterreqid:String! = ""
    
    var autologin = false
    
    var firstnamewallet:String! = ""
    
    var trip_id:String! = "empty"
    
    var corpstatus:Int! = 0

    var testTrip_id : String!
    
    var riderRatToDriver : String!
    
    var locate = CLLocation()
    let locationTracker = LocationTracker(threshold: 10.0)

    var stripe_ApiKey = ""
    
    var getCountryCheck:Int! = 0

    var getCountryName:String! = "None"
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
       
        self.initApp()
        
        self.getAllCredential()
        
        self.callLocalNotification()
        
        FIRApp.configure()
        
        Fabric.with([STPAPIClient.self, Crashlytics.self])
        
        // TODO: Replace with your own test publishable key
        // TODO: DEBUG ONLY! Remove / conditionalize before launch
        
    
        
        
        //workedold Stripe.setDefaultPublishableKey("pk_test_FhElr4VVNXcfGpiGGuGr1R1L")
        //admin apikey old Stripe.setDefaultPublishableKey("pk_test_Cq4Zzdwq8sWgXl58aG1F6toD")
        
//        GMSServices.provideAPIKey("AIzaSyDNtLlofE5VzMWI3w9dYGnH_munD_zZfk0")
//        
//        GMSPlacesClient.provideAPIKey("AIzaSyDNtLlofE5VzMWI3w9dYGnH_munD_zZfk0")
//        
        GMSServices.provideAPIKey("AIzaSyDMqU_zWVuR0FziY_i69DyWHtiNZj0gjY8")
        
        GMSPlacesClient.provideAPIKey("AIzaSyDMqU_zWVuR0FziY_i69DyWHtiNZj0gjY8")
        
        self.getLocation()

        let value = UserDefaults.standard.object(forKey: "userid")
        
        if value != nil{
            
            //leftMenu()
            
        }
        else{
            
            //setRootViewController()

            
        }
        
    //    self.autoLoginCheck()
        
            
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
    }
    
    
    func getAllCredential(){
        var urlstring:String = "\(live_url)settings/getDetails"
        urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        print(urlstring)
        let manager : AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
        manager.responseSerializer.acceptableContentTypes =  NSSet(objects: "text/plain", "text/html", "application/json", "audio/wav", "application/octest-stream") as Set<NSObject>
        manager.get("\(urlstring)",
            parameters: nil,
            success: { (operation: AFHTTPRequestOperation?,responseObject: Any?) in
                let jsonObjects:NSArray = responseObject as! NSArray
                for dataDict : Any in jsonObjects
                {
                    if jsonObjects.count == 0{
                        
                    }
                    else{
                        let is_live_stripe = (dataDict as AnyObject).object(forKey: "is_live_stripe") as? String
                       
                        if is_live_stripe == nil {
                            
                        }
                        else{

                            if(is_live_stripe == "0"){
                                let Test_PublishKey = (dataDict as AnyObject).object(forKey: "Test_PublishKey") as? String
                                self.stripe_ApiKey = Test_PublishKey!
                                Stripe.setDefaultPublishableKey(self.stripe_ApiKey)
                            }
                            else{
                                let Live_ApiKey = (dataDict as AnyObject).object(forKey: "Live_ApiKey") as? String
                                self.stripe_ApiKey = Live_ApiKey!
                                Stripe.setDefaultPublishableKey(self.stripe_ApiKey)
                            }
                        }
                    }
                }
        },
            failure: { (operation: AFHTTPRequestOperation?,error: Error) in
                print("Error: " + error.localizedDescription)
                
        })
    }
    
    func getLocation(){
        
        self.locationTracker.addLocationChangeObserver { (result) -> () in
            switch result {
            case .success(let location):
                let coordinate = location.physical.coordinate
                
                self.locate = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
                
            case .failure:
                break
            }
        }
        
        
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Arcane_Rider")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func callLocalNotification(){
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (success, error) in
            if let error = error {
                print("Request Authorization Failed (\(error), \(error.localizedDescription))")
            }
            else{
                
            }
        }
    }
    
    func initApp(){
        
        UINavigationBar.appearance().isTranslucent = false
        UIApplication.shared.statusBarStyle = .lightContent
        UINavigationBar.appearance().barTintColor = UIColor(hex: "#6F511F")
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black]
        UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.black], for: UIControlState())
        UIBarButtonItem.appearance().tintColor = UIColor.black
    }
    
    
    
    func setRootViewController(){
        
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // instantiate your desired ViewController
        let rootController = storyboard.instantiateViewController(withIdentifier: "appRootNavigationController")
        
        // Because self.window is an optional you should check it's value first and assign your rootViewController
        
        self.window!.rootViewController = rootController
        
    }
      /* func callMapVC(){
        
        let vc = ARMapVC()
        let navigationController = UINavigationController(rootViewController: vc)
        window!.rootViewController = navigationController
        
    } */
    
    func callSignInVC(){
        
        let vc = ARSignInVC()
        let navigationController = UINavigationController(rootViewController: vc)
        window!.rootViewController = navigationController
        
    }
    
    func callCompleteVC(){
        
        let vc = ARCompleteTripVC()
        let navigationController = UINavigationController(rootViewController: vc)
        window!.rootViewController = navigationController
        
    }
    func callProfileVC(){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let swiftViewController = storyboard.instantiateViewController(withIdentifier: "ARMainProfile") as! ARMainProfileVC
        let navigationController = UINavigationController(rootViewController: swiftViewController)
        window!.rootViewController = navigationController

    }
       func autoLoginCheck(){
        
        if(UserDefaults.standard.value(forKey: "userid") != nil){
            print("auto login")
            print(UserDefaults.standard.value(forKey: "userid")!)
            let userid:String = UserDefaults.standard.value(forKey: "userid")! as! String
            if(userid != ""){
                
                self.userid = userid
                self.autologin = true
             
                var urlstring:String! = "\(url)Rider/editProfile/user_id/\(self.userid!)/"
                
                urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
                print(urlstring)
                
                self.callSiginAPI(url: "\(urlstring!)")
                
                
            }
            
            
        }
        
        else
        {
            
            self.setRootViewController()
        }
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
                    
                    if(self.autologin == true){
                        
                        email = value.object(forKey: "email") as! String
                        first_name = value.object(forKey: "firstname") as! String
                        last_name = value.object(forKey: "lastname") as! String
                        //                    let mobile:String = value.object(forKey: "mobile") as? String
                        //userid = value.object(forKey: "userid") as! String
                        print("email is \(email!)")
                        print("user id is \(self.userid!)")
                        
                        
                        //self.appDelegate.userid = userid
                        self.fname = first_name
                        self.lname = last_name
                        self.loggedEmail = email
                        
                        // session started using NSUserDefaults
                        
                        UserDefaults.standard.setValue(self.userid!, forKey: "userid")
                        
                        print("\(UserDefaults.standard.value(forKey: "userid")!)")
                        
                        
                        leftMenu()

                        
                        
                    }
                    else{
                        
                        email = value.object(forKey: "email") as! String
                        first_name = value.object(forKey: "first_name") as! String
                        last_name = value.object(forKey: "last_name") as! String
                        //                    let mobile:String = value.object(forKey: "mobile") as? String
                        userid = value.object(forKey: "userid") as! String
                        
                        self.userid = userid
                        self.fname = first_name
                        self.lname = last_name
                        self.loggedEmail = email
                        
                        print("email is \(email)")
                        print("user id is \(userid)")
                        
                        UserDefaults.standard.setValue(userid, forKey: "userid")
                        
                        print("\(UserDefaults.standard.value(forKey: "userid")!)")
                        
                            leftMenu()
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

    func leftMenu(){
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let mainViewController = storyboard.instantiateViewController(withIdentifier: "mainMap") as! ARMainMapVC
        mainViewController.riderClickedPayPage = "not"
        
        let leftViewController = storyboard.instantiateViewController(withIdentifier: "LeftViewController") as! LeftViewController
        
        let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)
                
        leftViewController.mainViewController = nvc
        
        let slideMenuController = ExSlideMenuController(mainViewController:nvc, leftMenuViewController: leftViewController)
        slideMenuController.automaticallyAdjustsScrollViewInsets = true
        slideMenuController.delegate = mainViewController
      //  self.window?.backgroundColor = UIColor(red: 236.0, green: 238.0, blue: 241.0, alpha: 1.0)
        self.window?.rootViewController = slideMenuController
        self.window?.makeKeyAndVisible()
        
    }
    

    func mainprofile()
    {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // instantiate your desired ViewController
        let rootController = storyboard.instantiateViewController(withIdentifier: "ARMainProfile")
        
        // Because self.window is an optional you should check it's value first and assign your rootViewController
        
        let navigationController = UINavigationController(rootViewController: rootController)
        
        window!.rootViewController = navigationController
    }

    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        //let checkFB = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        let checkGoogle = GIDSignIn.sharedInstance().handle(url as URL!,sourceApplication: sourceApplication,annotation: annotation)
        let checkFB = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        
        return checkGoogle || checkFB
//        return checkGoogle
    }

    


}

