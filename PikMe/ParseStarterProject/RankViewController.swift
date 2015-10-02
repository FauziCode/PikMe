//
//  RankViewController.swift
//  PikMe
//
//  Created by Giacomo on 13/09/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit

class RankViewController: UITableViewController {

    @IBOutlet weak var btnUsername: UIButton!
    
    var pikList = [Pik]()

    var elementList = [RankElement]()
    let username = Cloud.username()
    
    var selectedIndexPath: NSIndexPath!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.btnUsername.setTitle(self.username, forState: UIControlState.Normal)
        
        initializeList();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeList(){
        
        Cloud.getPikList(10, orderByRank: true, callback: callBacker)
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

    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedIndexPath = indexPath
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        self.performSegueWithIdentifier("SinglePhotoSegue", sender: self)
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.pikList.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var index = indexPath.row
        let cell = tableView.dequeueReusableCellWithIdentifier("RankCell", forIndexPath: indexPath) as! RankCell

        var position =  index + 1;
        var positionText = String(position) + "."
        if (position < 10){
            positionText = "0" + positionText
        }
        cell.UsernameLabel.text = self.pikList[index].user.username
        cell.RankLabel.text = positionText
        cell.LikeNumberLabel.text = String(self.pikList[index].like)
        self.pikList[index].getImage({ (image: UIImage?, msgError: String?) -> Void in
            if(msgError == nil) {
                cell.Thumbnail.image = image
            }
            else {
                
            }
        })

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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "SinglePhotoSegue") {
            let singlePhotoVC = segue.destinationViewController as! SinglePhotoViewController
            
            let cell:RankCell = tableView.cellForRowAtIndexPath(selectedIndexPath)! as! RankCell
            singlePhotoVC.Image = cell.Thumbnail.image!
            singlePhotoVC.Like = self.pikList[selectedIndexPath.row].like
        }
    }
}
