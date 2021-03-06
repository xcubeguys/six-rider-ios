

import UIKit
import Stripe
import SVProgressHUD

class ScancardioViewController: UIViewController, STPPaymentCardTextFieldDelegate, CardIOPaymentViewControllerDelegate {
    
    @IBOutlet weak var payButton: UIButton!
    var paymentTextField: STPPaymentCardTextField!
    
    @IBOutlet weak var paybtn: UIButton!
    override func viewDidLoad() {
        // add stripe built-in text field to fill card information in the middle of the view
        super.viewDidLoad()
        let frame1 = CGRect(x: 20, y: 150, width: self.view.frame.size.width - 40, height: 40)
        /*paymentTextField = STPPaymentCardTextField(frame: frame1)
        paymentTextField.center = view.center
        paymentTextField.delegate = self
        view.addSubview(paymentTextField)*/
        //disable payButton if there is no card information
        paybtn.isEnabled = false
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        CardIOUtilities.preload()
    }
    
    @IBAction func scanCard(_ sender: Any) {
        //open cardIO controller to scan the card
        let cardIOVC = CardIOPaymentViewController(paymentDelegate: self)
        cardIOVC?.modalPresentationStyle = .formSheet
        present(cardIOVC!, animated: true, completion: nil)
    }
   
    @IBAction func payButtonTapped(_ sender: Any) {
        let card = paymentTextField.cardParams
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.dark)
        //send card information to stripe to get back a token
        getStripeToken(card)

    }
    
    
    
    func getStripeToken(_ card:STPCardParams) {
        // get stripe token for current card
        STPAPIClient.shared().createToken(withCard: card) { token, error in
            if let token = token {
                print(token)
                SVProgressHUD.showSuccess(withStatus: "Stripe token successfully received: \(token)")
                self.postStripeToken(token)
            } else {
                print(error)
                // SVProgressHUD.showError(errorwithStatus: ?.localizedDescription)
            }
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
            paybtn.isEnabled = true
        }
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
            print(str)
            
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
            
        }
    }
}
