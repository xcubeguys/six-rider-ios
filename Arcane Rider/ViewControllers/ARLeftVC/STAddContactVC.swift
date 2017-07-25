//
//  STAddContactVC.swift
//  SendTxT
//
//  Created by Apple on 08/11/16.
//  Copyright © 2016 Apple. All rights reserved.
//

import UIKit
import AddressBook

import MessageUI
import SwiftMessages



class STAddContactVC: UIViewController,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,CLTokenInputViewDelegate,MFMessageComposeViewControllerDelegate {

    
    var testCount = "1"
    //AFNetworking Manager
    let manager = AFHTTPRequestOperationManager()
    

    var user_id:NSString = ""
    var send_sms:String! = " "

    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet weak var topbarview:UIView!
    @IBOutlet weak var cancelbtnout:UIButton!
    @IBOutlet weak var titlelab:UILabel!
    @IBOutlet weak var sendbtnout:UIButton!
    
    @IBOutlet weak var searchview:UIView!
    
   
    @IBOutlet weak var contacttab: UITableView!
    @IBOutlet weak var searchtextFiled:UITextField!
    
    
    @IBOutlet weak var tokenInputTopSpace:NSLayoutConstraint!
    @IBOutlet weak var tableViewTopLayoutConstraint:NSLayoutConstraint!

    
    @IBOutlet weak var bottomConstraint:NSLayoutConstraint!

   
    @IBOutlet var tokenInputView: CLTokenInputView!

    
    let alert:UIAlertView = UIAlertView()
    
    var alpha:NSArray = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    
    

    var contactname:NSMutableArray = NSMutableArray()
    var contactno:NSMutableArray = NSMutableArray()
    var contactimg:NSMutableArray = NSMutableArray()
    
    var contactnamecopy:NSMutableArray = NSMutableArray()
    var contactnocopy:NSMutableArray = NSMutableArray()
    var contactimgcopy:NSMutableArray = NSMutableArray()
    
    var selectedname:NSMutableArray = NSMutableArray()
    var selectedno:NSMutableArray = NSMutableArray()
    var selectedimage:NSMutableArray = NSMutableArray()
    
    var contact_idarray:NSMutableArray = NSMutableArray()
    var contact_namearray:NSMutableArray = NSMutableArray()
    var contact_numberarray:NSMutableArray = NSMutableArray()
    var groupiconarray:NSMutableArray = NSMutableArray()
    var contacticonarray:NSMutableArray = NSMutableArray()

    var collectionNum:NSMutableArray = NSMutableArray()

    var selectSend:NSMutableArray = NSMutableArray()

    var maxsize:Int=0
    
    
    var addressBook: ABAddressBook?
    
    // check record in address book
    var record_found = false
    
    var filteredNames : NSMutableArray!

    var finalArray : NSArray!
    
    var names : NSArray!

    var selectedNames:NSMutableArray = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Contact"
        
        let btnName: UIButton = UIButton()
        btnName.setImage(UIImage(named: "arrow-left.png"), for: UIControlState())
        btnName.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btnName.addTarget(self, action: #selector(STAddContactVC.profileBtn(_:)), for: .touchUpInside)
        
        let leftBarButton:UIBarButtonItem = UIBarButtonItem()
        leftBarButton.customView = btnName
        self.navigationItem.leftBarButtonItem = leftBarButton
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(STAddContactVC.hidekeyboard))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
        
        if !self.responds(to: #selector(getter: self.automaticallyAdjustsScrollViewInsets)){
            
            self.tokenInputTopSpace.constant = 0.0

        }
        
           //     self.filteredNames = nil
        
        self.tokenInputView.fieldName = "To:"
        self.tokenInputView.placeholderText = "Select a name"
     //   self.tokenInputView.accessoryView! = self.contactAddButton()
        self.tokenInputView.drawBottomBorder = true
        self.tokenInputView.fieldColor = UIColor(red: 44.0/255.0, green: 32.0/255.0, blue: 12.0/255.0, alpha: 1.0)
        self.tokenInputView.keyboardType = UIKeyboardType.default
        self.tokenInputView.keyboardAppearance = UIKeyboardAppearance.default

