//
//  ARMainMapVC.swift
//  Arcane Rider
//
//  Created by Apple on 22/12/16.
//  Copyright © 2016 Apple. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Firebase
import GeoFire
import CoreLocation
import Alamofire
import SwiftMessages
import UserNotifications
import CoreMotion
import TGPControls
import MessageUI
import PMAlertController

enum PlaceType: CustomStringConvertible {
    case all
    case geocode
    case address
    case establishment
    case regions
    case cities
    var description : String {
        switch self {
        case .all: return ""
        case .geocode: return "geocode"
        case .address: return "address"
        case .establishment: return "establishment"
        case .regions: return "regions"
        case .cities: return "cities"
        }
    }
}

struct Place {
    let id: String
    let description: String
}

/*let maplocStyle1 = "[\n  {\n    \"elementType\": \"geometry\",\n    \"stylers\": [\n      {\n        \"color\": \"#f5f5f5\"\n      }\n    ]\n  },\n  {\n    \"elementType\": \"labels.icon\",\n    \"stylers\": [\n      {\n        \"visibility\": \"off\"\n      }\n    ]\n  },\n  {\n    \"elementType\": \"labels.text.fill\",\n    \"stylers\": [\n      {\n        \"color\": \"#616161\"\n      }\n    ]\n  },\n  {\n    \"elementType\": \"labels.text.stroke\",\n    \"stylers\": [\n      {\n        \"color\": \"#f5f5f5\"\n      }\n    ]\n  },\n  {\n    \"featureType\": \"administrative.land_parcel\",\n    \"elementType\": \"labels.text.fill\",\n    \"stylers\": [\n      {\n        \"color\": \"#bdbdbd\"\n      }\n    ]\n  },\n  {\n    \"featureType\": \"poi\",\n    \"elementType\": \"geometry\",\n    \"stylers\": [\n      {\n        \"color\": \"#eeeeee\"\n      }\n    ]\n  },\n  {\n    \"featureType\": \"poi\",\n    \"elementType\": \"labels.text.fill\",\n    \"stylers\": [\n      {\n        \"color\": \"#757575\"\n      }\n    ]\n  },\n  {\n    \"featureType\": \"poi.park\",\n    \"elementType\": \"geometry\",\n    \"stylers\": [\n      {\n        \"color\": \"#e5e5e5\"\n      }\n    ]\n  },\n  {\n    \"featureType\": \"poi.park\",\n    \"elementType\": \"labels.text.fill\",\n    \"stylers\": [\n      {\n        \"color\": \"#9e9e9e\"\n      }\n    ]\n  },\n  {\n    \"featureType\": \"road\",\n    \"elementType\": \"geometry\",\n    \"stylers\": [\n      {\n        \"color\": \"#ffffff\"\n      }\n    ]\n  },\n  {\n    \"featureType\": \"road.arterial\",\n    \"elementType\": \"labels.text.fill\",\n    \"stylers\": [\n      {\n        \"color\": \"#757575\"\n      }\n    ]\n  },\n  {\n    \"featureType\": \"road.highway\",\n    \"elementType\": \"geometry\",\n    \"stylers\": [\n      {\n        \"color\": \"#dadada\"\n      }\n    ]\n  },\n  {\n    \"featureType\": \"road.highway\",\n    \"elementType\": \"labels.text.fill\",\n    \"stylers\": [\n      {\n        \"color\": \"#616161\"\n      }\n    ]\n  },\n  {\n    \"featureType\": \"road.local\",\n    \"elementType\": \"labels.text.fill\",\n    \"stylers\": [\n      {\n        \"color\": \"#9e9e9e\"\n      }\n    ]\n  },\n  {\n    \"featureType\": \"transit.line\",\n    \"elementType\": \"geometry\",\n    \"stylers\": [\n      {\n        \"color\": \"#e5e5e5\"\n      }\n    ]\n  },\n  {\n    \"featureType\": \"transit.station\",\n    \"elementType\": \"geometry\",\n    \"stylers\": [\n      {\n        \"color\": \"#eeeeee\"\n      }\n    ]\n  },\n  {\n    \"featureType\": \"water\",\n    \"elementType\": \"geometry\",\n    \"stylers\": [\n      {\n        \"color\": \"#c9c9c9\"\n      }\n    ]\n  },\n  {\n    \"featureType\": \"water\",\n    \"elementType\": \"labels.text.fill\",\n    \"stylers\": [\n      {\n        \"color\": \"#9e9e9e\"\n      }\n    ]\n  }\n]"*/


class ARMainMapVC: UIViewController,UISearchBarDelegate , LocateOnTheMap,GMSAutocompleteFetcherDelegate,CLLocationManagerDelegate,GMSMapViewDelegate,UNUserNotificationCenterDelegate,MFMessageComposeViewControllerDelegate,UITableViewDelegate,UITableViewDataSource {

    //searchbarfunction
    let geocorder:CLGeocoder = CLGeocoder()
    var places = [Place]()
    var placeType: PlaceType = .all
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newLength = (searchBar.text!).characters.count + text.characters.count - range.length
        return newLength <= 30
    }
    /**
     * Called when an autocomplete request returns an error.
     * @param error the error that was received.
     */
    public func didFailAutocompleteWithError(_ error: Error) {
        //        resultText?.text = error.localizedDescription
        resultText?.text = error.localizedDescription

    }
    
    /**
     * Called when autocomplete predictions are available.
     * @param predictions an array of GMSAutocompletePrediction objects.
     */
    public func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
        //self.resultsArray.count + 1
        //self.placeAutocomplete()
        for prediction in predictions {
            
            if let prediction = prediction as GMSAutocompletePrediction!{
                self.resultsArray.append(prediction.attributedFullText.string)
            }
        }
        self.searchResultController.reloadDataWithArray(self.resultsArray)
        //   self.searchResultsTable.reloadDataWithArray(self.resultsArray)
        print("it is old")
        print(resultsArray)
        
        
        // for nearby 
        
        let resultsStr = NSMutableString()
        print("it is new")

        for prediction in predictions {
            print(predictions)
            resultsStr.appendFormat("%@\n", prediction.attributedPrimaryText)
        }
        
        resultText?.text = resultsStr as String

    }
    
    @IBOutlet weak var googleMapsContainer: UIView!
    
    var googleMapsView: GMSMapView!
    var searchResultController: SearchResultsController!
    var resultsArray = [String]()
    var gmsFetcher: GMSAutocompleteFetcher!
    
    var amountPass = ""
    var nearbyRadius = 1
    var request_duration = 15
    var isAirport = 0
    
    var waypointmerge:NSString = ""
    var waypointmerge1:NSString = ""
    var getdirectionurlstring:String = ""
    var Updatedlat:NSString = ""
    var Updatedlon:NSString = ""
    var updatemultilocindburl:NSString = ""
    var ridelatercount = 0
    
    @IBOutlet weak var searchview: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchTable: UITableView!
    @IBOutlet weak var viewMapArcane: GMSMapView!
    
    @IBOutlet weak var usersusedcount: UILabel!

    @IBOutlet weak var total_tollfee: UILabel!
    @IBOutlet weak var buttonTopPickUp: UIButton!
    
    @IBOutlet weak var buttonTopDrop: UIButton!
    
    @IBOutlet weak var rippleview1: UIView!
    @IBOutlet weak var viewTopPickup: UIView!
    @IBOutlet weak var viewUpdateDrop: UIView!
    
    @IBOutlet weak var viewTopDrop: UIView!
    
    @IBOutlet weak var viewRequest: UIView!
    
    @IBOutlet weak var driverETAlbl: UILabel!
    @IBOutlet weak var lastTripView: UIView!
    @IBOutlet weak var btnCancelProgress: UIButton!
    @IBOutlet weak var priceView: UIView!
    
    @IBOutlet var progressViewOutlet: UIProgressView!
    
    @IBOutlet weak var labelPickupCentre: UILabel!

    @IBOutlet weak var labelTopPickupCentre: UILabel!

    @IBOutlet weak var labelTopPickup: UILabel!
    @IBOutlet weak var labelTopDrop: UILabel!
    @IBOutlet weak var labelToUpdatepDrop: UILabel!
    

    @IBOutlet var licplate_no: UILabel!
    @IBOutlet weak var labelVer: UILabel!

    @IBOutlet weak var imageViewTopBlurBack: UIImageView!

    // Driver Details view
    @IBOutlet var driverDetail: UIView!
    @IBOutlet var driverPhoto: UIImageView!
    
    @IBOutlet var licensephoto: UIImageView!
    @IBOutlet var driverName: UILabel!
    @IBOutlet var carNameLabel: UILabel!
    
    @IBOutlet var platenoo: UILabel!

    @IBOutlet var carmodel: UILabel!
    @IBOutlet var addressView: UIView!
    
    
    @IBOutlet var statusView: UIView!
    @IBOutlet var statusLabel: UILabel!
    
    @IBOutlet weak var viewTopLeftMenu: UIView!
    @IBOutlet weak var viewTopLeftCancel: UIView!

    @IBOutlet weak var btnNewRequest: UIButton!

    @IBOutlet weak var btnNewPay: UIButton!

    @IBOutlet weak var btnNewTopBack: UIButton!

    @IBOutlet weak var buttonTopNewPickUp: UIButton!
    @IBOutlet weak var buttonTopUpdateDrop: UIButton!

    @IBOutlet weak var buttonTopNewChange: UIButton!

    @IBOutlet weak var buttonTopNewNavigationBar: UIButton!

    @IBOutlet weak var viewDriverImage: UIView!

    @IBOutlet var viewlicenseimage: UIView!
    @IBOutlet weak var imageViewCash: UIImageView!

    @IBOutlet weak var btnLeft: UIButton!

    
    @IBOutlet weak var btnPickupNewCentre: UIButton!

    @IBOutlet var viewCarCategory: UIView!

    @IBOutlet var labelSuvCircle: UILabel!
    @IBOutlet var labelSedanCircle: UILabel!
    @IBOutlet var labelHatchCircle: UILabel!

    
    @IBOutlet var viewTray: UIView!

    @IBOutlet var labelCarName1: UILabel!
    @IBOutlet var labelCarName2: UILabel!
    @IBOutlet var labelCarName3: UILabel!
    @IBOutlet var labelCarName4: UILabel!

    
    @IBOutlet var labelMinFare: UILabel!
    @IBOutlet var labelMaxSize: UILabel!
    @IBOutlet var labelPriceMin: UILabel!
    @IBOutlet var labelPriceKM: UILabel!

    
    @IBOutlet var viewFareEstimate: UIView!
    @IBOutlet var btnFareEstimate: UIButton!

    @IBOutlet var viewFareNewEstimate: UIView!
    @IBOutlet weak var lineLabelnew: UILabel!
    @IBOutlet var btnFareNewEstimate: UIButton!

    @IBOutlet var btnInfo: UIButton!

    @IBOutlet var viewCurrentTrip: UIView!

    @IBOutlet var labelCurrentTripDriver: UILabel!
    @IBOutlet var labelCurrentTripDriverCar: UILabel!
    @IBOutlet var imageViewCurrentTripDriver: UIImageView!

    @IBOutlet var viewBlurCurrentTrip: UIView!

    @IBOutlet weak var carSlideUpHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var labelSecondCircle : UILabel!
    @IBOutlet weak var labelThirdCircle : UILabel!
    
    @IBOutlet weak var btnPickShareRideNumbers: UIButton!
    @IBOutlet weak var imageViewRideShare: UIImageView!
    @IBOutlet weak var viewRideShareNumbers: UIView!

    
    
    @IBOutlet var carimg: UIImageView!
    @IBOutlet var plateno: UILabel!
    var trayOriginalCenter: CGPoint!
    
    var trayDownOffset: CGFloat!
    var trayUp: CGPoint!
    var trayDown: CGPoint!
     var homePassEditProfile : String!
    
    var touchPickUp = false
    var touchDropupdate = false
    var touchDrop = false
    
    var touched = false
    
    var loadingFirst = true
    
    var carCategoryPass = ""
    var estimatedfare:Double = 0.0
    
    var checked = ""
    var kilometer:Double = 0.0
    
    var progressLabel: UILabel?
    
    let locationTracker = LocationTracker(threshold: 10.0)
    
    var locationManager = CLLocationManager()
    
    var didFindMyLocation = false
    
    let screenSize: CGRect = UIScreen.main.bounds
    
    var currentLocation = CLLocation()
    var pickupLocation = CLLocation()
    
    var nearbyLocation = CLLocation()
    
    var idleLocation = CLLocation()
    
    var trip_status = "nil"
    var trip_id = "nil"
    
    var fareestimateclicked = "0"
    
    var latMutArray = NSMutableArray()
    var longMutArray = NSMutableArray()
    var states:NSMutableArray = NSMutableArray()
    var driverNamesArray:NSMutableArray = NSMutableArray()
    
    var dynamicLocation = CLLocation()
    var tapLocation = CLLocation()
    
    typealias jsonSTD = NSArray
    
    typealias jsonSTDAny = [String : AnyObject]
    
    @IBOutlet weak var viewPickupCentre: UIView!

    @IBOutlet weak var viewPay: UIView!

    @IBOutlet weak var viewCancelRequest: UIView!

    @IBOutlet weak var viewLineNewBar: UIView!

    @IBOutlet weak var requestDisableView: UIView!
    
    @IBOutlet weak var sliderCar: TGPDiscreteSlider!

    @IBOutlet weak var viewWholeTopFareEstimate: UIView!

    @IBOutlet var viewuser: UIButton!
    @IBOutlet weak var viewTopFareEstimate: UIView!
    @IBOutlet weak var viewTopFareAddress: UIView!
    @IBOutlet weak var viewTopFareDollar: UIView!

    @IBOutlet weak var labelTopFareCar: UILabel!
    @IBOutlet weak var labelTopFareDollar: UILabel!
    @IBOutlet weak var labelTopFarePickUp: UILabel!
    @IBOutlet weak var labelTopFareDrop: UILabel!

    @IBOutlet weak var labelMinute: UILabel!

    @IBOutlet weak var labelEta: UILabel!

    @IBOutlet weak var viewLeftCircleTime: UIView!

    @IBOutlet weak var terminalView: UIView!
    @IBOutlet weak var viewRightCircleTime: UIView!

    @IBOutlet weak var dropdownList: EDropdownList!
    @IBOutlet weak var terminallist: UIButton!
    @IBOutlet weak var doorlist: UIButton!
    @IBOutlet weak var terminalName: UILabel!

    var check = true
    var payCheckWillAppear = ""
    var timer = Timer()
    var poseDuration = 20
    var indexProgressBar = 0
    var currentPoseIndex = 0
    
    var firstTime:Int = 1
    
    var driverFirstName = ""
    var driverLastName = ""
    var vehiclemodel = ""
 //   var signInAPIUrl = live_Driver_url
    var drivers = 0
    var fCount = 0
    var url:String! = live_url
    var markercount = 0
    var multicount = 0
    
    var update_Marker = true // to update first time marker in map for current location
    
    let manager:AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
    
    let linearBar: LinearProgressBar = LinearProgressBar()

    var accepted = "no"
    var requestPressed = "no"
    var ridelater = "0"
    var setpickuppressed = "0"
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var requestStatus:Int = 0
    
    var loopingReqeustStatus:String! = ""
    
    var polyline = GMSPolyline()
    var marker = GMSMarker()
    var marker1 = GMSMarker()
    var markerloc1 = GMSMarker()
    var markerloc2 = GMSMarker()
    var markerloc3 = GMSMarker()
    var markerloc4 = GMSMarker()
    
    
    var myOrigin = CLLocation()
    var myDestination = CLLocation()

    var myloc1 = CLLocation()
    var myloc2 = CLLocation()
    var myloc3 = CLLocation()
    var myloc4 = CLLocation()
    
    var dropDestination = CLLocation()
    var driverLocation = CLLocation()
//    var placePicker : GMSPlacePicker = GMSPlacePicker(config: config)

    var placePicker: GMSPlace!

    var bearing = "default"
    
    var alert = 1

    var trips = "1"


    var payValue = "0"

    var viewAPIUrl = live_rider_url

    
    var noteString:String = ""

    
    // to calculate distacne
    var tripIsStarted = "no"
    var startLocation:CLLocation!
    var lastLocation: CLLocation!
    var traveledDistance:Double = 0

    
    var pickup = CLLocation()
    var dropup = CLLocation()
    
    
    var fetcher: GMSAutocompleteFetcher?
    var textField: UITextField?
    var resultText: UITextView?
    
    var imageName:String! = "endPinRound"
    var imageName1:String! = "markerloc1"
    var imageName2:String! = "markerloc2"
    var imageName3:String! = "markerloc3"
    var imageName4:String! = "markerloc4"


    var total = 0.0
    var distance1:CLLocation! // to get pickup location. Use first time only
    var distance2:CLLocation! // to get updated/ currenct location
    var distance3:CLLocation! // to set dynamic update from current locaiton / end location

    var ref : FIRDatabaseReference! = nil

    var req = "no"

//    var googleKey = "AIzaSyCP7fWdMSHNzfDwJMicupFGSjKIBdfMHvM"  // temp
    
    var placeID = ""

    var googleKey = "AIzaSyDMqU_zWVuR0FziY_i69DyWHtiNZj0gjY8"

    var firsttime = 1  // for trip status firsttime t is small

    
    var countryStatic:String! = "None"
    var getFirstCountry:String! = "None"
    var dropCountry:String! = "None"
    
    var arrayOfMaxSize:NSMutableArray=NSMutableArray()
    var arrayOfCarCategory:NSMutableArray=NSMutableArray()
    var arrayOfCarCategoryIds:NSMutableArray=NSMutableArray()
    var arrayOfMinFare:NSMutableArray=NSMutableArray()
    var arrayOfPrice_MIN:NSMutableArray=NSMutableArray()
    var arrayOfPrice_KM:NSMutableArray=NSMutableArray()

    var riderClickedCancelPass = "none"

    internal var riderClickedPayPage = "not"

    internal var riderClickedfareEstimate = "not"

    let amountDropDown = DropDown()

    lazy var dropDowns: [DropDown] = {
        return [
            self.amountDropDown,
        ]
    }()
    let terminalDropDown = DropDown()
    
    lazy var terminaldropDowns: [DropDown] = {
        return [
            self.terminalDropDown,
            ]
    }()
    let doorDropDown = DropDown()
    
    lazy var doordropDowns: [DropDown] = {
        return [
            self.doorDropDown,
            ]
    }()
     //var rippleViews: SMRippleView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.applicationEnteredForeground), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        
        self.incomingNotification1()
        
        definesPresentationContext = true
        
        
        //searchbarfunction
        searchview.isHidden = true
        self.searchBar?.delegate = self
        
        
        
        setupDropDowns()
        //ripple view
       //ripple()
        
        
      
//        for var i in 1...10{
//        self.rippleview1.isHidden = false
//        let fillColor: UIColor? = UIColor.black//UIColor(red: 33/255, green: 150/255, blue: 243/255, alpha: 1)
//         rippleViews = SMRippleView(frame: rippleview1.frame, rippleColor: UIColor.black, rippleThickness: 0.2, rippleTimer: 0.6, fillColor: fillColor, animationDuration: 4, parentFrame: self.view.frame)
//        self.view.addSubview(rippleViews!)
//        rippleViews?.startRipple()
//        }
        self.btnPickShareRideNumbers.isHidden = true
        self.total_tollfee.isHidden = true
        self.viewUpdateDrop.isHidden = true
        self.dropdownList.isHidden = true
        self.terminalView.isHidden = true
        self.doorlist.isHidden = true
        self.imageViewRideShare.image = UIImage(named : "unCheckBox.png")

        self.initListValue()
        dropdownList.delegate = self
        viewMapArcane.delegate = self
        if riderClickedPayPage == "click"{
         
            
         }
         else{
            self.getAllCredential()
            self.callCarListCategoryValues()
         }
        self.sliderCar.value = 0
        self.sliderCar.minimumValue = 0
        
        
        trayDownOffset = 160
        trayUp = viewCarCategory.center
        trayDown = CGPoint(x: viewCarCategory.center.x ,y: viewCarCategory.center.y + trayDownOffset)
        
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height

        
        licplate_no.layer.cornerRadius = 15
        
       // licplate_no.
        if screenHeight == 667{
            
         
            
        }
        else{
            
            
        }
        
        
       /* let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(ARMainMapVC.didPan))
        
        // Attach it to a view of your choice. If it's a UIImageView, remember to enable user interaction
        viewCarCategory.isUserInteractionEnabled = true
        viewCarCategory.addGestureRecognizer(panGestureRecognizer)*/

        
        let swipeUP : UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(ARMainMapVC.didPan))
        
        swipeUP.direction = UISwipeGestureRecognizerDirection.up
        
        let swipeDown : UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(ARMainMapVC.didPan))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        
        let swipeLeft : UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(ARMainMapVC.didPan))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        
        self.viewCarCategory.addGestureRecognizer(swipeUP)
        self.viewCarCategory.addGestureRecognizer(swipeDown)
        self.viewCarCategory.removeGestureRecognizer(swipeLeft)
        
        let ref = FIRDatabase.database().reference()
            ref.child("drivers_location").removeAllObservers()
            ref.child("drivers_data").removeAllObservers()

        self.ref = FIRDatabase.database().reference()

        
        self.trips = "1"
        self.bearing = "default"
        
        let ref1 = FIRDatabase.database().reference()
        
        let geoFire = GeoFire(firebaseRef: FIRDatabase.database().reference().child(byAppendingPath: "drivers_location"))

        self.viewCarCategory.isHidden = false
        
        self.labelSuvCircle.layer.cornerRadius = self.labelSuvCircle.bounds.size.height / 2
        self.labelSuvCircle.clipsToBounds = true

        self.labelSedanCircle.layer.cornerRadius = self.labelSedanCircle.bounds.size.height / 2
        self.labelSedanCircle.clipsToBounds = true

        self.labelHatchCircle.layer.cornerRadius = self.labelHatchCircle.bounds.size.height / 2
        self.labelHatchCircle.clipsToBounds = true

        self.imageViewCurrentTripDriver.layer.cornerRadius = imageViewCurrentTripDriver.frame.size.width / 2
        self.imageViewCurrentTripDriver.clipsToBounds = true
        
        self.labelSecondCircle.layer.cornerRadius = self.labelSecondCircle.bounds.size.height / 2
        self.labelSecondCircle.clipsToBounds = true
        
        self.labelThirdCircle.layer.cornerRadius = self.labelThirdCircle.bounds.size.height / 2
        self.labelThirdCircle.clipsToBounds = true

        // Do any additional setup after loading the view.
        
     //   self.placePicker = GMSPlace(config: config)
    
        self.driverPhoto.layer.cornerRadius = self.viewDriverImage.bounds.size.height / 2
        self.driverPhoto.clipsToBounds = true
        
      /*  self.labelMinute.layer.cornerRadius = self.viewDriverImage.bounds.size.height / 2
        self.labelMinute.clipsToBounds = true
        self.labelMinute.layer.borderWidth = 1.0
        self.labelMinute.layer.borderColor = UIColor.white.cgColor*/

        
        self.btnInfo.layer.cornerRadius = 15.0
        self.btnInfo.clipsToBounds = true
        self.licplate_no.layer.cornerRadius = 5.0
        self.licplate_no.clipsToBounds = true
        
        self.driverETAlbl.layer.cornerRadius = 15
        self.driverETAlbl.layer.masksToBounds = true
        
        self.btnNewRequest.backgroundColor = UIColor.white
        self.btnNewRequest.layer.cornerRadius = 3.0
        self.btnNewRequest.layer.borderWidth = 2.0
        self.btnNewRequest.layer.borderColor = UIColor.clear.cgColor
        self.btnNewRequest.layer.shadowColor = UIColor.lightGray.cgColor
        self.btnNewRequest.layer.shadowOpacity = 1.0
        self.btnNewRequest.layer.shadowRadius = 1.0
        self.btnNewRequest.layer.shadowOffset = CGSize(width: 0, height: 3)
        
       /* self.btnNewPay.backgroundColor = UIColor.white
        self.btnNewPay.layer.cornerRadius = 3.0
        self.btnNewPay.layer.borderWidth = 2.0
        self.btnNewPay.layer.borderColor = UIColor.clear.cgColor
        self.btnNewPay.layer.shadowColor = UIColor.lightGray.cgColor
        self.btnNewPay.layer.shadowOpacity = 1.0
        self.btnNewPay.layer.shadowRadius = 1.0
        self.btnNewPay.layer.shadowOffset = CGSize(width: 0, height: 3)*/
        
        self.viewPay.backgroundColor = UIColor.white
        self.viewPay.layer.cornerRadius = 3.0
        self.viewPay.layer.borderWidth = 2.0
        self.viewPay.layer.borderColor = UIColor.clear.cgColor
        self.viewPay.layer.shadowColor = UIColor.lightGray.cgColor
        self.viewPay.layer.shadowOpacity = 1.0
        self.viewPay.layer.shadowRadius = 1.0
        self.viewPay.layer.shadowOffset = CGSize(width: 0, height: 3)
        

        self.viewRideShareNumbers.backgroundColor = UIColor.white
        self.viewRideShareNumbers.layer.cornerRadius = 3.0
        self.viewRideShareNumbers.layer.borderWidth = 2.0
        self.viewRideShareNumbers.layer.borderColor = UIColor.clear.cgColor
        self.viewRideShareNumbers.layer.shadowColor = UIColor.lightGray.cgColor
        self.viewRideShareNumbers.layer.shadowOpacity = 1.0
        self.viewRideShareNumbers.layer.shadowRadius = 1.0
        self.viewRideShareNumbers.layer.shadowOffset = CGSize(width: 0, height: 3)

        
        self.buttonTopNewPickUp.backgroundColor = UIColor.white
        self.buttonTopNewPickUp.layer.cornerRadius = 3.0
        self.buttonTopNewPickUp.layer.borderWidth = 2.0
        self.buttonTopNewPickUp.layer.borderColor = UIColor.clear.cgColor
        self.buttonTopNewPickUp.layer.shadowColor = UIColor.lightGray.cgColor
        self.buttonTopNewPickUp.layer.shadowOpacity = 1.0
        self.buttonTopNewPickUp.layer.shadowRadius = 3.0
        self.buttonTopNewPickUp.layer.shadowOffset = CGSize(width: 0, height: 3)
        
        self.buttonTopUpdateDrop.backgroundColor = UIColor.white
        self.buttonTopUpdateDrop.layer.cornerRadius = 3.0
        self.buttonTopUpdateDrop.layer.borderWidth = 2.0
        self.buttonTopUpdateDrop.layer.borderColor = UIColor.clear.cgColor
        self.buttonTopUpdateDrop.layer.shadowColor = UIColor.lightGray.cgColor
        self.buttonTopUpdateDrop.layer.shadowOpacity = 1.0
        self.buttonTopUpdateDrop.layer.shadowRadius = 3.0
        self.buttonTopUpdateDrop.layer.shadowOffset = CGSize(width: 0, height: 3)
        
        self.terminalView.layer.cornerRadius = 3.0
        self.terminalView.layer.borderWidth = 2.0
        self.terminalView.layer.borderColor = UIColor.clear.cgColor
        self.terminalView.layer.shadowColor = UIColor.lightGray.cgColor
        self.terminalView.layer.shadowOpacity = 1.0
        self.terminalView.layer.shadowRadius = 3.0
        self.terminalView.layer.shadowOffset = CGSize(width: 0, height: 3)
        
        self.viewTopFareAddress.backgroundColor = UIColor.white
        self.viewTopFareAddress.layer.cornerRadius = 3.0
        self.viewTopFareAddress.layer.borderWidth = 2.0
        self.viewTopFareAddress.layer.borderColor = UIColor.clear.cgColor
        self.viewTopFareAddress.layer.shadowColor = UIColor.lightGray.cgColor
        self.viewTopFareAddress.layer.shadowOpacity = 1.0
        self.viewTopFareAddress.layer.shadowRadius = 3.0
        self.viewTopFareAddress.layer.shadowOffset = CGSize(width: 0, height: 3)
        
        self.viewTopFareEstimate.backgroundColor = UIColor.white
        self.viewTopFareEstimate.layer.cornerRadius = 3.0
        self.viewTopFareEstimate.layer.borderWidth = 2.0
        self.viewTopFareEstimate.layer.borderColor = UIColor.clear.cgColor
        self.viewTopFareEstimate.layer.shadowColor = UIColor.lightGray.cgColor
        self.viewTopFareEstimate.layer.shadowOpacity = 1.0
        self.viewTopFareEstimate.layer.shadowRadius = 3.0
        self.viewTopFareEstimate.layer.shadowOffset = CGSize(width: 0, height: 3)
        
        
        self.viewTopFareDollar.backgroundColor = UIColor.white
        self.viewTopFareDollar.layer.cornerRadius = 3.0
        self.viewTopFareDollar.layer.borderWidth = 2.0
        self.viewTopFareDollar.layer.borderColor = UIColor.clear.cgColor
        self.viewTopFareDollar.layer.shadowColor = UIColor.lightGray.cgColor
        self.viewTopFareDollar.layer.shadowOpacity = 1.0
        self.viewTopFareDollar.layer.shadowRadius = 3.0
        self.viewTopFareDollar.layer.shadowOffset = CGSize(width: 0, height: 3)
        
        
        self.btnNewTopBack.backgroundColor = UIColor.white
        self.btnNewTopBack.layer.cornerRadius = 3.0
        self.btnNewTopBack.layer.borderWidth = 2.0
        self.btnNewTopBack.layer.borderColor = UIColor.clear.cgColor
        self.btnNewTopBack.layer.shadowColor = UIColor.lightGray.cgColor
        self.btnNewTopBack.layer.shadowOpacity = 1.0
        self.btnNewTopBack.layer.shadowRadius = 1.0
        self.btnNewTopBack.layer.shadowOffset = CGSize(width: 0, height: 3)
        
        self.buttonTopNewChange.backgroundColor = UIColor.white
        self.buttonTopNewChange.layer.borderWidth = 2.0
        self.buttonTopNewChange.layer.borderColor = UIColor.clear.cgColor
        self.buttonTopNewChange.layer.shadowColor = UIColor.lightGray.cgColor
        self.buttonTopNewChange.layer.shadowOpacity = 1.0
        self.buttonTopNewChange.layer.shadowRadius = 5.0
        self.buttonTopNewChange.layer.shadowOffset = CGSize(width: 0, height: 3)
        
        
        self.viewWholeTopFareEstimate.isHidden = true

        
        self.viewBlurCurrentTrip.backgroundColor = UIColor.black
        self.viewBlurCurrentTrip.alpha = 0.5
        
       /* self.buttonTopNewNavigationBar.backgroundColor = UIColor.white
        self.buttonTopNewNavigationBar.layer.borderWidth = 2.0
        self.buttonTopNewNavigationBar.layer.borderColor = UIColor.clear.cgColor
        self.buttonTopNewNavigationBar.layer.shadowColor = UIColor.lightGray.cgColor
        self.buttonTopNewNavigationBar.layer.shadowOpacity = 1.0
        self.buttonTopNewNavigationBar.layer.shadowRadius = 1.0
        self.buttonTopNewNavigationBar.layer.shadowOffset = CGSize(width: 0, height: 3)*/
        
        let value = UserDefaults.standard.object(forKey: "userid")
        
        self.appDelegate.userid = value as! String!
        
        
        print(" !!! \(value)")
        
        if(self.ridelater == "0"){
        self.isridelaterstarted()
        }
        self.Referralearning()
        
        self.navigationController?.isNavigationBarHidden = true
        
        self.configureLinearProgressBar()
        
        labelPickupCentre.layer.cornerRadius = 15.0
        labelPickupCentre.clipsToBounds = true
        
        viewTopDrop.isHidden = true
        btnNewTopBack.isHidden = true
        buttonTopNewPickUp.isHidden = false
        labelTopPickupCentre.isHidden = true
        viewFareEstimate.isHidden = true
        marker.map = nil
        
        self.viewMapArcane.padding = UIEdgeInsetsMake(100, 0, 100, 0)
        
        let camera = GMSCameraPosition.camera(withLatitude: (self.appDelegate.locate.coordinate.latitude),longitude: (self.appDelegate.locate.coordinate.longitude),zoom: 16)
        
        self.viewMapArcane.animate(to: camera)

        
        
        do {
            // Set the map style by passing a valid JSON string.
           // self.viewMapArcane.mapStyle = try GMSMapStyle(jsonString: maplocStyle1)
            
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
        //  self.viewAAA.camera = camera
        
        //UISearchBar.appearance().backgroundColor = UIColor.black
        //UISearchBar.appearance().tintColor = UIColor.black
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.activityType = .fitness

        if(CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways)
        {
            if let loc = locationManager.location {
                currentLocation = loc
            }
            
        }
        

        
        self.locationTracker.addLocationChangeObserver { (result) -> () in
            switch result {
            case .success(let location):
                let coordinate = location.physical.coordinate
                let locationString = "\(coordinate.latitude), \(coordinate.longitude)"
                
                self.dynamicLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
                
                let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude,
                                                      longitude: coordinate.longitude,
                                                      zoom: 16)
                
                let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
                mapView.isMyLocationEnabled = true
                mapView.delegate = self
                
                // to avoid infinite loop method camera position in google map view
                
                if(self.firstTime == 1){
                    
                    
                    self.currentLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
                    var tripidd = ""
                    
                    if UserDefaults.standard.value(forKey: "trip_id") != nil{
                      
                        tripidd = (UserDefaults.standard.value(forKey: "trip_id") as? String)!
                        tripidd = tripidd.replacingOccurrences(of: "Optional(", with: "")
                        tripidd = tripidd.replacingOccurrences(of: ")", with: "")
                        tripidd = tripidd.replacingOccurrences(of: "\"", with: "")
                        
                    }

                    if tripidd == ""{
                        
                        self.autoComplete()
                        
                        self.getCurrentAddress(myLocation: self.currentLocation)
                        
                        self.nearbyLocation = self.currentLocation
                        
                        
                    }
                    
                    
                    self.updateLocation()

                    
                    do {
                    
                        // Set the map style by passing a valid JSON string.
                   //     self.viewMapArcane.mapStyle = try GMSMapStyle(jsonString: maplocStyle1)
                        
                        
                    } catch {
                        NSLog("One or more of the map styles failed to load. \(error)")
                    }
                    
                    self.viewMapArcane.camera = camera
                    
                    self.firstTime = 2
                }
                
                
            case .failure:
                
                
                break
                
            }
        }
        
        
        
        self.viewMapArcane.delegate = self
        self.viewMapArcane.isMyLocationEnabled = true
        self.viewMapArcane.settings.rotateGestures = true
        //self.viewMapArcane.settings.compassButton = true
        self.viewMapArcane.settings.myLocationButton = true
        self.viewMapArcane.settings.indoorPicker = true
        self.viewMapArcane.isIndoorEnabled = true
        
        
        viewCancelRequest.layer.cornerRadius = viewCancelRequest.frame.size.height / 2
        viewCancelRequest.clipsToBounds = true
        
        navigationController?.isNavigationBarHidden = true
        
        UINavigationBar.appearance().backgroundColor = UIColor.clear
    
        
    
        searchResultController = SearchResultsController()
        searchResultController.delegate = self
        gmsFetcher = GMSAutocompleteFetcher()
        gmsFetcher.delegate = self
        self.viewMapArcane.addSubview(viewPickupCentre)
        self.viewMapArcane.addSubview(viewRequest)
        self.viewMapArcane.addSubview(viewPay)
        self.viewMapArcane.addSubview(driverETAlbl)
        
        
        self.viewMapArcane.bringSubview(toFront: viewRideShareNumbers)
       // self.viewMapArcane.addSubview(viewRideShareNumbers)
        self.viewMapArcane.addSubview(viewFareEstimate)
        self.viewMapArcane.addSubview(viewTopLeftCancel)
        self.viewMapArcane.addSubview(viewWholeTopFareEstimate)
        self.viewMapArcane.addSubview(requestDisableView)
        self.viewMapArcane.addSubview(viewCancelRequest)
        self.viewMapArcane.addSubview(viewLineNewBar)
        self.viewMapArcane.addSubview(labelVer)
        self.viewMapArcane.addSubview(btnInfo)
        self.viewMapArcane.addSubview(licplate_no)
        self.viewMapArcane.addSubview(terminalView)
        self.viewMapArcane.addSubview(viewCurrentTrip)
        
       // self.viewPickupCentre.addsubview(rippleViews!)
