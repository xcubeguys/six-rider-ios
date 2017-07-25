//
//  ImageHeaderCell.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 11/3/15.
//  Copyright © 2015 Yuji Hato. All rights reserved.
//

import UIKit

class ImageHeaderView : UIView {
    
    @IBOutlet weak var profileImage : UIImageView!
    @IBOutlet weak var backgroundImage : UIImageView!
    @IBOutlet weak var labelUserName : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        self.profileImage.layer.cornerRadius = self.profileImage.bounds.size.height / 2
        self.profileImage.clipsToBounds = true
        
        let value = UserDefaults.standard.object(forKey: "userName")
        var final = value as! String!
        final = final?.replacingOccurrences(of: "Optional(", with: "")
        final = final?.replacingOccurrences(of: ")", with: "")
        final = final?.replacingOccurrences(of: "\"", with: "")
        final = final?.replacingOccurrences(of: "%20", with: " ")
        final = final?.replacingOccurrences(of: "nil", with: "")

        self.labelUserName.text = final as String!
        
        var valueProfile = UserDefaults.standard.object(forKey: "GProfilePic") as? String
        valueProfile = valueProfile?.replacingOccurrences(of: "Optional(", with: "")
        valueProfile = valueProfile?.replacingOccurrences(of: ")", with: "")
        
        if valueProfile == nil
        {
            
            self.profileImage.image = UIImage(named : "Userpic.png")
        }
        else if valueProfile == ""{
            
            //self.profileImage.image = UIImage(named : "Userpic.png")

        }
        else
        {
            
            self.profileImage.sd_setImage(with: NSURL(string: valueProfile!) as URL!)
        }
       // self.backgroundColor = UIColor(hex: "E0E0E0")
       // self.profileImage.layoutIfNeeded()
        
       // self.profileImage.layer.borderWidth = 1
       // self.profileImage.layer.borderColor = UIColor.white.cgColor
      //  self.profileImage.setRandomDownloadImage(80, height: 80)
        
        //self.backgroundImage.setRandomDownloadImage(Int(self.bounds.size.width), height: 160)
    }
}
