//
//  STContactsVC.swift
//  SendTxT
//
//  Created by Apple on 22/10/2016 A.
//  Copyright © 2016 Apple. All rights reserved.
//

import UIKit

class STContactsVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet var addBtn: UIButton!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var live_url = demo_url
    
    let manager = AFHTTPRequestOperationManager()
    
    var contactname:NSMutableArray = NSMutableArray()
    
    var tapGesture: UITapGestureRecognizer?
    var longPressGesture: UILongPressGestureRecognizer?
    var panGesture: UIPanGestureRecognizer?
    
    var contact_idarray:NSMutableArray = NSMutableArray()
    var contact_namearray:NSMutableArray = NSMutableArray()
    var contact_numberarray:NSMutableArray = NSMutableArray()
    
    var user_id:NSString = ""
    var groupname:NSString!=""
   


    override func viewDidLoad() {
        super.viewDidLoad()
        

        self.title = "Contacts"
        navigationController!.isNavigationBarHidden = false
        addEditButton()

        tableview.register((UINib(nibName: "STContactsCell", bundle: nil)), forCellReuseIdentifier: "cell")
        
        if let value : String =  UserDefaults.standard.object(forKey: "userid") as! String!{
            let userid = value
            print(userid)
            if(userid != nil){
                self.user_id = userid as NSString
            }
        }
      //  navigationController!.isNavigationBarHidden = false
self.contact()
        
             // Do any additional setup after loading the view.
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        

       // navigationController!.isNavigationBarHidden = false
        
        self.contact()
        
        // Do any additional setup after loading the view.
    }

    func contact()
    {
        let trimid:NSString! = "\(self.user_id)" as NSString!
        let id: NSString = "\(trimid!)" as NSString
        
        print("\(live_url)contacts/viewContact/user_id/\(id)")
        
        manager.get( "\(live_url)contacts/viewContact/user_id/\(id)",
            
            parameters: nil,
            success: { (operation: AFHTTPRequestOperation?,responseObject: Any?) in
                
                let jsonObjects=responseObject as! NSArray
                for dataDict : Any in jsonObjects {
                    
                    let status: String? = (dataDict as AnyObject).object(forKey: "status") as? String
                    let tmp: String? = "Success"
                    
                    if(status == tmp)
                    {
                        let contact_id: String? = (dataDict as AnyObject).object(forKey: "contact_id") as? String
                        let contact_name: String? = (dataDict as AnyObject).object(forKey: "contact_name") as? String
                        let contact_number: String? = (dataDict as AnyObject).object(forKey: "contact_number") as? String
                        
                        self.contact_idarray.add(contact_id!)
                        self.contact_namearray.add(contact_name!)
                        self.contact_numberarray.add(contact_number!)
                        self.tableview.reloadData()
                        
                        
                    }
                    else
                    {
                        
                        
                    }
                    
                    
                }
                
            },
            failure: { (operation: AFHTTPRequestOperation?,error: Error?) in
                
        })

    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addBtn.layer.cornerRadius = 0.5 * addBtn.bounds.size.width
        addBtn.clipsToBounds = true
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
    
    func editClicked(_ sender: AnyObject){
        self.navigationController?.pushViewController(STEditContactsVC(), animated: true)
    }
    @IBAction func addButtonClicked(_ sender: AnyObject) {
       self.navigationController?.pushViewController(STAddContactsVC(), animated: true)
    }

    


    func addEditButton(){
        
        let btnName: UIButton = UIButton()
        btnName.setImage(UIImage(named: "addcontact"), for: UIControlState())
        btnName.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btnName.addTarget(self, action: #selector(STContactsVC.editClicked(_:)), for: .touchUpInside)
        
        let rightBarButton:UIBarButtonItem = UIBarButtonItem()
        rightBarButton.customView = btnName
        self.navigationItem.rightBarButtonItem = rightBarButton
       
        
    }
    
  
    func setupGestureRecognizers()
    {
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(STEditContactsVC.saveclicked))
        //addGestureRecognizer(panGesture!)
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(STEditContactsVC.saveclicked))
      //  addGestureRecognizer(tapGesture!)
    }
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        if(contact_idarray.count != 0){
//            return contact_idarray.count
//        }
        if(section == 0){
            if(contact_idarray.count == 0)
            {
                return 1
            }
            else
            {
                return contact_idarray.count
            }        }
        else if(section == 1){
            if(contactname.count == 0)
            {
                return 1
            }
            else
            {
                return contactname.count
            }
        }
        else{
            return 0
        }

    }
    
 
    var selectedidarray:NSMutableArray = NSMutableArray()
    var numberarray:NSMutableArray = NSMutableArray()
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        let cell : STContactsCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! STContactsCell
        
//        let contact_id:NSString! = contact_idarray[(indexPath as NSIndexPath).row] as? NSString
//        tableView.cellForRow(at: indexPath as IndexPath)?.accessoryType = UITableViewCellAccessoryType.none

        
       let cell : STContactsCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! STContactsCell
        
        if(indexPath.section == 0){
            if(contact_idarray.count != 0){
                let name:String! = "\(contact_namearray.object(at: (indexPath as NSIndexPath).row))"
                let num:String! = "\(contact_numberarray.object(at: (indexPath as NSIndexPath).row))"
                
                cell.nameLabel!.text = "\(name!)"
                cell.mobileLabel!.text = "\(num!)"
                print("check \( cell.mobileLabel!.text)")
 
            }
        }
        else if(indexPath.section == 1){
            if(contactname.count != 0){
                cell.nameLabel.text="\(contactname.object(at: (indexPath as NSIndexPath).row))"
                cell.mobileLabel.text="\(contact_numberarray.object(at: (indexPath as NSIndexPath).row))"
 
            }
        }
        else{
            
        }
    
        return cell
        
    }
    

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        

        
              tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
        
         if(indexPath.section == 0){
            let name:String! = "\(contact_namearray.object(at: (indexPath as NSIndexPath).row))"
            let id:String! = "\(contact_idarray.object(at: (indexPath as NSIndexPath).row))"

            let num:String! = "\(contact_numberarray.object(at: (indexPath as NSIndexPath).row))"
            self.appDelegate.mobilenumber = "\(num!)"
            self.appDelegate.c_id = "\(id!)"
            self.appDelegate.name = "\(name!)"
            self.navigationController?.pushViewController(STEditContactsVC(), animated: true)
        }
        else if(indexPath.section == 1){
            let name:String! = "\(contactname.object(at: (indexPath as NSIndexPath).row))"
            let num:String! = "\(contact_numberarray.object(at: (indexPath as NSIndexPath).row))"
            self.appDelegate.mobilenumber = "\(num!)"
            self.appDelegate.name = "\(name!)"
            self.navigationController?.pushViewController(STEditContactsVC(), animated: true)
        }
        
     
    }

  
    
}