//        self.viewMapArcane.addSubview(rippleViews!)
//        self.viewMapArcane.addSubview(rippleview1)

        self.requestDisableView.isHidden = true
        self.driverETAlbl.isHidden = true
     //   self.driverDetail.isHidden = true
        self.statusView.isHidden = true
        self.btnInfo.isHidden = true
       // self.licplate_no.isHidden = true
        self.viewMapArcane.addSubview(viewRequest)
       /// self.viewMapArcane.addSubview(progressViewOutlet)
        self.viewMapArcane.addSubview(driverDetail)
        self.viewMapArcane.addSubview(statusView)
        
        self.driverDetail.isHidden = true
        self.viewCurrentTrip.isHidden = true
        self.viewBlurCurrentTrip.isHidden = true
        
   ////     progressViewOutlet.transform = progressViewOutlet.transform.scaledBy(x: 1, y: 5)
        
        
        
      /*  if(trip_id != "" || trip_id !=+ "nil"){
            self.getTripStatus()                      //raj
        }*/

       // self.placeAutocomplete()
        
        /*
         CATransaction.begin()
         CATransaction.setAnimationDuration(0.0)
         let marker1 = GMSMarker()
         marker1.snippet = "Drop Location"
         marker1.appearAnimation = kGMSMarkerAnimationNone
         marker1.icon = UIImage(named: "Drivers.png")
         marker1.map = self.viewMapArcane
         marker1.position = CLLocationCoordinate2D(latitude: 19.0600, longitude: 72.8900)
         
         CATransaction.commit() */

        
     /*   let directionsAPI = PXGoogleDirections(apiKey: "AIzaSyCuhsdolQuBDwCyapB9fhqgw_ZIhlGAzBk",
                                               from: PXLocation.coordinateLocation(CLLocationCoordinate2DMake(9.9239, 78.1140)),
                                               to: PXLocation.coordinateLocation(CLLocationCoordinate2DMake(9.8233, 77.9881)))

        directionsAPI.calculateDirections({ response in
            switch response {
            case let .error(_, error):
                // Oops, something bad happened, see the error object for more information
                break
            case let .success(request, routes):
                // Do your work with the routes object array here
                print("success")
                print(routes.count)
                print(routes[0])
                
                let direction = PXGoogleDirectionsRoute()
                print(direction.overviewPolyline)
                direction.overviewPolyline = directionsAPI.currentRoute.overviewPolyline
                print(direction.overviewPolyline)
//                direction.drawOnMap(self.viewMapArcane)
                let path: GMSPath = GMSPath(fromEncodedPath: direction.overviewPolyline!)!
                let polyline = GMSPolyline(path: path)
                
                polyline.strokeWidth = 1.5
                polyline.strokeColor = .black
                polyline.geodesic = true
                polyline.map = self.viewMapArcane
            

                break
            }
        })  */
        
        self.firstTime = 1
        self.locationManager.startUpdatingHeading()
        
        if screenHeight == 568{
            
            
            self.viewPay.frame = CGRect(x:7.3, y:440, width:305, height:75)
             self.lineLabelnew.frame = CGRect(x:0, y:38, width:305, height:1)
            
            self.buttonTopNewChange.frame = CGRect(x:205, y:5, width:82, height:30)
            self.viewFareEstimate.frame = CGRect(x:7.3, y:479, width:305, height:21)
            self.viewRideShareNumbers.frame = CGRect(x:7.3, y:407, width:305, height:30)
            self.btnPickShareRideNumbers.frame = CGRect(x:262, y:0, width:46, height:30)
            
            
        }
        
        if screenHeight == 667{
              //self.lineLabelnew.frame = CGRect(x:0, y:42, width:359, height:1)
            
            self.viewFareEstimate.frame = CGRect(x:7.3, y:568, width:359, height:40)
            
        }
        
        if screenHeight == 736{
            
            self.viewPay.frame = CGRect(x:7.3, y:600, width:399, height:85)
            self.lineLabelnew.frame = CGRect(x:0, y:42, width:399, height:1)
            self.buttonTopNewChange.frame = CGRect(x:307, y:5, width:82, height:30)
            self.viewFareEstimate.frame = CGRect(x:7.3, y:645, width:399, height:21)
            self.viewRideShareNumbers.frame = CGRect(x:7.3, y:567, width:399, height:30)
            self.btnPickShareRideNumbers.frame = CGRect(x:350, y:0, width:46, height:30)
            
            
        }
       
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let place = self.places[(indexPath as NSIndexPath).row]
        cell.textLabel!.text = place.description
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.searchBar.resignFirstResponder()
        self.searchBar.text = self.places[(indexPath as NSIndexPath).row].description
        searchTable.isHidden = true
        searchview.isHidden = true
        
        
        let urlpath = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=\(self.places[(indexPath as NSIndexPath).row].description)&key=\(googleKey)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        // to get place id
        
        print(urlpath!)
        let url = URL(string: urlpath!)
        // print(url!)
        let task = URLSession.shared.dataTask(with: url! as URL) { (data, response, error) -> Void in
            // 3
            
            do {
                if data != nil{
                    
                    let dic = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves) as! NSDictionary
                    
                    print(dic)
                    print(dic["predictions"]!)  // array
                    if let placeArray:NSArray = dic["predictions"] as? NSArray{
                        
                        print(placeArray.count)
                        if(placeArray.count == 0)
                        {
                            
                        }
                        else
                        {
                            if let predictions:NSDictionary = placeArray[0] as? NSDictionary{
                                print(predictions)
                                
                                if let place_id:String = predictions["place_id"] as? String{
                                    print(place_id)
                                    if(place_id != ""){
                                        print("placeid is not empty")
                                        
                                        self.placeID = place_id
                                        
                                        self.getLatLong(place_id: place_id,result:self.places[(indexPath as NSIndexPath).row].description)
                                        
                                        // to get lat and long with address
                                        
                                        
                                    }
                                }
                            }
                        }
                    }
                    
                    
                    
                    
                    var place_id = ""
                    // 4
                    
                    if (place_id != ""){
                        // https://maps.googleapis.com/maps/api/place/details/json?placeid=ChIJ8YeFgYjFADsRgSwrS69ttKk&key=AIzaSyD_nwCI7RqGsWkwWeEoJb-KkdVaIfDhFxc
                        // to get address , lat and long
                        
                        
                        let dic = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves) as! NSDictionary
                        
                        let lat =   (((((dic.value(forKey: "results") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "geometry") as! NSDictionary).value(forKey: "location") as! NSDictionary).value(forKey: "lat")) as! Double
                        
                        let lon =   (((((dic.value(forKey: "results") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "geometry") as! NSDictionary).value(forKey: "location") as! NSDictionary).value(forKey: "lng")) as! Double
                        
                        
                        print("\(lat),\(lon)")
                        
                        self.locateWithLongitude(lon, andLatitude: lat, andTitle: self.places[(indexPath as NSIndexPath).row].description)
                    }
                }
                
            }catch {
                print("Error")
            }
            
            
        }
        // 5
        task.resume()
    }
    
    
    func getLatLong(place_id: String, result: String){
        
        
        let urlPlace = "https://maps.googleapis.com/maps/api/place/details/json?placeid=\(place_id)&key=\(googleKey)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        //AIzaSyD_nwCI7RqGsWkwWeEoJb-KkdVaIfDhFxc".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        // to get place id
        
        
        print(urlPlace!)
        let url = URL(string: urlPlace!)
        // print(url!)
        let task1 = URLSession.shared.dataTask(with: url! as URL) { (data, response, error) -> Void in
            // 3
            
            do {
                if data != nil{
                    
                    let dic = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves) as! NSDictionary
                    
                    print(dic)
                    if let result1:NSDictionary = dic["result"] as? NSDictionary{
                        // to get lat and long
                        if let geometry:NSDictionary = result1["geometry"] as? NSDictionary{
                            
                            if let location:NSDictionary = geometry["location"] as? NSDictionary{
                                
                                let lat = location["lat"]
                                let long = location["lng"]

                                print("\(lat!),\(long!)")
                                self.locateWithLongitude(long! as! Double, andLatitude: lat! as! Double, andTitle: result)
                                
                            }
                        }
                    }
                    
                }
                
            }catch {
                print("Error")
            }
        }
        
        
        task1.resume()
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchText == "") {
            self.places = []
            self.searchTable.isHidden = true
        } else {
            self.searchTable.isHidden = false
            getPlaces(searchString: searchText)
        }
    }
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        // Stop doing the search stuff
        // and clear the text in the search bar
        searchBar.text = ""
        self.searchview.isHidden = true
       
    }
    
    func getPlaces(searchString: String) {
        var request = requestForSearch(searchString)
        
        var session = URLSession.shared
        var task = session.dataTask(with: request) { data, response, error in
            self.handleResponse(data, response: response as? HTTPURLResponse, error: error as NSError!)
            
        }
        
        task.resume()
    }
    
    func handleResponse(_ data: Data!, response: HTTPURLResponse!, error: NSError!) {
        if let error = error {
            print("GooglePlacesAutocomplete Error: \(error.localizedDescription)")
            return
        }
        if response == nil {
            print("GooglePlacesAutocomplete Error: No response from API")
            return
        }
        if response.statusCode != 200 {
            print("GooglePlacesAutocomplete Error: Invalid status code \(response.statusCode) from API")
            return
        }
        let serializationError: NSError? = error
        let json: NSDictionary = (try! JSONSerialization.jsonObject(
            with: data,
            options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
        if let error = serializationError {
            print("GooglePlacesAutocomplete Error: \(error.localizedDescription)")
            return
        }
        DispatchQueue.main.async(execute: {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if let predictions = json["predictions"] as? Array<AnyObject> {
                self.places = predictions.map { (prediction: AnyObject) -> Place in
                    return Place(
                        id: prediction["id"] as! String,
                        description: prediction["description"] as! String
                    )
                }
                self.searchTable.reloadData()
                self.searchTable.isHidden = false
            }
        })
    }
    
    func requestForSearch(_ searchString: String) -> URLRequest {
        
        let searchString = searchString.replacingOccurrences(of: "Optional", with: "")
        let place_type = placeType.description.replacingOccurrences(of: "Optional", with: "")
        let key_google = googleKey.replacingOccurrences(of: "Optional", with: "")
        
        print("print1\(searchString)")
        print("print2\(place_type)")
        print("print3\(key_google)")
        
        let params = [
            "input": searchString,
            //"type": "(\(placeType.description))",
            //"type": "",
            "key": googleKey
        ]
        
        print("Place url ->  https://maps.googleapis.com/maps/api/place/autocomplete/json?\(query(params as [String : Any] as [String : AnyObject]))")
        
        var url1 = "https://maps.googleapis.com/maps/api/place/autocomplete/json?\(query(params as [String : Any] as [String : AnyObject]))"
        print("Place->\(url1)")
        
        let url2 = url1.replacingOccurrences(of: "Optional", with: "")
        let url3 = url2.replacingOccurrences(of: "%28", with: "")
        let url4 = url3.replacingOccurrences(of: "%29", with: "")
        
        return NSMutableURLRequest(
            url: URL(string: url4)!
            ) as URLRequest
        
        
    }
    func query(_ parameters: [String: AnyObject]) -> String {
        var components: [(String, String)] = []
        for key in Array(parameters.keys).sorted(by: <) {
            let value: AnyObject! = parameters[key]
            components += [(escape(key), escape("\(value!)"))]
        }
        return (components.map{"\($0)=\($1)"} as [String]).joined(separator: "&")
    }
    func escape(_ string: String) -> String {
        let legalURLCharactersToBeEscaped: CFString = ":/?&=;+!@#$()',*" as CFString
        return CFURLCreateStringByAddingPercentEscapes(nil, string as CFString!, nil, legalURLCharactersToBeEscaped, CFStringBuiltInEncodings.UTF8.rawValue) as String
    }



//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        self.rippleViews?.startRipple()
//       rippleViews?.center = self.rippleview1.center
//        self.rippleview1.isHidden = false
//        let fillColor: UIColor? = UIColor.black//UIColor(red: 33/255, green: 150/255, blue: 243/255, alpha: 1)
//        rippleViews = SMRippleView(frame: rippleview1.frame, rippleColor: UIColor.black, rippleThickness: 0.2, rippleTimer: 0.6, fillColor: fillColor, animationDuration: 4, parentFrame: self.view.frame)
//        self.view.addSubview(rippleViews!)
//    }
//
    
    func applicationEnteredForeground(notification: NSNotification) {
        print("Application Entered Foreground")
        if(checked == "yes"){
        self.imageViewRideShare.image = UIImage(named : "checkBox.png")
        }
        else{
        self.imageViewRideShare.image = UIImage(named : "unCheckBox.png")
        }
    }
    
    func isridelaterstarted(){
        
        
        let ref = FIRDatabase.database().reference()
        
        let geoFire = GeoFire(firebaseRef: ref.child("ride_later"))
      
        print(self.appDelegate.userid!)
        
        if(self.appDelegate.userid! != nil || self.appDelegate.userid! != "" || self.appDelegate.userid! != "null"){
            
            ref.child("ride_later").child("\(self.appDelegate.userid!)")
                .queryOrdered(byChild: "status")
                .observe(.childChanged, with: { snapshot in
                    
           // ref.child("ride_later").child("\(self.appDelegate.userid!)").observe(.childChanged, with: { (snapshot) in
            
            print("updating")
            let status1 = snapshot.key as Any
            print(status1)
            
            var status = "\(status1)"
            status = status.replacingOccurrences(of: "Optional(", with: "")
            status = status.replacingOccurrences(of: ")", with: "")
            print(status)
                    
            
                    
            ref.child("ride_later").child("\(self.appDelegate.userid!)").child("\(status1)").child("status").observeSingleEvent(of: .value, with: { (snapshot) in
                        
                
                let status12 = snapshot.value as Any
                print(status12)
                var reqstatus = "\(status12)"
                reqstatus = reqstatus.replacingOccurrences(of: "Optional(", with: "")
                reqstatus = reqstatus.replacingOccurrences(of: ")", with: "")
                print(reqstatus)
                if(reqstatus != "0"){
                if(reqstatus == "ready_for_ride"){
                    let warning = MessageView.viewFromNib(layout: .CardView)
                    warning.configureTheme(.warning)
                    warning.configureDropShadow()
                    let iconText = "" //"🤔"
                    warning.configureContent(title: "", body: "Your ride will start in a while as per your ride later request", iconText: iconText)
                    warning.button?.isHidden = true
                    var warningConfig = SwiftMessages.defaultConfig
                    warningConfig.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
                    SwiftMessages.show(config: warningConfig, view: warning)
                    
                    var ref1 = FIRDatabase.database().reference().child("ride_later").child("\(self.appDelegate.userid!)").child("\(status1)")
                    ref1.updateChildValues(["status": "0"])
                }
                else if(reqstatus == "request"){
                    self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ARMainMapVC.setProgressBar), userInfo: nil, repeats: true)

                    self.appDelegate.request_id = status
                    
                    self.req = "yes"
                    self.buttonTopPickUp.isEnabled = false
                    self.buttonTopDrop.isEnabled = false
                    
                    self.requestDisableView.isHidden = false
                    self.btnLeft.isUserInteractionEnabled = false
                    
                    //self.getNextPoseData()
                    self.requestPressed = "yes" // to stop updating location header after request given.
                    
                    self.viewPickupCentre.isHidden = true
                    self.viewPay.isHidden = true
                    self.viewFareEstimate.isHidden = true
                    self.viewRideShareNumbers.isHidden = true
                    self.viewTopLeftCancel.isHidden = true
                    self.viewTopLeftMenu.isHidden = false
                    self.viewRequest.isHidden = true
                    //// self.progressViewOutlet.isHidden = false
                    self.statusView.isHidden = false
                    self.statusLabel.text = "REQUESTING"
                    self.viewLineNewBar.isHidden = false
                    self.linearBar.startAnimation()
                    self.viewMapArcane.padding = UIEdgeInsetsMake(100, 0, 100, 0)
                    
                    self.viewMapArcane.settings.myLocationButton = true
                    self.viewMapArcane.settings.indoorPicker = true
                    self.viewMapArcane.isIndoorEnabled = true
                    
                    self.viewCarCategory.isHidden = true
                    
                    self.viewCancelRequest.isHidden = false
                    
                    //// self.progressViewOutlet.setProgress(0, animated: false)
                    
                    self.progressLabel?.text = "0%"
                    
                    self.alert = 1
                    
                    self.requestStatus = 1
                    
                    var ref1 = FIRDatabase.database().reference().child("ride_later").child("\(self.appDelegate.userid!)").child("\(status1)")
                    ref1.updateChildValues(["status": "0"])
                    
                    if(self.ridelatercount == 0){
                        self.ridelatercount+=1
                        self.processURL()
                        self.getProcessRequest()
                    }
                }
                else{
                }
                }
            })
        })
        }
        
    }
    
    func incomingNotification1(){
        
        let ref = FIRDatabase.database().reference()
        
        let geoFire = GeoFire(firebaseRef: ref.child("cashoption"))
        
        // let geoFire = GeoFire(firebaseRef: ref.child("drivers_data/5857c2bada71b4d9708b4567/"))
        
        // print(geoFire!.firebaseRef(forLocationKey: "geolocation"))
        
        // updated
        
        ref.child("cashoption").observe(.childChanged, with: { (snapshot) in
            
            print("updating")
            let status1 = snapshot.value as Any
            print(status1)
            var status = "\(status1)"
            status = status.replacingOccurrences(of: "Optional(", with: "")
            status = status.replacingOccurrences(of: ")", with: "")
            print(status)
            
            if(self.imageViewCash.image == UIImage(named : "ub__payment_type_cash_no.png") || self.imageViewCash.image == UIImage(named : "ub__payment_type_cash.png")){
            if(status == "off"){
               
                self.imageViewCash.image = UIImage(named : "ub__payment_type_cash_no.png")
                self.appDelegate.cashno = "1"
                
            }
            else{
                self.imageViewCash.image = UIImage(named : "ub__payment_type_cash.png")
                self.appDelegate.cashno = "0"
            }
            }
            
            //
            
            
        })
        
    }

    func setupDropDowns() {
        
        setupAmountDropDown()
    }

    
    func setupAmountDropDown() {
        var door1 = ["Door 4", "Door 5", "Door 6", "Door 7"]
        var door2 = ["Door 1", "Door 2", "Door 3"]
        var door3 = ["B1 Door 1", "B2 Door 2", "B1 Door 3"]
        
        //Share Ride
        amountDropDown.anchorView = btnPickShareRideNumbers
        amountDropDown.bottomOffset = CGPoint(x: 0, y: btnPickShareRideNumbers.bounds.height)
        amountDropDown.dataSource = [
            "1",
            "2",
            "3",
            "4",
            "5",
        ]
        amountDropDown.selectionAction = { [unowned self] (index, item) in
            self.btnPickShareRideNumbers.setTitle(item, for: .normal)
        }
        
        
        //Terminal Action
        terminalDropDown.anchorView = terminallist
        terminalDropDown.bottomOffset = CGPoint(x: 0, y: terminallist.bounds.height)
        terminalDropDown.dataSource = [
            "Terminal 1, Level 1 Arrivals",
            "Terminal 2, Level 2 Arrivals",
            "Terminal 3, B1 Arrivals",
            "Terminal 4",
        ]
        terminalDropDown.selectionAction = { [unowned self] (index, item) in
            self.terminallist.setTitle(item, for: .normal)
            //doorDropDown
            self.terminallist.isHidden = true
            self.doorlist.isHidden = false
            self.terminalName.text = item
            self.doorDropDown.anchorView = self.doorlist
            self.doorDropDown.bottomOffset = CGPoint(x: 0, y: self.doorlist.bounds.height)
            if(item == "Terminal 1, Level 1 Arrivals"){
                self.doorDropDown.dataSource = door1
            }else if(item == "Terminal 2, Level 2 Arrivals"){
                self.doorDropDown.dataSource = door2
            }else{
                self.doorDropDown.dataSource = door3
            }
            let teminal_name = self.terminalName.text!
            self.doorDropDown.selectionAction = { [unowned self] (index1, item1) in
                self.doorlist.setTitle(item1, for: .normal)
                self.terminalName.text = "\(teminal_name),\(item1)"
            }
        }
    }
    @IBAction func resetTerminalAct(_ sender: Any) {
        self.terminallist.isHidden = false
        self.doorlist.isHidden = true
        self.terminalName.text = "Select Your Pickup area"
        self.doorlist.setTitle("Choose Door #", for: .normal)
    }
    @IBAction func teminalOkAct(_ sender: Any) {
        let ref1 = FIRDatabase.database().reference().child("riders_location").child(self.appDelegate.userid!)
        ref1.updateChildValues(["pickup_terminal": self.terminalName.text!])
    }
    
    func didPan(_ sender: UISwipeGestureRecognizer)
    {
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        let value = self.viewCarCategory.frame
        
        switch sender.direction {
        case UISwipeGestureRecognizerDirection.up:
            print("SWIPED up")
           
            if screenHeight == 667{
                
                self.viewCarCategory.frame = CGRect(x: 0, y: 417, width: screenWidth, height: 250)
            }
            else if screenHeight == 568{
                
                self.viewCarCategory.frame = CGRect(x: 0, y: 315, width: screenWidth, height: 250)
            }
            else if screenHeight == 736{
                
                self.viewCarCategory.frame = CGRect(x: 0, y: 486, width: screenWidth, height: 250)
            }
            else{
                
                self.viewCarCategory.frame = CGRect(x: 0, y: 486, width: screenWidth, height: 250)
            }
            
        case UISwipeGestureRecognizerDirection.down:
            
            self.viewCarCategory.frame.origin.y = screenHeight-90
            
            print("SWIPED down")
            
        case UISwipeGestureRecognizerDirection.left:
            
            
            
            break
        default:
            break
        }
        
       /* let location = sender.location(in: viewCarCategory)
        let velocity = sender.velocity(in: viewCarCategory)
        let translation = sender.translation(in: viewCarCategory)
        
        if sender.state == .began {
            print("Gesture began")
            trayOriginalCenter = viewCarCategory.center
            
        } else if sender.state == .changed {
            print("Gesture is changing")
            viewCarCategory.center = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y + translation.y)
            
        } else if sender.state == .ended {
            print("Gesture ended")
            
            if velocity.y > 0 {
                UIView.animate(withDuration: 0.3) {
                    self.viewCarCategory.center = self.trayDown
                }
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.viewCarCategory.center = self.trayUp
                }
            }
        }*/

    }
    
    func autoComplete(){
        
        let neBoundsCorner = CLLocationCoordinate2D(latitude: self.currentLocation.coordinate.latitude,
                                                    longitude: self.currentLocation.coordinate.longitude)
        let swBoundsCorner = CLLocationCoordinate2D(latitude: self.currentLocation.coordinate.latitude,
                                                    longitude: self.currentLocation.coordinate.longitude)
        let bounds = GMSCoordinateBounds(coordinate: neBoundsCorner,
                                         coordinate: swBoundsCorner)
        
        // Set up the autocomplete filter.
        let filter = GMSAutocompleteFilter()
        filter.type = .establishment
        
        // Create the fetcher.
        fetcher = GMSAutocompleteFetcher(bounds: bounds, filter: filter)
        fetcher?.delegate = self
        
        textField = UITextField(frame: CGRect(x: 5.0, y: 10.0,
                                              width: view.bounds.size.width - 5.0,
                                              height: 44.0))
        textField?.autoresizingMask = .flexibleWidth
        textField?.addTarget(self, action: #selector(textFieldDidChange(textField:)),
                             for: .editingChanged)
        
        resultText = UITextView(frame: CGRect(x: 0, y: 45.0,
                                              width: view.bounds.size.width,
                                              height: view.bounds.size.height - 45.0))
        resultText?.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        resultText?.text = "No Results"
        resultText?.isEditable = false
        
        //view.addSubview(textField!)
        //view.addSubview(resultText!)



    }
    @IBAction func btnFareEstimateNewAction(_ sender: Any) {
        
        
        
        if labelTopDrop.text == "Set Drop Location"{
            
            self.viewWholeTopFareEstimate.isHidden = true
            
            self.buttonTopPickUp.isEnabled = true
            self.buttonTopDrop.isEnabled = true
            
            let warning = MessageView.viewFromNib(layout: .CardView)
            warning.configureTheme(.warning)
            warning.configureDropShadow()
            let iconText = "" //"🤔"
            warning.configureContent(title: "", body: "Enter Destination Location", iconText: iconText)
            warning.button?.isHidden = true
            var warningConfig = SwiftMessages.defaultConfig
            warningConfig.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
            SwiftMessages.show(config: warningConfig, view: warning)
            
            
        }
        else{
            
            let value = UserDefaults.standard.object(forKey: "payValue") as! String
            if value == "not"{
                let warning = MessageView.viewFromNib(layout: .CardView)
                warning.configureTheme(.warning)
                warning.configureDropShadow()
                let iconText = ""
                warning.configureContent(title: "", body: "Please add your credit or debit card details to book a ride", iconText: iconText)
                warning.button?.isHidden = true
                var warningConfig = SwiftMessages.defaultConfig
                warningConfig.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
                
                SwiftMessages.show(config: warningConfig, view: warning)
                return

            }
            self.fareestimateclicked = "1"
            self.viewTopLeftCancel.isHidden = true
            self.riderClickedfareEstimate = "click"
            self.viewTopLeftMenu.isHidden = true
            self.viewRequest.isHidden = true
            self.addressView.isHidden = true
            self.viewWholeTopFareEstimate.isHidden = false
            self.viewCarCategory.isHidden = true
            self.btnNewRequest.isHidden = true
            
            let catCategory = self.carCategoryPass
            
            if catCategory == ""{
                
                self.carCategoryPass = "Standard"
            }
            else{
                
                self.carCategoryPass = catCategory
            }
            
            print("car fare /\(self.carCategoryPass)")
            
            let catIndex:Int = self.arrayOfCarCategory.index(of: self.carCategoryPass)
            var carCatId:NSString = ""
            
            carCatId = self.arrayOfCarCategoryIds.object(at: catIndex) as! NSString
            
            print(self.appDelegate.pickupLocation.coordinate.latitude)
            print(self.appDelegate.pickupLocation.coordinate.longitude)
            print(self.appDelegate.dropLocation.coordinate.latitude)
            print(self.appDelegate.dropLocation.coordinate.longitude)
            
            var urlstring:String = "\(live_request_url)requests/estFareCalc/start_lat/\(self.appDelegate.pickupLocation.coordinate.latitude)/start_long/\(self.appDelegate.pickupLocation.coordinate.longitude)/end_lat/\(self.appDelegate.dropLocation.coordinate.latitude)/end_long/\(self.appDelegate.dropLocation.coordinate.longitude)/category_id/\(carCatId)"
            
            urlstring = urlstring.replacingOccurrences(of: "Optional(", with: "")
            urlstring = urlstring.replacingOccurrences(of: ")", with: "")
            urlstring = urlstring.replacingOccurrences(of: "\"", with: "")
            urlstring = urlstring.replacingOccurrences(of: ",", with: "+")
            urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
            
            Alamofire.request(urlstring).responseJSON { (response) in
                do{
                let readableJSon:NSArray! = try JSONSerialization.jsonObject(with: response.data!, options: .mutableContainers) as! NSArray
                
                
                if let value:NSDictionary = readableJSon[0] as? NSDictionary{
                    
                    if let estFare:NSDictionary = value["est_fare"] as? NSDictionary{
                        if let estCost:Float = estFare["est_cost"] as? Float{
                        let pickUp = self.labelTopPickup.text!
                        let drop = self.labelTopDrop.text!
                        self.labelTopFarePickUp.text = pickUp
                        self.labelTopFareDrop.text = drop
                        self.labelTopFareCar.text = self.carCategoryPass
                        self.labelTopFareDollar.text = "$\(estCost)"
                        }
                    }
                }
                }
                catch{
                    
                    print(error)
                    
                    
                    
                }
            }
            
//            let userLocation:CLLocation = CLLocation(latitude: Double(self.appDelegate.pickupLocation.coordinate.latitude), longitude: Double(self.appDelegate.pickupLocation.coordinate.longitude))
//            
//            let priceLocation:CLLocation = CLLocation(latitude: Double(self.appDelegate.dropLocation.coordinate.latitude), longitude: Double(self.appDelegate.dropLocation.coordinate.longitude))
//            
//            let distance = String(format: "%.2f", userLocation.distance(from: priceLocation)/1000)
//            
//            
//            print("Distance is KM is:: \(distance)")
//            
//            var carPrice = self.carCategoryPass
//            var carNamePriceKM : String!
//            var carNamePriceFare : String!
//
//            
//            if carPrice == ""{
//                
//                //Hatchback
//                carNamePriceKM = self.arrayOfPrice_KM.firstObject as! String
//                carNamePriceFare = self.arrayOfMinFare.firstObject as! String
//                print(" hatch km \(carNamePriceKM)")
//                print(" hatch  fare\(carNamePriceFare)")
//            }
//            else if carPrice == self.labelCarName2.text!{
//                
//                //Sedan
//                carNamePriceKM = "\(self.arrayOfPrice_KM[1])"
//                carNamePriceFare = "\(self.arrayOfMinFare[1])"
//                print(" Sedan \(carNamePriceKM)")
//                print(" Sedan fare\(carNamePriceFare)")
//
//            }
//            else if carPrice == self.labelCarName1.text!{
//                
//                //Hatchback
//                carNamePriceKM = self.arrayOfPrice_KM.firstObject as! String?
//                carNamePriceFare = self.arrayOfMinFare.firstObject as! String?
//                print(" hatch km \(carNamePriceKM)")
//                print(" hatch  fare\(carNamePriceFare)")
//                
//            }
//            else if carPrice == self.labelCarName3.text!{
//                
//                //Hatchback
//                carNamePriceKM = "\(self.arrayOfPrice_KM[2])"
//                carNamePriceFare = "\(self.arrayOfPrice_KM[2])"
//                print(" hatch km \(carNamePriceKM)")
//                print(" hatch  fare\(carNamePriceFare)")
//                
//            }
//            else{
//                
//                //SUV
//               /* carNamePriceKM = self.arrayOfPrice_KM.lastObject as! String
//                carNamePriceFare = self.arrayOfMinFare.lastObject as! String*/
//                carNamePriceKM = "\(self.arrayOfPrice_KM[3])"
//                carNamePriceFare = "\(self.arrayOfPrice_KM[3])"
//                print(" SUV Km\(carNamePriceKM)")
//                print(" SUV fare\(carNamePriceFare)")
//
//            }
//
//            let value1 : Double = (carNamePriceKM! as NSString).doubleValue
//            
//            let myInt = (distance as NSString).doubleValue
//            
//            let total = myInt * value1
//            
//            print("\(total)")
//
//            let value2 : Double = (carNamePriceFare as NSString).doubleValue
//
//            let value3Final  = total + value2
//
//            print(" plus values \(value3Final)")
//
//            
//            let pickUp = self.labelTopPickup.text!
//            let drop = self.labelTopDrop.text!
//            self.labelTopFarePickUp.text = pickUp
//            self.labelTopFareDrop.text = drop
//            self.labelTopFareCar.text = self.carCategoryPass
//            self.labelTopFareDollar.text = "$\(value3Final)"
            
        }
    }
    
    @IBAction func Viewuserbtnact(_ sender: Any) {
//        let storyboard = UIStoryboard(name: "Main" , bundle: nil)
//        let controller = storyboard.instantiateViewController(withIdentifier:"ViewreferralUser") as! ViewreferralUser
//        self.present(controller , animated: true, completion: nil)
        //let storyboard = UIStoryboard(name: "main", bundle: nil)
        
        let mainViewController = self.storyboard!.instantiateViewController(withIdentifier: "ViewreferralUserVC") as! ViewreferralUser
       self.present(mainViewController, animated: true)
        
    }
    
    @IBAction func btnInfoAction(_ sender: Any) {
        
        self.viewTopLeftMenu.isHidden = true
        self.statusView.isHidden = true
        self.viewCurrentTrip.isHidden = false
        self.viewBlurCurrentTrip.isHidden = false

    }
    @IBAction func btnCurrenTripCancelAction(_ sender: Any) {
        
        self.viewCurrentTrip.isHidden = true
        self.viewTopLeftMenu.isHidden = false
        self.statusView.isHidden = false
        self.viewBlurCurrentTrip.isHidden = true
        
        let fillColor: UIColor? = UIColor.black//UIColor(red: 33/255, green: 150/255, blue: 243/255, alpha: 1)
        //rippleViews = SMRippleView(frame: rippleview1.frame, rippleColor: UIColor.black, rippleThickness: 0.2, rippleTimer: 0.6, fillColor: fillColor, animationDuration: 4, parentFrame: self.view.frame)
       // self.view.addSubview(rippleViews!)


    }
    
    func phone(phoneNum: String) {
        
        var phoneValue = phoneNum
        phoneValue = phoneValue.replacingOccurrences(of: "Optional(", with: "")
        phoneValue = phoneValue.replacingOccurrences(of: ")", with: "")
        phoneValue = phoneValue.replacingOccurrences(of: "\'", with: "")
        phoneValue = phoneValue.replacingOccurrences(of: "'", with: "")

        print("Driver Ph : \(phoneValue)")
        
        if let url = URL(string: "tel://\(phoneValue)") {
            if #available(iOS 10, *) {
                
                if UIApplication.shared.canOpenURL(url){
                    
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)

                }
                else{
                    
                    self.callNotSupportAlert(error: "This device not support to call")
                }
            } else {
                
                UIApplication.shared.openURL(url as URL)
            }
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
    
    
    @IBAction func btnCallDriverAction(_ sender: Any) {
        
        let acceptedDriverMobile = UserDefaults.standard.object(forKey: "acceptedDriverMobile") as! String!
        if acceptedDriverMobile == nil{
            
            self.phone(phoneNum: "")
            
        }
        else{
            
            self.phone(phoneNum: acceptedDriverMobile!)
            
        }

        
    }
    
    @IBAction func btnBlurCurrentTrip(_ sender: Any) {
        
        self.viewBlurCurrentTrip.isHidden = true
        self.viewCurrentTrip.isHidden = true
        self.viewTopLeftMenu.isHidden = false
        self.statusView.isHidden = false
        
    }
    /*func msgAction(msgNum : String){
        
        if let url = URL(string: "sms:\(msgNum)") {
            if #available(iOS 10, *) {
                
                if UIApplication.shared.canOpenURL(url){
                    
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    
                }
                else{
                    
                    self.callNotSupportAlert(error: "This device not support to message")
                }
            } else {
                
                UIApplication.shared.openURL(url as URL)
            }
        }

    }*/
    
    func msgAction(msgNum : String){
        
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = " "
            controller.recipients = [msgNum]
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }else{
            
            self.callNotSupportAlert(error: "This device not support to message")
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        //... handle sms screen actions
        self.dismiss(animated: true, completion: nil)
        self.viewCarCategory.isHidden = true
        self.viewTopLeftMenu.isHidden = false
        
    }
    
    @IBAction func btnMsgDriverAction(_ sender: Any) {
        
        let acceptedDriverMobile = UserDefaults.standard.object(forKey: "acceptedDriverMobile") as! String!
        if acceptedDriverMobile == nil{
            
            self.msgAction(msgNum: "")

        }
        else{
            
            self.msgAction(msgNum: acceptedDriverMobile!)

        }
    }
    @IBAction func btnCancelTripAction(_ sender: Any) {
        
       
        
        let optionMenu = UIAlertController(title: nil, message: "Are you sure you want to cancel the trip?", preferredStyle: .actionSheet)
        optionMenu.popoverPresentationController?.sourceView = self.view
        
        let sharePhoto = UIAlertAction(title: "YES", style: .default) { (alert : UIAlertAction) in
            
            
            self.riderClickedCancelPass = "clicked"
            
            if self.riderClickedCancelPass == "clicked"{
                
                self.callCancelTrip()

            }
            else{
                
                
            }
        }
        
        let cancel = UIAlertAction(title: "NO", style: .cancel) { (alert : UIAlertAction) in
            
            
            
        }
        
        //    optionMenu.addAction(takePhoto)
        optionMenu.addAction(sharePhoto)
        
        optionMenu.addAction(cancel)
        
        self.present(optionMenu, animated: true, completion: nil)

    }
    func newPMAlert(){
        self.viewMapArcane.isHidden = true
        let alertVC = PMAlertController(title: "WITHOUT PHONE NUMBER", description: "You need to set your phone number in profile without phone number driver can't able to contact you", image: UIImage(named: "ic_cardss.png"), style: .alert) //Image by freepik.com, taken on flaticon.com
        
        alertVC.addAction(PMAlertAction(title: "Cancel", style: .cancel, action: { () -> Void in
            print("Cancel")
        }))
        
        alertVC.addAction(PMAlertAction(title: "Set now", style: .default, action: { () in
            print("Set now")
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let subContentsVC = storyboard.instantiateViewController(withIdentifier: "ARMainEditProfileVC") as! ARMainEditProfileVC
            self.navigationController?.pushViewController(subContentsVC, animated: true)
            
        }))
        self.present(alertVC, animated: true, completion: nil)
       self.viewMapArcane.isHidden = false
   
    
    
    }

    
    
    
    @IBAction func btnCancelFareEstimateWholeAction(_ sender: Any) {
        
        self.viewRequest.isHidden = false
        self.addressView.isHidden = false
        self.viewTopLeftCancel.isHidden = false
        self.viewWholeTopFareEstimate.isHidden = true
        self.btnNewRequest.isHidden = false
        
        self.fareestimateclicked = "0"

        
        
    }
    
    @IBAction func didPanTray(_ sender: UIPanGestureRecognizer) {
        
        let location = sender.location(in: view)
        let velocity = sender.velocity(in: view)
        let translation = sender.translation(in: view)
        
        if sender.state == .began {
            print("Gesture began")
            trayOriginalCenter = viewCarCategory.center
            
        } else if sender.state == .changed {
            print("Gesture is changing")
            viewTray.center = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y + translation.y)

        } else if sender.state == .ended {
            print("Gesture ended")
            
            if velocity.y > 0 {
                UIView.animate(withDuration: 0.3) {
                    self.viewCarCategory.center = self.trayDown
                }
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.viewCarCategory.center = self.trayUp
                }
            }
        }
    }
    // MARK: - UIControlEvents
    
    func touchDown(_ sender: UIControl, event:UIEvent) {
        
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        let value = self.viewCarCategory.frame.origin.y

        print(" down")
        
        if screenHeight == 667{
            
            if value == 417{
                
                self.viewCarCategory.frame = CGRect(x: 0, y: 417, width: screenWidth, height: 250)
                
            }
            else if screenHeight == 568{
                if value == 315{
                    
                    self.viewCarCategory.frame = CGRect(x: 0, y: 315, width: screenWidth, height: 250)
                }
                
            }
        }
        else{
            
            
            
        }

    }
    func touchDownRepeat(_ sender: UIControl, event:UIEvent) {
        print(" repeat")
    }
    func touchDragInside(_ sender: UIControl, event:UIEvent) {
        print(" drag inside")
        
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        let value = self.viewCarCategory.frame.origin.y
        
        if screenHeight == 667{

            if value == 417{
                
                self.viewCarCategory.frame = CGRect(x: 0, y: 417, width: screenWidth, height: 250)

            }
            else if screenHeight == 568{
                if value == 315{
                    
                    self.viewCarCategory.frame = CGRect(x: 0, y: 315, width: screenWidth, height: 250)
                }
                
            }
        }
        else{
            
            
            
        }
    }
    func touchDragOutside(_ sender: UIControl, event:UIEvent) {
        
        print(" drag outside")
        
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        let value = self.viewCarCategory.frame.origin.y

        if screenHeight == 667{
            
            self.viewCarCategory.frame = CGRect(x: 0, y: 417, width: screenWidth, height: 250)
        }
        else if screenHeight == 568{
            
             self.viewCarCategory.frame = CGRect(x: 0, y: 315, width: screenWidth, height: 250)
        }
        else if screenHeight == 736{
            
            
        }
        else{
            
            
        }
        
    }
    func touchDragEnter(_ sender: UIControl, event:UIEvent) {
        
        let value = self.viewCarCategory.frame.origin.y

        print(" drag enter")
        
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        if screenHeight == 667{
            
            if value == 417{
                
                self.viewCarCategory.frame = CGRect(x: 0, y: 417, width: screenWidth, height: 250)
                
            }
            else if screenHeight == 568{
                if value == 315{
                    
                    self.viewCarCategory.frame = CGRect(x: 0, y: 315, width: screenWidth, height: 250)
                }
                
            }
        }
        else{
            
            
            
        }

    }
    func touchDragExit(_ sender: UIControl, event:UIEvent) {
        print(" drag exit")
        
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        let value = self.viewCarCategory.frame.origin.y

        if screenHeight == 667{
            
            if value == 417{
                
                self.viewCarCategory.frame = CGRect(x: 0, y: 417, width: screenWidth, height: 250)
            }
            
        }
        else if screenHeight == 568{
            if value == 315{
                
                self.viewCarCategory.frame = CGRect(x: 0, y: 315, width: screenWidth, height: 250)
            }
            
        }
        else if screenHeight == 736{
            
            
        }
        else{
            
            
        }
        
    }
    func touchUpInside(_ sender: UIControl, event:UIEvent) {
    
        print(" touch up  inside")
        
        
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        let value = self.viewCarCategory.frame.origin.y
        
        if screenHeight == 667{
            
            if value == 417{
                
                self.viewCarCategory.frame = CGRect(x: 0, y: 417, width: screenWidth, height: 250)
            }
            
        }
        else if screenHeight == 568{
            if value == 315{
                
                self.viewCarCategory.frame = CGRect(x: 0, y: 315, width: screenWidth, height: 250)
            }
            
        }
        else if screenHeight == 736{
            
            
        }
        else{
            
            
        }

        
    }
    func touchUpOutside(_ sender: UIControl, event:UIEvent) {
        
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        let value = self.viewCarCategory.frame.origin.y
        
        if screenHeight == 667{
            
            if value == 417{
                
                self.viewCarCategory.frame = CGRect(x: 0, y: 417, width: screenWidth, height: 250)
            }
            
        }
        else if screenHeight == 568{
            if value == 315{
                
                self.viewCarCategory.frame = CGRect(x: 0, y: 315, width: screenWidth, height: 250)
            }
            
        }
        else if screenHeight == 736{
            
            
        }
        else{
            
            
        }

    }
    func touchCancel(_ sender: UIControl, event:UIEvent) {
        
        
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        let value = self.viewCarCategory.frame.origin.y
        
        if screenHeight == 667{
            
            if value == 417{
                
                self.viewCarCategory.frame = CGRect(x: 0, y: 417, width: screenWidth, height: 250)
            }
            
        }
        else if screenHeight == 568{
            if value == 315{
                
                self.viewCarCategory.frame = CGRect(x: 0, y: 315, width: screenWidth, height: 250)
            }
            
        }
        else if screenHeight == 736{
            
            
        }
        else{
            
            
        }

    }
    func valueChanged(_ sender: TGPDiscreteSlider, event:UIEvent) {
        
        print(" value changed")
        print(arrayOfPrice_KM)
        
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        let value1 = self.viewCarCategory.frame.origin.y
        
        if screenHeight == 667{
            
            if value1 == 417{
                
                self.viewCarCategory.frame = CGRect(x: 0, y: 417, width: screenWidth, height: 250)
            }
            
        }
        else if screenHeight == 568{
            if value1 == 315{
                
                self.viewCarCategory.frame = CGRect(x: 0, y: 315, width: screenWidth, height: 250)
            }
            
        }
        else if screenHeight == 736{
            
            
        }
        else{
            
            
        }

        let value = Int(sender.value)
        
        if value == 0{
            
            self.sliderCar.thumbImage = "ic_thumb_standard.png"
            self.carCategoryPass = labelCarName1.text!
            //self.carCategoryPass = "Standard"
            
//            self.labelPriceKM.text = self.arrayOfPrice_KM.firstObject as! String?
//            self.labelPriceMin.text = self.arrayOfPrice_MIN.firstObject as! String?
//            self.labelMinFare.text = self.arrayOfMinFare.firstObject as! String?
//            self.labelMaxSize.text = self.arrayOfMaxSize.firstObject as! String?

        }
        else if value == 1{
            
            self.sliderCar.thumbImage = "ic_thumb_suv.png"
            self.carCategoryPass = labelCarName2.text!
            //self.carCategoryPass = "Luxury"
            
//            self.labelPriceKM.text = "\(self.arrayOfPrice_KM[1])"
//            self.labelPriceMin.text = "\(self.arrayOfPrice_MIN[1])"
//            self.labelMinFare.text = "\(self.arrayOfMinFare[1])"
//            self.labelMaxSize.text =  "\(self.arrayOfMaxSize[1])"
        }
        else if value == 2{
            
            
            self.sliderCar.thumbImage = "ic_thumb_luxury.png"
            self.carCategoryPass = labelCarName3.text!
            //self.carCategoryPass = "SUV"
            
//            self.labelPriceKM.text = "\(self.arrayOfPrice_KM[2])"
//            self.labelPriceMin.text = "\(self.arrayOfPrice_MIN[2])"
//            self.labelMinFare.text = "\(self.arrayOfMinFare[2])"
//            self.labelMaxSize.text =  "\(self.arrayOfMaxSize[2])"
            
        }
        else{
            
            self.sliderCar.thumbImage = "ic_thumb_taxi.png"
            self.carCategoryPass = labelCarName4.text!
            //self.carCategoryPass = "Taxi"
            
           /* self.labelPriceKM.text = self.arrayOfPrice_KM.lastObject as! String?
            self.labelPriceMin.text = self.arrayOfPrice_MIN.lastObject as! String?
            self.labelMinFare.text = self.arrayOfMinFare.lastObject as! String?
            self.labelMaxSize.text = self.arrayOfMaxSize.lastObject as! String?*/
            //self.labelPriceKM.text = "\(self.arrayOfPrice_KM[3])"
            //self.labelPriceMin.text = "\(self.arrayOfPrice_MIN[3])"
            //self.labelMinFare.text = "\(self.arrayOfMinFare[3])"
            //self.labelMaxSize.text =  "\(self.arrayOfMaxSize[3])"
        }
        self.viewMapArcane.clear()
        self.nearBy()
    }

    
    //    func driving(orign: CLLocationCoordinate2D , destination : CLLocationCoordinate2D){

    func driving(orignlat: String , originLon : String){
        
        
        self.viewLeftCircleTime.isHidden = false
        self.viewRightCircleTime.isHidden = false
        
        manager.responseSerializer.acceptableContentTypes =  NSSet(object: "application/json") as Set<NSObject>
      //  self.appDelegate.countryname = self.appDelegate.countryname.trimmingCharacters(in: CharacterSet.whitespaces) as NSString!
       
        var urlstring = "https://maps.googleapis.com/maps/api/distancematrix/json?origins=\(self.labelTopPickup.text!)&mode=driving&destinations=\(orignlat),\(originLon)&sensor=false&key=\(googleKey)" as NSString
        
        urlstring = urlstring.replacingOccurrences(of: "Optional", with: "") as NSString
        urlstring = urlstring.replacingOccurrences(of: "(", with: "") as NSString
        urlstring = urlstring.replacingOccurrences(of: ")", with: "") as NSString
        urlstring = urlstring.replacingOccurrences(of: "\"", with: "") as NSString

        urlstring = urlstring.addingPercentEscapes(using: String.Encoding.utf8.rawValue)! as NSString
        
        print(urlstring)
        
        urlstring = urlstring.replacingOccurrences(of: " ", with: "%20") as NSString
        
        print(urlstring)
        
        manager.responseSerializer.acceptableContentTypes =  NSSet(object: "application/json") as Set<NSObject>
        urlstring = urlstring.addingPercentEscapes(using: String.Encoding.utf8.rawValue)! as NSString
        urlstring = urlstring.replacingOccurrences(of: "%25", with: "%") as NSString
        
        print(urlstring)
        
        manager.get("\(urlstring)",
            parameters: nil,
            success: { (operation: AFHTTPRequestOperation?,responseObject: Any?) in
                if let dict = responseObject as? [String: AnyObject]
                {
                    let status: String? = (dict as AnyObject).object(forKey: "status") as? String
                    let tmp: String? = "INVALID_REQUEST Found"
                    if(status == tmp){
                    }
                    else{
                        if let rows:NSArray = (dict["rows"] as! NSArray){
                            if let elements:NSArray = (rows.value(forKey: "elements") as! NSArray){
                                var distance:NSArray = (elements.value(forKey: "distance")) as! NSArray
                                let duration:NSArray = (elements.value(forKey: "duration")) as! NSArray
                                print(distance.value(forKey: "text"))
                                print(duration.value(forKey: "text"))
                                
                                let dist:NSArray = (distance.value(forKey: "text")) as! NSArray
                                let dur:NSArray = (duration.value(forKey: "text")) as! NSArray
                                print(dist.componentsJoined(by: ""))
                                print(dur.componentsJoined(by: ""))
                                var disString = dist.componentsJoined(by: "")
                                disString = (disString.replacingOccurrences(of: "(", with: "") as NSString) as String
                                disString = (disString.replacingOccurrences(of: ")", with: "") as NSString) as String
                                disString = (disString.replacingOccurrences(of: "\"", with: "") as NSString) as String
                                
                                var durString = dur.componentsJoined(by: "")
                                durString = (durString.replacingOccurrences(of: "(", with: "") as NSString) as String
                                durString = (durString.replacingOccurrences(of: ")", with: "") as NSString) as String
                                durString = (durString.replacingOccurrences(of: "\"", with: "") as NSString) as String
                                durString = (durString.replacingOccurrences(of: "hours", with: "h") as NSString) as String
                                durString = (durString.replacingOccurrences(of: "hour", with: "h") as NSString) as String
                                
                                durString = (durString.replacingOccurrences(of: "mins", with: "m") as NSString) as String
                                durString = (durString.replacingOccurrences(of: "min", with: "m") as NSString) as String
                                durString = (durString.replacingOccurrences(of: "days", with: "d") as NSString) as String
                                durString = (durString.replacingOccurrences(of: "min", with: "m") as NSString) as String
                                
                                
                                disString = disString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                                durString = durString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                                //self.kilometer = Double(disString)!
                       
                                //self.kilometer = 0.6
                                 let kilometerr = (disString as NSString).doubleValue
                                print("kilometer!!\(kilometerr)")
                                print("disString~\(disString)")
                                print(durString)
                                let miles = self.toMiles( kilometerr )
                                var distance11 = String( myFormat:"%.2f", miles)
                                //var distance2 = String()
                                print("kilometer in miles~~\(distance11)")
                        
                                    if durString == "<null>" || durString == "" {
                                        
                                        self.viewLeftCircleTime.isHidden = true
                                        self.viewRightCircleTime.isHidden = true
                                        
                                       // self.labelEta.text = "--"
                                        self.driverETAlbl.text = "Your Driver Will Arrive in : < 1 Min "
                                        
                                    }
                                    else{
                                        
                                        self.viewLeftCircleTime.isHidden = false
                                        self.viewRightCircleTime.isHidden = false
                                        
                                        var removemin = "\(durString)" as NSString
                                        removemin = removemin.replacingOccurrences(of: "mins", with: "") as NSString
                                        removemin = removemin.replacingOccurrences(of: "m", with: "") as NSString
                                        removemin = removemin.replacingOccurrences(of: " ", with: "") as NSString

                                        self.labelMinute.text = "\(removemin)"
                                        print(self.labelMinute.text)
                                        self.driverETAlbl.text = "Your Driver is \(distance11) km away from you,will arrive in \(durString)"
                                       // self.labelEta.text = "\(removemin) MIN"
                                    }

                                
                            }
                        }
                    }
                }
                
                
        },
            failure: { (operation: AFHTTPRequestOperation?,error: Error) in
                
        })

        
    }
    
    func toMiles( _ kilometerr:Double ) -> Double {
        
        return kilometerr * 1000 / 1609.344
    }
    
    func toMiles1( _ kilometerr:Double ) -> Double {
        
        return kilometerr / 1609.344
    }

    
    func etaCalc(orignlat: String , originLon : String){
        
        
        manager.responseSerializer.acceptableContentTypes =  NSSet(object: "application/json") as Set<NSObject>
        //  self.appDelegate.countryname = self.appDelegate.countryname.trimmingCharacters(in: CharacterSet.whitespaces) as NSString!
        
        var urlstring = "https://maps.googleapis.com/maps/api/distancematrix/json?origins=\(orignlat),\(originLon)&mode=driving&destinations=\(self.labelTopPickup.text!)&sensor=false&key=\(googleKey)" as NSString
        
        urlstring = urlstring.replacingOccurrences(of: "Optional", with: "") as NSString
        urlstring = urlstring.replacingOccurrences(of: "(", with: "") as NSString
        urlstring = urlstring.replacingOccurrences(of: ")", with: "") as NSString
        urlstring = urlstring.replacingOccurrences(of: "\"", with: "") as NSString
        
        urlstring = urlstring.addingPercentEscapes(using: String.Encoding.utf8.rawValue)! as NSString
        
        print(urlstring)
        
        urlstring = urlstring.replacingOccurrences(of: " ", with: "%20") as NSString
        
        print(urlstring)
        
        manager.responseSerializer.acceptableContentTypes =  NSSet(object: "application/json") as Set<NSObject>
        urlstring = urlstring.addingPercentEscapes(using: String.Encoding.utf8.rawValue)! as NSString
        urlstring = urlstring.replacingOccurrences(of: "%25", with: "%") as NSString
        
        print(urlstring)
        
        manager.get("\(urlstring)",
            parameters: nil,
            success: { (operation: AFHTTPRequestOperation?,responseObject: Any?) in
                if let dict = responseObject as? [String: AnyObject]
                {
                    let status: String? = (dict as AnyObject).object(forKey: "status") as? String
                    let tmp: String? = "INVALID_REQUEST Found"
                    if(status == tmp){
                        
                    }
                    else{
                        if let rows:NSArray = (dict["rows"] as! NSArray){
                            if let elements:NSArray = (rows.value(forKey: "elements") as! NSArray){
                                var distance:NSArray = (elements.value(forKey: "distance")) as! NSArray
                                let duration:NSArray = (elements.value(forKey: "duration")) as! NSArray
                                print(distance.value(forKey: "text"))
                                print(duration.value(forKey: "text"))
                                print("distance~~~\(distance)")
                                let dist:NSArray = (distance.value(forKey: "text")) as! NSArray
                                let dur:NSArray = (duration.value(forKey: "text")) as! NSArray
                                print(dist.componentsJoined(by: ""))
                                print(dur.componentsJoined(by: ""))
                                var disString = dist.componentsJoined(by: "")
                                disString = (disString.replacingOccurrences(of: "(", with: "") as NSString) as String
                                disString = (disString.replacingOccurrences(of: ")", with: "") as NSString) as String
                                disString = (disString.replacingOccurrences(of: "\"", with: "") as NSString) as String
                                
                                var durString = dur.componentsJoined(by: "")
                                durString = (durString.replacingOccurrences(of: "(", with: "") as NSString) as String
                                durString = (durString.replacingOccurrences(of: ")", with: "") as NSString) as String
                                durString = (durString.replacingOccurrences(of: "\"", with: "") as NSString) as String
                                durString = (durString.replacingOccurrences(of: "hours", with: "h") as NSString) as String
                                durString = (durString.replacingOccurrences(of: "hour", with: "h") as NSString) as String
                                
                                durString = (durString.replacingOccurrences(of: "mins", with: "m") as NSString) as String
                                durString = (durString.replacingOccurrences(of: "min", with: "m") as NSString) as String
                                durString = (durString.replacingOccurrences(of: "days", with: "d") as NSString) as String
                                durString = (durString.replacingOccurrences(of: "min", with: "m") as NSString) as String
                                
                                
                                disString = disString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                                durString = durString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                                
                                print(disString)
                                print(durString)
                                let kilometerr = (disString as NSString).doubleValue
                                print("kilometer!!\(kilometerr)")
                                print("disString~\(disString)")
                                print(durString)
                                
                                var distance11:String = ""
                                print(disString.components(separatedBy: " ").last)
                                if(disString.components(separatedBy: " ").last == "km"){
                               // let miles = self.toMiles( kilometerr )
                                distance11 = String( myFormat:"%.2f", kilometerr )
                                //var distance2 = String()
                                print("kilometer in miles~~\(disString)")
                                }
                                else if(disString.components(separatedBy: " ").last == "m"){
                                    let kilometer = kilometerr / 1000
                                    distance11 = String( myFormat:"%.2f", kilometer )
                                    print("Meter in miles~~\(disString)")
                                }
                                else{
                                    
                                }

                                if durString == "<null>" || durString == "" {
                                    
                                     self.labelEta.text = "--"
                                    self.driverETAlbl.text = "Your Driver Will Arrive in : < 1 Min"
                                    
                                }
                                else{
                                    
                                    self.viewLeftCircleTime.isHidden = false
                                    self.viewRightCircleTime.isHidden = false
                                    
                                    var removemin = "\(durString)" as NSString
                                    removemin = removemin.replacingOccurrences(of: "mins", with: "") as NSString
                                    removemin = removemin.replacingOccurrences(of: "m", with: "") as NSString
                                    removemin = removemin.replacingOccurrences(of: " ", with: "") as NSString
                                    
                                    
                                    self.driverETAlbl.text = "Your Driver is \(distance11) km away from you,will arrive in \(durString)"
                                }
                                
                            }
                        }
                    }
                }
                
                
        },
            failure: { (operation: AFHTTPRequestOperation?,error: Error) in
                
        })
        
        
    }
    
    func callCarSlideImages(){
        
        
        self.sliderCar.addTarget(self, action: #selector(ARMainMapVC.touchDown(_:event:)), for: .touchDown)
      //  self.sliderCar.addTarget(self, action: #selector(ARMainMapVC.touchDownRepeat(_:event:)), for: .touchDownRepeat)
        self.sliderCar.addTarget(self, action: #selector(ARMainMapVC.touchDragInside(_:event:)), for: .touchDragInside)
        self.sliderCar.addTarget(self, action: #selector(ARMainMapVC.touchDragOutside(_:event:)), for: .touchDragOutside)
        self.sliderCar.addTarget(self, action: #selector(ARMainMapVC.touchDragEnter(_:event:)), for: .touchDragEnter)
        self.sliderCar.addTarget(self, action: #selector(ARMainMapVC.touchDragExit(_:event:)), for: .touchDragExit)
        self.sliderCar.addTarget(self, action: #selector(ARMainMapVC.touchUpInside(_:event:)), for: .touchUpInside)
      //  self.sliderCar.addTarget(self, action: #selector(ARMainMapVC.touchUpOutside(_:event:)), for: .touchUpOutside)
      //  self.sliderCar.addTarget(self, action: #selector(ARMainMapVC.touchCancel(_:event:)), for: .touchCancel)
        self.sliderCar.addTarget(self, action: #selector(ARMainMapVC.valueChanged(_:event:)), for: .valueChanged)
        
    }
    
    func textFieldDidChange(textField: UITextField) {
        fetcher?.sourceTextHasChanged(textField.text!)
    }
    
    
    /*func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
        let resultsStr = NSMutableString()
        for prediction in predictions {
            resultsStr.appendFormat("%@\n", prediction.attributedPrimaryText)
        }
        
        resultText?.text = resultsStr as String
    }
    
    func didFailAutocompleteWithError(_ error: Error) {
        resultText?.text = error.localizedDescription
    } */
    
    // payement type
    func checkPhNumber(){
        
        var urlstring:String = "\(live_rider_url)editProfile/user_id/\(self.appDelegate.userid!)"
        
        urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        
        //        urlstring = urlstring.removingPercentEncoding!
        
        print(urlstring)
        
        self.callviewPhAPI(url: "\(urlstring)")
        
    }
    func callviewPhAPI(url : String){
        
        
        Alamofire.request(url).responseJSON { (response) in
            print("url:\(url)")
            self.parseDataPh(JSONData: response.data!)
        }
        
    }
    
    func parseDataPh(JSONData : Data){
        
        do{
            
            let readableJSon = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as! jsonSTD
            
            print(" !!! \(readableJSon[0])")
            
            let value = readableJSon[0] as AnyObject
            
            if let final = value.object(forKey: "mobile"){
                print("final:\(final)")
                
                let mobile:String = value.object(forKey: "mobile") as! String
                
                if mobile == nil{
                    
                    self.newPMAlert()
                }
                else if mobile == ""{
                    
                    self.newPMAlert()
                }
                else{
                    
                    print("mobile:\(mobile)")
                }
                
            }
            else{
                
                
            }
        }
        catch{
            
            print(error)
            
            
            
        }
        
    }
    
    func cardStatus(){
        
        var urlstring:String = "\(viewAPIUrl)editProfile/user_id/\(self.appDelegate.userid!)"
        
        urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        
        urlstring = urlstring.removingPercentEncoding!
        
        print(urlstring)
        
        self.callStatusAPI(url: "\(urlstring)")
    }
    
    func callStatusAPI(url : String){
        
        Alamofire.request(url).responseJSON { (response) in
            
            self.parseData(JSONData: response.data!)
        }
        
    }
    
    func parseData(JSONData : Data){
        
        do{
            
            let readableJSon = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as! jsonSTD
            
            print(" !!! \(readableJSon[0])")
            
            let value = readableJSon[0] as AnyObject
            
            if let final = value.object(forKey: "card_status"){
                
                print(final)
                if(final as! String == "1"){
                    
                    let value = "pay"
                    UserDefaults.standard.set(value, forKey: "payValue")

                }
                else{
                    
                    let value = "not"
                    UserDefaults.standard.set(value, forKey: "payValue")

                }
                let corpostatus = value.object(forKey: "corporate_status")
                print(corpostatus)
                self.appDelegate.corpstatus = corpostatus as! Int!
                
            }
        }
        catch{
            
            print(error)
            
            
        }
        
    }

    func Referralearning()
    {
        
        print(self.appDelegate.userid)
        
        //http://demo.cogzideltemplates.com/tommy/rider/refrel_detail/user_id/58b69164da71b494448b4567
        
        var urlstring:NSString = "\(live_rider_url)refrel_detail/user_id/\(self.appDelegate.userid)" as NSString
        
        
        
        print(urlstring)
        
        
        
        urlstring = urlstring.replacingOccurrences(of: "Optional", with: "") as NSString
        
        urlstring = urlstring.replacingOccurrences(of: "(", with: "") as NSString
        
        urlstring = urlstring.replacingOccurrences(of: ")", with: "") as NSString
        urlstring = urlstring.replacingOccurrences(of: "\"", with: "") as NSString
        
        
        urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)! as NSString
        
        
        
        urlstring = urlstring.removingPercentEncoding! as NSString
        
        
        
        //   urlstring = UTF8.decode(urlstring)
        
        print(urlstring)
        
        
        
        self.callTotalReferral(url: "\(urlstring)")
        
        
    }
    func callTotalReferral(url : String){
        
        
        Alamofire.request(url).responseJSON { (response) in
            
            
            
            self.referralparseData(JSONData: response.data!)
            
            
            
        }
        
        
        
    }
    
    func referralparseData(JSONData : Data){
        
        
        
        do{
            
            
            
            let readableJSon = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as! jsonSTD
            
            
            
            print(" !!! \(readableJSon[0])")
            
            
            
            let value = readableJSon[0] as AnyObject
            
            
            
            
            for dataDict : Any in readableJSon
                
            {
                
                let status1: NSString? = (dataDict as AnyObject).object(forKey: "status") as? NSString
                
                if(status1 == "Success"){
                    
                    
                    let referd_users: NSString? = (dataDict as AnyObject).object(forKey: "referd_users") as? NSString
                    print("referd_users\(referd_users!)")
                    let referd_amount: NSString? = (dataDict as AnyObject).object(forKey: "referd_amount") as? NSString
                    
                    let referd_amount_date: NSString? = (dataDict as AnyObject).object(forKey: "referd_amount_date") as? NSString
                    
                    let referd_amount_week: NSString? = (dataDict as AnyObject).object(forKey: "referd_amount_week") as? NSString
                    
                    let referd_amount_month: NSString? = (dataDict as AnyObject).object(forKey: "referd_amount_month") as? NSString
                    
                    let referd_amount_year: NSString? = (dataDict as AnyObject).object(forKey: "referd_amount_year") as? NSString
                    
                    if (referd_users != "" && referd_users != nil)
                    {
                        self.usersusedcount.text = "\(referd_users!)" as String?
                    }
                    else{
                        
                    }
                    
                    if (referd_amount != "" && referd_amount != nil)
                    {
                        let doubleStr = String(format: "%.2f", Double(String(referd_amount!))!)
                        self.labelEta.text = "$\(doubleStr)" as String?
                        
                    }
                    else{
                        
                    }
                    
                    if (referd_amount_date != "" && referd_amount_date != nil)
                    {
                        let doubleStr = String(format: "%.2f", Double(String(referd_amount_date!))!)
                        self.labelMaxSize.text = "$\(doubleStr)" as String?
                    }
                    else{
                        
                    }
                    
                    if (referd_amount_week != "" && referd_amount_week != nil)
                    {
                        let doubleStr = String(format: "%.2f", Double(String(referd_amount_week!))!)
                        self.labelMinFare.text = "$\(doubleStr)" as String?
                    }
                    else{
                        
                    }
                    
                    if (referd_amount_month != "" && referd_amount_month != nil)
                    {
                        let doubleStr = String(format: "%.2f", Double(String(referd_amount_month!))!)
                        self.labelPriceMin.text = "$\(doubleStr)" as String?
                    }
                    else{
                        
                    }
                    
                    if (referd_amount_year != "" && referd_amount_year != nil)
                    {
                        let doubleStr = String(format: "%.2f", Double(String(referd_amount_year!))!)
                        self.labelPriceKM.text = "$\(doubleStr)" as String?
                    }
                    else{
                        
                    }
                    
                }
                else{
                    
                }
                
                //JSON Valuue
                
            }
            
        }
        catch{
            
            print(error)
        }
        
    }
    func cashoption(){
        let ref = FIRDatabase.database().reference()
        
        //let geoFire = GeoFire(firebaseRef: ref.child("drivers_data/\(self.appDelegate.userid!)"))
        let geoFire = GeoFire(firebaseRef: ref.child("cashoption").child("status"))
        
        
        //accept
        //get values from firebase after accepting
        ref.child("cashoption").child("status").observe(.value, with: { (snapshot) in
           
            
            print("updating")
            let status1 = snapshot.value as Any
            print(status1)
            var status = "\(status1)"
            status = status.replacingOccurrences(of: "Optional(", with: "")
            status = status.replacingOccurrences(of: ")", with: "")
            
            print(status)
            let value = UserDefaults.standard.object(forKey: "cashMode") as! String!
            
            if value == nil{
                
                if(status == "off"){
                    
                    self.imageViewCash.image = UIImage(named : "ub__payment_type_cash_no.png")
                   
                    
                }
                else{
                    self.imageViewCash.image = UIImage(named : "ub__payment_type_cash.png")
                    
                }
            }
            else if value == "cash"{
                
                if(status == "off"){
                    
                    self.imageViewCash.image = UIImage(named : "ub__payment_type_cash_no.png")
                    self.appDelegate.cashno = "1"
                    
                }
                else{
                    self.imageViewCash.image = UIImage(named : "ub__payment_type_cash.png")
                    self.appDelegate.cashno = "0"
                }
                
            }
                
            else if value == "corporate id"{
                
                self.imageViewCash.image = UIImage(named : "ic_cardss.png")
            }
            else if value == "credit"{
                
                self.imageViewCash.image = UIImage(named : "ub__payment_type_delegate.png")
            }
            else{
                self.imageViewCash.image = UIImage(named : "ub__payment_type_cash_no.png")
            }
            
        }) { (error) in
            
            print(error.localizedDescription)
        }

    }
    
    // set us default after login or redirect to home page always...
    
    func getTripStatus(){
        // using GEOfire
        
        print("heloooooo\(self.appDelegate.trip_id!)")
        if(self.appDelegate.trip_id! != "" && self.appDelegate.trip_id! != "empty"){
            let ref = FIRDatabase.database().reference()
            
            //let geoFire = GeoFire(firebaseRef: ref.child("drivers_data/\(self.appDelegate.userid!)"))
            let geoFire = GeoFire(firebaseRef: ref.child("drivers_data/\(self.appDelegate.accepted_Driverid!)"))
            
            
            //accept
            //get values from firebase after accepting
             ref.child("trips_data").child(self.appDelegate.trip_id!).child("status").observe(.value, with: { (snapshot) in
           // ref.child("drivers_data").child("\(self.appDelegate.accepted_Driverid!)").child("accept").child("status").observe(.value, with: { (snapshot) in
                //let dict = snapshot.value as! NSString
                
                print("updating")
                let status1 = snapshot.value as Any
                print(status1)
                var status = "\(status1)"
                status = status.replacingOccurrences(of: "Optional(", with: "")
                status = status.replacingOccurrences(of: ")", with: "")
                
                self.trip_status = status
                print(self.trip_status)
                //if("\(status1)" == "1"){
                if("\(self.trip_status)" != ""){
                    
                    if(self.trip_status == "1"){
                        // handle accepted and display arriving now view
                        

                        self.unHide()
                    }
                    else if(self.trip_status == "2"){
                        // handle accepted and display arriving now view
                        self.unHide()
                    }
                    else if(self.trip_status == "3"){
                        // handle start trip view
                        self.unHide()
                        
                    }
                    else if(self.trip_status == "4"){
                        // handle end trip view
                        self.unHide()
                    }
                    else{
                        // Handle normal login
                        self.hide()
                    }
                }
                //accept
                //get values from firebase after accepting
                //}
                
            }) { (error) in
                
                print(error.localizedDescription)
            }
            
            
            // trip id changing

        }
        
        
    }
    
    
    func unHide(){
        
        // for trip
        self.viewCancelRequest.isHidden = true
        self.statusView.isHidden = false
        self.viewPickupCentre.isHidden = true
        self.addressView.isHidden = true
        self.viewPay.isHidden = true
        self.viewFareEstimate.isHidden = true
        self.viewRideShareNumbers.isHidden = true
        self.viewMapArcane.isMyLocationEnabled = false
        self.driverDetail.isHidden = false
        self.viewCurrentTrip.isHidden = true
        self.viewBlurCurrentTrip.isHidden = true
        self.btnInfo.isHidden = false
       // self.licplate_no.isHidden = false
      //  self.licplate_no.layer.cornerRadius = 15
        self.viewCarCategory.isHidden = true
        self.requestFB()
        self.viewMapArcane.padding = UIEdgeInsetsMake(100, 0, 100, 0)

    }
    
    func hide(){
        
        // for normal login
        self.viewCancelRequest.isHidden = true
        self.statusView.isHidden = true
        self.viewPickupCentre.isHidden = false
       
        self.rippleview1.isHidden = false
        self.addressView.isHidden = false
        self.viewPay.isHidden = true
        self.viewFareEstimate.isHidden = true
        self.viewRideShareNumbers.isHidden = true
        self.viewMapArcane.isMyLocationEnabled = true
        self.driverDetail.isHidden = true
        self.viewCurrentTrip.isHidden = true
        self.viewBlurCurrentTrip.isHidden = true
        
        if(fareestimateclicked == "0"){
        self.viewCarCategory.isHidden = false
        }
        self.viewMapArcane.padding = UIEdgeInsetsMake(100, 0, 100, 0)
    }

       

    

    fileprivate func configureLinearProgressBar(){
        
        linearBar.backgroundColor = UIColor.clear
        linearBar.progressBarColor = UIColor.black
        linearBar.heightForLinearBar = 5
        self.viewLineNewBar.addSubview(linearBar)
        
    }
    

    override func viewWillAppear(_ animated: Bool) {
        
        if self.touched == true{
    
            self.viewCarCategory.isHidden = true
            self.viewFareEstimate.isHidden = false
            self.viewMapArcane.padding = UIEdgeInsetsMake(100, 0, 170, 0)
        }
        else{
            
             if(fareestimateclicked == "0"){
            
            self.viewCarCategory.isHidden = false
            }
        }
        
        if self.payCheckWillAppear == "1"{
            
            self.viewCarCategory.isHidden = true
        }
        else{
             if(fareestimateclicked == "0"){
            self.viewCarCategory.isHidden = false
            }
        }
        
       /* if riderClickedPayPage == "click"{
            
            
        }
        else{
            
            self.callCarListCategoryValues()

        }*/
        self.checkPhNumber()
        cashoption()
        
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        if screenHeight == 667{
            
         
        }
        else if screenHeight == 568{
            
             //self.viewCarCategory.frame = CGRect(x: 0, y: 315, width: screenWidth, height: 250)
        }
        else if screenHeight == 736{
            
            
        }
        else{
            
            
        }

        self.sliderCar.value = 0
        self.sliderCar.minimumValue = 0
        
        self.sliderCar.thumbImage = "ic_thumb_standard.png"
        
      //  self.viewCarCategory.isHidden = false
        
        self.callCarSlideImages()
        
        UNUserNotificationCenter.current().delegate = self
        
        slideMenuController()?.closeLeft()
        
     //   slideMenuController()?.closeRight()
        
        UIApplication.shared.isIdleTimerDisabled = true

        locationManager.delegate = self
       // locationManager.requestWhenInUseAuthorization()
        locationManager.activityType = .fitness
        
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.notDetermined{
            
            locationManager.requestWhenInUseAuthorization()
        }
        else if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse{
            
            if let loc = locationManager.location {
                currentLocation = loc
                locationManager.startUpdatingLocation()
            }
        }
        else if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways{
            
            if let loc = locationManager.location {
                currentLocation = loc
                locationManager.startUpdatingLocation()
            }
            
        }
        else if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.restricted{
            
            
        }
        else
        {
            //denied
            
            var alertController = UIAlertController (title: "Location Service Permission Denied", message: "please open settings and set location access to 'While Using the App'", preferredStyle: .alert)
            
            var settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                let settingsUrl = NSURL(string: UIApplicationOpenSettingsURLString)
                if let url = settingsUrl {
                    
                    UIApplication.shared.openURL(url as URL)
                }
            }
            
            var cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            alertController.addAction(settingsAction)
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true, completion: nil)
        }
        
       /* if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse{
            
            if let loc = locationManager.location {
                currentLocation = loc
            }
        }
        if(CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways)
        {
            if let loc = locationManager.location {
                currentLocation = loc
            }
            
        }*/

        cardStatus()
        
        
        navigationController?.isNavigationBarHidden = true
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default


        let value = UserDefaults.standard.object(forKey: "cashMode") as! String!
        
        if value == nil{
            
            if(self.appDelegate.cashno == "1"){
                
                self.imageViewCash.image = UIImage(named : "ub__payment_type_cash_no.png")
                
                
            }
            else{
                self.imageViewCash.image = UIImage(named : "ub__payment_type_cash.png")
            }
        }
        else if value == "cash"{
            
            if(self.appDelegate.cashno == "1"){
                
                self.imageViewCash.image = UIImage(named : "ub__payment_type_cash_no.png")
                
                
            }
            else{
                self.imageViewCash.image = UIImage(named : "ub__payment_type_cash.png")
            }
           
        }
        
        else if value == "corporate id"{
            
            imageViewCash.image = UIImage(named : "ic_cardss.png")
        }
        else if value == "credit"{
            
            imageViewCash.image = UIImage(named : "ub__payment_type_delegate.png")
        }
        else{
            imageViewCash.image = UIImage(named : "ub__payment_type_cash_no.png")
        }
        
        // to maintain trip status using trip id and driverid
        if UserDefaults.standard.value(forKey: "trip_id") != nil{
            
            let trip_id:String = UserDefaults.standard.value(forKey: "trip_id") as! String
            
            if(trip_id != "" && trip_id != "nil"){
                
                self.appDelegate.trip_id = trip_id
            }
            else{
                
            }
            
            //self.appDelegate.trip_id = trip_id
            print(self.appDelegate.trip_id)
            //self.appDelegate.trip_id = "empty"

         //   self.appDelegate.testTrip_id = String(trip_id)
            
        //    print("\(self.appDelegate.testTrip_id!)")
            
            print(UserDefaults.standard.value(forKey: "tripDriverid") as Any)
            print(UserDefaults.standard.value(forKey: "trip_id") as Any)
            if UserDefaults.standard.value(forKey: "tripDriverid") != nil {
               
                let driver_id:String! = UserDefaults.standard.value(forKey: "tripDriverid") as! String
                self.appDelegate.accepted_Driverid = driver_id
                if(driver_id != ""){
                    self.ref.child("drivers_data").child("\(self.appDelegate.accepted_Driverid!)").child("accept").child("tollfee").observe(.value, with: { (snapshot) in
                        
                        print("updating toll status")
                        if(snapshot.exists()){
                            let status1 = snapshot.value as Any
                            print(status1)
                            var status = "\(status1)"
                            status = status.replacingOccurrences(of: "Optional(", with: "")
                            status = status.replacingOccurrences(of: ")", with: "")
                            print(status)
                            self.appDelegate.total_tollfee = status
                            let doubleStr = String(format: "%.2f", Double(String(status))!)
                            self.total_tollfee.text = "Toll fee: $\(doubleStr)"
                        }
                        else{
                            self.total_tollfee.text = "Toll fee: $0"
                        }
                        
                    })
                }

            }
            
            //print(self.appDelegate.trip_id)
            if(self.appDelegate.trip_id != "" && self.appDelegate.trip_id != "nil" && self.appDelegate.trip_id != "empty"){
                
                self.getTripStatus()
                ref.child("trips_data").child(self.appDelegate.trip_id!).child("tollfee").observe(.value, with: { (snapshot) in
                    
                        
                        print("updating toll status")
                        if(snapshot.exists()){
                            let status1 = snapshot.value as Any
                            print(status1)
                            var status = "\(status1)"
                            status = status.replacingOccurrences(of: "Optional(", with: "")
                            status = status.replacingOccurrences(of: ")", with: "")
                            print(status)
                            self.appDelegate.total_tollfee = status
                            let doubleStr = String(format: "%.2f", Double(String(status))!)
                            self.total_tollfee.text = "Toll fee: $\(doubleStr)"
//                            let warning = MessageView.viewFromNib(layout: .CardView)
//                            warning.configureTheme(.info)
//                            warning.configureDropShadow()
//                            let iconText = "" //"🤔"
//                          //  warning.configureContent(title: "", body: "Toll-fee amount is updated by driver", iconText: iconText)
//                            warning.button?.isHidden = true
//                            var warningConfig = SwiftMessages.defaultConfig
//                            warningConfig.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
//                            SwiftMessages.show(config: warningConfig, view: warning)

                        }
                        else{
                            self.total_tollfee.text = "Toll fee: $0"
                        }
                    })
            }
            else{
                
                self.locateWithLongitude(self.currentLocation.coordinate.longitude, andLatitude: self.currentLocation.coordinate.latitude,andTitle: labelTopPickup.text!)

                self.viewMapArcane.clear()
                self.nearBy()
            }
  
        }
        
    }
    
    
    func callCarListCategoryValues(){
        
        self.arrayOfMaxSize.removeAllObjects()
        self.arrayOfMaxSize.remove("")
        self.arrayOfMinFare.removeAllObjects()
        self.arrayOfMinFare.remove("")
        self.arrayOfPrice_MIN.removeAllObjects()
        self.arrayOfPrice_MIN.remove("")
        self.arrayOfPrice_KM.removeAllObjects()
        self.arrayOfPrice_KM.remove("")
        self.arrayOfCarCategory.removeAllObjects()
        self.arrayOfCarCategory.remove("")
        
        var urlstring:String = "\(live_url)settings/getCategory"

        urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        
        print(urlstring)
        
        let manager : AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
        
        manager.responseSerializer.acceptableContentTypes =  NSSet(objects: "text/plain", "text/html", "application/json", "audio/wav", "application/octest-stream") as Set<NSObject>
        
        manager.get("\(urlstring)",
            parameters: nil,
            success: { (operation: AFHTTPRequestOperation?,responseObject: Any?) in
                
                let jsonObjects:NSArray = responseObject as! NSArray
                
                if jsonObjects.count == 0{
                    
                  
                }
                else{
                    
                    
                }
                for dataDict : Any in jsonObjects
                {
                    
                    if jsonObjects.count == 0{
                        
                       
                        
                    }
                    else{
                        
                        let catCategoryName = (dataDict as AnyObject).object(forKey: "categoryname") as? String
                        let catCategoryID = (dataDict as AnyObject).object(forKey: "categoryId") as? String

                        let maxSize = (dataDict as AnyObject).object(forKey: "max_size") as? String
                        let minFare = (dataDict as AnyObject).object(forKey: "price_fare") as? String
                        let perMIN = (dataDict as AnyObject).object(forKey: "price_minute") as? String
                        let perKM = (dataDict as AnyObject).object(forKey: "price_km") as? String
                        
                        if catCategoryName == nil {
                            
                            let value1 = 0
                            self.arrayOfCarCategory.add(value1)
                            self.labelCarName1.text = "\(value1)"
                        }
                        else{
                            
                            self.arrayOfCarCategory.add(catCategoryName! as String)
                          //  self.labelCarName1.text = self.arrayOfCarCategory.firstObject as! String?
                            
                            if(self.arrayOfCarCategory.count != 0){
                                for i in 0..<self.arrayOfCarCategory.count {
                        
                                    if i == 0{
                                        
                                         self.labelCarName1.text = "\(self.arrayOfCarCategory[i])"
                                        
                                    }
                                    else if i == 1{
                                        
                                         self.labelCarName2.text = "\(self.arrayOfCarCategory[i])"
                                    }
                                    else if i == 2{
                                        
                                         self.labelCarName3.text = "\(self.arrayOfCarCategory[i])"
                                    }
                                    else if  i == 3{
                                        
                                         self.labelCarName4.text = "\(self.arrayOfCarCategory[i])"
                                    }
                                    else{
                                        
                                        
                                    }
                                    
                                }
                                
                            }
                            
                        }
                        
                        if catCategoryID == nil{
                            
                            let value1 = 0
                            self.arrayOfCarCategoryIds.add(value1)
                            // self.labelMaxSize.text = "\(value1)"
                        }
                        else{
                            
                            self.arrayOfCarCategoryIds.add(catCategoryID! as String)
                            
                            // self.labelMaxSize.text = self.arrayOfMaxSize.firstObject as! String?
                        }

                        if maxSize == nil{
                            
                            let value1 = 0
                            self.arrayOfMaxSize.add(value1)
                           // self.labelMaxSize.text = "\(value1)"
                        }
                        else{
                            
                            self.arrayOfMaxSize.add(maxSize! as String)

                           // self.labelMaxSize.text = self.arrayOfMaxSize.firstObject as! String?
                        }
                        
                        if minFare == nil{
                            
                            let value2 = 0
                            self.arrayOfMinFare.add(value2)
                           // self.labelMinFare.text = "\(value2)"
                        }
                        else{
                            
                            self.arrayOfMinFare.add(minFare! as String)
                           // self.labelMinFare.text = self.arrayOfMinFare.firstObject as! String?

                        }
                        
                        if perMIN == nil{
                            
                            let value3 = 0
                            self.arrayOfPrice_MIN.add(value3)
                            //self.labelPriceMin.text = "\(value3)"
                        }
                        else{
                            
                            self.arrayOfPrice_MIN.add(perMIN! as String)
                           // self.labelPriceMin.text = self.arrayOfPrice_MIN.firstObject as! String?
                        }
                        
                        if perKM == nil{
                            
                            let value4 = 0
                            self.arrayOfPrice_KM.add(value4)
                            //self.labelPriceKM.text = "\(value4)"

                        }
                        else{
                            
                            self.arrayOfPrice_KM.add(perKM! as String)
                            //self.labelPriceKM.text = self.arrayOfPrice_KM.firstObject as! String?


                        }
                    }
                    
                    
                }
                
              //  self.multipleCar()
        },
            failure: { (operation: AFHTTPRequestOperation?,error: Error) in
                print("Error: " + error.localizedDescription)
                
        })
        
        
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
                        let reqDuration = (dataDict as AnyObject).object(forKey: "request_duration") as? String
                        let nearDist = (dataDict as AnyObject).object(forKey: "nearby_distance") as? String
                        let google_api = (dataDict as AnyObject).object(forKey: "google_api_key") as? String
                        self.googleKey = google_api!
                        //self.google_search_key = google_api
                        if nearDist == nil {
                            
                        }
                        else{
                            self.nearbyRadius = Int(nearDist!)!
                            //self.nearbyRadius = 1
                            self.request_duration = Int(reqDuration!)!
                        }
                    }
                }
            },
            failure: { (operation: AFHTTPRequestOperation?,error: Error) in
                print("Error: " + error.localizedDescription)
                
            })
    }
    
    func multipleCar(){
        
        if(arrayOfCarCategory.count != 0){
            for i in 0..<arrayOfCarCategory.count {
                
                let values: NSArray? = arrayOfCarCategory[i] as? NSArray
                
                let first = values?.firstObject
                
                let second = values?[2]
                
                let third = values?[3]
                
                
            }
            
        }
    }
    
    func setDropLoc(){
        
        
        if UserDefaults.standard.value(forKey: "Droplat") != nil{
            if UserDefaults.standard.value(forKey: "Droplng") != nil{
                
                print("not empty")
                var dropLat = UserDefaults.standard.value(forKey: "Droplat") as? String
                var dropLng = UserDefaults.standard.value(forKey: "Droplng") as? String
                /*print("dropLat:\(dropLat)")
                print("dropLng:\(dropLng)")*/
                dropLat = dropLat?.replacingOccurrences(of: "Optional(", with: "")
                dropLat = dropLat?.replacingOccurrences(of: ")", with: "")
                dropLat = dropLat?.replacingOccurrences(of: "\"", with: "")
                
                dropLng = dropLng?.replacingOccurrences(of: "Optional(", with: "")
                dropLng = dropLng?.replacingOccurrences(of: ")", with: "")
                dropLng = dropLng?.replacingOccurrences(of: "\"", with: "")
                
                if (dropLat != "") || (dropLng != ""){
                    self.dropup = CLLocation(latitude: Double(dropLat!)!,longitude: Double(dropLng!)!)
                    self.myDestination = self.dropup
                
                    self.setPickupLoc()
                }
            }
        }
        
        
    }
    
    func setPickupLoc(){
        
        
        if UserDefaults.standard.value(forKey: "pickuplat") != nil{
            if UserDefaults.standard.value(forKey: "pickuplng") != nil{
                
                print("not empty")
                var pickuplat:String! = UserDefaults.standard.value(forKey: "pickuplat") as? String
                var pickuplng:String! = UserDefaults.standard.value(forKey: "pickuplng") as? String
                
                pickuplat = pickuplat?.replacingOccurrences(of: "Optional(", with: "")
                pickuplat = pickuplat?.replacingOccurrences(of: ")", with: "")
                pickuplat = pickuplat?.replacingOccurrences(of: "\"", with: "")
                
                pickuplng = pickuplng?.replacingOccurrences(of: "Optional(", with: "")
                pickuplng = pickuplng?.replacingOccurrences(of: ")", with: "")
                pickuplng = pickuplng?.replacingOccurrences(of: "\"", with: "")
                if (pickuplng?.isEmpty)! || (pickuplat?.isEmpty)!{
                    
                }
                else if (pickuplat != "") || (pickuplng != ""){
                    self.pickup = CLLocation(latitude: Double(pickuplat!)!,longitude: Double(pickuplng!)!)
                    self.myOrigin = self.pickup
                    
                }
            }
        }
        
        
        
    }
    

    //UserDefaults.standard.setValue(droplat, forKey: "driverlat")
    //UserDefaults.standard.setValue(droplng, forKey: "driverlng")

    func setDriverLoc(){
        
        if UserDefaults.standard.value(forKey: "driverlat") != nil{
            if UserDefaults.standard.value(forKey: "driverlng") != nil{
                
                print("not empty")
                var driverlat = UserDefaults.standard.value(forKey: "driverlat") as? String
                var driverlng = UserDefaults.standard.value(forKey: "driverlng") as? String
                
                driverlat = driverlat?.replacingOccurrences(of: "Optional(", with: "")
                driverlat = driverlat?.replacingOccurrences(of: ")", with: "")
                driverlat = driverlat?.replacingOccurrences(of: "\"", with: "")
                
                driverlng = driverlng?.replacingOccurrences(of: "Optional(", with: "")
                driverlng = driverlng?.replacingOccurrences(of: ")", with: "")
                driverlng = driverlng?.replacingOccurrences(of: "\"", with: "")
                
                if (driverlat != "") || (driverlng != ""){
                    self.driverLocation = CLLocation(latitude: Double(driverlat!)!,longitude: Double(driverlng!)!)
                    self.myOrigin = self.driverLocation
                    self.setPickupLoc()
                    self.myDestination = self.pickup
                }
            }
        }
        
        
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
//        let handle: UInt! = 0

//        let ref = FIRDatabase.database().reference().child("drivers_location")
//        ref.removeObserver(withHandle: handle)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // This padding will be observed by the mapView
        if(self.appDelegate.backfrompayment == "1"){
        self.viewMapArcane.padding = UIEdgeInsetsMake(100, 0, 170, 0)
            self.appDelegate.backfrompayment = "0"
        }
        else{
            self.viewMapArcane.padding = UIEdgeInsetsMake(100, 0, 100, 0)
        }
        
        
        
       /* let arrayOfCars = self.arrayOfCarCategory.count
        
        if arrayOfCars > 4{
            
            self.labelCarName2.text = "\(self.arrayOfCarCategory[1])"
            self.labelCarName3.text = "\(self.arrayOfCarCategory[2])"
            self.labelCarName4.text = "\(self.arrayOfCarCategory[3])"
        }
        else{
            
            self.labelCarName2.text = "\(self.arrayOfCarCategory[1])"
            self.labelCarName3.text = "\(self.arrayOfCarCategory[2])"
            self.labelCarName4.text = self.arrayOfCarCategory.lastObject as! String?
        }*/

        
    }

    func initListValue() {
        let listValue = ["1", "2", "3", "4", "5"]
        self.dropdownList.valueList = listValue
        
        // Uncomment this line to set your own dropdown color.
        //self.dropdownList.dropdownColor(UIColor.blackColor(), selectedColor: UIColor.lightGrayColor(), textColor: UIColor.whiteColor())
        self.dropdownList.dropdownMaxHeight(200)
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

    @IBAction func btnLeftMenu(_ sender: Any) {
        
       // navigationController!.navigationBar.barStyle = .black

        self.toggleLeft()
        
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
        self.slideMenuController()?.addLeftGestures()
    }
    
    @IBAction func btnPickupCentre(_ sender: Any) {
        self.setpickuppressed = "1"
        self.viewMapArcane.padding = UIEdgeInsetsMake(100, 0, 170, 0)
        self.viewFareEstimate.isHidden = false
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.denied{
            
            var alertController = UIAlertController (title: "Location Service Permission Denied", message: "please open settings and set location access to 'While Using the App'", preferredStyle: .alert)
            
            var settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                let settingsUrl = NSURL(string: UIApplicationOpenSettingsURLString)
                if let url = settingsUrl {
                    
                    UIApplication.shared.openURL(url as URL)
                }
            }
            
            
            var cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            alertController.addAction(settingsAction)
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true, completion: nil)
            
        }

        touchPickUp = true
        
        self.touched = true // set pickuplocation is clicked
        
        self.viewCarCategory.isHidden = true
        self.labelTopPickupCentre.isHidden = false
        
        if(labelTopPickup.text != ""){
            
            if self.idleLocation != nil{
                
                self.locateWithLongitude(self.idleLocation.coordinate.longitude, andLatitude: self.idleLocation.coordinate.latitude,andTitle: labelTopPickup.text!)

            }
            else{
                self.locateWithLongitude(self.currentLocation.coordinate.longitude, andLatitude: self.currentLocation.coordinate.latitude,andTitle: labelTopPickup.text!)

            }


        }
        
     //
    
        
    }
    @IBAction func bntLeftCancelMenu(_ sender: Any) {
        self.viewMapArcane.padding = UIEdgeInsetsMake(100, 0, 100, 0)
        viewTopLeftCancel.isHidden = true
        
        labelTopPickupCentre.isHidden = true
        viewPay.isHidden = true
        viewFareEstimate.isHidden = true
        viewRideShareNumbers.isHidden = true
        viewTopDrop.isHidden = true
        viewRequest.isHidden = true
        btnNewTopBack.isHidden = true
        buttonTopNewPickUp.isHidden = false
         if(fareestimateclicked == "0"){
        self.viewCarCategory.isHidden = false
        viewTopLeftMenu.isHidden = false
        }
        self.touched = false
        self.req = "no"
    }
    
    @IBAction func btnPickupTop(_ sender: Any) {
        
    //    buttonTopPickUp.tag = 0
        
        touchPickUp = true
        
        navigationController!.isNavigationBarHidden = true
        
        searchview.isHidden = false
        searchBar.becomeFirstResponder()
        searchBar.text = ""
        searchTable?.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.searchTable?.isHidden = true
    
         /*let searchController = UISearchController(searchResultsController: searchResultController)
        
        searchController.searchBar.delegate = self
        
        self.present(searchController, animated:true, completion: nil)*/
        
    }
    
    @IBAction func backinsearch(_ sender: Any) {
        searchview.isHidden = true
        searchBar.resignFirstResponder()
    }
    @IBAction func btnDropTop(_ sender: Any) {
        
        
        touchDrop = true
        
        self.appDelegate.getCountryCheck = 1
    //    buttonTopDrop.tag = 1
        
    //    self.buttonTopPickUp.tag = 1

       // navigationController!.isNavigationBarHidden = true
        
        searchview.isHidden = false
        searchBar.becomeFirstResponder()
        searchBar.text = ""
        searchTable?.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.searchTable?.isHidden = true
        /*let searchController = UISearchController(searchResultsController: searchResultController)
        
        searchController.searchBar.delegate = self
       
        self.present(searchController, animated:true, completion: nil)*/

        
    }
    @IBAction func btnDropUpdateTop(_ sender: Any) {

        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let subContentsVC = storyboard.instantiateViewController(withIdentifier: "multidest") as! MultipleDestinationVC
        self.navigationController?.pushViewController(subContentsVC, animated: true)

        
    }
    
    /*
      // To Handle remove listener from firebase
     var handle: UInt = 0
     handle = ref.observe(.value, with: { snapshot in
     print(snapshot)
     if snapshot.exists() && snapshot.value as! String == "42" {
     print("The value is now 42")
     ref.removeObserver(withHandle: handle)
     }
     else{
     
     }
     })

    */
    
    var pickAddress = ""
    var dropAddress = ""
    
    @IBAction func btnRequest(_ sender: Any) {
        
//        self.dropCountry = self.appDelegate.getCountryName
        
        print("pickupCountry \(self.countryStatic!)")
        print("dropCountry \(self.dropCountry!)")
        
        if labelTopDrop.text == "Set Drop Location"{
            
            self.buttonTopPickUp.isEnabled = true
            self.buttonTopDrop.isEnabled = true
            
            let warning = MessageView.viewFromNib(layout: .CardView)
            warning.configureTheme(.warning)
            warning.configureDropShadow()
            let iconText = "" //"🤔"
            warning.configureContent(title: "", body: "Enter Destination Location", iconText: iconText)
            warning.button?.isHidden = true
            var warningConfig = SwiftMessages.defaultConfig
            warningConfig.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
            SwiftMessages.show(config: warningConfig, view: warning)
            
            
        }
        else if(self.appDelegate.cashno == "1"){
            let warning = MessageView.viewFromNib(layout: .CardView)
            warning.configureTheme(.warning)
            warning.configureDropShadow()
            let iconText = "" //"🤔"
            warning.configureContent(title: "", body: "Payment by Cash option is not available for now", iconText: iconText)
            warning.button?.isHidden = true
            var warningConfig = SwiftMessages.defaultConfig
            warningConfig.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
            SwiftMessages.show(config: warningConfig, view: warning)
        }
        else if self.countryStatic != self.dropCountry {
            
            self.buttonTopPickUp.isEnabled = true
            self.buttonTopDrop.isEnabled = true
            
            let warning = MessageView.viewFromNib(layout: .CardView)
            warning.configureTheme(.warning)
            warning.configureDropShadow()
            let iconText = "" //"🤔"
            warning.configureContent(title: "", body: "Service not allowed for this destination", iconText: iconText)
            warning.button?.isHidden = true
            var warningConfig = SwiftMessages.defaultConfig
            warningConfig.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
            SwiftMessages.show(config: warningConfig, view: warning)

        }
        else{
            self.viewMapArcane.padding = UIEdgeInsetsMake(100, 0, 100, 0)
            
            if labelTopPickup.text != "" || labelTopPickup.text != "Set Pickup Location"{
                self.pickAddress = labelTopPickup.text!
            }
            
            if labelTopDrop.text != "" || labelTopDrop.text != "Set Drop Location"{
                self.dropAddress = labelTopDrop.text!
            }
            
            let riderAlertController = UIAlertController(title: "", message: "SIXTNC, currently, does not provide child seats. Riders must provide child seats for children under 13 years of age.", preferredStyle: UIAlertControllerStyle.alert)
            
            // add the actions (buttons)
            //alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.default, handler: nil))
            riderAlertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
            
            // show the alert
            riderAlertController.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.destructive, handler: { action in
                
                self.req = "yes"
                self.buttonTopPickUp.isEnabled = false
                self.buttonTopDrop.isEnabled = false
                
                self.requestDisableView.isHidden = false
                self.btnLeft.isUserInteractionEnabled = false
                
                //self.getNextPoseData()
                self.requestPressed = "yes" // to stop updating location header after request given.
                
                self.viewPickupCentre.isHidden = true
                self.viewPay.isHidden = true
                self.viewFareEstimate.isHidden = true
                self.viewRideShareNumbers.isHidden = true
                self.viewTopLeftCancel.isHidden = true
                self.viewTopLeftMenu.isHidden = false
                self.viewRequest.isHidden = true
                //// self.progressViewOutlet.isHidden = false
                self.statusView.isHidden = false
                self.statusLabel.text = "REQUESTING"
                self.viewLineNewBar.isHidden = false
                self.linearBar.startAnimation()
                
                self.viewMapArcane.settings.myLocationButton = true
                self.viewMapArcane.settings.indoorPicker = true
                self.viewMapArcane.isIndoorEnabled = true
                
                self.viewCancelRequest.isHidden = false
                
                //// self.progressViewOutlet.setProgress(0, animated: false)
                
                self.progressLabel?.text = "0%"
                
                self.alert = 1
                
                self.requesting()
                
            }))
            
            self.present(riderAlertController, animated: true, completion: nil)

            /*var handle: UInt = 0

            let ref = FIRDatabase.database().reference()
            handle = ref.observe(.value, with: { snapshot in
                ref.child("drivers_location").removeAllObservers()
            }) */
            
            
            
        }
        
    }
    
    @IBAction func btnCashAction(_ sender: Any) {
        
        
        
    }
    
    @IBAction func btnCashChangeAction(_ sender: Any) {
        
        
        
        
    }
    @IBAction func btnCashChangeNew(_ sender: Any) {
         self.payCheckWillAppear = "1"
        self.riderClickedPayPage = "click"
        self.navigationController?.pushViewController(ARPaymentVC(), animated: true)

    }
    
    @IBAction func btnCancelRequestAction(_ sender: Any) {
        
        self.cancelReq = "pressed"
        self.req = "no"
        self.cancelRequest()
         if(fareestimateclicked == "0"){
        self.viewCarCategory.isHidden = false
        }

    }
    
    func getCurrentAddress(myLocation : CLLocation){
        
        var dynamicLocation1 = CLLocation()
        
        dynamicLocation1 = myLocation
        
        
        var urlstring:String = "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(dynamicLocation1.coordinate.latitude),\(dynamicLocation1.coordinate.longitude)&sensor=true&key=\(googleKey)"
        
        urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        print(urlstring)
        
        print(self.currentLocation.coordinate.latitude)
        
        if self.currentLocation.coordinate.latitude == 0.0{
           
            
            self.viewTopLeftCancel.isHidden = true
            self.viewTopDrop.isHidden = true
            self.btnNewTopBack.isHidden = true
            self.buttonTopNewPickUp.isHidden = false
            self.viewRequest.isHidden = true
            self.viewPay.isHidden = true
            self.viewFareEstimate.isHidden = true
            self.viewRideShareNumbers.isHidden = true
            self.labelTopPickupCentre.isHidden = true
            
            self.viewMapArcane.clear()
            self.labelPickupCentre.text = "NO CARS AVAILABLE"
            self.viewLeftCircleTime.isHidden = true
            self.viewRightCircleTime.isHidden = true
             if(fareestimateclicked == "0"){
            self.viewCarCategory.isHidden = false
            self.viewTopLeftMenu.isHidden = false
            }
            self.viewMapArcane.padding = UIEdgeInsetsMake(100, 0, 100, 0)

        }
        else{
            
            self.callSiginAPI(url: "\(urlstring)", location: myLocation)
 
        }
        
        
    }
    
    func callSiginAPI(url : String,location: CLLocation){
        self.isAirport = 0
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
            print(url)
            //            print(response)
            do{
                
                let readableJSon:NSDictionary! = try JSONSerialization.jsonObject(with: response.data!, options: .mutableContainers) as! NSDictionary
                
                //print(" !!! \(readableJSon["results"]!)")
                
                if let value = readableJSon["results"] as? [[String : AnyObject]] {
                    
                    for result in value{
                        if let addressComponents = result["address_components"] as? [[String : AnyObject]] {
                            let filteredItems = addressComponents.filter{ if let types = $0["types"] as? [String] {
                                return types.contains("country") } else { return false } }
                            let airportItems = addressComponents.filter{ if let types = $0["types"] as? [String] {
                                return types.contains("airport") } else { return false } }
                            if !filteredItems.isEmpty {
                                print("test_Tommy")
                                print(filteredItems[0]["long_name"] as! String)
                                self.countryStatic = filteredItems[0]["long_name"] as! String
                                UserDefaults.standard.setValue(self.countryStatic, forKey: "pickuplongname")
                                self.getFirstCountry = self.countryStatic
                            }
                            if !airportItems.isEmpty {
                                print("Airport")
                                self.isAirport = 1
                            }else{
                                print("Not Airport")
                            }
                        }
                    }
                    if(self.isAirport == 1)
                    {
                        //self.terminalView.isHidden = false
                        UserDefaults.standard.setValue(self.isAirport, forKey: "isTerminal")
                    }else{
                        //self.terminalView.isHidden = true
                        UserDefaults.standard.removeObject(forKey: "isTerminal")
                    }
                    
                    
                    
                    
                    
                    print(value)

                    if(value.count == 0){
                        
                    }
                    else{
                        if let zipArray: NSDictionary = value[0] as? NSDictionary{
                               print(zipArray)
                            if let zip:String = zipArray["formatted_address"] as? String{
                                // print(zip)
                                self.labelTopPickup.text = zip
                                if self.currentLocation.coordinate.latitude == 0.0{
                                   
                                    
                                    self.viewTopLeftCancel.isHidden = true
                                    self.viewTopDrop.isHidden = true
                                    self.btnNewTopBack.isHidden = true
                                    self.buttonTopNewPickUp.isHidden = false
                                    self.viewRequest.isHidden = true
                                    self.viewPay.isHidden = true
                                    self.viewFareEstimate.isHidden = true
                                    self.viewRideShareNumbers.isHidden = true
                                    self.labelTopPickupCentre.isHidden = true
                                    
                                    self.viewMapArcane.clear()
                                    self.touched = false
                                    self.labelPickupCentre.text = "NO CARS AVAILABLE"
                                    
                                     if(self.fareestimateclicked == "0"){
                                    self.viewCarCategory.isHidden = false
                                    self.viewTopLeftMenu.isHidden = false
                                    }
                                    self.viewLeftCircleTime.isHidden = true
                                    self.viewRightCircleTime.isHidden = true
                                    self.viewMapArcane.padding = UIEdgeInsetsMake(100, 0, 100, 0)
                                }
                                else{
                                    self.nearbyLocation = location
                                    
                                    self.nearBy()

                                }
                                
                            }
                        }
                        if let country: NSDictionary = value[value.count-1] as? NSDictionary{
                            if var zip:String = country["formatted_address"] as? String{
                                if self.countryStatic == "None"{
                                    zip = zip.replacingOccurrences(of: "Optional(", with: "")
                                    zip = zip.replacingOccurrences(of: ")", with: "")
                                    zip = zip.removingPercentEncoding!
                                   // self.countryStatic = zip
                                  //  self.getFirstCountry = self.countryStatic
                                }
                                else{
                                    zip = zip.replacingOccurrences(of: "Optional(", with: "")
                                    zip = zip.replacingOccurrences(of: ")", with: "")
                                    zip = zip.removingPercentEncoding!
                                   // self.countryStatic = zip

                                }
                                
                                // get the country value from here
                            }
                            
                        }
                    
                    }
                }
            }
            catch{
                
                print(error)
                
            }
            
        })
    }
    
    
    func getCountryForDrop(myLocation : CLLocation){
        
        var dynamicLocation1 = CLLocation()
        
        dynamicLocation1 = myLocation
        
        
        
        var urlstring:String = "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(dynamicLocation1.coordinate.latitude),\(dynamicLocation1.coordinate.longitude)&sensor=true&key=\(googleKey)"
        
        urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        print(urlstring)
        
        print(self.currentLocation.coordinate.latitude)
        
        
            self.getCountryWeb(url: "\(urlstring)", location: myLocation)
        
        
        
    }
    
    func getCountryWeb(url : String,location: CLLocation){
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
            print(url)
            //            print(response)
            do{
                let readableJSon:NSDictionary! = try JSONSerialization.jsonObject(with: response.data!, options: .mutableContainers) as! NSDictionary
                //print(" !!! \(readableJSon["results"]!)")
                if let value = readableJSon["results"] as? [[String : AnyObject]] {
                    
                    for result in value{
                        if let addressComponents = result["address_components"] as? [[String : AnyObject]] {
                            let filteredItems = addressComponents.filter{ if let types = $0["types"] as? [String] {
                                return types.contains("country") } else { return false } }
                            if !filteredItems.isEmpty {
                                print("test_Tommy")
                                print(filteredItems[0]["long_name"] as! String)
                                self.dropCountry = filteredItems[0]["long_name"] as! String
                                //self.getFirstCountry = self.countryStatic
                            }
                        }
                    }
                    
                    print(value[value.count - 1])
                    if(value.count == 0){
                        
                    }
                    else{
                        if let country: NSDictionary = value[value.count-1] as? NSDictionary{
                            print(country)
                            if var zip:String = country["formatted_address"] as? String{
                                print(zip)
                                
                                var str = "\(zip)"
                                
                               /* let lastChar = str[str.index(before: str.endIndex)]
                                
                                print(lastChar)*/

                                var passZip = ""
                                if var newlink = str.components(separatedBy: ",").last {
                                    
                                    print(newlink)
                                    passZip = newlink
                                }
                                else{
                                    
                                    passZip = zip
                                }
                                
                                
                                passZip = passZip.replacingOccurrences(of: "Optional(", with: "")
                                passZip = passZip.replacingOccurrences(of: ")", with: "")
                                passZip = passZip.replacingOccurrences(of: " ", with: "")
                                
                                passZip = passZip.removingPercentEncoding!
                                
                                if passZip == "USA"
                                {
                                    
                                    passZip = "United States"
                                }
                                else if passZip == "UnitedStates"{
                                    
                                    passZip = "United States"

                                }
                                else{
                                    
                                    
                                }
                                
                                //self.dropCountry = passZip
                                print(self.dropCountry)

                                // get the country value from here
                            }
                            
                        }
                        
                    }
                }
            }
            catch{
                
                print(error)
                
            }
            
        })
    }
    func getCountryForDropupdate(myLocation : CLLocation){
        var dynamicLocation1 = CLLocation()
        dynamicLocation1 = myLocation
        var urlstring:String = "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(dynamicLocation1.coordinate.latitude),\(dynamicLocation1.coordinate.longitude)&sensor=true&key=\(googleKey)"
        urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        print(urlstring)
        print(self.currentLocation.coordinate.latitude)
        self.getCountryWebupdate(url: "\(urlstring)", location: myLocation)
    }
    
    func getCountryWebupdate(url : String,location: CLLocation){
        print(self.appDelegate.dropLocation)
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
            print(url)
            do{
                let readableJSon:NSDictionary! = try JSONSerialization.jsonObject(with: response.data!, options: .mutableContainers) as! NSDictionary
                if let value = readableJSon["results"] as? [[String : AnyObject]] {
                    for result in value{
                        if let addressComponents = result["address_components"] as? [[String : AnyObject]] {
                            let filteredItems = addressComponents.filter{ if let types = $0["types"] as? [String] {
                                return types.contains("country") } else { return false } }
                            if !filteredItems.isEmpty {
                                print("test_Tommy")
                                print(filteredItems[0]["long_name"] as! String)
                                self.dropCountry = filteredItems[0]["long_name"] as! String
                            }
                        }
                    }
 
                }
                if self.countryStatic != self.dropCountry {
                    
                    self.buttonTopPickUp.isEnabled = true
                    self.buttonTopDrop.isEnabled = true
                    
                    let warning = MessageView.viewFromNib(layout: .CardView)
                    warning.configureTheme(.warning)
                    warning.configureDropShadow()
                    let iconText = "" //"🤔"
                    warning.configureContent(title: "", body: "Service not allowed for this destination", iconText: iconText)
                    warning.button?.isHidden = true
                    var warningConfig = SwiftMessages.defaultConfig
                    warningConfig.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
                    SwiftMessages.show(config: warningConfig, view: warning)
                }else{
                    self.dropup = CLLocation(latitude: Double(self.appDelegate.dropLocation.coordinate.latitude),longitude: Double(self.appDelegate.dropLocation.coordinate.longitude))
                    self.myDestination = self.dropup
                    self.gettingDirectionsAPI()
                    let ref1 = FIRDatabase.database().reference().child("riders_location").child(self.appDelegate.userid!).child("Updatelocation")
                    ref1.updateChildValues(["0": String(self.appDelegate.dropLocation.coordinate.latitude)])
                     ref1.updateChildValues(["1": String(self.appDelegate.dropLocation.coordinate.longitude)])
                    let dropLat = "\(self.appDelegate.dropLocation.coordinate.latitude)"
                    let dropLng = "\(self.appDelegate.dropLocation.coordinate.longitude)"
                    print("UpdatedDropLat:\(dropLat)")
                    print("UpdatedDropLng:\(dropLng)")
                    UserDefaults.standard.setValue(dropLat, forKey: "Droplat")
                    UserDefaults.standard.setValue(dropLng, forKey: "Droplng")
                }
            }
            catch{
                print(error)
            }
        })
    }
    var nocar = "yes"
    func mapView(_ mapView:GMSMapView,idleAt position:GMSCameraPosition)
    {
        
        let point:CGPoint = mapView.center;
        let coor:CLLocationCoordinate2D = mapView.projection.coordinate(for: point)
        
        self.tapLocation = CLLocation(latitude: coor.latitude, longitude: coor.longitude)
        //to get street address
        let longitude :CLLocationDegrees = coor.longitude
        let latitude :CLLocationDegrees = coor.latitude
        
        print(longitude)
        print(latitude)
        if(self.accepted == "yes"   || self.requestPressed == "yes"){
            
        }
        else{
            self.nocar = "yes"
            self.idleLocation = self.tapLocation
            if(self.setpickuppressed != "1"){
            self.getCurrentAddress(myLocation: self.tapLocation)
            }
            self.setpickuppressed = "0"
            if self.touched == true{
                
                self.viewTopLeftMenu.isHidden = true
                if(self.fareestimateclicked == "0"){
                    
                self.viewTopLeftCancel.isHidden = false
                    
                }
                self.viewTopDrop.isHidden = false
                self.btnNewTopBack.isHidden = false
                self.buttonTopNewPickUp.isHidden = true
                self.viewRequest.isHidden = false
                self.viewPay.isHidden = false
                self.viewRideShareNumbers.isHidden = false

            }
            else{
                
                if(self.fareestimateclicked == "0"){
                self.viewTopLeftMenu.isHidden = false
                }
                self.viewTopLeftCancel.isHidden = true
                self.viewTopDrop.isHidden = true
                self.btnNewTopBack.isHidden = true
                self.buttonTopNewPickUp.isHidden = false
                self.viewRequest.isHidden = true
                self.viewPay.isHidden = true
                self.viewFareEstimate.isHidden = true
                self.viewRideShareNumbers.isHidden = true
                self.viewMapArcane.padding = UIEdgeInsetsMake(100, 0, 100, 0)

            }

        }
    }
    
    // request cancelled by close action and timeup action
    
    func cancelRequest(){
        self.viewMapArcane.padding = UIEdgeInsetsMake(100, 0, 100, 0)
        
        self.buttonTopPickUp.isEnabled = true
        self.buttonTopDrop.isEnabled = true
        
        self.requestPressed = "no" // to stop updating location header after request given.
        
        self.viewPickupCentre.isHidden = false
        self.viewPay.isHidden = true
        self.viewFareEstimate.isHidden = true
        self.viewRideShareNumbers.isHidden = true
        self.labelTopPickupCentre.isHidden = true
        self.viewTopDrop.isHidden = true
        self.btnNewTopBack.isHidden = true
        self.viewTopLeftCancel.isHidden = true
        self.viewTopLeftMenu.isHidden = false
        self.viewRequest.isHidden = true
        self.viewCancelRequest.isHidden = true
        viewMapArcane.settings.myLocationButton = true
        /// progressViewOutlet.isHidden = true
        self.linearBar.stopAnimation()
        self.viewLineNewBar.isHidden = true
        self.statusView.isHidden = true
        //// progressViewOutlet.setProgress(0.0, animated: false)
        indexProgressBar = 0
        timer.invalidate()
        //        self.timer = nil

        
        self.requestDisableView.isHidden = true
        self.btnLeft.isUserInteractionEnabled = true

        
        DispatchQueue.main.async { () -> Void in
            
            var urlstring:String = "\(live_url)requests/cancelRequest/request_id/\(self.appDelegate.request_id!)"
            
            self.appDelegate.accepted_Driverid = ""
            
            urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
            print(urlstring)
            
            let manager : AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
            
            manager.responseSerializer.acceptableContentTypes =  Set<AnyHashable>(["application/json", "text/json", "text/javascript", "text/html"])
            
            manager.get( "\(urlstring)",
                parameters: nil,
                success: { (operation: AFHTTPRequestOperation?,responseObject: Any?) in
                    if let jsonObjects=responseObject as? NSArray {
                        //                var dataDict: NSDictionary?
                        for dataDict : Any in jsonObjects {
                            let message: NSString! = (dataDict as AnyObject).object(forKey: "status") as? NSString
                            
                            //define and get the accept statust
                            if(message == "accept"){
                                // handle arrivenow view.
                            }
                            else{
                                // cancel action and get back to request view.
                                
                            }
                            
                        }
                    }
            },
                failure: { (operation: AFHTTPRequestOperation?,error: Error) in
                    print("Error: " + error.localizedDescription)
                    //let alertview = UIAlertView()
                    //  alertview.title = "Error!"
                    //  alertview.message = "\(error.localizedDescription)"
                    //  alertview.addButton(withTitle: "OK")
                    //  alertview.show()
            })

        
        }
        
    }
    
    /**
     Locate map with longitude and longitude after search location on UISearchBar
     
     - parameter lon:   longitude location
     - parameter lat:   latitude location
     - parameter title: title of address location
     */
    func locateWithLongitude(_ lon: Double, andLatitude lat: Double, andTitle title: String) {
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        print(lon)
        print(lat)
        
        self.pickupLocation = CLLocation(latitude: lat, longitude: lon)
        
        DispatchQueue.main.async { () -> Void in
            
            let position = CLLocationCoordinate2DMake(lat, lon)
            
            
            if self.touchPickUp == true {
                
                if self.touched == true{
                    
                    
                    self.viewTopLeftMenu.isHidden = true
                    self.viewTopLeftCancel.isHidden = false
                    self.viewTopDrop.isHidden = false
                    self.btnNewTopBack.isHidden = false
                    self.buttonTopNewPickUp.isHidden = true
                    self.viewRequest.isHidden = false
                    self.viewPay.isHidden = false
                    self.viewRideShareNumbers.isHidden = false

                }

                
                self.appDelegate.pickupLocation = CLLocation(latitude: lat, longitude: lon)
                
                let camera = GMSCameraPosition.camera(withLatitude: self.pickupLocation.coordinate.latitude, longitude: self.pickupLocation.coordinate.longitude, zoom: self.viewMapArcane.camera.zoom)
                
                self.viewMapArcane.camera = camera
                
//                marker.title = "Address : \(title)"
//                marker.map = self.viewMapArcane
                self.labelTopPickup.text = "\(title)"
                
                
                /*self.viewTopDrop.isHidden = false
                self.btnNewTopBack.isHidden = false
                self.buttonTopNewPickUp.isHidden = true
                self.labelTopPickupCentre.isHidden = false
                self.viewRequest.isHidden = false
                self.viewPay.isHidden = false*/
                
                if(self.loadingFirst == true){
                    self.loadingFirst = false
                }
                else{
                }
                
                UserDefaults.standard.set("", forKey: "trip_id")
                
                self.touchPickUp = false

                self.nearbyLocation = self.pickupLocation
                //self.viewMapArcane.clear()
                self.nearBy()

                
            }
            else if self.touchDrop == true{
                
                
                self.viewTopPickup.isHidden = false
                self.viewTopDrop.isHidden = false
                self.btnNewTopBack.isHidden = false
                self.buttonTopNewPickUp.isHidden = true
                self.viewPay.isHidden = false
                self.viewRideShareNumbers.isHidden = false

                if self.riderClickedfareEstimate == "click"{
                    
                    self.viewRequest.isHidden = true

                }
                else{
                    
                    self.viewRequest.isHidden = false
                }
                
                self.appDelegate.dropLocation = CLLocation(latitude: lat, longitude: lon)
                self.touchDrop = false
                self.labelTopDrop.text = "\(title)"
                self.getCountryForDrop(myLocation: self.appDelegate.dropLocation)
                self.labelTopDrop.textColor = UIColor(hex: "#6F511F")
            }
            else if self.touchDropupdate == true{
                self.appDelegate.dropLocation = CLLocation(latitude: lat, longitude: lon)
                self.labelToUpdatepDrop.text = "\(title)"
                var updateloc =  self.labelToUpdatepDrop.text
                print("updateloc~~\(updateloc!)")
                self.appDelegate.updatelocationname = updateloc!
                self.appDelegate.updatelocationstatus = 1
                self.getCountryForDropupdate(myLocation: self.appDelegate.dropLocation)
                self.labelToUpdatepDrop.textColor = UIColor(hex: "#6F511F")
            }
            else{
                
                
                self.viewTopPickup.isHidden = false
                self.viewTopDrop.isHidden = true
                self.btnNewTopBack.isHidden = true
                self.buttonTopNewPickUp.isHidden = false
                self.viewRequest.isHidden = true
                self.viewPay.isHidden = true
                self.viewFareEstimate.isHidden = false
                self.viewRideShareNumbers.isHidden = true
                self.labelTopPickupCentre.isHidden = true
                self.viewMapArcane.padding = UIEdgeInsetsMake(100, 0, 170, 0)
                
            }
            
            
            
            
        /*    if self.buttonTopPickUp.tag == 0{
                
                print(lat)
                print(lon)
                
                self.appDelegate.pickupLocation = CLLocation(latitude: lat, longitude: lon)
                
                let camera = GMSCameraPosition.camera(withLatitude: self.pickupLocation.coordinate.latitude, longitude: self.pickupLocation.coordinate.longitude, zoom: 12)
                
                self.viewMapArcane.camera = camera
                
                marker.title = "Address : \(title)"
                marker.map = self.viewMapArcane
                self.labelTopPickup.text = "\(title)"
                
                self.viewTopDrop.isHidden = false
                self.labelTopPickupCentre.isHidden = false
                self.viewRequest.isHidden = false
                self.viewPay.isHidden = false

                if(self.loadingFirst == true){
                    self.loadingFirst = false
                }
                else{
                    
                    self.viewTopDrop.isHidden = false
                    self.viewPay.isHidden = false
                    self.labelTopPickupCentre.isHidden = false
                    
                }
                
                self.buttonTopPickUp.tag = 1

                
            }
            else{
                
                
                self.appDelegate.dropLocation = CLLocation(latitude: lat, longitude: lon)
                
                self.labelTopDrop.text = "\(title)"
                
                self.viewRequest.isHidden = false
                self.viewPay.isHidden = false
                
                self.viewMapArcane.settings.myLocationButton = false
                self.viewMapArcane.settings.indoorPicker = false
                self.viewMapArcane.isIndoorEnabled = false
                
                
            }*/
            
        }
        
    }
    
    func requesting(){
        
        //call Json
        print(self.appDelegate.pickupLocation.coordinate.latitude)
        print(self.appDelegate.pickupLocation.coordinate.longitude)
        print(self.appDelegate.dropLocation.coordinate.latitude)
        print(self.appDelegate.dropLocation.coordinate.longitude)
        
        
        self.requestStatus = 1
        
        
        let catCategory = self.carCategoryPass
        
        if catCategory == ""{
            
            self.carCategoryPass = "Standard"
        }
        else{
            
            self.carCategoryPass = catCategory
        }
        
        print("car fare /\(self.carCategoryPass)")
        
        
        print(self.appDelegate.pickupLocation.coordinate.latitude)
        print(self.appDelegate.pickupLocation.coordinate.longitude)
        print(self.appDelegate.dropLocation.coordinate.latitude)
        print(self.appDelegate.dropLocation.coordinate.longitude)
        
        let userLocation:CLLocation = CLLocation(latitude: Double(self.appDelegate.pickupLocation.coordinate.latitude), longitude: Double(self.appDelegate.pickupLocation.coordinate.longitude))
        
        let priceLocation:CLLocation = CLLocation(latitude: Double(self.appDelegate.dropLocation.coordinate.latitude), longitude: Double(self.appDelegate.dropLocation.coordinate.longitude))
        
        let distance = String(format: "%.2f", userLocation.distance(from: priceLocation)/1000)
        
        
        print("Distance is KM is:: \(distance)")
        
        var carPrice = self.carCategoryPass
        var carNamePriceKM : String!
        var carNamePriceFare : String!
        
        
        if carPrice == ""{
            
            //Hatchback
            carNamePriceKM = self.arrayOfPrice_KM.firstObject as! String
            carNamePriceFare = self.arrayOfMinFare.firstObject as! String
            print(" hatch km \(carNamePriceKM)")
            print(" hatch  fare\(carNamePriceFare)")
        }
        else if carPrice == self.labelCarName2.text!{
            
            //Sedan
            carNamePriceKM = "\(self.arrayOfPrice_KM[1])"
            carNamePriceFare = "\(self.arrayOfMinFare[1])"
            print(" Sedan \(carNamePriceKM)")
            print(" Sedan fare\(carNamePriceFare)")
            
        }
        else if carPrice == self.labelCarName1.text!{
            
            //Hatchback
            carNamePriceKM = self.arrayOfPrice_KM.firstObject as! String?
            carNamePriceFare = self.arrayOfMinFare.firstObject as! String?
            print(" hatch km \(carNamePriceKM)")
            print(" hatch  fare\(carNamePriceFare)")
            
        }
        else if carPrice == self.labelCarName3.text!{
            
            //Hatchback
            carNamePriceKM = "\(self.arrayOfPrice_KM[2])"
            carNamePriceFare = "\(self.arrayOfPrice_KM[2])"
            print(" hatch km \(carNamePriceKM)")
            print(" hatch  fare\(carNamePriceFare)")
            
        }
        else{
            
            //SUV
            /* carNamePriceKM = self.arrayOfPrice_KM.lastObject as! String
             carNamePriceFare = self.arrayOfMinFare.lastObject as! String*/
            carNamePriceKM = "\(self.arrayOfPrice_KM[3])"
            carNamePriceFare = "\(self.arrayOfPrice_KM[3])"
            print(" SUV Km\(carNamePriceKM)")
            print(" SUV fare\(carNamePriceFare)")
            
        }
        
        let value1 : Double = (carNamePriceKM! as NSString).doubleValue
        
        let myInt = (distance as NSString).doubleValue
        
        let total = myInt * value1
        
        print("\(total)")
        
        let value2 : Double = (carNamePriceFare as NSString).doubleValue
        
        let value3Final  = total + value2
        
        print(" plus values \(value3Final)")
        
        self.estimatedfare = value3Final
        
        self.setRequestStatus()
        
    }
    
    func setRequestStatus(){
        
        //changed to requestStatus as 2 by accepting by the driver.
        
        let catCategory = self.carCategoryPass
        
        if catCategory == ""{
            
            self.carCategoryPass = "Standard"
        }
        else{
            
            self.carCategoryPass = catCategory
        }
        
        print("car request /\(self.carCategoryPass)")
        
        let maxShareValues = self.btnPickShareRideNumbers.titleLabel?.text
        var passRideType = ""
        
        print("share count\(maxShareValues)")
        
        if checked == "no"{
            
            passRideType = "none"
        }
        else{
            
            passRideType = "shared"
        }
        
        let value = UserDefaults.standard.object(forKey: "cashMode") as! String!
        
        if value == nil{
            
            self.amountPass = "cash"
        }
        else if value == "cash"{
            
            self.amountPass = "cash"
        }
        
        else if value == "corporate id"{
            
            self.amountPass = "corpID"
        }
        else{
            
            self.amountPass = "stripe"
        }
        
        self.requestStatus = 2
        
        var urlstring:String = "\(url!)requests/setRequest/userid/\(self.appDelegate.userid!)/start_lat/\(self.appDelegate.pickupLocation.coordinate.latitude)/start_long/\(self.appDelegate.pickupLocation.coordinate.longitude)/end_lat/\(self.appDelegate.dropLocation.coordinate.latitude)/end_long/\(self.appDelegate.dropLocation.coordinate.longitude)/payment_mode/\(self.amountPass)/pickup_address/\(self.pickAddress)/drop_address/\(self.dropAddress)/category/\(self.carCategoryPass)/ride_type/\(passRideType)/max_share/\(maxShareValues)"
        
        urlstring = urlstring.replacingOccurrences(of: "Optional(", with: "")
        urlstring = urlstring.replacingOccurrences(of: ")", with: "")
        urlstring = urlstring.replacingOccurrences(of: "\"", with: "")
        urlstring = urlstring.replacingOccurrences(of: ",", with: "+")
        urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        print(urlstring)
        
        
        Alamofire.request(urlstring).responseJSON { (response) in
            print(urlstring)
            //            print(response)
            do{
                
                let readableJSon:NSArray! = try JSONSerialization.jsonObject(with: response.data!, options: .mutableContainers) as! NSArray
                
                print(" !!! \(readableJSon[0])")
                
                if let value:NSDictionary = readableJSon[0] as? NSDictionary{
                    
                    //                    print(value["destination"]!)        // dictionary
                    //                    print(value["pickup"]!)             // dictionary
                    //                    print(value["request_id"]!)         // String
                    //                    print(value["request_status"]!)     // String
                    //                    print(value["rider_id"]!)           // String
                    
                    if let pickup:NSDictionary = value["pickup"] as? NSDictionary{
                        let pickupLat:String = pickup["lat"] as! String
                        let pickupLong:String = pickup["long"] as! String
                        
                        self.appDelegate.pickup_lat = pickupLat
                        self.appDelegate.pickup_long = pickupLong
                        
                        
                    }
                    if let dest:NSDictionary = value["destination"] as? NSDictionary{
                        let destLat:String = dest["lat"] as! String
                        let destLong:String = dest["long"] as! String
                        
                        self.appDelegate.dest_lat = destLat
                        self.appDelegate.dest_long = destLong
                        
                    }
                    
                    self.appDelegate.request_id = value["request_id"] as! String
                    self.appDelegate.request_status = value["request_status"] as! String
                    print("Requesting")
                    
                    self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ARMainMapVC.setProgressBar), userInfo: nil, repeats: true)
                    
                    self.processURL()
                    
                    self.getProcessRequest() //  not in use

                    
                }
            }
            catch{
                
                print(error)
                
            }
            
        }
        
        
    }
    
    
    
    func setProgressBar()
    {
        if indexProgressBar == poseDuration
        {
            //getNextPoseData()
            
            // reset the progress counter
            indexProgressBar = 0
        }
        
        // update the display
        // use poseDuration - 1 so that you display 20 steps of the the progress bar, from 0...19
      //  progressViewOutlet.progress = Float(indexProgressBar) / Float(poseDuration - 1)
        
        // increment the counter
        indexProgressBar += 1
        
        if(indexProgressBar % 2 == 0){
            if(accepted == "no"){
                self.getRequestURL()
            }
            else{
                if self.cancelReq == "pressed"{
                    
//                    self.cancelReq = ""
                }
                else{
                    
                    self.cancelReq = "not"

                }
                self.cancelRequest()
//                self.btnCancelRequestAction(self.btnCancelProgress)
            }
        }
        
        if(indexProgressBar == 15){
//            indexProgressBar = 0
//            timer.invalidate()
        }
        
    }
    
    func getRequestURL(){
        
      
        var urlstring:String = "\(live_url)requests/getRequest/request_id/\(self.appDelegate.request_id!)"
        
        urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        print(urlstring)
        
        
        
        let manager : AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
        
        //manager.responseSerializer.acceptableContentTypes =  Set<AnyHashable>(["application/json", "text/json", "text/javascript", "text/html"])
        
        manager.get( "\(urlstring)",
            parameters: nil,
            success: { (operation: AFHTTPRequestOperation?,responseObject: Any?) in
                let jsonObjects=responseObject as! NSArray
                //                var dataDict: NSDictionary?
                
                let value = jsonObjects[0] as AnyObject
                
                print(value)
                

                if let request_status:String = value["request_status"] as? String{
                    if(request_status == "processing"){
                        //  self.appDelegate.req_status = request_status
                        self.loopingReqeustStatus = "Process"
                        
                    }
                    else if(request_status == "no_driver"){
                        
                        self.loopingReqeustStatus = "No Driver"
                        
                        //    self.appDelegate.req_status = request_status
                        self.cancelReq = "not"
                        self.cancelRequest()
//                        self.btnCancelRequestAction(self.btnCancelProgress)
                        
                    }
                    else if(request_status == "accept"){
                        
                        self.accepted = "yes"
                        self.loopingReqeustStatus = "Accepted"
                        self.driverETAlbl.isHidden = false
                   
                        self.ridelater = "1"  //me
                        self.timer.invalidate()
                        
                   ////     self.progressViewOutlet.setProgress(0, animated: false)
                        print(UserDefaults.standard.object(forKey: "isTerminal"))
                        if (UserDefaults.standard.object(forKey: "isTerminal") != nil)
                        {
                            self.terminalView.isHidden = false
                        }else{
                            self.terminalView.isHidden = true
                        }
                      
                        self.linearBar.stopAnimation()
                        self.statusView.isHidden = true
                        self.viewLineNewBar.isHidden = true
                        self.appDelegate.req_status = request_status
                        let driver_id:String = (value["driver_id"] as? String)!
                        self.appDelegate.accepted_Driverid = driver_id
                        var carcat:String = (value["category"] as? String)!
                        if("\(carcat)" != ""){
                            
                            carcat = carcat.replacingOccurrences(of: "Optional(", with: "")
                            carcat = carcat.replacingOccurrences(of: ")", with: "")
                            UserDefaults.standard.set("\(carcat)", forKey: "acceptedDriverCarCategoryName")
                        }
                        
                        if(self.appDelegate.accepted_Driverid! != ""){
                            let ref1 = FIRDatabase.database().reference().child("drivers_data").child(self.appDelegate.accepted_Driverid!).child("accept")
                            ref1.updateChildValues(["status": 0])
                            
                            let ref2 = FIRDatabase.database().reference().child("drivers_data").child(self.appDelegate.accepted_Driverid!).child("request")
                            ref2.updateChildValues(["status": 0])
                            
                        }
                        

                        UserDefaults.standard.setValue(driver_id, forKey: "tripDriverid")
                        var driver_locLat:String = ""
                        var driver_locLong:String = ""
                        

                        
                        if let driver_location:NSDictionary = (value["driver_location"] as? NSDictionary){
                            print(driver_location["lat"]!)
                            print(driver_location["long"]!)
                            
                            driver_locLat = driver_location["lat"]! as! String
                            driver_locLong = driver_location["long"]! as! String
                            self.timer.invalidate()
                            
                            self.appDelegate.driverLat = driver_location["lat"]! as! String
                            self.appDelegate.driverLong = driver_location["long"]! as! String
                            
                          ////  self.progressViewOutlet.isHidden = true
                            self.linearBar.stopAnimation()
                            self.viewLineNewBar.isHidden = true
                            self.viewCancelRequest.isHidden = true
                            self.statusView.isHidden = false
                            self.viewPickupCentre.isHidden = true
                            self.addressView.isHidden = true
                            self.viewPay.isHidden = true
                            self.viewFareEstimate.isHidden = true
                            self.viewRideShareNumbers.isHidden = true
                            self.viewMapArcane.isMyLocationEnabled = false
                            self.driverDetail.isHidden = false
                            self.viewCurrentTrip.isHidden = false
                            self.viewBlurCurrentTrip.isHidden = false

                            var handle: UInt = 0
                            

                            self.viewMapArcane.padding = UIEdgeInsetsMake(100, 0, 100, 0)
                            
                            //self.ref1.removeObserver(withHandle: handle)

                        }
                        
                        let pickup:NSDictionary = (value["pickup"] as? NSDictionary)!
                        let destination:NSDictionary = (value["destination"] as? NSDictionary)!
                        
                        print(pickup["lat"]!)
                        print(pickup["long"]!)
                        
                        print(destination["lat"]!)
                        print(destination["long"]!)
                        
                        let pickupLat:String = (pickup["lat"] as? String)!
                        let pickupLong:String = (pickup["long"] as? String)!
                        
                        let destLat:String = (destination["lat"] as? String)!
                        let destLong:String = (destination["long"] as? String)!
                        
                        //self.myOrigin = CLLocation(latitude: Double(pickupLat)!,longitude: Double(pickupLong)!)
                        //self.myDestination = CLLocation(latitude: Double(destLat)!,longitude: Double(destLong)!)
                        
                        self.startLocation = CLLocation(latitude: Double(pickupLat)!,longitude: Double(pickupLong)!)
                        //self.lastLocation = CLLocation(latitude: Double(destLat)!,longitude: Double(destLong)!)
                        
                        
                        //self.myOrigin = CLLocation(latitude: Double(driver_locLat)!,longitude: Double(driver_locLong)!)
                        //self.myDestination = CLLocation(latitude: Double(pickupLat)!,longitude: Double(pickupLong)!)
                        
                        self.imageName = "endPinRound"
                        self.imageName1 = "markerloc1"
                        self.imageName2 = "markerloc2"
                        self.imageName3 = "markerloc3"
                        self.imageName4 = "markerloc4"

                        
                        self.driverLocation = CLLocation(latitude: Double(driver_locLat)!,longitude: Double(driver_locLong)!)
                        
                        self.dropDestination = CLLocation(latitude: Double(destLat)!,longitude: Double(destLong)!)

                        self.pickup = CLLocation(latitude: Double(pickupLat)!,longitude: Double(pickupLong)!)
                        self.dropup = CLLocation(latitude: Double(destLat)!,longitude: Double(destLong)!)

                        self.distance1 = self.pickup
                        self.distance2 = self.pickup

                        // set drop location
                        
                        let droplat = "\(self.dropup.coordinate.latitude)"
                        let droplng = "\(self.dropup.coordinate.longitude)"
                        
                       
                            UserDefaults.standard.setValue(droplat, forKey: "Droplat")
                            UserDefaults.standard.setValue(droplng, forKey: "Droplng")
         
                        // set pickup location
                        
                        let pickuplat = "\(self.pickup.coordinate.latitude)"
                        let pickuplng = "\(self.pickup.coordinate.longitude)"
                        
                        UserDefaults.standard.setValue(pickuplat, forKey: "pickuplat")
                        UserDefaults.standard.setValue(pickuplng, forKey: "pickuplng")

                        // set driver location
                        
                        let driverlat = "\(self.driverLocation.coordinate.latitude)"
                        let driverlng = "\(self.driverLocation.coordinate.longitude)"
                        
                        UserDefaults.standard.setValue(driverlat, forKey: "driverlat")
                        UserDefaults.standard.setValue(driverlng, forKey: "driverlng")

                        
                        self.requestDisableView.isHidden = true
                        self.btnLeft.isUserInteractionEnabled = true

                        
                        
                        
                        
                        
                    }
                    else{
                        
                    }
                    
                }
                self.checkLoop()
                
                
                

                
        },
            failure: { (operation: AFHTTPRequestOperation?,error: Error) in
                print("Error: " + error.localizedDescription)
                //let alertview = UIAlertView()
                //  alertview.title = "Error!"
                //  alertview.message = "\(error.localizedDescription)"
                //  alertview.addButton(withTitle: "OK")
                //  alertview.show()
        })
        
        
    }
    
    func checkLoop(){
        if(loopingReqeustStatus == "Process"){
            print("Process")
            self.getRequestURL()
            self.loopingReqeustStatus = ""
        }
        else if(loopingReqeustStatus == "No Driver"){
            
            if(alert == 1){
                
                self.noDriver()
                alert = 0
            }
            print("No Driver")
            self.loopingReqeustStatus = ""

        }
        else if(loopingReqeustStatus == "Accepted"){
            
            
            
            self.noteString = "Driver accepted your request."
            
            self.getDriverDetails()
            
            self.ridelater = "1"

            
            self.statusLabel.text = "ACCEPTED"
            self.driverETAlbl.isHidden = false
            self.btnInfo.isHidden = false
          //  self.licplate_no.isHidden = false
        //    self.licplate_no.layer.cornerRadius = 15
            
            if (UserDefaults.standard.object(forKey: "isTerminal") != nil)
            {
                self.terminalView.isHidden = false
            }else{
                self.terminalView.isHidden = true
            }
            
            print("Getting driver Information")
     //       self.driverDetail.isHidden = false   // new issue
            self.viewCurrentTrip.isHidden = true
            self.viewBlurCurrentTrip.isHidden = true

            print(self.appDelegate.accepted_Driverid!)
            
               /* self.ref.child("drivers_data").child("\(self.appDelegate.accepted_Driverid!)").child("accept").child("tollfee").observe(.value, with: { (snapshot) in

                    print("updating toll status")
                    if(snapshot.exists()){
                        let status1 = snapshot.value as Any
                        print(status1)
                        var status = "\(status1)"
                        status = status.replacingOccurrences(of: "Optional(", with: "")
                        status = status.replacingOccurrences(of: ")", with: "")
                        print(status)
                        self.appDelegate.total_tollfee = status
                        self.total_tollfee.text = "Toll fee: $\(status)"
                    }
                    else{
                       self.total_tollfee.text = "Toll fee: $0"
                    }
                    
                })*/
            
           // loop_i = loop_i + 1
            
            
            self.loopingReqeustStatus = ""
            self.getTripID()
            self.myOrigin = self.driverLocation
            self.myDestination = self.pickup
            self.gettingDirectionsAPI()   // to set  polyline for pickup location to driversloca
            
            //To listen about the trip updates from the driver like arrived/start/end trip
            self.newStatusTrip()
            self.startBearing(location: self.myOrigin)



        }
        else{
            print("some error occured")
        }
    }

    var cancelReq = "not"
    
    func noDriver(){
        
        self.viewRequest.isHidden = true
        self.viewCancelRequest.isHidden = true
        viewMapArcane.settings.myLocationButton = true
      ////  progressViewOutlet.isHidden = true
        self.linearBar.stopAnimation()
        self.viewLineNewBar.isHidden = true
        self.statusView.isHidden = true
        indexProgressBar = 0
        timer.invalidate()
        
        if self.cancelReq == "pressed"{
            self.cancelReq = ""
        }
        else if self.cancelReq == "not"{
            
            let alert = UIAlertView()
            
            alert.title = "No Drivers"
            alert.message = "There is no Drivers"
            alert.delegate = self
            alert.addButton(withTitle: "Ok")
            alert.show()
            
            self.buttonTopNewPickUp.isHidden = false
             if(fareestimateclicked == "0"){
            self.viewCarCategory.isHidden = false
            }
            self.viewPay.isHidden = true
            self.viewFareEstimate.isHidden = true
            self.viewRideShareNumbers.isHidden = true
            self.viewMapArcane.padding = UIEdgeInsetsMake(100, 0, 100, 0)

        }
        else{
            
        }
    }
    
    func getNextPoseData()
    {
        // do next pose stuff
        currentPoseIndex += 1
        print(currentPoseIndex)
    }
    
    func processURL(){
        
        
        // function in use
//        self.getRequestAlf()
        
//        self.getRequestURL()
        
        
        var urlstring:String = "\(live_url)requests/processRequest/request_id/\(self.appDelegate.request_id!)/est_fare/\(self.estimatedfare)"
        
        urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        print(urlstring)
        
        
        let manager : AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
        manager.responseSerializer.acceptableContentTypes =  NSSet(objects: "text/plain", "text/html", "application/json", "audio/wav", "application/octest-stream") as Set<NSObject>
        
        manager.get("\(urlstring)",
            parameters: nil,
            success: { (operation: AFHTTPRequestOperation?,responseObject: Any?) in
                let jsonObjects:NSArray = responseObject as! NSArray
                //  var dataDict: NSDictionary?
                let value = jsonObjects[0] as AnyObject
                print(value)
                self.trip_id = value.object(forKey: "trip_id") as! String
                self.appDelegate.trip_id = self.trip_id
                
//                let carcategory = value.object(forKey: "category") as! String
//                print("car\(carcategory)")
//                self.carCategoryPass = carcategory
//                self.gettingDirectionsAPI()
                
        
        },
            failure: { (operation: AFHTTPRequestOperation?,error: Error) in
                print("Error: " + error.localizedDescription)
                
                //let alertview = UIAlertView()
                //  alertview.title = "Error!"
                //  alertview.message = "\(error.localizedDescription)"
                //  alertview.addButton(withTitle: "OK")
                //  alertview.show()
        })
        
        
        
        
        
    }
    
    // if processurl is using in alamofire then use this funciton
    
    func processParse(JSONData : Data){
        
        do{
            
            let readableJSon = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as! jsonSTD
            
            print(" !!! \(readableJSon[0])")
            
            let value = readableJSon[0] as AnyObject
            
            let final = value.object(forKey: "status")
            print(final!)
            
            
        }
        catch{
            
            print(error)
            
        }
        
    }

    
    func firstCharacterUppercaseString(string: String) -> String {
        
        let str = string as NSString
        let firstUppercaseCharacter = str.substring(to: 1).uppercased()
        let firstUppercaseCharacterString = str.replacingCharacters(in: NSMakeRange(0, 1), with: firstUppercaseCharacter)
        print(firstUppercaseCharacterString)
        return firstUppercaseCharacterString
        
    }
    
    func getDriverDetails(){
        
        // calling driver profile url
        // self.appDelegate.accepted_Driverid
        
        self.driverDetail.isHidden = false
        
        //self.btnCancelRequestAction(self.btnCancelProgress)

        self.myOrigin = self.driverLocation
        self.myDestination = self.pickup
        
        self.gettingDirectionsAPI()

        
        
        var urlstring:String = "\(live_Driver_url)editProfile/user_id/\(self.appDelegate.accepted_Driverid!)"
        
        
        urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        print(urlstring)
        
        let manager : AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
        
        manager.responseSerializer.acceptableContentTypes =  Set<AnyHashable>(["application/json", "text/json", "text/javascript", "text/html"])
        
        manager.get( "\(urlstring)",
            parameters: nil,
            success: { (operation: AFHTTPRequestOperation?,responseObject: Any?) in
                let jsonObjects=responseObject as! NSArray
                //                var dataDict: NSDictionary?
                if let request_status:NSDictionary = jsonObjects[0] as? NSDictionary{
                    print(request_status)
                    if var firstname:String = request_status["firstname"] as? String{
                        if("\(firstname)" != ""){
                            print(firstname)
                            firstname = firstname.replacingOccurrences(of: "Optional(", with: "")
                            firstname = firstname.replacingOccurrences(of: ")", with: "")
                            
                            self.driverFirstName = "\(firstname)"
                            print("Mouni \(self.driverFirstName)")
                           // self.driverName.text = "\(firstname)"
                        }
                    }
                    if var lastName:String = request_status["lastname"] as? String{
                        if("\(lastName)" != ""){
                            
                            lastName = lastName.replacingOccurrences(of: "Optional(", with: "")
                            lastName = lastName.replacingOccurrences(of: ")", with: "")
                            
                            self.driverLastName = "\(lastName)"
                            
                        }
                    }
                    var value = "\(self.driverFirstName) \(self.driverLastName)"
                    print(value)
                    
                    value = value.replacingOccurrences(of: "Optional(", with: "")
                    value = value.replacingOccurrences(of: ")", with: "")
                    value = value.replacingOccurrences(of: "\"", with: "")
                    value = value.replacingOccurrences(of: "%20", with: " ")
                    let name = self.firstCharacterUppercaseString(string: "\(value)")
                    
                    self.driverName.text = name
                    self.labelCurrentTripDriver.text = value
                    
                    UserDefaults.standard.set(value, forKey: "acceptedDriverName")

                    if var carCatgory:String = request_status["category"] as? String{
                        
                        print("mounii\(carCatgory)")
                        if("\(carCatgory)" != ""){
                            
                            carCatgory = carCatgory.replacingOccurrences(of: "Optional(", with: "")
                            carCatgory = carCatgory.replacingOccurrences(of: ")", with: "")
                            
                            self.labelCurrentTripDriverCar.text = "\(carCatgory)"
                            
                            self.carNameLabel.text = "\(carCatgory)"
                            
                            UserDefaults.standard.set("\(carCatgory)", forKey: "acceptedDriverCarCategoryName")
                            
                            UserDefaults.standard.set(carCatgory, forKey: "qwe")
                            
                            let dasda = UserDefaults.standard.value(forKey: "qwe")
                            
                            print(" aeae \(dasda!)")
                            
                        }
                        self.carCategoryPass = carCatgory
                        if("\(carCatgory)" == self.labelCarName1.text!){
                            
                            carCatgory = carCatgory.replacingOccurrences(of: "Optional(", with: "")
                            carCatgory = carCatgory.replacingOccurrences(of: ")", with: "")
                         //   carCatgory = (carCatgory as AnyObject).replacingOccurrences(of: "%20", with: " ")
                            self.carimg.image = UIImage(named: "ic_thumb_standard.png")
                             self.carNameLabel.text = "\(carCatgory)"
                        }
                        else if("\(carCatgory)" == self.labelCarName2.text!){
                            
                            carCatgory = carCatgory.replacingOccurrences(of: "Optional(", with: "")
                            carCatgory = carCatgory.replacingOccurrences(of: ")", with: "")
                        //    carCatgory = (carCatgory as AnyObject).replacingOccurrences(of: "%20", with: " ")
                            self.carimg.image = UIImage(named: "ic_thumb_suv.png")
                             self.carNameLabel.text = "\(carCatgory)"
                        }
                        else if("\(carCatgory)" == self.labelCarName3.text!){
                            
                            carCatgory = carCatgory.replacingOccurrences(of: "Optional(", with: "")
                            carCatgory = carCatgory.replacingOccurrences(of: ")", with: "")
                           // carCatgory = (carCatgory as AnyObject).replacingOccurrences(of: "%20", with: " ")
                            self.carimg.image = UIImage(named: "ic_thumb_luxury.png")
                            self.carNameLabel.text = "\(carCatgory)"
                        }
                        else if("\(carCatgory)" == self.labelCarName4.text!){
                            
                            carCatgory = carCatgory.replacingOccurrences(of: "Optional(", with: "")
                            carCatgory = carCatgory.replacingOccurrences(of: ")", with: "")
                          //  carCatgory = (carCatgory as AnyObject).replacingOccurrences(of: "%20", with: " ")
                            self.carimg.image = UIImage(named: "ic_thumb_taxi.png")
                            self.carNameLabel.text = "\(carCatgory)"
                        }
                            
   
                        else{
                            
                            self.labelCurrentTripDriverCar.text = ""
                            
                            self.carNameLabel.text = ""
                        }
                        
                    }
                    self.gettingDirectionsAPI()
                    
                    if var carmodel:String = request_status["vehicle_model"] as? String{
                        print("model\(carmodel)")
                        if("\(carmodel)" != ""){
                            
                            carmodel = carmodel.replacingOccurrences(of: "Optional(", with: "")
                            carmodel = carmodel.replacingOccurrences(of: ")", with: "")
                            //carmodel = (carmodel as AnyObject).replacingOccurrences(of: "%20", with: " ")
                            
                           // self.labelCurrentTripDriverCar.text = "\(carCatgory)"
                            self.carmodel.text = "\(carmodel)"
                        }
                            
                        else{
                            
                            //self.labelCurrentTripDriverCar.text = ""
                            
                            self.carmodel.text = ""
                        }
                        
                    }
                        
                    else{
                        
                    }
                    
                    if var plate_no:String = request_status["number_plate"] as? String{
                        print(plate_no)
                        if("\(self.plateno)" != ""){
                            
                            plate_no = plate_no.replacingOccurrences(of: "Optional(", with: "")
                            plate_no = plate_no.replacingOccurrences(of: ")", with: "")
                            plate_no = plate_no.replacingOccurrences(of: "%20", with: " ")
                            
                            // self.labelCurrentTripDriverCar.text = "\(carCatgory)"
                            
                            self.platenoo.text = "\(plate_no)"
                            print(self.platenoo.text!)
                        }
                        else{
                            
                            //self.labelCurrentTripDriverCar.text = ""
                            
                            self.licplate_no.text = ""
                        }
                        
                    }

                     var mobile = request_status["mobile"] as? String
                        
                        if mobile == nil || mobile == "" {
                            
                            mobile = ""

                        }
                        else{
                            
                            mobile = (mobile as AnyObject).replacingOccurrences(of: "Optional(", with: "")
                            mobile = (mobile as AnyObject).replacingOccurrences(of: ")", with: "")
                            mobile = (mobile as AnyObject).replacingOccurrences(of: "%20", with: " ")
                            
                            UserDefaults.standard.set(mobile, forKey: "acceptedDriverMobile")
                        }
                        
                    
                    if var profilePic:String = request_status["profile_pic"] as? String{
                        print("mouni\(profilePic)")
                        if("\(profilePic)" != ""){
                            
                            profilePic = profilePic.replacingOccurrences(of: "Optional(", with: "")
                            profilePic = profilePic.replacingOccurrences(of: ")", with: "")
                           // profilePic = (profilePic as AnyObject).replacingOccurrences(of: "%20", with: " ")
                            
                            
                            let imageURL1 = profilePic
                            print("2nd trip\(imageURL1)")
                            let url = URL(string: imageURL1)

                            if(url != nil){
                                self.driverPhoto.setImageWithUrl(url!)
                            
                                self.imageViewCurrentTripDriver.setImageWithUrl(url!)
                            }
                            
                            UserDefaults.standard.set(imageURL1, forKey: "acceptedDriverPhoto")
                            
                            UserDefaults.standard.set(imageURL1, forKey: "acceptedDriverPhoto1")
                            
                           
                        }
                        else{
                           
                            UserDefaults.standard.set("", forKey: "acceptedDriverPhoto1")
//                            self.driverPhoto.backgroundColor = UIColor.white
//                            self.viewDriverImage.backgroundColor = UIColor.white
                            
                        }
                        
                    }
                        
                        if var licensePic:String = request_status["license"] as? String{
                            if("\(licensePic)" != ""){
                                
                                licensePic = licensePic.replacingOccurrences(of: "Optional(", with: "")
                                licensePic = licensePic.replacingOccurrences(of: ")", with: "")
                                //licensePic = (licensePic as AnyObject).replacingOccurrences(of: "%20", with: " ")
                                
                                let imageURL1 = licensePic
                                
                                let url = URL(string: imageURL1)
                                
                                self.licensephoto.setImageWithUrl(url!)
                                
                               // self.imageViewCurrentTripDriver.setImageWithUrl(url!)
                                
                                UserDefaults.standard.set(imageURL1, forKey: "acceptedDriverPhoto")
                                
                                
                            }
                            else{
                                
                               
                                self.licensephoto.backgroundColor = UIColor.white
                                self.viewlicenseimage.backgroundColor = UIColor.white
                            }
                    }
                }
        },
            failure: { (operation: AFHTTPRequestOperation?,error: Error) in
                print("Error: " + error.localizedDescription)
                
                //let alertview = UIAlertView()
                //  alertview.title = "Error!"
                //  alertview.message = "\(error.localizedDescription)"
                //  alertview.addButton(withTitle: "OK")
                //  alertview.show()
        })
        // this function ends the continue calling function after accepted by the driver.
        
        self.notification()
    }
    
    
    
    
    func notification(){
        
        UNUserNotificationCenter.current().getNotificationSettings { (notificationSettings) in
            switch notificationSettings.authorizationStatus {
            case .notDetermined:
                self.requestAuthorization(completionHandler: { (success) in
                    guard success else { return }
                    
                    // Schedule Local Notification
                    if self.noteString != ""{
                        self.scheduleLocalNotification(status: "\(self.noteString)")
                        self.noteString = ""
                    }
                })
            case .authorized:
                
                // Schedule Local Notification
                
                if self.noteString != ""{
                    self.scheduleLocalNotification(status: "\(self.noteString)")
                    self.noteString = ""
                }
                
            case .denied:
                print("Application Not Allowed to Display Notifications")
            }
        }
    }
    
    
    internal func scheduleLocalNotification(status: String) {
        // Create Notification Content
        let notificationContent = UNMutableNotificationContent()
        
        // Configure Notification Content
       // notificationContent.title = "Arcane Rider"
        notificationContent.subtitle = ""
        notificationContent.body = status
        

        
        // Add Trigger
        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 1.0, repeats: false)
        
        // Create Notification Request
        let notificationRequest = UNNotificationRequest(identifier: "cocoacasts_local_notification", content: notificationContent, trigger: notificationTrigger)
        
        // Add Request to User Notification Center
        UNUserNotificationCenter.current().add(notificationRequest) { (error) in
            if let error = error {
                print("Unable to Add Notification Request (\(error), \(error.localizedDescription))")
            }
        }
    }
    
    
    internal func requestAuthorization(completionHandler: @escaping (_ success: Bool) -> ()) {
        // Request Authorization
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (success, error) in
            if let error = error {
                print("Request Authorization Failed (\(error), \(error.localizedDescription))")
            }
            
            completionHandler(success)
        }
    }

    internal func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
    internal func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print("didReceive")
        completionHandler()
    }
    
    var angle:Double! = 0.0

    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
            //self.angle = 0.0
            let  heading:Double = newHeading.trueHeading;
           // marker.rotation = heading
            marker.map = self.viewMapArcane
            print(marker.rotation)
           // self.angle = heading
        
    }



    func calcDistacneDynamic(){
        
        if self.distance1 == nil {
            
        }
        else{
            
            let distanceInMeters = self.distance2.distance(from: self.distance3) // result is in meters
            print(distanceInMeters)
            total = total + distanceInMeters
            print("distance in meter \(total)")
            print("distance in km \(total/1000)")
            
            self.distance2 = self.distance3

        }
        
        /*
         By changing previous as next and next as upnext using distance 2,3
         */
        
        //distance in meter 177.543054637013
    }


    
    func gettingDirectionsAPI(){
        
       // myOrigin = CLLocation(latitude: 9.9252, longitude: 78.1198)
       // myDestination = CLLocation(latitude: 13.0827, longitude: 80.2707)

        
        let originString = "\(myOrigin.coordinate.latitude),\(myOrigin.coordinate.longitude)"
        let destinationString = "\(myDestination.coordinate.latitude),\(myDestination.coordinate.longitude)"
        
        // old Key == > &key=AIzaSyD_nwCI7RqGsWkwWeEoJb-KkdVaIfDhFxc
//        var urlstring:String = "https://maps.googleapis.com/maps/api/directions/json?&origin=\(originString)&destination=\(destinationString)&mode=driving&key=AIzaSyD_nwCI7RqGsWkwWeEoJb-KkdVaIfDhFxc" //AIzaSyCuhsdolQuBDwCyapB9fhqgw_ZIhlGAzBk"
        
        // for polyline for multiple waypoints
        /*if(self.waypointmerge != ""){
            self.getdirectionurlstring = "https://maps.googleapis.com/maps/api/directions/json?&origin=\(originString)&destination=\(destinationString)&waypoints=\(waypointmerge)&mode=driving&key=\(googleKey)"
        }
        else{*/
            self.getdirectionurlstring = "https://maps.googleapis.com/maps/api/directions/json?&origin=\(originString)&destination=\(destinationString)&mode=driving&key=\(googleKey)"
        //}
       
        // AIzaSyCuhsdolQuBDwCyapB9fhqgw_ZIhlGAzBk"
        // AIzaSyD_nwCI7RqGsWkwWeEoJb-KkdVaIfDhFxc"


        self.getdirectionurlstring = self.getdirectionurlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        print(self.getdirectionurlstring)
        
        let manager : AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
        
        manager.responseSerializer.acceptableContentTypes =  Set<AnyHashable>(["application/json", "text/json", "text/javascript", "text/html"])

        manager.get( "\(self.getdirectionurlstring)",
            parameters: nil,
            success: { (operation: AFHTTPRequestOperation?,responseObject: Any?) in
                let jsonObjects:NSDictionary = responseObject as! NSDictionary
                
                if(jsonObjects["status"] as! String != "NOT_FOUND"){
                   
                    let routesArray:NSArray = jsonObjects["routes"] as! NSArray
                    
                    CATransaction.begin()
                    CATransaction.setAnimationDuration(0.0)
                    CATransaction.setCompletionBlock {
                        

                        //DispatchQueue.main.async { () -> Void in

                            if routesArray.count > 0 {
                                
                                //if self.isPendingUpdate == "updating"{

                                self.viewMapArcane.clear()

                                self.polyline.map = nil
                                
                                let routeDict:NSDictionary = routesArray[0] as! NSDictionary
                                let routeOverviewPolyline:NSDictionary = routeDict["overview_polyline"] as! NSDictionary
                                let points = (routeOverviewPolyline["points"] as! String)
                                let path: GMSPath = GMSPath(fromEncodedPath: points)!
                                
                                self.polyline = GMSPolyline(path: path)
                                self.polyline.strokeWidth = 5.0
                                self.polyline.strokeColor = .blue
                          // For changes in PolylineColor use this code
                                //self.polyline.strokeColor = UIColor(red:0.0/255.0, green:128.0/255.0, blue:227.0/255.0, alpha: 1.0)
                                self.polyline.geodesic = true
                                self.polyline.map = self.viewMapArcane
                            
                            
                                
                                //self.marker1.map = nil
                                //self.marker.map = nil

                                //self.isPendingUpdate = ""
                                self.marker.appearAnimation = kGMSMarkerAnimationNone
                                if(self.carCategoryPass == self.labelCarName2.text!){
                                    self.marker.icon = nil
                                    //self.viewMapArcane.clear()
                                    self.marker.icon = UIImage(named: "map_lux.png")
                                }
                                else if(self.carCategoryPass == self.labelCarName3.text!){
                                    self.marker.icon = nil
                                    //self.viewMapArcane.clear()
                                    self.marker.icon = UIImage(named: "map_suv.png")
                                }
                                else if(self.carCategoryPass == self.labelCarName4.text!){
                                    self.marker.icon = nil
                                    //self.viewMapArcane.clear()
                                    self.marker.icon = UIImage(named: "map_taxi.png")
                                }
                                else if(self.carCategoryPass == self.labelCarName1.text!){
                                    self.marker.icon = nil
                                    //self.viewMapArcane.clear()
                                    self.marker.icon = UIImage(named: "ic_standard.png")
                                }else{
                                    self.marker.icon = nil
                                    self.marker.icon = UIImage(named: "loading.png")
                                }
                                //self.marker.icon = UIImage(named: "Drivers.png")
                                self.marker.map = self.viewMapArcane
                                self.marker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
                                self.marker.isFlat = true
                                
                                self.marker.position = CLLocationCoordinate2D(latitude: self.myOrigin.coordinate.latitude, longitude: self.myOrigin.coordinate.longitude)
                                
                                if let routeDict:NSDictionary = (routesArray[0] as? NSDictionary){
                                    
                                    if let legsArray:NSArray = (routeDict["legs"] as? NSArray){
                                        
                                        if let legs:NSDictionary = (legsArray[0] as? NSDictionary){
                                            
                                            if let startloc:NSDictionary = (legs["start_location"] as? NSDictionary) {


                                                let lat = (startloc["lat"])
                                                let lng = (startloc["lng"])

                                            }
                                            
                                            if let stepsArray:NSArray = (legs["steps"] as? NSArray){
                                                if let startLocation:NSDictionary = (stepsArray[0] as? NSDictionary){
                                                    
                                                    if let start_location:NSDictionary = (startLocation["end_location"] as? NSDictionary){
                                                        
                                                        let lat = (start_location["lat"])
                                                        let lng = (start_location["lng"])
                                                        print("\(lat!) , \(lng!)")
                                                        self.locationManager.startUpdatingHeading()
                                                        self.marker.rotation = self.angle
                                                        if self.isPendingUpdate == ""{
                                                            self.isPendingUpdate = "update"
                                                            // to avoid concurrent updates and avoid hanging issues
                                                        }
                                                    }
                                                    
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                //self.marker1.snippet = "Drop Location"
                                self.marker1.appearAnimation = kGMSMarkerAnimationNone
                                self.marker1.icon = UIImage(named: self.imageName)
                                let fancy = GMSCameraPosition.camera(withLatitude: self.myOrigin.coordinate.latitude, longitude: self.myOrigin.coordinate.longitude, zoom: 17, bearing: self.angle, viewingAngle: 30)
                                self.viewMapArcane.animate(to: fancy)
                               // self.viewMapArcane.camera = fancy
                                self.marker1.map = self.viewMapArcane
                                self.marker1.position = CLLocationCoordinate2D(latitude: self.myDestination.coordinate.latitude, longitude: self.myDestination.coordinate.longitude)
                                self.markercount = 0
                                self.waypointmerge1 = ""
                                var ref1 = FIRDatabase.database().reference()
                                ref1.child("riders_location").child(self.appDelegate.userid!).child("WayPointCount").observeSingleEvent(of: .value, with: { (snapshot) in
                                    if(snapshot.exists()){
                                        if snapshot.value != nil{
                                            print("Snapshot value is not equal to nil")
                                            print(snapshot.value)
                                            
                                            let waypointcount1 = snapshot.value!
                                            
                                            let waypointcount = Int((waypointcount1 as AnyObject) as! NSNumber)
                                            
                                            
                                            
                                            for var i in 1..<waypointcount+1 {
                                                print(i)
                                                var count = 0
                                                FIRDatabase.database().reference().child("riders_location").child(self.appDelegate.userid!).child("DestinationWaypoints").child("WayPoint \(i)").observeSingleEvent(of: .value, with: { (snapshot) in
                                                    if(snapshot.exists()){
                                                        print(snapshot.value)
                                                        
                                                        if snapshot.value != nil{
                                                            FIRDatabase.database().reference().child("riders_location").child(self.appDelegate.userid!).child("DestinationWaypoints").child("WayPoint \(i)").child("Coordinates").observeSingleEvent(of: .value, with: { (snapshot) in
                                                                if(snapshot.exists()){
                                                                    if(count == 0){
                                                                        print(snapshot.value)
                                                                        
                                                                        if snapshot.value != nil{
                                                                            let multidest = snapshot.value!
                                                                            print(multidest)
                                                                            print("multidest:\((multidest as AnyObject).count)")
                                                                            
                                                                            if let value = snapshot.value as? NSArray {
                                                                                if (multidest as AnyObject).count == 2{
                                                                                    
                                                                                    self.imageName1 = "markerloc1"
                                                                                    self.imageName2 = "markerloc2"
                                                                                    self.imageName3 = "markerloc3"
                                                                                    self.imageName4 = "markerloc4"
                                                                                    
                                                                                    print(value[0])
                                                                                    print(value[1])
                                                                                    print("Waypoint is\("WayPoint \(i)")")
                                                                                    if(self.waypointmerge1 == ""){
                                                                                        self.waypointmerge1 =  "via:\(String(describing: value[0])),\(String(describing: value[1]))" as NSString
                                                                                        print(self.waypointmerge1)
                                                                                        
                                                                                        self.markerloc1.appearAnimation = kGMSMarkerAnimationNone
                                                                                        self.markerloc1.icon = UIImage(named: self.imageName1)
                                                                                        self.markerloc1.map = self.viewMapArcane
                                                                                        self.myloc1 = CLLocation(latitude: value[0] as! CLLocationDegrees, longitude: value[1] as! CLLocationDegrees)
                                                                                        self.markerloc1.position = CLLocationCoordinate2D(latitude: self.myloc1.coordinate.latitude, longitude: self.myloc1.coordinate.longitude)
                                                                                        print(self.imageName1)
                                                                                        print(self.myloc1)
                                                                                    }
                                                                                    else{
                                                                                        if(self.waypointmerge1.contains("via:\(value[0]),\(value[1])")){
                                                                                            print("already added this location")
                                                                                        }
                                                                                        else{
                                                                                            self.waypointmerge1 =  "\(self.waypointmerge1)|via:\(value[0]),\(value[1])" as NSString
                                                                                            print(self.waypointmerge1)
                                                                                            self.markercount += 1
                                                                                            
                                                                                            if(self.markercount == 1){
                                                                                                self.markerloc2.appearAnimation = kGMSMarkerAnimationNone
                                                                                                self.markerloc2.icon = UIImage(named: self.imageName2)
                                                                                                self.markerloc2.map = self.viewMapArcane
                                                                                                self.myloc2 = CLLocation(latitude: value[0] as! CLLocationDegrees, longitude: value[1] as! CLLocationDegrees)
                                                                                                self.markerloc2.position = CLLocationCoordinate2D(latitude: self.myloc2.coordinate.latitude, longitude: self.myloc2.coordinate.longitude)
                                                                                            }
                                                                                            else if(self.markercount == 2){
                                                                                                self.markerloc3.appearAnimation = kGMSMarkerAnimationNone
                                                                                                self.markerloc3.icon = UIImage(named: self.imageName3)
                                                                                                self.markerloc3.map = self.viewMapArcane
                                                                                                self.myloc3 = CLLocation(latitude: value[0] as! CLLocationDegrees, longitude: value[1] as! CLLocationDegrees)
                                                                                                self.markerloc3.position = CLLocationCoordinate2D(latitude: self.myloc3.coordinate.latitude, longitude: self.myloc3.coordinate.longitude)
                                                                                            }
                                                                                            else if(self.markercount == 3){
                                                                                                self.markerloc4.appearAnimation = kGMSMarkerAnimationNone
                                                                                                self.markerloc4.icon = UIImage(named: self.imageName4)
                                                                                                self.markerloc4.map = self.viewMapArcane
                                                                                                self.myloc4 = CLLocation(latitude: value[0] as! CLLocationDegrees, longitude: value[1] as! CLLocationDegrees)
                                                                                                self.markerloc4.position = CLLocationCoordinate2D(latitude: self.myloc4.coordinate.latitude, longitude: self.myloc4.coordinate.longitude)
                                                                                            }
                                                                                            else{
                                                                                                
                                                                                            }
                                                                                        }
                                                                                    }
                                                                                    
                                                                                }
                                                                            }
                                                                        }
                                                                        count += 1
                                                                    }
                                                                }
                                                            })
                                                            
                                                            
                                                            i = i + 1
                                                            
                                                        }
                                                    }
                                                })
                                                
                                                
                                            }
                                            if(waypointcount == 0){
                                                self.waypointmerge1 = ""
                                            }
                                            else{
                                                //self.gettingDirectionsAPI()
                                            }
                                            print(self.waypointmerge1)
                                            
                                        }
                                        else{
                                            print("Snapshot value is nil")
                                        }
                                        
                                    }
                                    
                                    
                                    
                                }) { (error) in
                                    print(error.localizedDescription)
                                }
                                }

                            //}
                        //}
                        
                        
                    }
                    CATransaction.commit()

                        
                    
                    
                }
                else{
                    
                }

                
        },
            failure: { (operation: AFHTTPRequestOperation?,error: Error) in
                print("Error: " + error.localizedDescription)
                if error.localizedDescription == "The request timed out."{
                   
                    self.isPendingUpdate = "fail"

                }
        })
            
            

    }
    
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        
        self.viewMapArcane.padding = UIEdgeInsetsMake(100, 0, 100, 0)
        
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.denied{
            
            var alertController = UIAlertController (title: "Location Service Permission Denied", message: "please open settings and set location access to 'While Using the App'", preferredStyle: .alert)
            
            var settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                let settingsUrl = NSURL(string: UIApplicationOpenSettingsURLString)
                if let url = settingsUrl {
                    
                    UIApplication.shared.openURL(url as URL)
                }
            }
            
            var cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            alertController.addAction(settingsAction)
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true, completion: nil)
            
        }
        let camera = GMSCameraPosition.camera(withLatitude: (self.currentLocation.coordinate.latitude),longitude: (self.currentLocation.coordinate.longitude),zoom: self.viewMapArcane.camera.zoom)
        
        self.viewMapArcane.camera = camera
        self.firstTime = 1
        return true
        
    }
    
    @IBAction func btnChangeImageCheck(_ sender: Any) {
               
        print(self.imageViewRideShare.image)

        if imageViewRideShare.image == UIImage(named: "unCheckBox.png"){
            
             self.imageViewRideShare.image = UIImage(named : "checkBox.png")
             self.btnPickShareRideNumbers.isHidden = true
             self.checked = "yes"
            
              //  self.dropdownList.isHidden = false

        }
        else if imageViewRideShare.image == UIImage(named : "checkBox.png"){
            
            self.imageViewRideShare.image = UIImage(named : "unCheckBox.png")
            self.btnPickShareRideNumbers.isHidden = true
           // self.dropdownList.isHidden = true
            self.btnPickShareRideNumbers.setTitle("0", for: .normal)
            self.checked = "no"

        }
        else{
            
            
        }
        
    }
    @IBAction func btnPickUpNumbersAction(_ sender: Any) {
        
        amountDropDown.show()
    }
    @IBAction func doorlistAct(_ sender: Any) {
        doorDropDown.show()
    }
    @IBAction func terminallistAct(_ sender: Any) {
        terminalDropDown.show()
    }
    
    
    /*func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
        
        self.viewMapArcane.animate(toBearing: 0)
        self.firstTime = 1
        
    }
    
    func mapView(_ mapView: GMSMapView, didBeginDragging marker: GMSMarker) {
        
        self.viewMapArcane.animate(toBearing: 0)
        

    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
       
        self.viewMapArcane.animate(toBearing: 0)

    } */
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            
            locationManager.startUpdatingLocation()
            
            viewMapArcane.isMyLocationEnabled = true
            viewMapArcane.settings.myLocationButton = true
        }
    }
    
    
    // MARK: GMSMapViewDelegate method implementation
    
    
    // 6
    /*func locationManager(_ manager: CLLocationManager, did_UpdateLocations locations: [CLLocation]) {
        
        
        if let location = locations.first {
            
            let ref = FIRDatabase.database().reference()
            // for rider
            let geoRider = GeoFire(firebaseRef: ref.child("riders_location").child(self.appDelegate.userid!))
            
            geoRider!.setLocation(CLLocation(latitude: self.currentLocation.coordinate.latitude, longitude: self.currentLocation.coordinate.longitude), forKey: "geolocation") { (error) in
                
                if (error != nil) {
                    
                    
                }
                else{
                    
                    print("Saved location successfully!")
                    
                }
            }
            
            // for driver availability
            
            
            
            let geoFire = GeoFire(firebaseRef: ref.child("drivers_location").child("585a29d2da71b40b128b4567"))
            
            // let geoFire = GeoFire(firebaseRef: ref.child("drivers_location/5857c2bada71b4d9708b4567/"))
            
            //    print(geoFire!.firebaseRef(forLocationKey: "geolocation"))
            // 5857a775da71b456718b4567
            // geoFire!.getLocationForKey("firebase-hq-android", withCallback: { (location, error) in
            geoFire!.getLocationForKey("geolocation", withCallback: { (location, error) in
                if (error != nil) {
                    
                    print("An error occurred getting the location for \"firebase-hq-iOS\": \(error!.localizedDescription)")
                    
                }
                else if (location != nil) {
                    
                    //   print("Location for \"firebase-hq-android\" is [\(location!.coordinate.latitude), \(location!.coordinate.longitude)]")
                    
                    ref.child("drivers_location").observeSingleEvent(of: .value, with: { (snapshot) in
                        
                        self.states.removeAllObjects()
                        self.latMutArray.removeAllObjects()
                        self.longMutArray.removeAllObjects()
                        self.driverNamesArray.removeAllObjects()
                        
                        let dict = snapshot.value as! NSDictionary
                        if let result = snapshot.children.allObjects as? [FIRDataSnapshot] {
                            for childTest in result {
                                //do your logic and validation here
                                //print("res \(result)")                  // 1 by 1 for loop
                                // child.value["meanAcc"] as! String
                                
                                let meanAcc = childTest.key
                                
                                print("maenKey \(meanAcc)")             // inside key access
                                
                                
                                if let gandoValues = dict["\(meanAcc)"] as? NSDictionary{
                                    //  print("g and l values \(gandoValues)")
                                    
                                    
                                    //                                    let email = gandoValues["email"] as! NSString
                                    
                                    
                                    //                                print("l values \(email) \(name)")
                                    
                                    if let geo_location = gandoValues["geolocation"] as? NSDictionary{
                                        //  print(geo_location)
                                        if let latLong = geo_location["l"] as? NSArray{
                                            // print(latLong)
                                            if(latLong.count == 0){
                                                
                                            }
                                            else{
                                                
                                                let lat = latLong[0]
                                                let long = latLong[1]
                                                // print(lat)
                                                // print(long)
                                                if let name = gandoValues["name"] as? NSString{
                                                    self.driverNamesArray.add(name)
                                                    //  print(name)
                                                }
                                                else{
                                                    self.driverNamesArray.add("\(lat),\(long)")
                                                }
                                                
                                                
                                                
                                                self.latMutArray.add(lat)
                                                self.longMutArray.add(long)
                                                self.states.add("\(lat),\(long)")
                                                
                                                
                                            }
                                            
                                            
                                        }
                                        
                                        if let acceptStatus = gandoValues["accept"] as? NSDictionary{
                                            if let status = acceptStatus["status"] as? Any{
                                                print(status)
                                                self.trip_status = status as! String
                                                
                                            }
                                            if let tripid = acceptStatus["trip_id"] as? Any{
                                                print(tripid)
                                                //self.trip_id = tripid as! String
                                                
                                            }
                                            
                                            if(self.trip_status == "nil"){
                                                
                                            }
                                            else if(self.trip_status == "1"){
                                                
                                            }
                                            else if(self.trip_status == "2"){
                                                
                                            }
                                            else if(self.trip_status == "3"){
                                                
                                            }
                                            else if(self.trip_status == "4"){
                                                
                                            }
                                            
                                            
                                        }
                                    }
                                }
                                
                                //
                                //                                let firstValue = weather[0]
                                //
                                //                                let secondValue = weather[1]
                                //
                                //                                print("meanAcc \(meanAcc)")
                                //
                                //                                print("frist \(firstValue)")
                                //
                                //                                print("second \(secondValue)")
                                //
                                //                                self.states.add(meanAcc)
                                //
                                //                                self.latMutArray.add(firstValue)
                                //
                                //                                self.longMutArray.add(secondValue)
                                
                                //      var coordinatesToAppend = CLLocationCoordinate2D(latitude: firstValue as! CLLocationDegrees, longitude: secondValue as! CLLocationDegrees)
                                
                                //
                                //                                let marker = GMSMarker()
                                //                                marker.position = CLLocationCoordinate2D(latitude: firstValue as! CLLocationDegrees, longitude: secondValue as! CLLocationDegrees)
                                //
                                //                                marker.snippet = "Users"
                                //                                marker.appearAnimation = kGMSMarkerAnimationNone
                                //                                marker.icon = UIImage(named: "addLoc.png")
                                //                                marker.map = self.testView
                                
                                //                                var coordinatesToAppend1 = CLLocationCoordinate2D(latitude: self.latMutArray[1] as! CLLocationDegrees, longitude: self.longMutArray[1] as! CLLocationDegrees)
                                //
                                //
                                //                                let marker1 = GMSMarker()
                                //                                marker1.position = CLLocationCoordinate2D(latitude: self.latMutArray[1] as! CLLocationDegrees, longitude: self.longMutArray[1] as! CLLocationDegrees)
                                //
                                //                                marker1.snippet = "Users1"
                                //                                marker1.appearAnimation = kGMSMarkerAnimationNone
                                //                                marker1.icon = UIImage(named: "addLoc.png")
                                //                                marker1.map = self.testView
                                
                                //mapView.animate(to: GMSCameraPosition.camera(withLatitude: firstValue as! CLLocationDegrees, longitude: secondValue as! CLLocationDegrees, zoom: 15))
                                
                                
                            }
                            print(self.longMutArray.count)
                            print(self.latMutArray.count)
                            print(self.states.count)
                            print(self.driverNamesArray.count)
                            if(self.longMutArray.count != 0 ){
//                                self.multipleMarker()
                                if(self.drivers == 0){
                                    self.drivers = 1
                                    self.fCount = self.latMutArray.count
                                    
                                }
                            }
                            
                            
                            /*   for child in snapshot.children {
                             
                             // total 2 Combine
                             print("child \(child)")
                             
                             print("sanpshot \(snapshot)")
                             }*/
                            
                            
                        } else {
                            
                            print("no results")
                        }
                    }) { (error) in
                        
                        print(error.localizedDescription)
                    }
                    
                    
                    
                }
                else {
                    
                    print("GeoFire does not contain a location for \"firebase-hq\"")
                }
            })
            
            
            // to update location for bearing
            
            // myOrigin = CLLocation(latitude: 9.9252, longitude: 78.1198)
            // myDestination = CLLocation(latitude: 13.0827, longitude: 80.2707)

