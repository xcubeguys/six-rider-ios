//
//  ARMainProfileVC.swift
//  Arcane Rider
//
//  Created by Apple on 22/12/16.
//  Copyright © 2016 Apple. All rights reserved.
//

import UIKit
import Alamofire
import Photos



extension String {
    func stringByAppendingPathComponent(path: String) -> String {
        let nsSt = self as NSString
        return nsSt.appendingPathComponent(path)
    }
}
class ARMainProfileVC: UIViewController,UIDocumentInteractionControllerDelegate{

    @IBOutlet weak var nicknamelabel: UILabel!
    @IBOutlet weak var referrallabel: UILabel!
    @IBOutlet weak var labelFirstName: UILabel!
    @IBOutlet weak var labelLastName: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var labelPhoneNumber: UILabel!

    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    @IBOutlet weak var viewCirlce: UIView!

    @IBOutlet weak var imageViewProfile: UIImageView!

    @IBOutlet weak var profilepicload: UIActivityIndicatorView!
    @IBOutlet var shareview: UIView!
    @IBOutlet weak var share: UIButton!
    
    var documentController: UIDocumentInteractionController!

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
   
    var viewAPIUrl = live_rider_url
    
    typealias jsonSTD = NSArray
    
    typealias jsonSTDAny = [String : AnyObject]
    
   /* override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .lightContent
    }*/
    
