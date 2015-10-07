//
//  SignupViewController.swift
//  PikMe
//
//  Created by Giacomo on 06/07/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController, UITextFieldDelegate {
    

    @IBOutlet var usernameField: UITextField!
   
    @IBOutlet var mailField: UITextField!
 
    @IBOutlet var passwordField: UITextField!
    
    @IBOutlet var confirmPwdField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.usernameField.delegate = self;
        self.mailField.delegate = self;
        self.passwordField.delegate = self;
        self.confirmPwdField.delegate = self;
        
        //Used to dismiss the keyboard when press outside TextFields
        let tapper = UITapGestureRecognizer(target: self, action: "handleSingleTap");
        self.view.addGestureRecognizer(tapper);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Dismiss the keyboard when press Return
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
    
    func handleSingleTap(){
        
        self.view.endEditing(true);
    }
    
    
    @IBAction func onSingUpBtClick(sender:UIButton){
        
        if (self.passwordField.text != self.confirmPwdField.text){
            
            launchAlert("Passwords do not match!")
            
        }
        
        else if(self.usernameField.text == "" || self.mailField.text == "" || self.passwordField.text == ""
           || self.confirmPwdField.text == "") {
            
            launchAlert("All fields are required!")
        }
        else {
            
            Cloud.signUp(usernameField.text, password: passwordField.text, email: mailField.text, callback: callBacker)
        }
    }
    
    func callBacker(succeded: Bool, msgError: String)->Void{
      
        if(!succeded) {
            launchAlert(msgError)
        }
        else {
            self.performSegueWithIdentifier("signUpSegue", sender: self)
        }
    }
    
    func launchAlert(msg:String)->Void{
        var alert = UIAlertController(title: "Sign-up error", message: msg, preferredStyle: UIAlertControllerStyle.Alert)
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
