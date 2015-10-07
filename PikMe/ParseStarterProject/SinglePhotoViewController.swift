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
    
    var Image: UIImage!
    var Like: Int!
    var Username: String!
    var pikList = [Pik]()
    var indexInList: Int!
    var likePressed: Bool = false;

    
    @IBAction func onLikePressed(sender: AnyObject) {
        if(self.likePressed) { /*C'è già il like*/
            self.pikList[indexInList].unlike({ (succeded: Bool, msgError: String?)->Void in
                if(msgError == nil) {
                    self.likeButton.setBackgroundImage(UIImage(named: "button_like_unpressed"), forState: nil)
                    self.likePressed = false
                    var nLike = self.NLikeLabel.text?.toInt()
                    nLike!--
                    self.NLikeLabel.text = String(nLike!)
                }
            })
        }
        else { /*Non c'è il like*/
            self.pikList[indexInList].like({ (succeded: Bool, msgError: String?)->Void in
                if(msgError == nil) {
                    self.likeButton.setBackgroundImage(UIImage(named: "button_like_pressed"), forState: nil)
                    self.likePressed = true
                    var nLike = self.NLikeLabel.text?.toInt()
                    nLike!++
                    self.NLikeLabel.text = String(nLike!)
                }
            })
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.UsernameLabel.text = self.Username
        self.UsernameLabel.sizeToFit()
        self.PhotoImageView.image = self.Image
        self.NLikeLabel.text = String(self.Like)
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), {() -> Void in
            let likeButtonPressed = self.pikList[self.indexInList].alreadyLike()
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if(likeButtonPressed) { /*C'è già il like*/
                    self.likeButton.setBackgroundImage(UIImage(named: "button_like_pressed"), forState: nil)
                    self.likePressed = true;
                }
                else {
                    self.likeButton.setBackgroundImage(UIImage(named: "button_like_unpressed"), forState: nil)
                    self.likePressed = false;
                }
            })
        })
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
