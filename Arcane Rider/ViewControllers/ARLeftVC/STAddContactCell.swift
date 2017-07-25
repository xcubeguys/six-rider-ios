//
//  STAddContactCell.swift
//  SendTxT
//
//  Created by Apple on 08/11/16.
//  Copyright © 2016 Apple. All rights reserved.
//

import UIKit

class STAddContactCell: UITableViewCell {

    @IBOutlet weak var selectedtick: UIButton!
    @IBOutlet weak var profimg: UIImageView!
    @IBOutlet weak var peoplename: UILabel!
    @IBOutlet weak var peopleno: UILabel!
    @IBOutlet weak var line:UIView!
    @IBOutlet weak var iconContact: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.iconContact.clipsToBounds = true
        self.iconContact.layer.cornerRadius = self.iconContact.frame.size.width / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