//            self.bearing = true

           /*else if(self.bearing == false){
                if(self.trips == "1"){
                    self.locationManager.startUpdatingLocation()
                }
                else{
                    self.locationManager.stopUpdatingLocation()
                }
            } */
            
            
        }
        
        if(self.bearing == true){
            
            self.bearing = false
            self.startBearing(location: self.myOrigin)
     
     
        }
        
        // check if trip is started then calculate distance per km
        
        if(tripIsStarted == "yes"){
            // start updating calculation.
            
            if(tripIsStarted == "done"){
                // stop updating calculation.
                self.tripIsStarted = "no"
            }
            else{
                if startLocation == nil {
                    //startLocation = locations.first
                    // start location is set as pickup location
                } else {
                    
                    
                    // to getting updatable location based on moving
                    var lastLocation = locations.last
                    self.locationTracker.addLocationChangeObserver { (result) -> () in
                        switch result {
                            
                        case .success(let location):
                            let coordinate = location.physical.coordinate
//                            lastLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
                            
                            lastLocation = self.lastLocation
                            // to avoid infinite loop method camera position in google map view
                            
                        case .failure:
                            
                            break
                            
                        }
                    }
                    
                    let userLocation:CLLocation = CLLocation(latitude: self.myOrigin.coordinate.latitude, longitude: self.myOrigin.coordinate.longitude)         // pickup Location
                    let priceLocation:CLLocation = CLLocation(latitude: self.myDestination.coordinate.latitude, longitude: self.myDestination.coordinate.longitude)        // traveling Location
                    let distance = String(format: "%.2f km", userLocation.distance(from: priceLocation)/1000) // calculating distance
                    print("Distance is KM is:: \(distance)")

                    
                    // end location is set as updating by current location
                 /*   let distance = startLocation.distance(from: lastLocation!)
                    let lastDistance = lastLocation?.distance(from: lastLocation!)fire
                    traveledDistance += lastDistance!
                    print( "\(startLocation)")
                    print( "\(lastLocation)")
                    print("FULL DISTANCE: \(traveledDistance)")
                    print("STRAIGHT DISTANCE: \(distance)") */
                    
                    
                }
                //lastLocation = locations.last
                
            }
        }
        
    } */
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
        let location = locations.first
        if  location != nil {
            
            self.currentLocation = CLLocation(latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!)
            
            self.autoComplete()
            if self.getFirstCountry == "None" || self.countryStatic == "None"{
            
            }
            else if self.getFirstCountry == self.countryStatic{
                
            }
            else if self.getFirstCountry != self.countryStatic{
                
            }
            else{
                self.getCurrentAddress(myLocation: self.currentLocation)
            }
            
            self.gettingDirectionsAPI()

        }
        else{
            //
        }

        
    }
    
    var isPendingUpdate = "update"

    var myGroup = DispatchGroup()

    
    func startBearing(location:CLLocation){
        

        
        self.gettingDirectionsAPI()

        //self.viewMapArcane.settings.compassButton = true
        self.viewMapArcane.settings.rotateGestures = true

        print("livetrack\(self.appDelegate.accepted_Driverid!)")
        if(self.appDelegate.accepted_Driverid! != ""){
            
            var checkCarCategory = UserDefaults.standard.object(forKey: "acceptedDriverCarCategoryName") as? String
            print(checkCarCategory)
            if checkCarCategory == nil || checkCarCategory == ""  {
                
                let geoFire = GeoFire(firebaseRef: ref.child("drivers_location").child("\(self.appDelegate.accepted_Driverid!)").child("l"))

                
                // let geoFire = GeoFire(firebaseRef: ref.child("drivers_location/5857c2bada71b4d9708b4567/"))

                
                let childChanged = ref.child("drivers_location").child("\(self.appDelegate.accepted_Driverid!)").observe(.value, with: { (snapshot) in
                    
                    let temp = self.appDelegate.accepted_Driverid
                    
                    if(temp == nil){
                        
                        
                    }
                    else if(self.appDelegate.accepted_Driverid! != ""){
                        
                        if self.isPendingUpdate == "update"{
                            
                            
                            if checkCarCategory == nil {
                                
                                self.appDelegate.passAcceptedDriverCarCategory = "Standard"
                            }
                            else{
                                
                                self.appDelegate.passAcceptedDriverCarCategory = checkCarCategory as String!
                                
                            }
                            
                            var asdasd = self.appDelegate.passAcceptedDriverCarCategory!
                            
                            print("\(self.appDelegate.passAcceptedDriverCarCategory!)")
                            
                            self.isPendingUpdate = "updating"
                            
                            self.ref.child("drivers_location").child("\(self.appDelegate.passAcceptedDriverCarCategory!)").child("\(self.appDelegate.accepted_Driverid!)").observe(.value, with: { (snapshot) in
                                if self.appDelegate.accepted_Driverid == ""{
                                    
                                }
                                else{
                                    if(snapshot.value == nil){
                                        
                                    }
                                    else{
                                        
                                        let dict = snapshot.value as? NSDictionary
                                        //                        print(dict as Any)
                                        if((dict?["bearing"]) != nil){
                                            
                                            let final_bear = dict?["bearing"]
                                            let temp_bear:NSString = final_bear as! NSString
                                            let temp_bear1 = Double(temp_bear as String)
                                            self.angle = temp_bear1 as! Double!
                                            
                                        }
                                        
                                        if let latLong = dict?["l"] as? NSArray{
                                             print(latLong)
                                            if(latLong.count == 0){
                                                
                                            }
                                            else{
                                                
                                                let lat = latLong[0]
                                                let long = latLong[1]
                                                self.etaCalc(orignlat: "\(lat)", originLon: "\(long)")
                                                print("waiting")
                                                //if self.isPendingUpdate == "update"{  // old condition
                                                print("it coming")
                                                
                                                print("twice")
                                                
                                                //                                        print("lat is \(lat)")
                                                //                                        print("long is \(long)")
                                                
                                                self.myOrigin = CLLocation(latitude: lat as! CLLocationDegrees, longitude: long as! CLLocationDegrees)
                                                //self.myDestination = self.dropup
                                                //self.lastLocation = CLLocation(latitude: lat as! CLLocationDegrees, longitude: long as! CLLocationDegrees)
                                                
                                                if self.myOrigin != self.currentLocation{
                                                    
                                                    
                                                    self.gettingDirectionsAPI()
                                                    
                                                    if self.tripIsStarted == "yes"{
                                                        
                                                        self.distance3 = CLLocation(latitude: lat as! CLLocationDegrees, longitude: long as! CLLocationDegrees)
                                                        if self.distance3 != nil{
                                                            self.calcDistacneDynamic()
                                                            
                                                        }
                                                        //                                                UserDefaults.standard.setValue(lat, forKey: "pickuplat")
                                                        //                                                UserDefaults.standard.setValue(long, forKey: "pickuplng")
                                                        
                                                    }
                                                    
                                                    
                                                    
                                                }
                                                
                                                //}  // old condition
                                                /*else{
                                                 // handle pause option before polyline updating
                                                 
                                                 }*/  // old contition
                                                
                                            }
                                        }
                                    }
                                }
                                
                                
                            })
                        }
                        else if self.isPendingUpdate == "fail" {
                            
                            self.isPendingUpdate = "update"
                        }
                        
                    }
                    
                })
            }
            else{
                
                self.appDelegate.passAcceptedDriverCarCategory = checkCarCategory as String!
                print(self.labelMinute.text)
                var asdasd = self.appDelegate.passAcceptedDriverCarCategory!
                
                print("livetrackcar\(self.appDelegate.passAcceptedDriverCarCategory!)")
                
                let geoFire = GeoFire(firebaseRef: ref.child("drivers_location").child("\(self.appDelegate.passAcceptedDriverCarCategory!)").child("\(self.appDelegate.accepted_Driverid!)").child("l"))
                
                // let geoFire = GeoFire(firebaseRef: ref.child("drivers_location/5857c2bada71b4d9708b4567/"))
                
                
                let childChanged = ref.child("drivers_location").child("\(self.appDelegate.passAcceptedDriverCarCategory!)").child("\(self.appDelegate.accepted_Driverid!)").observe(.value, with: { (snapshot) in
                    
                    let temp = self.appDelegate.accepted_Driverid
                    
                    if(temp == nil){
                        
                        
                    }
                    else if(self.appDelegate.accepted_Driverid! != ""){
                        
                        if self.isPendingUpdate == "update"{
                            
                            
                            if checkCarCategory == nil {
                                
                                self.appDelegate.passAcceptedDriverCarCategory = "Standard"
                            }
                            else{
                                
                                self.appDelegate.passAcceptedDriverCarCategory = checkCarCategory as String!
                                
                            }
                            
                            var asdasd = self.appDelegate.passAcceptedDriverCarCategory!
                            
                            print("\(self.appDelegate.passAcceptedDriverCarCategory!)")
                            
                            self.isPendingUpdate = "updating"
                            
                            
                            self.ref.child("drivers_location").child("\(self.appDelegate.passAcceptedDriverCarCategory!)").child("\(self.appDelegate.accepted_Driverid!)").observe(.value, with: { (snapshot) in
                                if self.appDelegate.accepted_Driverid == ""{
                                    
                                }
                                else{
                                    if(snapshot.value == nil){
                                        
                                    }
                                    else{
                                        
                                        let dict = snapshot.value as? NSDictionary
                                        //                        print(dict as Any)
                                        if((dict?["bearing"]) != nil){
                                            let final_bear = dict?["bearing"]
                                            let temp_bear:NSString = final_bear as! NSString
                                            let temp_bear1 = Double(temp_bear as String)
                                            self.angle = temp_bear1 as! Double!
                                        }
                                        if let latLong = dict?["l"] as? NSArray{
                                            // print(latLong)
                                            if(latLong.count == 0){
                                                
                                            }
                                            else{
                                                
                                                let lat = latLong[0]
                                                let long = latLong[1]
                                                print("waiting")
                                                //if self.isPendingUpdate == "update"{  // old condition
                                                print("it coming")
                                                
                                                print("twice")
                                                
                                                //                                        print("lat is \(lat)")
                                                //                                        print("long is \(long)")
                                                
                                                self.etaCalc(orignlat: "\(lat)", originLon: "\(long)")
                                                
                                                self.myOrigin = CLLocation(latitude: lat as! CLLocationDegrees, longitude: long as! CLLocationDegrees)
                                                //self.myDestination = self.dropup
                                                //self.lastLocation = CLLocation(latitude: lat as! CLLocationDegrees, longitude: long as! CLLocationDegrees)
                                                
                                                if self.myOrigin != self.currentLocation{
                                                    
                                                    
                                                    self.gettingDirectionsAPI()
                                                    
                                                    if self.tripIsStarted == "yes"{
                                                        
                                                        self.distance3 = CLLocation(latitude: lat as! CLLocationDegrees, longitude: long as! CLLocationDegrees)
                                                        if self.distance3 != nil{
                                                            self.calcDistacneDynamic()
                                                            
                                                        }
                                                        //                                                UserDefaults.standard.setValue(lat, forKey: "pickuplat")
                                                        //                                                UserDefaults.standard.setValue(long, forKey: "pickuplng")
                                                        
                                                    }
                                                    
                                                    
                                                    
                                                }
                                                
                                                //}  // old condition
                                                /*else{
                                                 // handle pause option before polyline updating
                                                 
                                                 }*/  // old contition
                                                
                                            }
                                        }
                                    }
                                }
                                
                                
                            })
                        }
                        else if self.isPendingUpdate == "fail" {
                            
                            self.isPendingUpdate = "update"
                        }
                        
                    }
                    
                })

            }
            

            

        }
        else{
            
        }
        
    

    }
    
    
    func getBearing(toPoint point: CLLocationCoordinate2D) -> Double {
        func degreesToRadians(degrees: Double) -> Double { return degrees * M_PI / 180.0 }
        func radiansToDegrees(radians: Double) -> Double { return radians * 180.0 / M_PI }
        
        let lat1 = degreesToRadians(degrees: myOrigin.coordinate.latitude)
        let lon1 = degreesToRadians(degrees: myOrigin.coordinate.longitude)
        
        let lat2 = degreesToRadians(degrees: point.latitude);
        let lon2 = degreesToRadians(degrees: point.longitude);
        
        //19.017950, 72.856395
        //        let lat2 = degreesToRadians(degrees: 19.017950);
        //        let lon2 = degreesToRadians(degrees: 72.856395);
        
        let dLon = lon2 - lon1;
        
        let y = sin(dLon) * cos(lat2);
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);
        let radiansBearing = atan2(y, x);
        
        
      /*  let marker = GMSMarker()
        marker.snippet = "Bearing Location"
        marker.appearAnimation = kGMSMarkerAnimationNone
        marker.icon = UIImage(named: "Drivers.png")
        marker.map = self.viewMap
        marker.position = CLLocationCoordinate2D(latitude: lat1, longitude: lon1) */
        
        
        //self.viewMap.animate(toViewingAngle: radiansBearing)
        
        //        return radiansToDegrees(radians: radiansBearing)
        return radiansToDegrees(radians: radiansBearing)
    }


    func callCancelTrip(){
        
        self.addressView.isHidden = true
        self.viewCurrentTrip.isHidden = true
        self.viewBlurCurrentTrip.isHidden = true
        self.viewPickupCentre.isHidden = true
        self.viewTopLeftMenu.isHidden = true
        
        let ref1 = FIRDatabase.database().reference().child("drivers_data").child(self.appDelegate.accepted_Driverid!).child("accept")
        ref1.updateChildValues(["status": "5"])
        
        let refClearRequest = FIRDatabase.database().reference().child("drivers_data").child(self.appDelegate.accepted_Driverid!).child("request")
        let zero = 0
        refClearRequest.updateChildValues(["eta": zero])
        refClearRequest.updateChildValues(["req_id": ""])
        refClearRequest.updateChildValues(["status": zero])

        var urlstring : String!
        
        urlstring = "\(live_request_url)requests/updateTrips/trip_id/\(self.trip_id)/trip_status/cancel/accept_status/5/distance/0/user_id/\(self.appDelegate.userid!)"
        // cancel trip status
        
        
        if(trip_id != "nil"){
            
            self.tripStatusUpdating(urlString: urlstring)
            
            
        }
        else{
            
        }
        
        ref1.updateChildValues(["trip_id": ""])
        ref1.updateChildValues(["trip_id_rider_name": ""])
        self.viewMapArcane.clear()
        
        var ref2 = FIRDatabase.database().reference().child("drivers_data").child(self.appDelegate.accepted_Driverid!).child("accept")
        ref2.updateChildValues(["status": ""])
        print(self.appDelegate.trip_id!)
        if(self.appDelegate.trip_id != nil){
        var reff = FIRDatabase.database().reference().child("trips_data").child(self.appDelegate.trip_id!)
        reff.updateChildValues(["status": "5"])
        self.appDelegate.trip_id = "empty"
            UserDefaults.standard.removeObject(forKey: "trip_id")
        }
        
        DispatchQueue.main.async { () -> Void in
            
            
            if self.firsttime == 1 {
                
                self.locationManager.stopUpdatingHeading()
                self.firsttime = 0
                print("5 is")
                self.tripIsStarted = "done"
                self.accepted = "no"
                self.bearing = "default"
                self.trips = "2"
              //  self.noteString = "Driver cancelled the trip."
                self.btnInfo.isHidden = true
              //  self.licplate_no.isHidden = true
              //  self.notification()
                
                if self.appDelegate.accepted_Driverid! != "" {
                    let ref = FIRDatabase.database().reference().child("drivers_data")
                    let ref1 = FIRDatabase.database().reference().child("drivers_location")
                    //.child("\(self.appDelegate.accepted_Driverid!)").child("accept").child("status")
                    ref.removeAllObservers()
                    ref1.removeAllObservers()
                    self.appDelegate.accepted_Driverid = ""
                    self.appDelegate.passAcceptedDriverCarCategory = ""
                    
                }
                else{
                    
                    
                }
                
                ref1.removeAllObservers()
                ref2.removeAllObservers()
                
                
                self.locationManager.stopUpdatingLocation()
                
                self.callCancelTripMap()
                
                
            }
            
            UserDefaults.standard.setValue("", forKey: "Droplat")
            UserDefaults.standard.setValue("", forKey: "Droplng")
            
            UserDefaults.standard.setValue("", forKey: "pickuplat")
            UserDefaults.standard.setValue("", forKey: "pickuplng")
            
            UserDefaults.standard.removeObject(forKey: "acceptedDriverMobile")

        }
    }
    
    func tripStatusUpdating(urlString: String){
        if(trip_id != "nil"){
            print(urlString)
            var urlstring:String! = urlString
            print(urlstring)
            urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
            print("\(urlstring)")
            
            
            let manager : AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
            
            manager.responseSerializer.acceptableContentTypes =  Set<AnyHashable>(["application/json", "text/json", "text/javascript", "text/html"])
            
            manager.get( "\(urlstring!)",
                parameters: nil,
                success: { (operation: AFHTTPRequestOperation?,responseObject: Any?) in
                    let jsonObjects=responseObject as! NSArray
                    //                var dataDict: NSDictionary?
                    
                    let value = jsonObjects[0] as AnyObject
                    
                    print(value)
                    
                    self.appDelegate.callCompleteVC()

            },
                failure: { (operation: AFHTTPRequestOperation?,error: Error) in
                    print("Error: " + error.localizedDescription)
            })
            
        }
        
    }

    func newStatusTrip(){
        
        
        print("hiiiii\(self.appDelegate.trip_id!)")
        
        let ref = FIRDatabase.database().reference()
        
        // updated
        ref.child("trips_data").child(self.appDelegate.trip_id!).observe(.childChanged, with: { (snapshot) in
      //  ref.child("drivers_data").child("\(self.appDelegate.accepted_Driverid!)").child("accept").observe(.childChanged, with: { (snapshot) in
            
            print("updating")
            let status1 = snapshot.value as Any
            print(status1)
            var status = "\(status1)"
            status = status.replacingOccurrences(of: "Optional(", with: "")
            status = status.replacingOccurrences(of: ")", with: "")
            print(status)
            if(status == "1"){
                print("1 is")
                self.total_tollfee.isHidden = true
                self.statusLabel.text = "ACCEPTED"
                if (UserDefaults.standard.object(forKey: "isTerminal") != nil)
                {
                    self.terminalView.isHidden = false
                }else{
                    self.terminalView.isHidden = true
                }
                self.driverETAlbl.isHidden = false
                self.btnInfo.isHidden = false
               // self.licplate_no.isHidden = false
             //   self.licplate_no.layer.cornerRadius = 15
                self.viewCurrentTrip.isHidden = true
                self.viewBlurCurrentTrip.isHidden = true

                
                self.driverETAlbl.isHidden = false
                self.noteString = "Driver is accepted your request."
                self.notification()
                self.viewTopPickup.isHidden = true

            }
            else if(status == "2"){
                print("2 is")
                self.statusLabel.text = "ARRIVING"
                self.driverETAlbl.isHidden = true
                self.btnInfo.isHidden = false
               // self.licplate_no.isHidden = false
               // self.licplate_no.layer.cornerRadius = 15
                self.noteString = "Driver is arriving now."
                self.notification()
                self.total_tollfee.isHidden = true
                self.viewCurrentTrip.isHidden = true
                self.viewBlurCurrentTrip.isHidden = true
                
                // to get trip id
                self.getTripID()
                self.myOrigin = self.driverLocation
                self.myDestination = self.pickup
                self.gettingDirectionsAPI()   // to set  polyline for pickup location to driverslocation.

                self.startBearing(location: self.myOrigin)

                self.imageName = "endPinRound"
                self.imageName1 = "markerloc1"
                self.imageName2 = "markerloc2"
                self.imageName3 = "markerloc3"
                self.imageName4 = "markerloc4"

                self.viewTopPickup.isHidden = true


            }
            else if(status == "3"){
                print("3 is")
                self.bearing = "trip"
                self.noteString = "Trip is started now."
                self.notification()

                self.imageName = "endPinSquare"
                self.imageName1 = "markerloc1"
                self.imageName2 = "markerloc2"
                self.imageName3 = "markerloc3"
                self.imageName4 = "markerloc4"

                
                 self.terminalView.isHidden = true
                self.myOrigin = self.pickup
                self.myDestination = self.dropup
                print(self.myOrigin.coordinate)
                print(self.myDestination.coordinate)
                
                // to set intial polyline for pickup location to drop location.
                
                self.startBearing(location: self.myOrigin)

                self.statusLabel.text = "ON TRIP"
                self.total_tollfee.isHidden = false
                self.viewCurrentTrip.isHidden = true
                self.viewBlurCurrentTrip.isHidden = true
                self.btnInfo.isHidden = true
             //   self.licplate_no.isHidden = true
                self.tripIsStarted = "yes"
                self.viewTopPickup.isHidden = true
                self.viewUpdateDrop.isHidden = false
                self.waypointmerge = ""
                self.waypointmerge1 = ""
                self.autoUpdateforLocation()
                self.terminalView.isHidden = true
                UserDefaults.standard.removeObject(forKey: "isTerminal")
                let ref1 = FIRDatabase.database().reference().child("riders_location").child(self.appDelegate.userid!)
                ref1.updateChildValues(["pickup_terminal": "None"])


            }
            else if (status == "5") || (status == ""){
                
                if self.riderClickedCancelPass == "clicked"{

                    //self.appDelegate.trip_id = ""
                    self.total_tollfee.isHidden = true
                    self.observeCancelTripWithPutNotification()
                }
                else{
                    
                    self.observeCancelTrip()
                }
                
                
            }
            else if(status == "4") || (status == "0") || (status == ""){
                
                
                self.viewCurrentTrip.isHidden = true
                self.viewBlurCurrentTrip.isHidden = true
                self.viewUpdateDrop.isHidden = true
                print(self.firsttime)
                DispatchQueue.main.async { () -> Void in
                    
                    
                    if self.firsttime == 1 {
                        
                        self.locationManager.stopUpdatingHeading()
                        self.firsttime = 0
                        print("4 is")
                        self.tripIsStarted = "done"
                        self.accepted = "no"
                        self.bearing = "default"
                        self.trips = "2"
                        self.ridelater = "0"
                        self.noteString = "Trip is Completed."
                        self.btnInfo.isHidden = true
                   //     self.licplate_no.isHidden = true
                        self.notification()
                        print("final distance in km \(self.total/1000)")
                        
                        
                        self.appDelegate.distance = self.total/1000
                        print(self.appDelegate.distance)
                        if self.appDelegate.accepted_Driverid! != "" {
                            let ref = FIRDatabase.database().reference().child("drivers_data")
                            let ref1 = FIRDatabase.database().reference().child("drivers_location")
                            //.child("\(self.appDelegate.accepted_Driverid!)").child("accept").child("status")
                            ref.removeAllObservers()
                            ref1.removeAllObservers()
                            self.appDelegate.accepted_Driverid = ""
                           // self.appDelegate.trip_id = ""
                            
                            self.appDelegate.passAcceptedDriverCarCategory = ""
                            
                            //ref.removeObserver(FIRDatabase.database().reference(), forKeyPath: "driver_data")
                            
                            
                            //                    ref.removeAllObservers()
                            //                    var handle: UInt = 4
                            //                    handle = ref.observe(.value, with: { snapshot in
                            //                        print(snapshot)
                            //                        print("The value is now 42")
                            //                        ref.removeObserver(withHandle: handle)
                            //
                            //                    })
                        }
                        else{
                            
                            
                        }
                        
                        
                        /*let vC = ARCompleteTripVC()
                        vC.modalPresentationStyle = .formSheet
                        vC.modalTransitionStyle = .coverVertical
                        self.present(vC, animated: true, completion: nil)*/
                        self.appDelegate.waypointmerge = ""
                        self.appDelegate.waypointaddress = ""
                        self.appDelegate.waypointcountrycode = ""
                        
                        self.appDelegate.callCompleteVC()
                        
                        //    self.navigationController?.pushViewController(ARCompleteTripVC(), animated: true)

                        // To Handle remove listener from firebase
                        
                        
                        //                self.present(ARCompleteTripVC(), animated: true, completion: nil)
                        
                        /*
                         self.progressViewOutlet.isHidden = false
                         //  self.driverDetail.isHidden = false
                         self.statusLabel.isHidden = true
                         self.viewPickupCentre.isHidden = false
                         self.addressView.isHidden = false
                         self.viewPay.isHidden = false
                         self.viewMapArcane.isMyLocationEnabled = true */
                        
                        self.statusLabel.text = "END TRIP"
                    }
                    
                    UserDefaults.standard.setValue("", forKey: "Droplat")
                    UserDefaults.standard.setValue("", forKey: "Droplng")
                    
                    UserDefaults.standard.setValue("", forKey: "pickuplat")
                    UserDefaults.standard.setValue("", forKey: "pickuplng")
                    
                    let ref2 = FIRDatabase.database().reference().child("riders_location").child(self.appDelegate.userid!).child("Updatelocation")
                    ref2.updateChildValues(["0": String(0)])
                    ref2.updateChildValues(["1": String(0)])
                    
                    FIRDatabase.database().reference().child("riders_location").child(self.appDelegate.userid!).child("DestinationWaypoints").removeValue { (error, ref) in
                        if error != nil {
                            print("error \(error)")
                        }
                    }
                    let ref111 = FIRDatabase.database().reference().child("riders_location").child(self.appDelegate.userid!)
                    ref111.updateChildValues(["WayPointCount": 0])
                    
                    let ref = FIRDatabase.database().reference().child("drivers_data")
                    let ref1 = FIRDatabase.database().reference().child("drivers_location")
                    //.child("\(self.appDelegate.accepted_Driverid!)").child("accept").child("status")
                    ref.removeAllObservers()
                    ref1.removeAllObservers()
                    
                    
                }

            }
            else{
                
//                UserDefaults.standard.setValue("", forKey: "Droplat")
//                UserDefaults.standard.setValue("", forKey: "Droplng")
//                
//                UserDefaults.standard.setValue("", forKey: "pickuplat")
//                UserDefaults.standard.setValue("", forKey: "pickuplng")

            }
            
            //
            
            
        })
        
        
    }
    
    
    func observeCancelTripWithPutNotification(){
        
        
        self.viewCurrentTrip.isHidden = true
        self.viewBlurCurrentTrip.isHidden = true
        self.addressView.isHidden = true
        self.viewPickupCentre.isHidden = true
        self.viewTopLeftMenu.isHidden = true
        
        UserDefaults.standard.removeObject(forKey: "acceptedDriverMobile")
        
        DispatchQueue.main.async { () -> Void in
            
            
            if self.firsttime == 1 {
                
                self.locationManager.stopUpdatingHeading()
                self.firsttime = 0
                print("5 is")
                self.tripIsStarted = "done"
                self.accepted = "no"
                self.bearing = "default"
                self.trips = "2"
               // self.noteString = "Driver cancelled the trip."
                self.btnInfo.isHidden = true
                //self.licplate_no.isHidden = true
               // self.notification()
                
                if self.appDelegate.accepted_Driverid! != "" {
                    let ref = FIRDatabase.database().reference().child("drivers_data")
                    let ref1 = FIRDatabase.database().reference().child("drivers_location")
                    //.child("\(self.appDelegate.accepted_Driverid!)").child("accept").child("status")
                    ref.removeAllObservers()
                    ref1.removeAllObservers()
                    self.appDelegate.accepted_Driverid = ""
                    self.appDelegate.passAcceptedDriverCarCategory = ""
                    
                }
                else{
                    
                    
                }
                
                
                self.callCancelTripMap()
                
                
            }
            
            UserDefaults.standard.setValue("", forKey: "Droplat")
            UserDefaults.standard.setValue("", forKey: "Droplng")
            
            UserDefaults.standard.setValue("", forKey: "pickuplat")
            UserDefaults.standard.setValue("", forKey: "pickuplng")
            
        }

        
    }
    
    
    func observeCancelTrip(){
        
        
        self.viewCurrentTrip.isHidden = true
        self.viewBlurCurrentTrip.isHidden = true
        self.addressView.isHidden = true
        self.viewPickupCentre.isHidden = true
        self.viewTopLeftMenu.isHidden = true
        
        UserDefaults.standard.removeObject(forKey: "acceptedDriverMobile")
        
        DispatchQueue.main.async { () -> Void in
            
            
            if self.firsttime == 1 {
                
                self.locationManager.stopUpdatingHeading()
                self.firsttime = 0
                print("5 is")
                self.tripIsStarted = "done"
                self.accepted = "no"
                self.bearing = "default"
                self.trips = "2"
                self.noteString = "Driver cancelled the trip."
                self.btnInfo.isHidden = true
                self.notification()
                
                if self.appDelegate.accepted_Driverid! != "" {
                    let ref = FIRDatabase.database().reference().child("drivers_data")
                    let ref1 = FIRDatabase.database().reference().child("drivers_location")
                    //.child("\(self.appDelegate.accepted_Driverid!)").child("accept").child("status")
                    ref.removeAllObservers()
                    ref1.removeAllObservers()
                    self.appDelegate.accepted_Driverid = ""
                    self.appDelegate.passAcceptedDriverCarCategory = ""
                    self.appDelegate.trip_id = "empty"
                    UserDefaults.standard.removeObject(forKey: "trip_id")
                    
                }
                else{
                    
                    
                }
                
                
                self.callCancelTripMap()
                
                
            }
            
            UserDefaults.standard.setValue("", forKey: "Droplat")
            UserDefaults.standard.setValue("", forKey: "Droplng")
            
            UserDefaults.standard.setValue("", forKey: "pickuplat")
            UserDefaults.standard.setValue("", forKey: "pickuplng")
            
        }

    }

    func callCancelTripMap(){
        
        let ref = FIRDatabase.database().reference()
        ref.removeAllObservers()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let mainViewController = storyboard.instantiateViewController(withIdentifier: "mainMap") as! ARMainMapVC
        let leftViewController = storyboard.instantiateViewController(withIdentifier: "LeftViewController") as! LeftViewController
        
        let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)
        
        leftViewController.mainViewController = nvc
        
        let slideMenuController = ExSlideMenuController(mainViewController:nvc, leftMenuViewController: leftViewController)
        slideMenuController.automaticallyAdjustsScrollViewInsets = true
        slideMenuController.delegate = mainViewController
        
        self.present(slideMenuController, animated: true, completion: nil)
    }
    
    
    func getTripID(){
        
        let ref = FIRDatabase.database().reference()
        let driverid = self.appDelegate.accepted_Driverid!

        if(driverid != ""){

            let geoFire = GeoFire(firebaseRef: ref.child("drivers_data").child("\(driverid)").child("accept"))

            ref.child("drivers_data").child("\(driverid)").child("accept").child("trip_id").observeSingleEvent(of: .value, with: { (snapshot) in
                
                print("updating trip status")
                let status1 = snapshot.value as Any
                print(status1)
                var status = "\(status1)"
                status = status.replacingOccurrences(of: "Optional(", with: "")
                status = status.replacingOccurrences(of: ")", with: "")
                status = status.replacingOccurrences(of: "\"", with: "")
                print(status)
                print("heloooooooo\(self.appDelegate.trip_id!)")
                if(self.appDelegate.trip_id == "empty"){
                    if(status != "" && status != nil){
                        
                        self.appDelegate.trip_id = status
                        print("appdelegatetripidval\(self.appDelegate.trip_id)")
                        self.appDelegate.testTrip_id = String(status)
                        
                        UserDefaults.standard.setValue("\(self.appDelegate.testTrip_id!)", forKey: "test")
                        
                        print("\(self.appDelegate.accepted_Driverid!)")
                        if(self.appDelegate.accepted_Driverid! != ""){
                            let ref1 = FIRDatabase.database().reference().child("drivers_data").child(self.appDelegate.accepted_Driverid!).child("accept")
                            ref1.updateChildValues(["status": 0])
                            
                            let ref2 = FIRDatabase.database().reference().child("drivers_data").child(self.appDelegate.accepted_Driverid!).child("request")
                            ref2.updateChildValues(["status": 0])
                            
                        }
                        
                        
                        
                        ref.child("trips_data").child(self.appDelegate.trip_id!).child("tollfee").observe(.value, with: { (snapshot) in
                            
                                
                                print("updating toll status")
                                if(snapshot.exists()){
                                    let status1 = snapshot.value as Any
                                    print(status1)
                                    var status = "\(status1)"
                                    status = status.replacingOccurrences(of: "Optional(", with: "")
                                    status = status.replacingOccurrences(of: ")", with: "")
                                    print(status)
                                    self.appDelegate.total_tollfee = status
                                    let doubleStr = String(format: "%.2f", Double(String(status))!)
                                    self.total_tollfee.text = "Toll fee: $\(doubleStr)"
                                    let warning = MessageView.viewFromNib(layout: .CardView)
                                    warning.configureTheme(.info)
                                    warning.configureDropShadow()
                                    let iconText = "" //"🤔"
                                    warning.configureContent(title: "", body: "Toll-fee amount is updated by driver", iconText: iconText)
                                    warning.button?.isHidden = true
                                    var warningConfig = SwiftMessages.defaultConfig
                                    warningConfig.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
                                    SwiftMessages.show(config: warningConfig, view: warning)

                                    
                                }
                                else{
                                    self.total_tollfee.text = "Toll fee: $0"
                                }
                                
                                
                        })
                        //let ref3 = FIRDatabase.database().reference().child("drivers_data").child(self.appDelegate.accepted_Driverid!).child("accept")
                        // ref3.updateChildValues(["trip_id": ""])
                        
                        
                        let test = UserDefaults.standard.object(forKey: "test") as! String
                        self.newStatusTrip()
                        if test != ""{
                            
                            UserDefaults.standard.setValue("\(test)", forKey: "testValue")
                            
                            print("okay")
                        }
                        else{
                            
                            print("no okay")
                        }
                        
                        print("test ok\(test)")
                        
                        UserDefaults.standard.setValue(status, forKey: "trip_id")
                        ref.removeAllObservers()
                    }
                    else{
                        self.getTripID()
                    }
                }
                
            })
            
            ref.removeAllObservers()
            //ref1.removeAllObservers()

        }
    }
    
    
    
    func requestFB(){
        
        let ref = FIRDatabase.database().reference()
        
        // to get lat long for pickup and drop locaiton
        /*
        if UserDefaults.standard.value(forKey: "pickupLoc") != nil {

            if UserDefaults.standard.value(forKey: "dropLoc") != nil {

                let pickupLoc:String! = UserDefaults.standard.value(forKey: "pickupLoc") as! String
                let dropLoc:String! = UserDefaults.standard.value(forKey: "dropLoc") as! String
                
                print(pickupLoc)
                print(dropLoc)
                
            }
        } */
        
        
        let driverid = self.appDelegate.accepted_Driverid!

        print(driverid)
        
        self.getDriverDetails()

        
        if(driverid != ""){
            
            //        let geoFire = GeoFire(firebaseRef: ref.child("drivers_data").child("\(self.appDelegate.accepted_Driverid!)").child("accept"))
            let geoFire = GeoFire(firebaseRef: ref.child("drivers_data").child("\(driverid)").child("accept"))
            
            // let geoFire = GeoFire(firebaseRef: ref.child("drivers_location/5857c2bada71b4d9708b4567/"))
            
            print(geoFire!.firebaseRef(forLocationKey: "geolocation"))
            print(self.appDelegate.trip_id)
            ref.child("trips_data").child(self.appDelegate.trip_id!).child("status").observe(.value, with: { (snapshot) in
            //ref.child("trips_data").child("\(self.appDelegate.trip_id)").child("status").observe(.value, with: { (snapshot) in
                
                print("updating trip status")
                let status1 = snapshot.value as Any
                print(status1)
                var status = "\(status1)"
                status = status.replacingOccurrences(of: "Optional(", with: "")
                status = status.replacingOccurrences(of: ")", with: "")
                print(status)
                if(status == "1"){
                    
                    //accept
                    //
                    self.setDriverLoc()

                    self.statusLabel.text = "ACCEPTED"
                    if (UserDefaults.standard.object(forKey: "isTerminal") != nil)
                    {
                        self.terminalView.isHidden = false
                    }else{
                        self.terminalView.isHidden = true
                    }
                    self.driverETAlbl.isHidden = false
                    self.viewCurrentTrip.isHidden = true
                    self.viewBlurCurrentTrip.isHidden = true

                    self.setDriverLoc()

                    self.gettingDirectionsAPI()   // to set  polyline for pickup location to driverslocation.
                    
                    self.startBearing(location: self.myOrigin)
                    self.total_tollfee.isHidden = true
                    self.viewTopPickup.isHidden = true

                }
                else if(status == "2"){
                    
                    print("2 is")
                    self.noteString = "Driver is arriving now."
                    self.notification()

                    
                    self.setDriverLoc()

                    self.statusLabel.text = "ARRIVING"
                    self.driverETAlbl.isHidden = true

                    
                    // to get trip id
                    
                    self.getTripID()
                    self.gettingDirectionsAPI()   // to set  polyline for pickup location to driverslocation.
                    
                    //self.startBearing(location: self.myOrigin)
                    
                    self.imageName = "endPinRound"
                    self.imageName1 = "markerloc1"
                    self.imageName2 = "markerloc2"
                    self.imageName3 = "markerloc3"
                    self.imageName4 = "markerloc4"
                    self.total_tollfee.isHidden = true
                    self.viewTopPickup.isHidden = true
                    
                }
                else if(status == "3"){
                    print("3 is")

                    self.bearing = "trip"
                    self.noteString = "Trip is started now."
                    self.notification()

                    self.setDropLoc()

                    self.imageName = "endPinSquare"
                    self.imageName1 = "markerloc1"
                    self.imageName2 = "markerloc2"
                    self.imageName3 = "markerloc3"
                    self.imageName4 = "markerloc4"
                    print(self.myOrigin.coordinate)
                    print(self.myDestination.coordinate)
                    
                    // to set intial polyline for pickup location to drop location.
                    
                    self.startBearing(location: self.myOrigin)
                    
                    self.statusLabel.text = "ON TRIP"
                    self.total_tollfee.isHidden = false
                    self.btnInfo.isHidden = true
                    self.viewCurrentTrip.isHidden = true
                    self.viewBlurCurrentTrip.isHidden = true
                    self.viewUpdateDrop.isHidden = false
                    self.waypointmerge = ""
                    self.waypointmerge1 = ""
                    self.autoUpdateforLocation()
                    self.tripIsStarted = "yes"
                    self.viewTopPickup.isHidden = true
                    self.terminalView.isHidden = true
                    UserDefaults.standard.removeObject(forKey: "isTerminal")
                    let ref1 = FIRDatabase.database().reference().child("riders_location").child(self.appDelegate.userid!)
                    ref1.updateChildValues(["pickup_terminal": "None"])

                }
                else if(status == "4") || (status == "0") || (status == ""){
                    
                    if(self.multicount == 0){
                        self.updatemultilocindb()
                        self.multicount += 1
                    }
                    
                    
                    self.viewCurrentTrip.isHidden = true
                    self.viewBlurCurrentTrip.isHidden = true
                    self.viewUpdateDrop.isHidden = true
                    print(self.firsttime)
                    DispatchQueue.main.async { () -> Void in
                        
                        
                        if self.firsttime == 1 {
                            
                            self.locationManager.stopUpdatingHeading()
                            self.firsttime = 0
                            print("4 is")
                            self.tripIsStarted = "done"
                            self.accepted = "no"
                            self.bearing = "default"
                            self.trips = "2"
                            self.ridelater = "0"
                            self.noteString = "Trip is Completed."
                            self.btnInfo.isHidden = true
                       //     self.licplate_no.isHidden = true
                            self.notification()
                            print("final distance in km \(self.total/1000)")
                            
                            
                            self.appDelegate.distance = self.total/1000
                            print(self.appDelegate.distance)
                            if self.appDelegate.accepted_Driverid! != "" {
                                let ref = FIRDatabase.database().reference().child("drivers_data")
                                let ref1 = FIRDatabase.database().reference().child("drivers_location")
                                //.child("\(self.appDelegate.accepted_Driverid!)").child("accept").child("status")
                                ref.removeAllObservers()
                                ref1.removeAllObservers()
                                self.appDelegate.accepted_Driverid = ""
                                // self.appDelegate.trip_id = ""
                                
                                self.appDelegate.passAcceptedDriverCarCategory = ""
                                
                                //ref.removeObserver(FIRDatabase.database().reference(), forKeyPath: "driver_data")
                                
                                
                                //                    ref.removeAllObservers()
                                //                    var handle: UInt = 4
                                //                    handle = ref.observe(.value, with: { snapshot in
                                //                        print(snapshot)
                                //                        print("The value is now 42")
                                //                        ref.removeObserver(withHandle: handle)
                                //
                                //                    })
                            }
                            else{
                                
                                
                            }
                            
                            
                            /*let vC = ARCompleteTripVC()
                             vC.modalPresentationStyle = .formSheet
                             vC.modalTransitionStyle = .coverVertical
                             self.present(vC, animated: true, completion: nil)*/
                            self.appDelegate.waypointmerge = ""
                            self.appDelegate.waypointaddress = ""
                            self.appDelegate.waypointcountrycode = ""
                            
                            self.appDelegate.callCompleteVC()
                            
                            //    self.navigationController?.pushViewController(ARCompleteTripVC(), animated: true)
                            
                            // To Handle remove listener from firebase
                            
                            
                            //                self.present(ARCompleteTripVC(), animated: true, completion: nil)
                            
                            /*
                             self.progressViewOutlet.isHidden = false
                             //  self.driverDetail.isHidden = false
                             self.statusLabel.isHidden = true
                             self.viewPickupCentre.isHidden = false
                             self.addressView.isHidden = false
                             self.viewPay.isHidden = false
                             self.viewMapArcane.isMyLocationEnabled = true */
                            
                            self.statusLabel.text = "END TRIP"
                        }
                        
                        UserDefaults.standard.setValue("", forKey: "Droplat")
                        UserDefaults.standard.setValue("", forKey: "Droplng")
                        
                        UserDefaults.standard.setValue("", forKey: "pickuplat")
                        UserDefaults.standard.setValue("", forKey: "pickuplng")
                        let ref2 = FIRDatabase.database().reference().child("riders_location").child(self.appDelegate.userid!).child("Updatelocation")
                        ref2.updateChildValues(["0": String(0)])
                        ref2.updateChildValues(["1": String(0)])
                        FIRDatabase.database().reference().child("riders_location").child(self.appDelegate.userid!).child("DestinationWaypoints").removeValue { (error, ref) in
                            if error != nil {
                                print("error \(error)")
                            }
                        }
                    }
                    let ref111 = FIRDatabase.database().reference().child("riders_location").child(self.appDelegate.userid!)
                    ref111.updateChildValues(["WayPointCount": 0])
                    
                }
                

                else{
                    // empty
                }
                
                
                
            })
            
            
            
            if ((geoFire?.didChangeValue(forKey: "status")) != nil){
                
            }
            
            //self.newStatusTrip()
            
        }
        else{
            
        }
        
    }
    
    
    func autoUpdateforLocation(){
        
        
        
        var ref1 = FIRDatabase.database().reference()

        ref1.child("riders_location").child(self.appDelegate.userid!).child("Updatelocation").observe(.value, with: { (snapshot) in
            if(snapshot.exists()){
            if snapshot.value != nil{
                
                print("Snapshot value is not equal to nil")
                let d = snapshot.value!
                print(d)
                print("d.count:\((d as AnyObject).count)")
                
                if let value = snapshot.value as? NSArray {
                    if (d as AnyObject).count == 2{
                        
                        print("Values:")
                        
                        print(value)
                        
                        self.Updatedlat = value[0] as? NSString ?? ""
                        print("UpdatedLat:\(self.Updatedlat)")
                        self.Updatedlon = value[1] as? NSString ?? ""
                        print("UpdatedLon:\(self.Updatedlon)")
                        if (self.Updatedlat != "") && (self.Updatedlon != "") && (self.Updatedlat != "0") && (self.Updatedlon != "0") {
                            self.dropup = CLLocation(latitude: Double(self.Updatedlat as String)!,longitude: Double(self.Updatedlon as String)!)
                            
                            self.myDestination = self.dropup
                            
                            
                        }
                    }
                    
                }
                else{
                    
                    print("Null value")
                    
                }
                
                
            }
            else{
                
                print("Snapshot value is nil")
                
            }
            
            }
        }) { (error) in
            print(error.localizedDescription)
        }
        ref1.child("riders_location").child(self.appDelegate.userid!).child("WayPointCount").observe(.value, with: { (snapshot) in
            if(snapshot.exists()){
            if snapshot.value != nil{
                print("Snapshot value is not equal to nil")
                print(snapshot.value)
                
                let waypointcount1 = snapshot.value!
                
                let waypointcount = Int((waypointcount1 as AnyObject) as! NSNumber)
                
                
                
                for var i in 1..<waypointcount+1 {
                    print(i)
                    var count = 0
                    FIRDatabase.database().reference().child("riders_location").child(self.appDelegate.userid!).child("DestinationWaypoints").child("WayPoint \(i)").observeSingleEvent(of: .value, with: { (snapshot) in
                        if(snapshot.exists()){
                        print(snapshot.value)
                        
                        if snapshot.value != nil{
                            FIRDatabase.database().reference().child("riders_location").child(self.appDelegate.userid!).child("DestinationWaypoints").child("WayPoint \(i)").child("Coordinates").observeSingleEvent(of: .value, with: { (snapshot) in
                                if(snapshot.exists()){
                                if(count == 0){
                                    print(snapshot.value)
                                    
                                    if snapshot.value != nil{
                                        let multidest = snapshot.value!
                                        print(multidest)
                                        print("multidest:\((multidest as AnyObject).count)")
                                        
                                        if let value = snapshot.value as? NSArray {
                                            if (multidest as AnyObject).count == 2{
                                                
                                                self.imageName1 = "markerloc1"
                                                self.imageName2 = "markerloc2"
                                                self.imageName3 = "markerloc3"
                                                self.imageName4 = "markerloc4"
                                                
                                                print(value[0])
                                                print(value[1])
                                                print("Waypoint is\("WayPoint \(i)")")
                                                if(self.waypointmerge == ""){
                                                    self.waypointmerge =  "via:\(String(describing: value[0])),\(String(describing: value[1]))" as NSString
                                                    print(self.waypointmerge)
                                                    
                                                        self.markerloc1.appearAnimation = kGMSMarkerAnimationNone
                                                        self.markerloc1.icon = UIImage(named: self.imageName1)
                                                        self.markerloc1.map = self.viewMapArcane
                                                        self.myloc1 = CLLocation(latitude: value[0] as! CLLocationDegrees, longitude: value[1] as! CLLocationDegrees)
                                                        self.markerloc1.position = CLLocationCoordinate2D(latitude: self.myloc1.coordinate.latitude, longitude: self.myloc1.coordinate.longitude)
                                                    print(self.imageName1)
                                                    print(self.myloc1)
                                                }
                                                else{
                                                    if(self.waypointmerge.contains("via:\(value[0]),\(value[1])")){
                                                        print("already added this location")
                                                    }
                                                    else{
                                                        self.waypointmerge =  "\(self.waypointmerge)|via:\(value[0]),\(value[1])" as NSString
                                                        print(self.waypointmerge)
                                                        
                                                    }
                                                }
                                                
                                            }
                                        }
                                    }
                                    count += 1
                                }
                            }
                            })
                            
                            
                            i = i + 1
                            
                        }
                        }
                    })
                    
                    
                }
                if(waypointcount == 0){
                    self.appDelegate.waypointmerge = ""
                    self.appDelegate.waypointaddress = ""
                    self.appDelegate.waypointcountrycode = ""
                    self.waypointmerge = ""
                }
                else{
                    self.gettingDirectionsAPI()
                }
                print(self.waypointmerge)
                
            }
            else{
                print("Snapshot value is nil")
            }
            
            }
            
            
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    var locationLatArray:NSMutableArray = NSMutableArray()
    var locationLonArray:NSMutableArray = NSMutableArray()
    
    
    func updatemultilocindb(){
        
        if(self.appDelegate.waypointmerge != ""){
        
        var updatemultilocindburl:String = "\(live_url)requests/updateDestinationWaypoints/coordinates/\(self.appDelegate.waypointmerge!)/countrycodes/\(self.appDelegate.waypointcountrycode!)/address/\(self.appDelegate.waypointaddress!)/trip_id/\(self.appDelegate.trip_id!)"
        
        updatemultilocindburl = updatemultilocindburl.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        
        print(updatemultilocindburl)
        
            updatemultilocindburl = (updatemultilocindburl.replacingOccurrences(of: "Optional", with: "") as NSString) as String
            updatemultilocindburl = (updatemultilocindburl.replacingOccurrences(of: "(", with: "") as NSString) as String
            updatemultilocindburl = (updatemultilocindburl.replacingOccurrences(of: ")", with: "") as NSString) as String
            updatemultilocindburl = (updatemultilocindburl.replacingOccurrences(of: "\"", with: "") as NSString) as String
            updatemultilocindburl = updatemultilocindburl.replacingOccurrences(of: ",", with: "%2C")
            
            
        let manager : AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
        
        manager.responseSerializer.acceptableContentTypes =  NSSet(object: "application/json") as Set<NSObject>
      
        manager.get("\(updatemultilocindburl)",
            parameters: nil,
            success: { (operation: AFHTTPRequestOperation?,responseObject: Any?) in
                if let dict = responseObject as? [String: AnyObject]
                {
                    let status: String? = (dict as AnyObject).object(forKey: "status") as? String
                    print(status)
                }
        },
            failure: { (operation: AFHTTPRequestOperation?,error: Error) in
                print("Error: " + error.localizedDescription)
                
        })
            }
        
    }
    
    func pickupView(){
        
        self.viewTopDrop.isHidden = false
        self.viewPay.isHidden = false
        self.viewRideShareNumbers.isHidden = false
        self.viewRequest.isHidden = false
        self.labelTopPickupCentre.isHidden = false
        self.btnNewTopBack.isHidden = false

    }

    func noCarsView(){
        
        self.viewPickupCentre.isHidden = true
        self.viewTopDrop.isHidden = true
        self.viewPay.isHidden = true
        self.viewFareEstimate.isHidden = true
        self.viewRideShareNumbers.isHidden = true
        self.viewRequest.isHidden = true
        self.labelTopPickupCentre.isHidden = true
        self.btnNewTopBack.isHidden = true
        self.viewMapArcane.padding = UIEdgeInsetsMake(100, 0, 100, 0)

    }
    
    /*func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        if tripIsStarted == "yes"{
            self.viewPickupCentre.isHidden = true

        }
        else if self.accepted == "yes"{
            
            self.viewPickupCentre.isHidden = true
        }
        else{
            
            var tripid = ""
            if UserDefaults.standard.value(forKey: "trip_id") != nil{
                
                tripid = (UserDefaults.standard.value(forKey: "trip_id") as? String)!
                tripid = tripid.replacingOccurrences(of: "Optional(", with: "")
                tripid = tripid.replacingOccurrences(of: ")", with: "")
                tripid = tripid.replacingOccurrences(of: "\"", with: "")
                
            }
            if tripid == ""{
                
                /*
                self.viewPickupCentre.isHidden = false
                self.labelPickupCentre.text = "NO CARS AVAILABLE"
                self.btnPickupNewCentre.isEnabled = false*/
                
                
                self.nearBy()
                
            }
            else{
                self.viewPickupCentre.isHidden = true
 
            }

            
        }
    } */
    
    
    func nearBy(){
        
        
        let catCategory = self.carCategoryPass
        
        if catCategory == ""{
            
            self.carCategoryPass = "Standard"
        }
        else{
            
            self.carCategoryPass = catCategory
        }

        print("car /\(self.carCategoryPass)")
        
        let ref1 = FIRDatabase.database().reference()
        
        print(" data base \(ref1)")
        
        let geoFire = GeoFire(firebaseRef: FIRDatabase.database().reference().child(byAppendingPath: "drivers_location").child("\(self.carCategoryPass)"))

        print(self.nearbyRadius)
        
        let circleQuery = geoFire?.query(at: self.nearbyLocation, withRadius: Double(self.nearbyRadius))
        var tripid = ""
        if UserDefaults.standard.value(forKey: "trip_id") != nil{
            
            tripid = (UserDefaults.standard.value(forKey: "trip_id") as? String)!
            tripid = tripid.replacingOccurrences(of: "Optional(", with: "")
            tripid = tripid.replacingOccurrences(of: ")", with: "")
            tripid = tripid.replacingOccurrences(of: "\"", with: "")
            
        }
        if tripid == ""{
            let markerShow = GMSMarker()
            var pinIcons: Dictionary<String, GMSMarker> = [:]
            let updating = circleQuery!.observe(.keyEntered, with: { (key: String?, location: CLLocation?) in

                
                if(location != nil){
                    if self.accepted == "yes"{
                        self.viewPickupCentre.isHidden = true
                    }
                    else if self.req == "yes"{
                        
                    }
                    else if self.touched == true{
                        
                        self.viewTopLeftMenu.isHidden = true
                        if(self.fareestimateclicked == "0"){
                        self.viewTopLeftCancel.isHidden = false
                        }
                        self.viewTopDrop.isHidden = false
                        self.btnNewTopBack.isHidden = false
                        self.buttonTopNewPickUp.isHidden = true
                        self.viewRequest.isHidden = false
                        self.viewPay.isHidden = false
                        self.viewRideShareNumbers.isHidden = false
                        self.labelTopPickupCentre.isHidden = false
                        
                    }

                    else{
                        self.nocar = "no"
                        let markerShow = GMSMarker()

                        markerShow.position = CLLocationCoordinate2D(latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!)

                        markerShow.appearAnimation = kGMSMarkerAnimationNone
                        if(self.carCategoryPass == self.labelCarName2.text!){
                            markerShow.icon = UIImage(named: "map_lux.png")

                        }
                        else if(self.carCategoryPass == self.labelCarName3.text!){
                            markerShow.icon = UIImage(named: "map_suv.png")

                        }
                        else if(self.carCategoryPass == self.labelCarName4.text!){
                            markerShow.icon = UIImage(named: "map_taxi.png")
                        }
                        else{
                            markerShow.icon = UIImage(named: "Drivers.png")
                        }
                       
                        markerShow.isFlat = true
                        markerShow.userData = pinIcons
                        markerShow.map = self.viewMapArcane
                        pinIcons[key!] = markerShow
                        markerShow.groundAnchor = CGPoint(x: 0.5, y: 0.5)
                        self.viewPickupCentre.isHidden = false
                        self.labelPickupCentre.text = "SET PICKUP LOCATION"
                        self.btnPickupNewCentre.isEnabled = true
                      //  self.viewCarCategory.isHidden = true
                        self.viewLeftCircleTime.isHidden = false
                        self.viewRightCircleTime.isHidden = false
                        self.driving(orignlat: "\(location?.coordinate.latitude)", originLon: "\(location?.coordinate.longitude)")

                    }
                    
                    if self.touchPickUp == true{
                        
                        
                    }
                    
                }
                else{
                    
                }
                
            })
            
            print(updating.hashValue)
                
            
            
            var disupdating = circleQuery!.observe(.keyExited, with: { (key: String?, location: CLLocation?) in
                if self.accepted == "yes"{
                    
                    self.viewPickupCentre.isHidden = true

                }
                else if self.req == "yes"{
                    // if the request process is going then do nothing
                }
                else if self.touched == true{
                    
                    markerShow.map = nil
                    self.viewTopLeftMenu.isHidden = true
                    self.viewTopLeftCancel.isHidden = false
                    self.viewTopDrop.isHidden = false
                    self.btnNewTopBack.isHidden = false
                    self.buttonTopNewPickUp.isHidden = true
                    self.viewRequest.isHidden = false
                    self.viewPay.isHidden = false
                    self.viewRideShareNumbers.isHidden = false
                    self.labelTopPickupCentre.isHidden = false
                    
                }

                else{
                    
                    if((pinIcons[key!]) != nil){
                        var marker_move = pinIcons[key!]!
                        marker_move.map = nil
                    }
                    
                    //markerShow.map = nil
                    //self.viewMapArcane.clear()
                    
                    self.viewTopLeftCancel.isHidden = true
                    self.viewTopDrop.isHidden = true
                    self.btnNewTopBack.isHidden = true
                    self.buttonTopNewPickUp.isHidden = false
                    self.viewRequest.isHidden = true
                    self.viewPay.isHidden = true
                    self.viewFareEstimate.isHidden = true
                    self.viewRideShareNumbers.isHidden = true
                    self.labelTopPickupCentre.isHidden = true
                    self.viewMapArcane.padding = UIEdgeInsetsMake(100, 0, 100, 0)
                    
                    self.touched = false
                    self.labelPickupCentre.text = "NO CARS AVAILABLE"
                    self.viewLeftCircleTime.isHidden = true
                    self.viewRightCircleTime.isHidden = true
                     if(self.fareestimateclicked == "0"){
                    self.viewCarCategory.isHidden = false
                    self.viewTopLeftMenu.isHidden = false
                    }


                }
                
            })
            let marker = GMSMarker()

            var moving = circleQuery!.observe(.keyMoved, with: { (key: String?, location: CLLocation?) in
                
                //var marker_move = GMSMarker()
                
                
                
                if self.accepted == "yes"{
                    
                    self.viewPickupCentre.isHidden = true
                    
                }
                else if self.req == "yes"{
                    
                }
                else if self.touched == true{
                    
                    self.viewTopLeftMenu.isHidden = true
                    self.viewTopLeftCancel.isHidden = false
                    self.viewTopDrop.isHidden = false
                    self.btnNewTopBack.isHidden = false
                    self.buttonTopNewPickUp.isHidden = true
          
                    
                    
                    
                    self.viewRequest.isHidden = false
                    self.viewPay.isHidden = false
                    self.viewRideShareNumbers.isHidden = false
                    self.labelTopPickupCentre.isHidden = false
                    //self.etaCalc(orignlat: "\(location?.coordinate.latitude)", originLon: "\(location?.coordinate.longitude)")
                }
                else{
                    
//                    self.viewPickupCentre.isHidden = false
//                    self.labelPickupCentre.text = "NO CARS AVAILABLE"
//                    self.btnPickupNewCentre.isEnabled = false
                    
                    if((pinIcons[key!]) != nil){
                        var marker_move = pinIcons[key!]!
                        self.ref.child("drivers_location").child("\(self.carCategoryPass)").child("\(key!)").observe(.value, with: { (snapshot) in
                            
                            let dict = snapshot.value as? NSDictionary
                            //                        print(dict as Any)
                            if((dict?["bearing"]) != nil){
                                
                                let final_bear = dict?["bearing"]
                                let temp_bear:NSString = final_bear as! NSString
                                let temp_bear1 = Double(temp_bear as String)
                                self.angle = temp_bear1 as! Double!
                                marker_move.rotation = self.angle
                            }
                        })
                        marker_move.appearAnimation = kGMSMarkerAnimationNone
                        marker_move.position = CLLocationCoordinate2D(latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!)
                    }
                    
                    
                    //marker.map = nil
                    //marker.position = CLLocationCoordinate2D(latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!)
                    
                    //marker.appearAnimation = kGMSMarkerAnimationNone
                    //if(self.carCategoryPass == "Luxury"){
                     //   marker.icon = nil
                        //self.viewMapArcane.clear()
                      //  marker.icon = UIImage(named: "map_lux.png")
                    //}
                   // else if(self.carCategoryPass == "SUV"){
                   //     marker.icon = nil
                        //self.viewMapArcane.clear()
                    //    marker.icon = UIImage(named: "map_suv.png")
                    //}
                    //else if(self.carCategoryPass == "Taxi"){
                     //   marker.icon = nil
                       // self.viewMapArcane.clear()
                     //   marker.icon = UIImage(named: "map_taxi.png")
                    //}
                   // else{
                     //   marker.icon = nil
                      //  self.viewMapArcane.clear()
                     //   marker.icon = UIImage(named: "Drivers.png")
                    //}
                    //marker.icon = UIImage(named: "Drivers.png")
                    //marker.isFlat = true
                   // marker.map = self.viewMapArcane
                    //marker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
                    self.viewPickupCentre.isHidden = false
                    self.labelPickupCentre.text = "SET PICKUP LOCATION"
                    self.btnPickupNewCentre.isEnabled = true
                  //  self.viewCarCategory.isHidden = true
                    var passDurationTime = CLLocationCoordinate2D(latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!)
                    self.viewLeftCircleTime.isHidden = false
                    self.viewRightCircleTime.isHidden = false

                    self.driving(orignlat: "\(location?.coordinate.latitude)", originLon: "\(location?.coordinate.longitude)")
                    
                }
                
            })

            
            circleQuery?.observeReady({
                //            print("All initial data has been loaded and events have been fired!")
                
            })
            
            if self.accepted == "yes"{
                
                self.viewPickupCentre.isHidden = true
                
            }
            else if self.req == "yes"{
                
            }
            else{
                if(labelPickupCentre.text == "NO CARS AVAILABLE") || (self.nocar != "no"){
                    //Hira
                    
                    self.viewTopLeftCancel.isHidden = true
                    self.viewTopDrop.isHidden = true
                    self.btnNewTopBack.isHidden = true
                    self.buttonTopNewPickUp.isHidden = false
                    self.viewRequest.isHidden = true
                    self.viewPay.isHidden = true
                    self.viewFareEstimate.isHidden = true
                    self.viewRideShareNumbers.isHidden = true
                    self.labelTopPickupCentre.isHidden = true
                    self.viewMapArcane.padding = UIEdgeInsetsMake(100, 0, 100, 0)

                    self.viewMapArcane.clear()
                    self.touched = false
                    self.labelPickupCentre.text = "NO CARS AVAILABLE"
                    if(fareestimateclicked == "0"){
                        self.viewCarCategory.isHidden = false
                        self.viewTopLeftMenu.isHidden = false
                    }
                    self.viewLeftCircleTime.isHidden = true
                    self.viewRightCircleTime.isHidden = true
                }
                else{
                    
                    if self.touched == true{
                        
                        self.viewTopLeftMenu.isHidden = true
                        
                        if(self.fareestimateclicked == "0"){
                        self.viewTopLeftCancel.isHidden = false
                        }
                        self.viewTopDrop.isHidden = false
                        self.btnNewTopBack.isHidden = false
                        self.buttonTopNewPickUp.isHidden = true
                        self.viewRequest.isHidden = false
                        self.viewPay.isHidden = false
                        self.viewRideShareNumbers.isHidden = false
                        self.labelTopPickupCentre.isHidden = false

                    }
                    
                }
            }
            
        }
        else{

            self.btnPickupNewCentre.isEnabled = true

        }
        
    
        
        
    }
    // 1 normal update location // updateLocation() ,riderURL(url : String) , riderParseData(JSONData : Data)
    
    
    func updateLocation(){
        
        
        self.markerPosition()
        var urlstring:String = "\(live_rider_url)updateLocation/userid/\(self.appDelegate.userid!)/lat/\(self.currentLocation.coordinate.latitude)/long/\(self.currentLocation.coordinate.longitude)"
        
        urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        print(urlstring)
        
        self.riderURL(url: "\(urlstring)")
        
        
    }
    
    
    
    func riderURL(url : String){
        
        self.markerPosition()
        
        Alamofire.request(url).responseJSON { (response) in
            
            self.riderParseData(JSONData: response.data!)
            
        }
        
    }
    
    
    func riderParseData(JSONData : Data){
        
        do{
            
            let readableJSon = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as! jsonSTD
            
            print(" !!! \(readableJSon[0])")
            
            let value = readableJSon[0] as AnyObject
            
            let final = value.object(forKey: "status")
            print(final!)
            // self.setRequestStatus()
            
            
        }
        catch{
            
            print(error)
            
        }
        
    }
    
    
    func markerPosition(){
        
        let camera = GMSCameraPosition.camera(withLatitude: (self.currentLocation.coordinate.latitude), longitude:self.currentLocation.coordinate.longitude, zoom:16)
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: self.currentLocation.coordinate.latitude, longitude: self.currentLocation.coordinate.longitude)
        
        //camera.target
        //   marker.position = CLLocationCoordinate2D(latitude: 41.887, longitude: -87.622)
        
        //marker.snippet = "My Location"
        //marker.map = nil
        //marker.appearAnimation = kGMSMarkerAnimationNone
        //marker.icon = UIImage(named: "pinImage.png")
        marker.isFlat = true
        marker.map = self.viewMapArcane
        marker.map = nil
        

    }

    /**
     Searchbar when text change
     
     - parameter searchBar:  searchbar UI
     - parameter searchText: searchtext description
     */
    /*func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        
        self.resultsArray.removeAll()
        gmsFetcher?.sourceTextHasChanged(searchText)
        
       // fetcher?.sourceTextHasChanged(searchText)

    
    }*/
    
    // function by order
    /*
     1. Set Request
     2. process Request
     3. Get Request
     4. Update Request
     5. Update trip status
     
     */
    
    
    func getProcessRequest(){
        
        //changed to requestStatus as 2 by accepting by the driver.
        
        
        self.getRequestAlf()
        self.getRequestURL()
        
        self.requestStatus = 2
        
        let req_id = self.appDelegate.userid!
        
        var urlstring:String = "\(live_url)requests/processRequest/request_id/\(req_id)/est_fare/\(self.estimatedfare)"
        
        urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        print(urlstring)
        Alamofire.request(urlstring).responseJSON { (response) in
            print(urlstring)
            //            print(response)
            do{
                let readableJSon:NSArray! = try JSONSerialization.jsonObject(with: response.data!, options: .mutableContainers) as! NSArray
                
                print(" !!! \(readableJSon[0])")
            }
            catch{
                print(error)
            }
            
        }
        
        
    }
    
    
    
    func getRequestAlf(){
        
        let req_id = self.appDelegate.userid!
        
        var urlstring:String = "\(live_url)requests/getRequest/request_id/\(req_id)"
        
        urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        print(urlstring)
        
        
        Alamofire.request("\(live_url)requests/getRequest/request_id/\(req_id)").responseJSON { (response) in
            print(urlstring)
            //            print(response)
            do{
                
                let readableJSon:NSArray! = try JSONSerialization.jsonObject(with: response.data!, options: .mutableContainers) as! NSArray
                
                print(" !!! \(readableJSon[0])")
                
                let value = readableJSon[0] as AnyObject
                
                print(value)
                
                
                if let request_status:String = value["request_status"] as? String{
                    if(request_status == "processing"){
                        //  self.appDelegate.req_status = request_status
                        self.loopingReqeustStatus = "Process"
                        
                    }
                    else if(request_status == "no_driver"){
                        
                        self.loopingReqeustStatus = "No Driver"
                        
                        //    self.appDelegate.req_status = request_status
                        self.cancelReq = "not"
                        self.cancelRequest()

//                        self.btnCancelRequestAction(self.btnCancelProgress)
                        
                    }
                    else if(request_status == "accept"){
                        
                        self.accepted = "yes"
                        self.loopingReqeustStatus = "Accepted"
                        
                        self.timer.invalidate()
                        
                       // self.progressViewOutlet.setProgress(0, animated: false)
                        self.viewLineNewBar.isHidden = true
                        self.linearBar.stopAnimation()
                        self.statusView.isHidden = true
                        self.appDelegate.req_status = request_status
                        let driver_id:String = (value["driver_id"] as? String)!
                        self.appDelegate.accepted_Driverid = driver_id
                        
                        UserDefaults.standard.setValue(driver_id, forKey: "tripDriverid")

                        
                        
                        if let driver_location:NSDictionary = (value["driver_location"] as? NSDictionary){
                            print(driver_location["lat"]!)
                            print(driver_location["long"]!)
                            
                            self.timer.invalidate()
                            
                            self.appDelegate.driverLat = driver_location["lat"]! as! String
                            self.appDelegate.driverLong = driver_location["long"]! as! String
                            
                          ////  self.progressViewOutlet.isHidden = true
                            self.viewLineNewBar.isHidden = true
                            self.linearBar.stopAnimation()
                            self.viewCancelRequest.isHidden = true
                            self.statusView.isHidden = false
                            self.viewPickupCentre.isHidden = true
                            self.addressView.isHidden = true
                            self.viewPay.isHidden = true
                            self.viewFareEstimate.isHidden = true
                            self.viewRideShareNumbers.isHidden = true
                            self.viewMapArcane.isMyLocationEnabled = false
                      //      self.driverDetail.isHidden = false
                            self.viewCurrentTrip.isHidden = false
                            self.viewBlurCurrentTrip.isHidden = false
                            if (UserDefaults.standard.object(forKey: "isTerminal") != nil)
                            {
                                self.terminalView.isHidden = false
                            }else{
                                self.terminalView.isHidden = true
                            }

                            self.viewMapArcane.padding = UIEdgeInsetsMake(100, 0, 100, 0)
                        }
                        
                        
                        
                        
                        
                        
                    }
                    else{
                        
                    }
                    
                }
                
                self.checkLoop()
                
                
            }
            catch{
                
                print(error)
                
            }
            
        }
        
    }
    
    var placesClient = GMSPlacesClient()
    
    /*func placeAutocomplete() {
        
        let visibleRegion = viewMapArcane.projection.visibleRegion()
        let bounds = GMSCoordinateBounds(coordinate: (CLLocationCoordinate2DMake(9.9239, 78.1140)), coordinate: (CLLocationCoordinate2DMake(9.9239, 78.1140)))
        
        let filter = GMSAutocompleteFilter()
        //GMSPlacesClient.provideAPIKey("AIzaSyCuhsdolQuBDwCyapB9fhqgw_ZIhlGAzBk")
        filter.type = .establishment
        placesClient.autocompleteQuery("Madurai", bounds: nil, filter: filter, callback: {
            (results, error) -> Void in
            guard error == nil else {
                print("Autocomplete error \(error)")
                return
            }
            if let results = results {
                for result in results {
                    print("Result \(result.attributedFullText) with placeID \(result.placeID)")
                }
            }
        })
    }*/
    
    


}
extension ARMainMapVC : SlideMenuControllerDelegate {
    
