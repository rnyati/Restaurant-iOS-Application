//
//  HomeTableViewCell.swift
//  myFbLogin
//
//  Created by Raghav Nyati on 12/15/16.
//  Copyright © 2016 Raghav Nyati. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLabelView: UILabel!
    @IBOutlet weak var priceLabelView: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
