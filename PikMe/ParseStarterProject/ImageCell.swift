//
//  ImageCell.swift
//  PikMe
//
//  Created by Giacomo on 05/07/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit

class ImageCell: UITableViewCell {

    @IBOutlet var nicknameLabel: UILabel!
    @IBOutlet var likeCounterLabel: UILabel!
    @IBOutlet var photoImage: UIImageView!
    @IBOutlet var likeButton: UIButton!
    
    var likeButtonPressed : Bool = false
    
    @IBAction func onLikePressed(sender: AnyObject) {
        toggleLikeButton()
    }
    
    func toggleLikeButton(){
        likeButtonPressed = !likeButtonPressed
        likeButtonPressed ? likeButton.setBackgroundImage(UIImage(named: "button_like_pressed"), forState: nil) : likeButton.setBackgroundImage(UIImage(named: "button_like_unpressed"), forState: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
