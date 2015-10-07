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
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var pikList = [Pik]()
    
    var FeedView: UIView! { return self.view as UIView }
    
    var loader = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    
    var loaderNewImage = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    var labelNewImage = UILabel()
    
    var loaderEmptyList = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    var labelEmptyMessage = UILabel()
    
    var viewHeader = UIView()
    
    var loaderLabel = UILabel()
    var hiddenView = UIView()
    var refresher = UIRefreshControl()
    
    var canRefresh: Bool = true
    
    let LABEL_WIDTH:CGFloat = 80
    let LABEL_HEIGHT:CGFloat = 20
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        self.edgesForExtendedLayout = UIRectEdge.All
        //self.tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, CGRectGetHeight(self.tabBarController!.tabBar.frame), 0.0)
        self.tableView.contentInset = UIEdgeInsetsMake(32.0, 0.0, CGRectGetHeight(self.tabBarController!.tabBar.frame), 0.0)
        
        /*Refresher*/
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
        self.refresher = refreshControl
        
        if(canRefresh) {
            let username = Cloud.username()
            self.btnUsername.setTitle(username, forState: UIControlState.Normal)
            
            /*Caricamento iniziale*/
            let hiddenV = UIView()
            hiddenV.frame = CGRectMake(0, 0, self.FeedView.frame.size.width, self.FeedView.frame.size.height)
            hiddenV.backgroundColor = UIColor.whiteColor()
            hiddenV.alpha = 1
            self.FeedView.addSubview(hiddenV)
            self.hiddenView = hiddenV
            
            let loaderL = UILabel()
            loaderL.frame = CGRectMake((self.hiddenView.frame.size.width - LABEL_WIDTH)/2 + 20, (self.hiddenView.frame.size.height - LABEL_HEIGHT)/2 - 80, LABEL_WIDTH, LABEL_HEIGHT)
            loaderL.text = "Loading…";
            self.hiddenView.addSubview(loaderL)
            self.loaderLabel = loaderL
            
            let loadeR = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
            loadeR.frame = CGRectMake(self.loaderLabel.frame.origin.x - LABEL_HEIGHT - 5, self.loaderLabel.frame.origin.y, LABEL_HEIGHT, LABEL_HEIGHT);
            self.hiddenView.addSubview(loadeR)
            self.loader = loadeR
            loadeR.startAnimating()
            
            self.viewHeader.frame = CGRectMake(0, 0, self.tableView.frame.size.width, 30)
            self.viewHeader.backgroundColor = UIColor.whiteColor()
            self.viewHeader.hidden = true
            
            self.loaderNewImage.center = CGPointMake(CGRectGetMidX(self.viewHeader.bounds) - 60, CGRectGetMidY(self.viewHeader.bounds) - 20)
            self.viewHeader.addSubview(self.loaderNewImage)
            self.loaderNewImage.startAnimating()
            
            self.labelNewImage.center = CGPointMake(CGRectGetMidX(self.viewHeader.bounds) - 40, CGRectGetMidY(self.viewHeader.bounds) - 30)
            self.labelNewImage.text = "Uploading image..."
            self.labelNewImage.sizeToFit()
            self.viewHeader.addSubview(self.labelNewImage)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        initializeList()
    }
    
    func refresh(sender:AnyObject)
    {
        self.refresher.beginRefreshing()
        initializeList()
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
            self.pikList = piks!.reverse()
            for var index = 0; index < self.pikList.count; ++index {
                self.pikList[index].getImage(callBacker2)
            }
        }
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(2)
        self.hiddenView.alpha = 0
        UIView.commitAnimations()
        
        self.loaderLabel.hidden = true
        self.loader.stopAnimating()
        self.refresher.endRefreshing()
    }
    
    func callBacker2(image: UIImage?, msgError: String?)->Void {
        if(msgError == nil) {
            self.tableView.reloadData()
        }
    }
    
    
    /*Take a photo*/
    @IBAction func takePhoto(sender: UIButton) {
        
        var imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
            imagePickerController.sourceType = UIImagePickerControllerSourceType.Camera
            //imagePickerController.allowsEditing = true
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
        
        self.viewHeader.hidden = false;
        self.loaderNewImage.startAnimating()
        self.loaderEmptyList.startAnimating()
        self.labelEmptyMessage.text = "Uploading image..."
        self.labelEmptyMessage.sizeToFit()
        
        let view = UIView(frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height))
        self.labelEmptyMessage.center = CGPointMake(CGRectGetMidX(view.bounds) - 3, CGRectGetMidY(view.bounds))
        
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
                self.pikList.append(myPik)
                self.tableView.reloadData()
                let indexpath = NSIndexPath(forRow: 0, inSection: 0)
                self.tableView.scrollToRowAtIndexPath(indexpath, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
                self.loaderNewImage.stopAnimating()
                self.viewHeader.hidden = true;
                self.loaderEmptyList.stopAnimating()
                self.labelEmptyMessage.text = "There are no photos uploaded.\n Be the first to upload one!"
                self.labelEmptyMessage.sizeToFit()
            }
        }
        picker.dismissViewControllerAnimated(true, completion: nil)
        canRefresh = false
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
        var index = self.pikList.count - 1 - indexPath!.row
        
        let alreadyLike = self.pikList[index].alreadyLike()
        if(alreadyLike) { /*C'è già il like*/
            self.pikList[index].unlike({ (succeded: Bool, msgError: String?)->Void in
                if(msgError == nil) {
                    //self.pikList[index].like--;
                }
            })
        }
        else { /*Non c'è il like*/
            self.pikList[index].like({ (succeded: Bool, msgError: String?)->Void in
                if(msgError == nil) {
                    //self.pikList[index].like++;
                }
            })
        }
        let cellIdentifier = "Cell" + String(index)
        let img:UIImage = cell.photoImage.image!
        let user: String = cell.nicknameLabel.text!
        let like = self.pikList[index].like
        self.appDelegate.cachedImages.updateValue((img, user, like, !alreadyLike), forKey: cellIdentifier)
    }
    
    
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        if(self.pikList.count > 0) {
            self.tableView.backgroundView = nil
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
            return 1
        }
        else {
            let view = UIView(frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height))
            
            let messageLabel = UILabel()
            messageLabel.text = "There are no photos uploaded.\n Be the first to upload one!";
            messageLabel.textColor = UIColor.blackColor()
            messageLabel.numberOfLines = 0;
            messageLabel.textAlignment = NSTextAlignment.Center
            messageLabel.sizeToFit()
            messageLabel.center = CGPointMake(CGRectGetMidX(view.bounds) - 3, CGRectGetMidY(view.bounds))
            self.labelEmptyMessage = messageLabel
            
            self.loaderEmptyList.center = CGPointMake(CGRectGetMidX(view.bounds), CGRectGetMidY(view.bounds) - 40)
            
            view.addSubview(messageLabel)
            view.addSubview(self.loaderEmptyList)
            
            view.sizeToFit()
            
            self.tableView.backgroundView = view
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if(self.pikList.count > 0) {
            return self.viewHeader
        }
        return nil
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.pikList.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("PhotoCell", forIndexPath: indexPath) as! ImageCell
        var index = self.pikList.count - 1 - indexPath.row
        
        let cellIdentifier = "Cell" + String(index)
        
        if(self.appDelegate.cachedImages[cellIdentifier] != nil) { /*Cache*/
            let (image, user, like, likePressed) = self.appDelegate.cachedImages[cellIdentifier]!
            cell.photoImage.image = image
            cell.nicknameLabel.text = user
            cell.nicknameLabel.sizeToFit()
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), {() -> Void in
                let nLike = String(self.pikList[index].like)
                let likeButtonPressed = self.pikList[index].alreadyLike()
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    cell.likeCounterLabel.text = nLike
                    if(likeButtonPressed) {
                        cell.likeButton.setBackgroundImage(UIImage(named: "button_like_pressed"), forState: nil)
                        cell.likeButtonPressed = true;
                    }
                    else {
                        cell.likeButton.setBackgroundImage(UIImage(named: "button_like_unpressed"), forState: nil)
                        cell.likeButtonPressed = false;
                    }
                })
            })
        }
        else { /*Non Cache*/
            let indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
            indicator.center = CGPointMake(CGRectGetMidX(cell.photoImage.bounds), CGRectGetMidY(cell.photoImage.bounds))
            cell.photoImage.addSubview(indicator)
            indicator.startAnimating()
            
            cell.photoImage.image = nil
            cell.nicknameLabel.text = nil;
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), {() -> Void in
                var nickname = self.pikList[index].user.username!
                var img = UIImage()
                self.pikList[index].getImage({ (image: UIImage?, msgError: String?) -> Void in
                    if(msgError == nil) {
                        img = image!
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), {() -> Void in
                            var nlike = self.pikList[index].like
                            var alreadylike = self.pikList[index].alreadyLike()
                        
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                cell.nicknameLabel.text = nickname
                                cell.nicknameLabel.sizeToFit()
                                cell.photoImage.image = img
                                cell.likeCounterLabel.text = String(nlike)
                            
                                if(alreadylike) {
                                    cell.likeButton.setBackgroundImage(UIImage(named: "button_like_pressed"), forState: nil)
                                    cell.likeButtonPressed = true;
                                }
                                else {
                                    cell.likeButton.setBackgroundImage(UIImage(named: "button_like_unpressed"), forState: nil)
                                    cell.likeButtonPressed = false;
                                }
                                self.appDelegate.cachedImages.updateValue((img, nickname, nlike, alreadylike), forKey: cellIdentifier)
                                
                                indicator.stopAnimating()
                            })
                        })
                    }
                    else {
                        
                    }
                })
                
            })
        }
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