        let nib = UINib(nibName: "STAddContactCell", bundle: nil)
        self.contacttab.register(nib, forCellReuseIdentifier:"addcontact")
  //      searchtextFiled.delegate=self
  //      searchtextFiled.addTarget(self, action: #selector(STAddContactVC.search(_:)), for: UIControlEvents.editingChanged)
        
//        self.contacttab.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
//        self.maxsize=Int((self.appDelegate.passmaxsize as String))!
//        self.maxsize=self.maxsize-1
        self.test()
        self.get_SendTXT_contact()
        self.contacttab.frame = CGRect(x:0, y:35,width:self.contacttab.frame.size.width,height:self.contacttab.frame.size.height)
        
        NotificationCenter.default.addObserver(self, selector: #selector(STAddContactVC.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(STAddContactVC.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        UIApplication.shared.isStatusBarHidden=false;
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if !self.tokenInputView.isEditing {
          //  self.tokenInputView.beginEditing()
            
        }
     //   super.viewDidAppear(animated)

    }
    
    func adjustingHeight(show:Bool, notification:NSNotification) {
        // 1
        var userInfo = notification.userInfo!
        // 2
        let keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        // 3
        let animationDurarion = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        // 4
        let changeInHeight = (keyboardFrame.height + 30) * (show ? 1 : -1)
        //5
        
        let value = keyboardFrame.height
        
        let frame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue

        let change = frame

        let screenSize: CGRect = UIScreen.main.bounds
        screenSize.origin
        
        let screenHeight = screenSize.height;

        
        UIView.animate(withDuration: animationDurarion) {
            
         //   self.bottomConstraint.constant += changeInHeight

            if self.tokenInputView.isEditing {
                

            }
            else{
                
                if(screenHeight == 667)
                {
                   

                }

            }
            
        }
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    func keyboardWillShow(notification:NSNotification) {
        
       


        if self.tokenInputView.isEditing {
            
            
        }
        else{
            
            
            if self.tokenInputView.isEditing {
                
                
                adjustingHeight(show: true, notification: notification)

            }
            else{
                

            }
            
            
        }

        
    }
    
    func keyboardWillHide(notification:NSNotification) {
        
        
        adjustingHeight(show: false, notification: notification)
        
    }
    func hidekeyboard()
    {
        
        
      //  viewDidAppear(true)
        
    }
    func profileBtn(_ Selector: AnyObject) {
        appDelegate.mainprofile()
       
        
    }

    var updatevalue:NSMutableArray = []

    @IBAction func sharereferal(_ sender: Any) {
        updatevalue = collectionNum
        
        let saa = selectedno
        
        print("!!! \(selectedno)")
        
        print("!!!!!! \(selectedno.count)")
        
        let stringRepresentation = updatevalue.componentsJoined(by: ",")
        
        
        
        
        print(" !!! \(updatevalue)")
        
        print(" !!!  !!!  \(stringRepresentation)")
        
        self.msgAction(msgNum: updatevalue)
        
        let d = updatevalue.count
        print(d)
        
        
        
        }
    func msgAction(msgNum : NSMutableArray){
        
        print(msgNum)
        
        if (MFMessageComposeViewController.canSendText()) {
            
            let controller = MFMessageComposeViewController()
            
            let shareText = "Get Credit on your Bank Account by using Referral Code on Registering with SIX Driver App Your Referral Code is "
            
            let space = "\(self.appDelegate.referalcodeprofile!)"
            
            let code = ".Enjoy your Trip"
            
            print(shareText)
            print(space)
            print(code)
            
            
            let shareItems:Array = [shareText,space,code]
            controller.body = "\(shareText)\(space)\(code)"
            
            //msgNum.replacingOccurrences(of: "Optional", with: "") as String as NSString!
            
           ///msgNum.replacingOccurrences(of: "(", with: "") as String as NSString!
            
            //msgNum.replacingOccurrences(of: ")", with: "") as String as NSString!
            
            var swiftArray = NSArray(array:msgNum) as! Array<String>
            
            controller.recipients = swiftArray
            print(controller.recipients as Any)
            
            controller.messageComposeDelegate = self
            
            self.present(controller, animated: true, completion: nil)
            
        }else{
            
            
            
            self.callNotSupportAlert(error: "This device not support to message")
            
        }
        
    }
    
    func callNotSupportAlert(error : String){
        
        
        
        let warning = MessageView.viewFromNib(layout: .CardView)
        
        warning.configureTheme(.warning)
        
        warning.configureDropShadow()
        
        let iconText = "" //"🤔"
        
        warning.configureContent(title: "", body: "\(error)", iconText: iconText)
        
        warning.button?.isHidden = true
        
        var warningConfig = SwiftMessages.defaultConfig
        
        warningConfig.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
        
        SwiftMessages.show(config: warningConfig, view: warning)
        
        
        
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        
        //... handle sms screen actions
        if result == .cancelled {
            
            let warning = MessageView.viewFromNib(layout: .CardView)
            warning.configureTheme(.warning)
            warning.configureDropShadow()
            let iconText = "" //"😶"
            warning.configureContent(title: "", body: "Your referal codes sending is cancelled", iconText: iconText)
            warning.button?.isHidden = true
            var warningConfig = SwiftMessages.defaultConfig
            warningConfig.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
            SwiftMessages.show(config: warningConfig, view: warning)
            print("Message cancelled")
            
        }
        else if result == .sent {
            
            let warning = MessageView.viewFromNib(layout: .CardView)
            warning.configureTheme(.success)
            warning.configureDropShadow()
            let iconText = "" //"😶"
            warning.configureContent(title: "", body: "Your referal codes is shared to your Contacts", iconText: iconText)
            warning.button?.isHidden = true
            var warningConfig = SwiftMessages.defaultConfig
            warningConfig.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
            SwiftMessages.show(config: warningConfig, view: warning)
            print("Message sent")
            
        }
        else {
            
            let warning = MessageView.viewFromNib(layout: .CardView)
            warning.configureTheme(.error)
            warning.configureDropShadow()
            let iconText = "" //"😶"
            warning.configureContent(title: "", body: "Your referal codes share is failed", iconText: iconText)
            warning.button?.isHidden = true
            var warningConfig = SwiftMessages.defaultConfig
            warningConfig.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
            SwiftMessages.show(config: warningConfig, view: warning)
            print("Message failed")
            
        }
        
        self.dismiss(animated: true, completion: nil)
        
        
        
        
        
    }
    


    func search(_ text:UITextField)
    {
        
        let lcount=(contactnamecopy.count)
        
        let contactarray:NSMutableArray = NSMutableArray()
        
        let contactnoarray:NSMutableArray = NSMutableArray()
        
        if(text.text!.characters.count != 0)
        {
            
            //            contactname = contactnamecopy
            //            contactno = contactnocopy
            //            contactimg = contactimgcopy
            
            let contactnamecopy1:NSMutableArray=NSMutableArray()
            let contactnocopy1:NSMutableArray=NSMutableArray()
            let contactimgcopy1:NSMutableArray=NSMutableArray()
            
            // var j:Int = lcount-1
            var j:Int = 0
            for i in 0 ..< lcount
            {
                
                contactarray.add(contactnamecopy.object(at: j))
                
                contactnoarray.add(contactnocopy.object(at: j))
                
                // let predicate = NSPredicate(format: "SELF CONTAINS %@", text.text!)
                
                let arrayOfAgesFiltered = (contactarray as NSArray).filtered(using: NSPredicate(format: "SELF CONTAINS[cd] %@", text.text!))
                
                let arrayOfAgesFiltered1 = (contactnoarray as NSArray).filtered(using: NSPredicate(format: "SELF CONTAINS[cd] %@", text.text!))
                //
                print("filterarray \(arrayOfAgesFiltered) \(arrayOfAgesFiltered1) \(arrayOfAgesFiltered.count) \(arrayOfAgesFiltered1.count)")
                
                if arrayOfAgesFiltered.count > 0 { //|| arrayOfAgesFiltered1.count > 0 {
                    print("not Removed")
                    contactnamecopy1.add(contactnamecopy.object(at: j))
                    contactnocopy1.add(contactnocopy.object(at: j))
                    contactimgcopy1.add(contactimgcopy.object(at: j))
                }
                else if arrayOfAgesFiltered1.count > 0 { //|| arrayOfAgesFiltered1.count > 0 {
                    print("not Removed")
                    contactnamecopy1.add(contactnamecopy.object(at: j))
                    contactnocopy1.add(contactnocopy.object(at: j))
                    contactimgcopy1.add(contactimgcopy.object(at: j))
                }
                    
                    //                    if(((contactname.objectAtIndex(j) as! String)).containsIgnoreCase("\(text.text)") || ((contactno.objectAtIndex(j) as! String)).containsIgnoreCase("\(text.text)"))
                    //                    {
                    //                        //print("not Removed")
                    //                    }
                else
                {
                    print("Removed")
                    //                        contactname.removeObjectAtIndex(j)
                    //                        contactno.removeObjectAtIndex(j)
                    //                        contactimg.removeObjectAtIndex(j)
                    
                }
                contactarray.removeObject(at: 0)
                contactnoarray.removeObject(at: 0)
                j += 1
                
            }
//            contact_namearray = contactnamecopy1
//            contact_numberarray = contactnocopy1
//            contactimg = contactimgcopy1
            contactname = contactnamecopy1
            contactno = contactnocopy1
            contactimg = contactimgcopy1
            

            
            contacttab.reloadData()
        }
        else
        {
            contactname.removeAllObjects()
            contactno.removeAllObjects()
            contactimg.removeAllObjects()
            
            self.test()
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    
    //get contact details
    func extractABAddressBookRef(_ abRef: Unmanaged<ABAddressBook>!) -> ABAddressBook? {
        if let ab = abRef {
            return Unmanaged<NSObject>.fromOpaque(ab.toOpaque()).takeUnretainedValue()
        }
        return nil
    }
    
    func test() {
        if (ABAddressBookGetAuthorizationStatus() == ABAuthorizationStatus.notDetermined) {
            var errorRef: Unmanaged<CFError>? = nil
            if let addressBook1 = extractABAddressBookRef(ABAddressBookCreateWithOptions(nil, &errorRef)) {
                self.addressBook = addressBook1
                ABAddressBookRequestAccessWithCompletion(addressBook, { success, error in
                    if success {
                        self.getContactNames()
                    }
                })
            }
            else {
                alert.dismiss(withClickedButtonIndex: 0, animated: false)
                alert.delegate=self
                alert.title="Warning"
                alert.message="FS in testfun"
                alert.addButton(withTitle: "OK")
                alert.show()
            }
        }
        else if (ABAddressBookGetAuthorizationStatus() == ABAuthorizationStatus.denied || ABAddressBookGetAuthorizationStatus() == ABAuthorizationStatus.restricted) {
            
        }
        else if (ABAddressBookGetAuthorizationStatus() == ABAuthorizationStatus.authorized) {
            
            self.getContactNames()
        }
    }
    
    func getContactNames() {
        var errorRef: Unmanaged<CFError>?
        if let addressBook1 = extractABAddressBookRef(ABAddressBookCreateWithOptions(nil, &errorRef)) {
            self.addressBook = addressBook1
            if let people = ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(addressBook, nil, ABPersonSortOrdering(kABPersonSortByFirstName)).takeRetainedValue() as [ABRecord]? {
                
                for record:ABRecord in people {
                    
                    
                    let contactPerson: ABRecord = record
                    
                    if((ABRecordCopyCompositeName(contactPerson)) != nil)
                    {
                        let contactName: String = ABRecordCopyCompositeName(contactPerson).takeRetainedValue() as String
                        
                        let numbers:ABMultiValue = ABRecordCopyValue(
                            record, kABPersonPhoneProperty).takeRetainedValue()
                        
                        let index = 0 as CFIndex
                        
                        if (ABMultiValueGetCount(numbers) > 0) {
                            
                            let value = ABMultiValueCopyValueAtIndex(numbers,index).takeRetainedValue() as! String
                            
                            
                            self.contactname.add(contactName)
                            self.contactno.add(value)
                            
                            let c = contactName.characters;
                            let r = c.index((c.startIndex), offsetBy: 0)
                            
                            let substring = contactName[r]
                            print(substring)
                            var uc = "\(substring)"
                            uc = uc.uppercased()
                            self.contacticonarray.add("\(uc)")
                            
                            if ABPersonHasImageData(record) {
                                let data = ABPersonCopyImageDataWithFormat(record, kABPersonImageFormatThumbnail)
                                if let data1 = data {
                                    self.contactimg.add(data1.takeRetainedValue())
                                    
                                }
                                else {
                                    let tmpimg:UIImage = UIImage(named:"UserPic_old")!
                                    let tmdata:Data = UIImageJPEGRepresentation(tmpimg, 1.0)!
                                    self.contactimg.add(tmdata)
                                    
                                }
                            }
                            else
                            {
                                let tmpimg:UIImage = UIImage(named:"UserPic_old")!
                                let tmdata:Data = UIImageJPEGRepresentation(tmpimg, 1.0)!
                                self.contactimg.add(tmdata)
                                
                            }
                            
                        }
                    }
                    
                }
                
            }
            else {
                
            }
            
        }
        else {
            
        }
        
        self.contactnamecopy = self.contactname
        self.filteredNames = self.contactname
        self.names = self.contactname
        self.contactnocopy = self.contactno
        self.contactimgcopy = self.contactimg
        self.finalArray = self.contactname

        self.contacttab.reloadData()
        
    }
    
    func get_SendTXT_contact(){
            }
    
    
    func searchWord(text : String){
        
        
        let lcount=(contactnamecopy.count)
        
        let contactarray:NSMutableArray = NSMutableArray()
        
        let contactnoarray:NSMutableArray = NSMutableArray()
        
        if(text.characters.count != 0)
        {
            
            //            contactname = contactnamecopy
            //            contactno = contactnocopy
            //            contactimg = contactimgcopy
            
            let contactnamecopy1:NSMutableArray=NSMutableArray()
            let contactnocopy1:NSMutableArray=NSMutableArray()
            let contactimgcopy1:NSMutableArray=NSMutableArray()
            
            // var j:Int = lcount-1
            var j:Int = 0
            for i in 0 ..< lcount
            {
                
                contactarray.add(contactnamecopy.object(at: j))
                
                contactnoarray.add(contactnocopy.object(at: j))
                
                // let predicate = NSPredicate(format: "SELF CONTAINS %@", text.text!)
                
                let arrayOfAgesFiltered = (contactarray as NSArray).filtered(using: NSPredicate(format: "SELF CONTAINS[cd] %@", text))
                
                let arrayOfAgesFiltered1 = (contactnoarray as NSArray).filtered(using: NSPredicate(format: "SELF CONTAINS[cd] %@", text))
                //
                print("filterarray \(arrayOfAgesFiltered) \(arrayOfAgesFiltered1) \(arrayOfAgesFiltered.count) \(arrayOfAgesFiltered1.count)")
                
                if arrayOfAgesFiltered.count > 0 { //|| arrayOfAgesFiltered1.count > 0 {
                    print("not Removed")
                    contactnamecopy1.add(contactnamecopy.object(at: j))
                    contactnocopy1.add(contactnocopy.object(at: j))
                    contactimgcopy1.add(contactimgcopy.object(at: j))
                }
                else if arrayOfAgesFiltered1.count > 0 { //|| arrayOfAgesFiltered1.count > 0 {
                    print("not Removed")
                    contactnamecopy1.add(contactnamecopy.object(at: j))
                    contactnocopy1.add(contactnocopy.object(at: j))
                    contactimgcopy1.add(contactimgcopy.object(at: j))
                }
                    
                    //                    if(((contactname.objectAtIndex(j) as! String)).containsIgnoreCase("\(text.text)") || ((contactno.objectAtIndex(j) as! String)).containsIgnoreCase("\(text.text)"))
                    //                    {
                    //                        //print("not Removed")
                    //                    }
                else
                {
                    print("Removed")
                    //                        contactname.removeObjectAtIndex(j)
                    //                        contactno.removeObjectAtIndex(j)
                    //                        contactimg.removeObjectAtIndex(j)
                    
                }
                contactarray.removeObject(at: 0)
                contactnoarray.removeObject(at: 0)
                j += 1
                
            }
            
            contactname = contactnamecopy1
            contactno = contactnocopy1
            contactimg = contactimgcopy1
            
            contacttab.reloadData()
        }
        else
        {
            contactname.removeAllObjects()
            contactno.removeAllObjects()
            contactimg.removeAllObjects()
            self.test()
        }

        
    }
    //get contact details
    
    func tokenInputView(_ view: CLTokenInputView, didChangeText text: String?) {
        
        if (text == "") {
            
          //  self.filteredNames = nil
         //   self.contacttab.isHidden = true
            self.testCount = "1"
        
        }
        else {
            
            self.searchWord(text: text!)
            
//            let value = self.contactname
//            
//            let valuw = self.names
//            
//            self.finalArray = self.contactname
//            
//            let asdas = self.finalArray
//            
//            
//            let predicate = NSPredicate(format: "self contains[cd] %@", text!)
//            self.finalArray = self.names.filtered(using: predicate) as NSArray!
//            self.contacttab.isHidden = false
            
            
        }
//        self.contacttab.reloadData()

    }
    
    func tokenInputView(_ view: CLTokenInputView, didAdd token: CLToken) {
        
        
        let name = token.displayText
        
        print("\(name)")
        
        print("\(tokenInputView)")
        
        let cvdsv = token.displayText
        
        print(" fasfsa \(cvdsv)")
        
        self.selectedNames.add(name)

    }
    
    func tokenInputView(_ view: CLTokenInputView, didRemove token: CLToken) {
        
        
        let name = token.displayText
        self.selectedNames.remove(name)
        self.contacttab.reloadData()
        
        print("\(tokenInputView)")
        
        
        let cvdsv = token.displayText
        
        print(" fasfsa \(cvdsv)")

    }
    
    func tokenInputView(_ view: CLTokenInputView, tokenForText text: String) -> CLToken? {
        
        return nil
    }
    
    func tokenInputViewDidEndEditing(_ view: CLTokenInputView) {
        
        view.accessoryView = nil
        
    }
    func tokenInputViewDidBeginEditing(_ view: CLTokenInputView) {
        
        self.view.removeConstraint(self.tableViewTopLayoutConstraint)
        self.tableViewTopLayoutConstraint = NSLayoutConstraint(item: self.contacttab, attribute: .top, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0)
        self.view.addConstraint(self.tableViewTopLayoutConstraint)
        self.view.layoutIfNeeded()

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if(contact_idarray.count != 0) {
            return 2
        }
        else if(contactno.count != 0) {
            return 2
        }
        else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView,
                   forSection section: Int) {
        
        // Background color
//        view.tintColor = UIColor.gray
        view.tintColor = UIColor.white
//        view.tintColor = UIColor(red: 45.0/255.0, green: 190.0/255.0, blue: 96.0/255.0, alpha: 1.0)

        
        // Text Color/Font
        let header = view as! UITableViewHeaderFooterView
        header.textLabel!.textAlignment = .center
        header.textLabel!.font = UIFont(name:"TimesNewRoman-Medium", size: 16.0)
        header.textLabel!.textColor = UIColor(red: 44.0/255.0, green: 32.0/255.0, blue: 12.0/255.0, alpha: 1.0)
        // put the font you want here...
    }
    
    
    func scrollViewWillBeginDragging(_ table: UIScrollView)
    {
      //  self.searchtextFiled.resignFirstResponder()
    }
    
    //Display details
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(section == 0){
            if(contact_idarray.count == 0)
            {
                return 0 //1
            }
            else
            {
                if self.testCount == "true"{
                    
                    return finalArray.count
                }
                else{
                    
                    return contact_idarray.count

                }
            }
        }
        else if(section == 1){
            if(contactname.count == 0)
            {
                return 0  //1
            }
            else
            {
                if self.testCount == "true"{
                    
                    return finalArray.count
                }
                else{
                    
                    return contactname.count

                }
            }
        }
        else{
            return 0
        }

    }

    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56.0
    }
    
   
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:STAddContactCell = tableView.dequeueReusableCell(withIdentifier: "addcontact") as! STAddContactCell!

        if(indexPath.section == 0){
            if(contact_idarray.count != 0){
                let name:String! = "\(contact_namearray.object(at: (indexPath as NSIndexPath).row))"
                let num:String! = "\(contact_numberarray.object(at: (indexPath as NSIndexPath).row))"
                let icon:String! = "\(groupiconarray.object(at: (indexPath as NSIndexPath).row))"
                
            var nameValue = name
            nameValue = nameValue?.replacingOccurrences(of: "%20", with: " ")
                
                cell.peoplename.text="\(num!)"
                cell.peopleno.text="\(nameValue!)"
                cell.iconContact.text = "\(icon!)"
                //            cell.profimg.image=UIImage(data: contactimg.object(at: (indexPath as NSIndexPath).row) as! Data)
                record_found = true
        
                self.finalArray.adding(contact_namearray)
                
                self.names.adding(contact_namearray)
                
                
                self.filteredNames.adding(contact_namearray)
                
                var name1 = self.contact_namearray[indexPath.row]
                name1 = (name1 as AnyObject).replacingOccurrences(of: "%20", with: " ")
                name1 = (name1 as AnyObject).replacingOccurrences(of: "Optional", with: "")
                name1 = (name1 as AnyObject).replacingOccurrences(of: "(", with: "")
                name1 = (name1 as AnyObject).replacingOccurrences(of: ")", with: "")
                name1 = (name1 as AnyObject).replacingOccurrences(of: "\"", with: "")
                cell.peopleno!.text = String(describing: name1)
                if self.selectedNames.contains(name1) {
                    
                    cell.accessoryType = .checkmark
                    cell.tintColor = UIColor(red: 44.0/255.0, green: 32.0/255.0, blue: 12.0/255.0, alpha: 1.0)
                }
                else {
                    
                    cell.accessoryType = .none
                }

            }
        }
        else if(indexPath.section == 1){
            if(contactname.count != 0){
                let icon:String! = "\(contacticonarray.object(at: (indexPath as NSIndexPath).row))"
                cell.iconContact.text = "\(icon!)"
                cell.peopleno.text="\(contactname.object(at: (indexPath as NSIndexPath).row))"
                cell.peoplename.text="\(contactno.object(at: (indexPath as NSIndexPath).row))"
                cell.profimg.image=UIImage(data: contactimg.object(at: (indexPath as NSIndexPath).row) as! Data)
                record_found = true
                
                self.finalArray.adding(contactname)

                self.names.adding(contactname)

                self.filteredNames.adding(contactname)

            var name1 = self.contactname[indexPath.row]
                name1 = (name1 as AnyObject).replacingOccurrences(of: "%20", with: " ")
                name1 = (name1 as AnyObject).replacingOccurrences(of: "Optional", with: "")
                name1 = (name1 as AnyObject).replacingOccurrences(of: "(", with: "")
                name1 = (name1 as AnyObject).replacingOccurrences(of: ")", with: "")
                name1 = (name1 as AnyObject).replacingOccurrences(of: "\"", with: "")
                cell.peopleno!.text = String(describing: name1)
                if self.selectedNames.contains(name1) {
                    
                    cell.accessoryType = .checkmark
                    cell.tintColor = UIColor(red: 44.0/255.0, green: 32.0/255.0, blue: 12.0/255.0, alpha: 1.0)
                }
                else {
                    
                    cell.accessoryType = .none
                }

            }
        }
        else{
            
        }
        
        
        return cell
    }
//    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
//        return 2
//    }
    
