//
//  AgendaEventCell.swift
//  GrausApp
//
//  Created by Pallas, Ricardo on 7/1/17.
//  Copyright © 2017 Pallas, Ricardo. All rights reserved.
//

import UIKit
import PINRemoteImage

class AgendaEventCell: UITableViewCell {
    var event: AgendaEvent? {
        didSet {
            if let event = event {
                iconImageView.image = nil
                if let thumbnailUrl = event.imageThumbnailUrl {
                    let url = URL(string: thumbnailUrl)
                    iconImageView.pin_setImage(from: url)
                }
                hoursLabel.text = event.date.toString()
                titleLabel.text = event.name
            }
        }
    }
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!
    

}
