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
            self.collectionView?.reloadData()
        }
    }

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ProfileCell

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
        let singlePhotoVC = segue.destinationViewController as! SinglePhotoViewController
        singlePhotoVC.u
    }
    

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return self.pikList.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ProfileCell
    
        var index = indexPath.row
        
        // Configure the cell
        self.pikList[index].getImage({ (image: UIImage?, msgError: String?) -> Void in
            if(msgError == nil) {
                cell.PersonalImage.image = image
            }
            else {
                
            }
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
