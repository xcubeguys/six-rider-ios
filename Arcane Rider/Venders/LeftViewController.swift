//
//  LeftViewController.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 12/3/14.
//

import UIKit
import GoogleSignIn
import Firebase
import MessageUI

enum LeftMenu: Int {
    case main = 0
    case swift
    case wallet
    case SoS
    case rideLater
    case bankdetails
    case feedback
    case java
 
}

protocol LeftMenuProtocol : class {
    func changeViewController(_ menu: LeftMenu)
}

class LeftViewController : UIViewController, LeftMenuProtocol,MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var menus = ["Your Trips","Settings","Wallet","SoS","Ride Later","Bank Details","Feedback","Log Out"]
    var mainViewController: UIViewController!
    var swiftViewController: UIViewController!
    var javaViewController: UIViewController!
    var goViewController: UIViewController!
    var riderLaterViewController: UIViewController!
    var nonMenuViewController: UIViewController!
    var imageHeaderView: ImageHeaderView!
    var walletViewController: UIViewController!
    var SoSViewController: UIViewController!
    var bankViewController: UIViewController!
    var referralEarningViewController: UIViewController!
    var feedbacksViewController: UIViewController!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
   
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.shared.isIdleTimerDisabled = true
        
        self.tableView.separatorColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1.0)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let rootController = storyboard.instantiateViewController(withIdentifier: "mainMenuVC") as! ViewController
        self.nonMenuViewController = UINavigationController(rootViewController: rootController)
        
        let swiftViewController = storyboard.instantiateViewController(withIdentifier: "ARMainProfile") as! ARMainProfileVC
        
        
        self.swiftViewController = UINavigationController(rootViewController: swiftViewController)
        
        let javaViewController = storyboard.instantiateViewController(withIdentifier: "ARMainEditProfileVC") as! ARMainEditProfileVC
        self.javaViewController = UINavigationController(rootViewController: javaViewController)
        
        //ARBankVC
        let bankViewController1 = storyboard.instantiateViewController(withIdentifier: "ARBankVC") as! ARBankVC
        self.bankViewController = UINavigationController(rootViewController: bankViewController1)
        
       let goViewController = storyboard.instantiateViewController(withIdentifier: "yourTripsVC") as! ARMainYourTripsVC
        self.goViewController = UINavigationController(rootViewController: goViewController)
        
        let rideLatViewController = storyboard.instantiateViewController(withIdentifier: "SRRideLaterVC") as! SRRideLaterVC
        self.riderLaterViewController = UINavigationController(rootViewController: rideLatViewController)
        
        let walletViewController1 = storyboard.instantiateViewController(withIdentifier: "walletvc") as! ARwalletVC
        self.walletViewController = UINavigationController(rootViewController: walletViewController1)
        
        let SoSViewController1 = storyboard.instantiateViewController(withIdentifier: "sosvc") as! ARSoSVC
        self.SoSViewController = UINavigationController(rootViewController: SoSViewController1)
        
        let referralEarningViewController1 = storyboard.instantiateViewController(withIdentifier: "referralvc") as! ARReferalVC
        self.referralEarningViewController = UINavigationController(rootViewController: referralEarningViewController1)
        
        let feedbackViewController1 = storyboard.instantiateViewController(withIdentifier: "feedbackVC") as! FeedbackViewController
        self.feedbacksViewController = UINavigationController(rootViewController: feedbackViewController1)
        
        
        // instantiate your desired ViewController
        
        
        
    /*    let nonMenuController = storyboard.instantiateViewController(withIdentifier: "NonMenuController") as! NonMenuController
        nonMenuController.delegate = self
        self.nonMenuViewController = UINavigationController(rootViewController: nonMenuController)*/
        
        self.tableView.registerCellClass(BaseTableViewCell.self)
        
        self.imageHeaderView = ImageHeaderView.loadNib()
        self.view.addSubview(self.imageHeaderView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.imageHeaderView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 250)
        self.view.layoutIfNeeded()
    }
  /*  func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients(["forlearnios@gmail.com"])
        mailComposerVC.setSubject("App Feedback")
        mailComposerVC.setMessageBody("Hi Team!\n\nI would like to share the following feedback..\n", isHTML: false)
        
        return mailComposerVC
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        //switch result.value {
        switch result{
        case MFMailComposeResult.cancelled:
            print("Cancelled mail")
        case MFMailComposeResult.sent:
            print("Mail Sent")
        case MFMailComposeResult.failed:
            print("Mail Sent failed")
        default:
            break
        }
        self.dismiss(animated: true, completion: nil)
    }
    */

    func changeViewController(_ menu: LeftMenu) {
        switch menu {
            
        case .main:
            
            
            self.slideMenuController()?.changeMainViewController(self.goViewController, close: true)
            
          /*  let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let tripsVC = storyboard.instantiateViewController(withIdentifier: "yourTripsVC") as! ARMainYourTripsVC
            let navigationController = UINavigationController(rootViewController: tripsVC)
            navigationController.navigationBar.barStyle = .black
            self.present(navigationController, animated: true, completion: nil)*/
            
            
            break
            
        case .swift:
            
            
            self.slideMenuController()?.changeMainViewController(self.swiftViewController, close: true)
            
           /* let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let profileVC = storyboard.instantiateViewController(withIdentifier: "ARMainProfile") as! ARMainProfileVC
            let navigationController = UINavigationController(rootViewController: profileVC)
            navigationController.navigationBar.barStyle = .black
            self.present(navigationController, animated: true, completion: nil)*/
            
            
            break
        
        case .rideLater:
            
            self.slideMenuController()?.changeMainViewController(self.riderLaterViewController, close: true)
            
            
            break
            
        case .java:
            
            
                logout()
            
            break
            
        case .wallet:
            
            self.slideMenuController()?.changeMainViewController(self.walletViewController, close: true)
            
            self.appDelegate.stripepaymentstatus = "1"
            
            break
            
        case .SoS:
            
            self.slideMenuController()?.changeMainViewController(self.SoSViewController, close: true)
            
            break
            
        case .feedback:
            
            print("Feedback row tapped.")
                       /* let mailComposeViewController = configuredMailComposeViewController()
            
            if MFMailComposeViewController.canSendMail() {
                self.present(mailComposeViewController, animated: true, completion: nil)
            }
*/
            self.slideMenuController()?.changeMainViewController(self.feedbacksViewController, close:true)
                  break
            
            
        case .bankdetails:
            
            self.slideMenuController()?.changeMainViewController(self.bankViewController, close: true)
            break
            
       //     self.slideMenuController()?.changeMainViewController(self.javaViewController, close: true)
       
        }
    }
    
    
    func logout(){
        
        
     /*   let alert = UIAlertController(title: "Confirm", message: "Are You Sure want to Log Out?",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "OK", style: .default)
        {
            (action : UIAlertAction!) -> Void in
            
             let prefs = UserDefaults.standard
             prefs.removeObject(forKey: "userid")
             prefs.removeObject(forKey: "userName")
             prefs.removeObject(forKey: "cashMode")
             prefs.removeObject(forKey: "profilePic")
             prefs.removeObject(forKey: "payValue")
             prefs.removeObject(forKey: "acceptedDriverName")
             prefs.removeObject(forKey: "acceptedDriverPhoto")
            self.appDelegate.initApp()
            
            self.appDelegate.setRootViewController()
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        {
            (action : UIAlertAction!) -> Void in
        }
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)*/
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        let optionMenu = UIAlertController(title: nil, message: "Are You Sure want to Log Out?", preferredStyle: .actionSheet)
        optionMenu.popoverPresentationController?.sourceView = self.view
        
        let takePhoto = UIAlertAction(title: "Confirm", style: .default) { (alert : UIAlertAction!) in
            
            
        }
        let sharePhoto = UIAlertAction(title: "Log Out", style: .default) { (alert : UIAlertAction) in
            
            GIDSignIn.sharedInstance().signOut()
            let prefs = UserDefaults.standard
            prefs.removeObject(forKey: "userid")
            prefs.removeObject(forKey: "userName")
            prefs.removeObject(forKey: "cashMode")
            prefs.removeObject(forKey: "profilePic")
            prefs.removeObject(forKey: "payValue")
            prefs.removeObject(forKey: "acceptedDriverName")
            prefs.removeObject(forKey: "acceptedDriverPhoto")
            prefs.removeObject(forKey: "GProfilePic")
            prefs.removeObject(forKey: "trip_id")
            self.appDelegate.trip_id = "empty"
            self.appDelegate.accepted_Driverid = ""
            UserDefaults.standard.setValue("" , forKey: "tripDriverid")
            let ref = FIRDatabase.database().reference().child("drivers_data")
            ref.removeAllObservers()
            
            let ref1 = FIRDatabase.database().reference().child("trips_data")
            ref1.removeAllObservers()
          //  self.appDelegate.initApp()
            
          //  appDelegate.setRootViewController()
            
            self.slideMenuController()?.changeMainViewController(self.nonMenuViewController, close: true)

        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (alert : UIAlertAction) in
            
            
            
        }
        
        //    optionMenu.addAction(takePhoto)
        optionMenu.addAction(sharePhoto)
        
        optionMenu.addAction(cancel)
        
        self.present(optionMenu, animated: true, completion: nil)

    }
}

extension LeftViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let menu = LeftMenu(rawValue: indexPath.row) {
            switch menu {
            case .main, .swift,.wallet,  .SoS, .rideLater, .bankdetails, .feedback, .java:
                
                return BaseTableViewCell.height()
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let menu = LeftMenu(rawValue: indexPath.row) {
            print(menu)
            
            self.changeViewController(menu)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.tableView == scrollView {
            
        }
    }
}

extension LeftViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(menus.count)
        print(menus)
        
        return menus.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if let menu = LeftMenu(rawValue: indexPath.row) {
            print(menu)
            
            switch menu {
                
            case .main, .swift,.wallet,  .SoS, .rideLater, .bankdetails, .feedback, .java:
                let cell = BaseTableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: BaseTableViewCell.identifier)
                cell.setData(menus[indexPath.row])
                return cell
            }
        }
        return UITableViewCell()
    }
}
