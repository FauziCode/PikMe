//
//  RankCell.swift
//  PikMe
//
//  Created by Giacomo on 14/09/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit

class RankCell: UITableViewCell {

    @IBOutlet var RankLabel: UILabel!
    @IBOutlet var UsernameLabel: UILabel!
    @IBOutlet var LikeNumberLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