    var cont:String!=""

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            
            return 30.0
        }
        else {
            
            return 0.0
        }
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?{

        if section == 0 {
            cont = "Contacts"
        }
        if section == 1 {
            cont = ""
        }
        return "\(cont!)"
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath as IndexPath)?.selectionStyle = UITableViewCellSelectionStyle.none
     //   tableView.deselectRow(at: indexPath, animated: true)

        
        if(indexPath.section == 0){
            
            
            let name:String! = "\(contact_namearray.object(at: (indexPath as NSIndexPath).row))"
            let num:String! = "\(contact_numberarray.object(at: (indexPath as NSIndexPath).row))"
            
                     //   self.navigationController?.pushViewController(STNewMessageVC(), animated: true)
            
            let value1 = self.contact_numberarray[indexPath.row]
            
            var name1 = self.contact_namearray[indexPath.row]
            name1 = (name1 as AnyObject).replacingOccurrences(of: "%20", with: " ")
            name1 = (name1 as AnyObject).replacingOccurrences(of: "Optional", with: "")
            name1 = (name1 as AnyObject).replacingOccurrences(of: "(", with: "")
            name1 = (name1 as AnyObject).replacingOccurrences(of: ")", with: "")
            name1 = (name1 as AnyObject).replacingOccurrences(of: "\"", with: "")

            let asdsad = self.contact_numberarray[indexPath.row]
            
            let token1 = CLToken(displayText: asdsad as! String, context: nil)

            
            let token = CLToken(displayText: name1 as! String, context: nil)
            
            if self.tokenInputView.isEditing {
                
                self.names.adding(contact_namearray)
                self.tokenInputView.add(token)
                self.collectionNum.add(value1)
         //       self.tokenInputView.add(token1)
                
                let cvdsv = tokenInputView.text
                
                print(" fasfsa \(cvdsv)")
                
                self.selectedno.add(token1)
            }
            else{
                
                self.names.adding(contact_namearray)
                self.tokenInputView.add(token)
                self.collectionNum.add(value1)
                
                self.selectedno.add(token1)
                
        //        self.tokenInputView.add(token1)

                let cvdsv = tokenInputView.text
                
                print(" fasfsa \(cvdsv)")

            }
        }
        else if(indexPath.section == 1){
            let name:String! = "\(contactname.object(at: (indexPath as NSIndexPath).row))"
            let num:String! = "\(contactno.object(at: (indexPath as NSIndexPath).row))"
            
        //    self.navigationController?.pushViewController(STNewMessageVC(), animated: true)
            
            let value1 = self.contactno[indexPath.row]

            let asdsad = self.contactno[indexPath.row]
            
            let token1 = CLToken(displayText: asdsad as! String, context: nil)

            var name1 = self.contactname[indexPath.row]
            var token = CLToken(displayText: name1 as! String, context: nil)
            
            if self.tokenInputView.isEditing {
                
                self.names.adding(contactname)
                self.tokenInputView.add(token)
                self.collectionNum.add(value1)
                
                self.selectedno.add(token1)

        //        self.tokenInputView.add(token1)


            }else{
                
                
                self.names.adding(contactname)
                self.tokenInputView.add(token)
                self.collectionNum.add(value1)
                
                self.selectedno.add(token1)

        //        self.tokenInputView.add(token1)

            }
        }
        
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.cellForRow(at: indexPath as IndexPath)?.selectionStyle = UITableViewCellSelectionStyle.none
//
//        if record_found == false {
//        }
//        else {
//            let currentCell = tableView.cellForRow(at: indexPath) as! STAddContactCell;
//            if(currentCell.selectedtick.imageView?.image == UIImage(named: "Oval 1.png"))
//            {
//                if(self.maxsize != 0)
//                {
//                    selectedname.add(contactname.object(at: (indexPath as NSIndexPath).row))
//                    selectedno.add(contactno.object(at: (indexPath as NSIndexPath).row))
//                    selectedimage.add(contactimg.object(at: (indexPath as NSIndexPath).row))
//                    self.maxsize=self.maxsize-1
//                    currentCell.selectedtick.setImage(UIImage(named:"Oval 2.png"), for: UIControlState())
//                }
//                else
//                {
//                    alert.dismiss(withClickedButtonIndex: 0, animated: false)
//                    alert.delegate = self
//                    alert.title=NSLocalizedString("title_Message",comment:"title_Message")
//                    alert.message = NSLocalizedString("maximum", comment: "maximum")
//                    alert.addButton(withTitle: "OK")
//                    alert.show()
//                }
//            }
//            else if(currentCell.selectedtick.imageView?.image == UIImage(named: "Oval 2.png"))
//            {
//                currentCell.selectedtick.setImage(UIImage(named:"Oval 1.png"), for: UIControlState())
//                
//                //to remove selected items
//                
//                let lcount=(selectedname.count)
//                var j:Int = lcount-1
//                for i in 0 ..< lcount
//                {
//                    if(((selectedname.object(at: j) as! String)).contains((contactname.object(at: (indexPath as NSIndexPath).row) as! String)))
//                    {
//                        selectedname.removeObject(at: j)
//                        selectedno.removeObject(at: j)
//                        selectedimage.removeObject(at: j)
//                    }
//                    
//                    j -= 1
//                    
//                }
//                //to remove selected items
//                self.maxsize=self.maxsize+1
//                
//            }
//            
//        }
//        
//    }
    //Display details
    
    func tick(_ sender:UIButton)
    {
        if(sender.imageView?.image == UIImage(named: "Oval 1.png"))
        {
            sender.setImage(UIImage(named:"Oval 2.png"), for: UIControlState())
        }
        else if(sender.imageView?.image == UIImage(named: "Oval 2.png"))
        {
            sender.setImage(UIImage(named:"Oval 1.png"), for: UIControlState())
        }
        
    }
    
    @IBAction func sendact(_ sender:AnyObject)
    {
        
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelact(_ sender:UIButton)
    {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
