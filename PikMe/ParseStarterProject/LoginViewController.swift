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
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var switchToSignupButton: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loginButton.layer.cornerRadius = 10
        loginButton.layer.borderWidth = 2
        loginButton.layer.borderColor = UIColor.whiteColor().CGColor
        
        switchToSignupButton.layer.cornerRadius = 10
        switchToSignupButton.layer.borderWidth = 2
        switchToSignupButton.layer.borderColor = UIColor.whiteColor().CGColor
        
        self.userNameField.delegate = self;
        self.passwordField.delegate = self;
        self.indicator.hidden = true;
        
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
        
        if(self.userNameField.text == "" || self.passwordField.text == "") {
            launchAlert("All fields are required!")
        }
        else {
            self.indicator.hidden = false
            self.indicator.startAnimating()
            Cloud.logIn(self.userNameField.text, password: self.passwordField.text, callback: callBacker)
        }
    }
    
    
    func callBacker(succeded: Bool, msgError: String)->Void{
        
        if(msgError != "") { /*C'è un errore nel login*/
            
            self.indicator.stopAnimating()
            launchAlert(msgError)
        }
        else {
            dispatch_async(dispatch_get_main_queue()) {
                self.performSegueWithIdentifier("loginSegue", sender: self);
            }
        }
    }
    
    func launchAlert(msg:String)->Void{
        var alert = UIAlertController(title: "Login error", message: msg, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
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
