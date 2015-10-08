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
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    var Image: UIImage?
    var Like: Int!
    var Username: String!
    var pikList = [Pik]()
    var indexInList: Int!
    var likePressed: Bool!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.UsernameLabel.text = self.Username
        self.UsernameLabel.sizeToFit()
        self.PhotoImageView.image = self.Image
        self.NLikeLabel.text = String(self.Like)
        
        let cellIdentifier =  self.pikList[self.indexInList].objectId!
        if(self.appDelegate.cachedImages[cellIdentifier] != nil) { /*Cache*/
            let (image, user, like, alreadyLike) = self.appDelegate.cachedImages[cellIdentifier]!
        
            if(alreadyLike) { /*C'è già il like*/
                self.likeButton.setBackgroundImage(UIImage(named: "button_like_pressed"), forState: nil)
                self.likePressed = true;
            }
            else {
                self.likeButton.setBackgroundImage(UIImage(named: "button_like_unpressed"), forState: nil)
                self.likePressed = false;
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onLikePressed(sender: AnyObject) {
        likeButton.enabled = false
        if((self.likePressed) != nil && self.likePressed!) { /*C'è già il like*/
            self.pikList[indexInList].unlike({ (succeded: Bool, msgError: String?)->Void in
                if(msgError == nil) {
                    /*Interfaccia*/
                    self.likeButton.setBackgroundImage(UIImage(named: "button_like_unpressed"), forState: nil)
                    self.likePressed = false
                    var nLike = self.NLikeLabel.text?.toInt()
                    nLike!--
                    self.NLikeLabel.text = String(nLike!)
                    self.likeButton.enabled = true
                    
                    /*Cache*/
                    var like = self.pikList[self.indexInList].like
                    let cellIdentifier =  self.pikList[self.indexInList].objectId!
                    let img:UIImage = self.Image!
                    let user: String = self.Username
                    self.appDelegate.cachedImages.updateValue((img, user, like, self.likePressed!), forKey: cellIdentifier)
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
                    self.likeButton.enabled = true
                    
                    /*Cache*/
                    var like = self.pikList[self.indexInList].like
                    let cellIdentifier =  self.pikList[self.indexInList].objectId!
                    let img:UIImage = self.Image!
                    let user: String = self.Username
                    self.appDelegate.cachedImages.updateValue((img, user, like, self.likePressed!), forKey: cellIdentifier)
                }
            })
        }
        
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
