//
//  referralcell.swift
//  SIX Rider
//
//  Created by Apple on 25/05/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

class referralcell: UITableViewCell {

    @IBOutlet var referralusername: UILabel!
    @IBOutlet var referralimage: UIImageView!
    @IBOutlet var userlastname: UILabel!
    @IBOutlet var usercategory: UILabel!
    @IBOutlet var usertype: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        referralimage.layer.cornerRadius = referralimage.frame.size.width / 2
        referralimage.clipsToBounds = true

        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
