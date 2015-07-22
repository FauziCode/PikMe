//
//  LoginViewController.swift
//  PikMe
//
//  Created by Giacomo on 29/06/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var userNameField: UITextField!
    @IBOutlet var passwordField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        userNameField.delegate = self;
        passwordField.delegate = self;
        
        //Used to dismiss the keyboard when press outside TextFields
        let tapper = UITapGestureRecognizer(target: self, action: "handleSingleTap");
        self.view.addGestureRecognizer(tapper);
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func handleSingleTap(){
        
        self.view.endEditing(true);
    }
    
    // Dismiss the keyboard when press Return
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
    
    
    @IBAction func onLoginBtClick(sender:UIButton){
        
        Cloud.logIn(userNameField.text, password: passwordField.text, callback: callBacker)
        
    }
    
    
    func callBacker(succeded: Bool, msgError: String)->Void{
        
        if(msgError != "") { /*C'è un errore nel login*/
            
            var alert = UIAlertController(title: "Authentication Error", message: msgError, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else {
            performSegueWithIdentifier("loginSegue", sender: self);
        }
        
        
 
        
    }/*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
