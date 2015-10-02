//
//  SinglePhotoViewController.swift
//  PikMe
//
//  Created by Giacomo on 18/09/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit

class SinglePhotoViewController: UIViewController {

    @IBOutlet var UsernameLabel: UILabel!
    @IBOutlet var PhotoImageView: UIImageView!
    @IBOutlet var NLikeLabel: UILabel!
    
    @IBOutlet var likeButton: UIButton!
    
    
    var Image:UIImage!
    var Like: Int!
    
    var likeButtonPressed : Bool = false
    let username = Cloud.username()
    
    
    @IBAction func onLikePressed(sender: AnyObject) {
        toggleLikeButton()
        /*other stuffs here...*/
    }
    
    func toggleLikeButton(){
        likeButtonPressed = !likeButtonPressed
        likeButtonPressed ? likeButton.setBackgroundImage(UIImage(named: "button_like_pressed"), forState: nil) : likeButton.setBackgroundImage(UIImage(named: "button_like_unpressed"), forState: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.UsernameLabel.text = username
        self.PhotoImageView.image = self.Image
        self.NLikeLabel.text = String(self.Like)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
