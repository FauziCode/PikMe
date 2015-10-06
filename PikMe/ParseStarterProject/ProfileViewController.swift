//
//  ProfileViewController.swift
//  PikMe
//
//  Created by Giacomo on 15/09/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import Parse

let reuseIdentifier = "ProfileCell"

class ProfileViewController: UICollectionViewController {

    
    @IBOutlet weak var lblUsername: UILabel!
    
    let username = Cloud.username()
    var pikList = [Pik]()
    var user = PFUser()
    
    var selectedImage:UIImageView?
    var selectedIndexPath: NSIndexPath!
    var canVisualizeMsg: Bool = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Do any additional setup after loading the view.
        user.username = username
        initializeList()
    }

    override func viewWillAppear(animated: Bool) {
        self.lblUsername.text = username
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeList(){
        
        Cloud.getUserPikList(100, user: PFUser.currentUser()!, callback: callBacker)
    }
    
    func callBacker(piks : [Pik]?, msgError: String?) -> Void {
        
        if(msgError != nil) { /*C'è un errore*/
            var alert = UIAlertController(title: "Generic Error", message: msgError, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else {
            self.pikList = piks!.reverse()
            if(self.pikList.count == 0) {
                self.canVisualizeMsg = true;
            }
            else {
                self.canVisualizeMsg = false;
            }
            self.collectionView?.reloadData()
        }
    }

    @IBAction func onLogoutBtClick(sender: AnyObject) {
        
        Cloud.logOut(logoutCallBacker);
    }
    
    func logoutCallBacker(succeded: Bool, msgError: String)->Void {
        
        if(msgError != "") { /*C'è un errore nel logout*/
            
            var alert = UIAlertController(title: "Logout Error", message: msgError, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else {
            //performSegueWithIdentifier("logoutSegue", sender: self);
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("LoginViewController") as! UIViewController
            self.presentViewController(vc, animated: true, completion: nil)
        }
    }
    

    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if(segue.identifier == "SinglePhotoSegue") {
            let singlePhotoVC = segue.destinationViewController as! SinglePhotoViewController
            
            let cell:ProfileCell = collectionView?.cellForItemAtIndexPath(selectedIndexPath) as! ProfileCell
            singlePhotoVC.Image = cell.PersonalImage.image
            singlePhotoVC.Like = self.pikList[selectedIndexPath.row].like
            singlePhotoVC.Username = self.pikList[selectedIndexPath.row].user.username
            singlePhotoVC.pikList = self.pikList
            singlePhotoVC.indexInList = selectedIndexPath.row
        }
    }
    

    // MARK: UICollectionViewDataSource
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.selectedIndexPath = indexPath
        self.performSegueWithIdentifier("SinglePhotoSegue", sender: self)
    }

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        if(self.pikList.count > 0) {
            self.collectionView!.backgroundView = nil
            return 1
        }
        else if(self.canVisualizeMsg){
            let messageLabel = UILabel(frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height))
            messageLabel.text = "You haven't uploaded any photos yet.";
            messageLabel.textColor = UIColor.blackColor()
            messageLabel.numberOfLines = 0;
            messageLabel.textAlignment = NSTextAlignment.Center
            messageLabel.sizeToFit()
            
            self.collectionView!.backgroundView = messageLabel
        }
        return 0
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return self.pikList.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ProfileCell
    
        var index = indexPath.row
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), {() -> Void in
            var img = UIImage()
            self.pikList[index].getImage({ (image: UIImage?, msgError: String?) -> Void in
                if(msgError == nil) {
                    img = image!
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        cell.PersonalImage.image = img
                    })
                }
                else {
                    
                }
            })
            
        })
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