    override var prefersStatusBarHidden: Bool {
        
        return false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.shareview.isHidden = true
        // Do any additional setup after loading the view.
        
        
        navigationController!.navigationBar.barStyle = .black
        
        navigationController!.isNavigationBarHidden = false
        
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "arrow-left.png")!, for: .normal)
        button.addTarget(self, action: #selector(ARMainProfileVC.profileBtn(_:)), for: .touchUpInside)
        //CGRectMake(0, 0, 53, 31)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        //(frame: CGRectMake(3, 5, 50, 20))
        let label = UILabel(frame: CGRect(x: 20, y: 5, width: 100, height: 20))
        // label.font = UIFont(name: "Arial-BoldMT", size: 13)
        label.text = "Settings"
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.clear
       // profilepicload.startAnimating()
        button.addSubview(label)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = barButton
        
        viewCirlce.layer.cornerRadius = viewCirlce.frame.size.width / 2
        viewCirlce.clipsToBounds = true
        
        rightNaviCallBtn()
        
        
    }
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
        navigationController!.navigationBar.barStyle = .black
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
    }
    
    @IBAction func closeshare(_ sender: Any) {
        self.shareview.isHidden = true
    }
    
    
    var savePath: String = NSHomeDirectory().stringByAppendingPathComponent(path: "Documents/Test.ig")
    
    func mergeImageAndText(text: NSString, atPoint: CGPoint) -> UIImage{
        let demoImage = UIImage(named: "Ridershare.png")!
        // Setup the font specific variables
        let textColor = UIColor.black
        let textFont = UIFont(name: "Helvetica", size: 48)!
        // Setup the image context using the passed image
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(demoImage.size,false,scale)
        // Setup the font attributes that will be later used to dictate how the text should be drawn
        let textFontAttributes = [
            NSFontAttributeName: textFont,
            NSForegroundColorAttributeName: textColor,
            ] as [String : Any]
        demoImage.draw(in: CGRect(x: 0, y: 0, width: 1024, height: 768))
        let rect =  CGRect(x: atPoint.x, y: atPoint.y, width: demoImage.size.width, height: demoImage.size.height)
        // Draw the text into an image
        text.draw(in: rect, withAttributes: textFontAttributes)
        // Create a new image out of the images we have created
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        // End the context now that we have the image we need
        UIGraphicsEndImageContext()
        //Pass the image back up to the caller
        print(text)
        print(newImage!)
        //view.addSubview(newImage)
        return newImage!
    }
    

    @IBAction func socialmediashare(_ sender: Any) {
       
         /*  let shareText = "Get Credit on your Bank Account by using Referral Code on Registering with SIX Driver App Your Referral Code is "
        
        let space = "\(self.referrallabel.text!)"
        
        let code = ".Enjoy your Trip"
        
        let myWebsite = ("\(shareText)\(space)\(code)")
        
     let imageView = UIImageView(frame: CGRect(x: 20, y: 50, width: 300, height: 300))
        let finalImage =  UIImage(named: "ic_referral.png")!.addText(drawText: "\(myWebsite)" as NSString, atPoint: CGPoint(x: 50, y: 100), textColor:UIColor.black , textFont:UIFont.systemFont(ofSize: 20))
        
        
        print(finalImage)
        
        //let finalImage: UIImage = UIImage(named: "\(imagename)")!
       // docController.UTI = "com.instagram.photo"
        
        var instagramURL = NSURL(string: "instagram://app")!
        if UIApplication.shared.canOpenURL(instagramURL as URL) {
            
            let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let localPath = directoryURL.appendingPathComponent("Image.ig")
           
            
            
            do {
                
                try UIImagePNGRepresentation(finalImage)?.write(to: URL(fileURLWithPath: "\(localPath)"), options: .atomic)
                
                
            } catch {
                
                print(error)
                
                
            }
            
            
            var imageURL = NSURL.fileURL(withPath: "\(localPath)")
            
            print(imageURL)
            
            documentController  = UIDocumentInteractionController()
            documentController.delegate = self
            documentController.uti = "com.instagram.exclusivegram"
            documentController.url = imageURL
            documentController.presentOpenInMenu(from: CGRect.zero, in: self.view, animated: true)
            
        } else {
            print("instagram not found")
        } */
       
        
       // let shareText = "Get Credit on your Bank Account by using Referral Code on Registering with SIX Driver App Your Referral Code is "
        
        let space = "\(self.referrallabel.text!)"
        
       // let code = ".Enjoy your Trip"
        
       // let myWebsite = ("\(shareText)\(space)\(code)")
       
        let imagenew = self.mergeImageAndText(text: "\(space)" as NSString, atPoint: CGPoint(x: 453, y: 460))
        print("fbreferalcodeShareImage:\(imagenew)")
       
       // let shareItems:Array = [shareText,space,code]
        
       // let shareItems:Array = [myWebsite]
        
       // let firstActivityItem = "\(myWebsite)"
        var activityVC = UIActivityViewController(activityItems: [imagenew], applicationActivities: nil)
        
        activityVC.excludedActivityTypes = [
            UIActivityType.postToWeibo,
            UIActivityType.print,
            UIActivityType.copyToPasteboard,
            UIActivityType.assignToContact,
            UIActivityType.saveToCameraRoll,
            UIActivityType.addToReadingList,
            UIActivityType.postToFlickr,
            UIActivityType.postToVimeo,
            UIActivityType.postToTencentWeibo,
            UIActivityType.airDrop
        ]
        
        
        
        
        self.present(activityVC, animated: true, completion: nil)
       
    }
    
    
   
    
    override func viewWillAppear(_ animated: Bool) {
        self.shareview.isHidden = true
        
        UIApplication.shared.isIdleTimerDisabled = false
        
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
        navigationController!.navigationBar.barStyle = .black
        
        self.activityView.startAnimating()
        
        var urlstring:String = "\(viewAPIUrl)editProfile/user_id/\(self.appDelegate.userid!)"
        
        urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        
        urlstring = urlstring.removingPercentEncoding!
        
               
        print(urlstring)
        
        self.callviewAPI(url: "\(urlstring)")
        
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
        
        appDelegate.leftMenu()
        
       // self.dismiss(animated: true, completion: nil)
    }

    
    @IBAction func mainshare(_ sender: Any) {
        self.shareview.isHidden = false
        
    }
    
    
    func rightNaviCallBtn(){
        
        let btnName: UIButton = UIButton()
        btnName.setImage(UIImage(named: "pencil.png"), for: UIControlState())
        btnName.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btnName.addTarget(self, action: #selector(ARMainProfileVC.callHistoryBtn(_:)), for: .touchUpInside)
        
        let leftBarButton:UIBarButtonItem = UIBarButtonItem()
        leftBarButton.customView = btnName
        self.navigationItem.rightBarButtonItem = leftBarButton
        
    }
    func callHistoryBtn(_ Selector: AnyObject) {
        
        
       /* let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc : ARMainEditProfileVC = storyboard.instantiateViewController(withIdentifier: "ARMainEditProfileVC") as! ARMainEditProfileVC
        let navigationController = UINavigationController(rootViewController: vc)
        
        self.present(navigationController, animated: true, completion: nil)*/
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let subContentsVC = storyboard.instantiateViewController(withIdentifier: "ARMainEditProfileVC") as! ARMainEditProfileVC
        self.navigationController?.pushViewController(subContentsVC, animated: true)
    }
    
    func callviewAPI(url : String){
        print()
        self.activityView.startAnimating()
    
        Alamofire.request(url).responseJSON { (response) in
            
            self.parseData(JSONData: response.data!)
            print("callviewAPI response\(response)")
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
                    
                    var firstname = value.object(forKey: "firstname") as? String
                    var lastname = value.object(forKey: "lastname") as? String
                    let mobile:String = value.object(forKey: "mobile") as! String
                    let cc:String = value.object(forKey: "country_code") as! String
                    let email:String = value.object(forKey: "email") as! String
                    let profilePic = value.object(forKey: "profile_pic") as! String
                    
                    var nick_name = value.object(forKey: "nick_name") as! String
                    
                    let refrel_code = value.object(forKey: "refrel_code") as! String
                    
                    if(refrel_code != nil || refrel_code != "")
                    {
                        self.appDelegate.referalcodeprofile = refrel_code
                    }
                    else{
                        
                    }
                    var wallet_amount = value.object(forKey: "wallet_amount") as! String
 
                    
                    if wallet_amount != nil {
                       
                        
                        self.appDelegate.wallet_amount = wallet_amount
                        
                        print(self.appDelegate.wallet_amount)
                        
                    }
                    else{
                        
                    }

                    
                    
                    let value = profilePic
                    
                    UserDefaults.standard.setValue(value, forKey: "profilePic")
                    
                    if firstname != nil{
                        firstname = firstname?.replacingOccurrences(of: "Optional(", with: "")
                        firstname = firstname?.replacingOccurrences(of: ")", with: "")
                        firstname = firstname?.replacingOccurrences(of: "%20", with: " ")
                        firstname = firstname?.replacingOccurrences(of: "\"", with: "")
                        
                        self.appDelegate.firstnamewallet = firstname
                        
                        print(self.appDelegate.firstnamewallet)
                        
                    }
                    else{
                        firstname = ""
                    }
                    if nick_name != nil{
                        nick_name = nick_name.replacingOccurrences(of: "Optional(", with: "")
                        nick_name = nick_name.replacingOccurrences(of: ")", with: "")
                        nick_name = nick_name.replacingOccurrences(of: "%20", with: " ")
                        nick_name = nick_name.replacingOccurrences(of: "\"", with: "")
                         nick_name = nick_name.replacingOccurrences(of: "%2522", with: "")
                        
                    }
                    else{
                        nick_name = ""
                    }
                    if lastname != nil{
                        lastname = lastname?.replacingOccurrences(of: "Optional(", with: "")
                        lastname = lastname?.replacingOccurrences(of: ")", with: "")
                        lastname = lastname?.replacingOccurrences(of: "%20", with: " ")
                        lastname = lastname?.replacingOccurrences(of: "\"", with: "")
                        lastname = lastname?.replacingOccurrences(of: "%2522", with: "")
                        
                       
                        
                    }
                    else{
                        lastname = ""
                    }

                    
                    labelFirstName.text = firstname
                    labelLastName.text = lastname
                    labelEmail.text = email
                    nicknamelabel.text = nick_name
                    referrallabel.text = refrel_code
                    
                    
                    var ccValue = cc
                    labelPhoneNumber.text = "\(ccValue)  \(mobile)"
                    let userValue = "\(firstname) \(lastname)"
                    UserDefaults.standard.setValue(userValue, forKey: "userName")
                    
                    if profilePic == nil{
                        
                        imageViewProfile.image = UIImage(named: "UserPic_old.png")
                        
                    }
                    else if profilePic == ""{
                        
                        imageViewProfile.image = UIImage(named: "UserPic_old.png")
                        UserDefaults.standard.setValue(profilePic, forKey: "GProfilePic")

                    }
                    else{
                        self.appDelegate.userprofilepic = profilePic
                        
                        
                        imageViewProfile.sd_setImage(with: NSURL(string: profilePic) as URL!)
                        UserDefaults.standard.setValue(profilePic, forKey: "GProfilePic")
                    }

                   /* if profilePic == "http://demo.cogzidel.com/arcane_lite/images/yy.png"{
                        
                    
                    imageViewProfile.image = UIImage(named: "UserPic.png")


                    }
                    else if profilePic != ""{
                    
                    let imageURL = profilePic
                    
                    let url = URL(string: imageURL)
                    
                    imageViewProfile.setImageWithUrl(url!)
                    
                    }
                    else{
                        
                        imageViewProfile.image = UIImage(named: "UserPic.png")
                        
                    }*/
                    
                  /*  var valueProfile = UserDefaults.standard.object(forKey: "GProfilePic") as? String
                    valueProfile = valueProfile?.replacingOccurrences(of: "Optional(", with: "")
                    valueProfile = valueProfile?.replacingOccurrences(of: ")", with: "")
                    
                    if valueProfile == nil{
                        
                        if profilePic == nil{
                            
                            imageViewProfile.image = UIImage(named: "UserPic.png")
                            
                        }
                        else if profilePic == ""{
                            
                            imageViewProfile.image = UIImage(named: "UserPic.png")
                            
                        }
                        else{
                            
                            imageViewProfile.sd_setImage(with: NSURL(string: profilePic) as URL!)
                            
                        }
                        
                    }
                    else{
                        
                        imageViewProfile.sd_setImage(with: NSURL(string: valueProfile!) as URL!)
                        
                    }*/
                    
                self.activityView.stopAnimating()
                    
                    
                }
                else{
                    
                    
                self.activityView.stopAnimating()
                    
                }
            }
        }
        catch{
            
            print(error)
            
            self.activityView.stopAnimating()
            
        }
        
    }
    
    
    
    
    @IBAction func contactshareaction(_ sender: Any) {
        self.navigationController?.pushViewController(STAddContactVC(), animated: true)
    }
    
  
    

}
extension UIImageView{
    
