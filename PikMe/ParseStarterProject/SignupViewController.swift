//
//  SignupViewController.swift
//  PikMe
//
//  Created by Giacomo on 06/07/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController {
    

    @IBOutlet var usernameField: UITextField!
   
    @IBOutlet var mailField: UITextField!
 
    @IBOutlet var passwordField: UITextField!
    
    @IBOutlet var confirmPwdField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSingUpBtClick(sender:UIButton){
        
        if (passwordField.text != confirmPwdField.text){
            
            launchAlert("passwords do not match!")
            
        }
        else {
            Cloud.signUp(usernameField.text, password: passwordField.text, email: mailField.text, callback: callBacker)
        
        }
        
        
        
    }
    
    
    func callBacker(succeded: Bool, msgError: String)->Void{
      
        launchAlert(msgError)
        
    }
    
    func launchAlert(msg:String)->Void{
        var alert = UIAlertController(title: "Signup", message: msg, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        
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
