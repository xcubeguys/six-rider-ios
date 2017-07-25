//
//  ARMainTripsCell.swift
//  Arcane Rider
//
//  Created by Apple on 02/01/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

class ARMainTripsCell: UITableViewCell {

    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var labelCar: UILabel!
    @IBOutlet weak var labelStart: UILabel!
    @IBOutlet weak var labelEnd: UILabel!
    @IBOutlet weak var labelAmount: UILabel!
    @IBOutlet weak var imageViewProfile: UIImageView!
    @IBOutlet weak var viewCircle: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        viewCircle.layer.cornerRadius = viewCircle.frame.size.width / 2
        viewCircle.clipsToBounds = true

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