    func leftWillOpen() {
        print("SlideMenuControllerDelegate: leftWillOpen")
    }
    
    func leftDidOpen() {
        print("SlideMenuControllerDelegate: leftDidOpen")
    }
    
    func leftWillClose() {
        print("SlideMenuControllerDelegate: leftWillClose")
    }
    
    func leftDidClose() {
        print("SlideMenuControllerDelegate: leftDidClose")
    }
    
    func rightWillOpen() {
        print("SlideMenuControllerDelegate: rightWillOpen")
    }
    
    func rightDidOpen() {
        print("SlideMenuControllerDelegate: rightDidOpen")
    }
    
    func rightWillClose() {
        print("SlideMenuControllerDelegate: rightWillClose")
    }
    
    func rightDidClose() {
        print("SlideMenuControllerDelegate: rightDidClose")
    }
    
   
    
}
/*extension ARMainMapVC: UNUserNotificationCenterDelegate {
 let fancy = GMSCameraPosition.camera(withLatitude: self.myOrigin.coordinate.latitude,
 longitude: self.myOrigin.coordinate.longitude,
 zoom: 16)
 self.viewMapArcane.camera = fancy
 
 
}*/
extension ARMainMapVC: EdropdownListDelegate {
    func didSelectItem(_ selectedItem: String, index: Int) {
        print("select: \(selectedItem), index: \(index)")
        dropdownList.textColor = UIColor.black
    }
}
extension String {
    
    init( myFormat: NSString, _ value: Double ) {
        
        self.init()
        
        let formatted = NSString( format: myFormat, value )
        self = "\(formatted)"
    }
}