    func setImageFromURl(stringImageUrl url: String){
        
        if let url = NSURL(string: url) {
            if let data = NSData(contentsOf: url as URL) {
                self.image = UIImage(data: data as Data)
            }
        }
    }
}
extension UIImage {
    
    func addText(drawText: NSString, atPoint: CGPoint, textColor: UIColor?, textFont: UIFont?) -> UIImage{
        
        // Setup the font specific variables
        var _textColor: UIColor
        if textColor == nil {
            _textColor = UIColor.white
        } else {
            _textColor = textColor!
        }
        
        var _textFont: UIFont
        if textFont == nil {
            _textFont = UIFont.systemFont(ofSize: 16)
        } else {
            _textFont = textFont!
        }
        
        // Setup the image context using the passed image
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        
        // Setup the font attributes that will be later used to dictate how the text should be drawn
        let textFontAttributes = [
            NSFontAttributeName: _textFont,
            NSForegroundColorAttributeName: _textColor,
            ] as [String : Any]
        
        // Put the image into a rectangle as large as the original image
        
       
        draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        // Create a point within the space that is as bit as the image
        
        let rect =  CGRect(x: atPoint.x, y: atPoint.y, width: size.width, height: size.height)

        
        // Draw the text into an image
        drawText.draw(in: rect, withAttributes: textFontAttributes)
        
        // Create a new image out of the images we have created
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // End the context now that we have the image we need
        UIGraphicsEndImageContext()
        
        //Pass the image back up to the caller
        return newImage!
        
    }
}


extension UIView {
    func takeSnapshot(width: CGFloat, height: CGFloat) -> UIImage {
        var cropRect = CGRect(x: 0, y: 0, width: 600, height: 600)
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        //image.imageWithNewSize(CGSizeMake(width, height))
        return image!
    }
}

