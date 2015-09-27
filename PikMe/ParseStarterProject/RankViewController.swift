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
    
    var elementList = [RankElement]()
    let username = Cloud.username()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for (var i = 0 ; i < 25 ; i++){
            var el = RankElement()
            el.position = i
            el.username = "user_" + String(i)
            el.totLikeN = i * 5
            el.thumb = UIImage(named: "pic01.jpg")!
            
            elementList.append(el)
        }

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

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elementList.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var index = indexPath.row
        
        let cell = tableView.dequeueReusableCellWithIdentifier("RankCell", forIndexPath: indexPath) as! RankCell

       
        var position =  elementList[index].position
         var positionText = String(position) + "."
        if (position < 10){
            positionText = "0" + positionText
        }
        cell.UsernameLabel.text = elementList[index].username
        cell.RankLabel.text = positionText
        cell.LikeNumberLabel.text = String(elementList[index].totLikeN)
        cell.Thumbnail.image = elementList[index].thumb

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
