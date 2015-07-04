//
//  ViewController.swift
//
//  Copyright 2011-present Parse Inc. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet var rememberMeFlag: UISwitch!
    @IBOutlet var usernameField: UITextField!
    @IBOutlet var passwordField: UITextField!
    
    @IBAction func login(sender: AnyObject) {
        
        //LP30-06-2016
        //Test uso del metodo di login
        Cloud.logIn(usernameField.text, password: passwordField.text, callback: {
        (succeded: Bool, msgError: String)->Void in
            if succeded
            {
                println("Loggato abbestia")
            }
            else
            {
                println("Strunzo " + msgError)
            }
        })
    }
    
    @IBAction func forgotPassword(sender: AnyObject) {
    }
    
    @IBOutlet var signUpNow: UIButton!
}

