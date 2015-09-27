//
//  FeedTableViewController.swift
//  PikMe
//
//  Created by Giacomo on 05/07/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit

class FeedTableViewController: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    
    @IBOutlet weak var btnUsername: UIButton!
    
    let username = Cloud.username()
    var pikList = [Pik]()
    var elementList = [Element]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = UIRectEdge.All
        //self.tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, CGRectGetHeight(self.tabBarController!.tabBar.frame), 0.0)
        self.tableView.contentInset = UIEdgeInsetsMake(32.0, 0.0, CGRectGetHeight(self.tabBarController!.tabBar.frame), 0.0)

        initializeList()
        
        
        //        self.tableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, CGRectGetHeight(self.tabBarController.tabBar.frame), 0.0f);
    //}
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func viewWillAppear(animated: Bool) {
        self.btnUsername.setTitle(self.username, forState: UIControlState.Normal)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeList(){
        
        Cloud.getPikList(100, callback: callBacker)
    }
    
    func callBacker(piks : [Pik]?, msgError: String?) -> Void {
        
        if(msgError != nil) { /*C'è un errore*/
            var alert = UIAlertController(title: "Generic Error", message: msgError, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else {
            self.pikList = piks!
            self.tableView.reloadData()
        }
    }
    
    /*Take a photo*/
    @IBAction func takePhoto(sender: UIButton) {
        
        var imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
            imagePickerController.sourceType = UIImagePickerControllerSourceType.Camera
            imagePickerController.allowsEditing = true
            self.presentViewController(imagePickerController, animated: true, completion: nil)
        }
        
    }
    
    /*Select a photo from album*/
    @IBAction func selectPhoto(sender: UIButton) {
        
        var imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary)) {
            imagePickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            imagePickerController.allowsEditing = true
            self.presentViewController(imagePickerController, animated: true, completion: nil)
        }
    }
    
    
    /*Choose the photo*/
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        let img = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        /*Creo il pik*/
        let myPik = Pik(image:img)
        
        /*Salvo il pik in cloud*/
        myPik.saveInBackgroundWithBlock {(ok:Bool, error: NSError?) -> Void in
            if error != nil
            {
                var alert = UIAlertController(title: "Network error", message: "Unable to saving the photo", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            }
            else
            {
//              var el = Element()
//              el.likeN = myPik.like;
//              el.username = self.username;
//              el.pic = img
//              self.elementList.append(el)
                self.pikList.append(myPik)
                self.tableView.reloadData()
            }
        }
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
        
    /*Cancel*/
    func imagePickerControllerDidCancel(picker: UIImagePickerController)
    {
        NSLog("picker cancel.")
        picker.dismissViewControllerAnimated(true, completion: nil)

    }
    
    
    @IBAction func btnLikeTapped(sender: AnyObject) {
        
        let button = sender as! UIButton
        let view = button.superview!
        let cell = view.superview as! ImageCell
        let indexPath = self.tableView.indexPathForCell(cell)
        var index = indexPath!.row
        
        if(self.pikList[index].alreadyLike()) { /*C'è già il like*/
            self.pikList[index].unlike({ (succeded: Bool, msgError: String?)->Void in
                if(msgError == nil) {
                    self.pikList[index].like--;
                }
            })
        }
        else { /*Non c'è il like*/
            self.pikList[index].like({ (succeded: Bool, msgError: String?)->Void in
                if(msgError == nil) {
                    self.pikList[index].like++;
                }
            })
        }
    }
    
    
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.pikList.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var index = indexPath.row
        let cell = tableView.dequeueReusableCellWithIdentifier("PhotoCell", forIndexPath: indexPath) as! ImageCell
        
        cell.nicknameLabel.text = self.pikList[index].user.username
        self.pikList[index].getImage({ (image: UIImage?, msgError: String?) -> Void in
            if(msgError == nil) {
                cell.photoImage.image = image
            }
            else {
                
            }
        })
        cell.likeCounterLabel.text = String(self.pikList[index].like)
        
        return cell
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
