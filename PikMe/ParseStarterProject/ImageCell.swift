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
        if(likeButtonPressed) {
            likeButton.setBackgroundImage(UIImage(named: "button_like_pressed"), forState: nil)
            
            var nLike = self.likeCounterLabel.text?.toInt()
            nLike!++
            self.likeCounterLabel.text = String(nLike!)
        }
        else {
            likeButton.setBackgroundImage(UIImage(named: "button_like_unpressed"), forState: nil)
            var nLike = self.likeCounterLabel.text?.toInt()
            if(nLike > 0) {
                nLike!--
            }
            self.likeCounterLabel.text = String(nLike!)
        }
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
