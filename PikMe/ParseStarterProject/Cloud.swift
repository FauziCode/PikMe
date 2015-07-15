//
//  Cloud.swift
//  PikMe
//
//  Created by Luca Paganelli on 29/06/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//
// Raga ho provato a fare un tentativo di parziale codifica delle funzioni di login e signup, ma
// Swift con la sua sintassi esotica di optiona, closure e compagnia bella è come scalare una parete 
// verticale di vetro senza ventose.

import Foundation
import Parse

//---------------------------------------------------------------------
//                              CLOUD
//---------------------------------------------------------------------
public class Cloud
{
    //---------------------------------------------------------------------
    //                              logIn
    //---------------------------------------------------------------------
    public class func logIn(username: String, password: String, callback: (succeded: Bool, msgError: String)->Void)
    {
        PFUser.logInWithUsernameInBackground(username.lowercaseString, password:password)
        {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil
            {
                // OK
                callback(succeded:true, msgError:"");
            }
            else
            {
                // KO
                callback(succeded:false, msgError:error?.userInfo?["error"] as! String);
            }
        }
    }
    
    //---------------------------------------------------------------------
    //                              signUp
    //---------------------------------------------------------------------
    public class func signUp(username: String, password: String, email: String, callback: (succeded: Bool, msgError: String)->Void)
    {
        var user = PFUser()
        
        user.username   = username
        user.password   = password
        user.email      = email
        
        user.signUpInBackgroundWithBlock
        {
            (succeded:Bool, error: NSError?) -> Void in
            if let error = error
            {
                // KO
                let errorString = error.userInfo?["error"] as! String
                callback(succeded: false, msgError: errorString)
            }
            else
            {
                // OK
                callback(succeded: true, msgError: "")
            }
        }
    }
    
    
    //---------------------------------------------------------------------
    //                              logOut
    //---------------------------------------------------------------------
    public class func logOut(callback: (succeded: Bool, msgError: String)->Void)
    {
        PFUser.logOutInBackgroundWithBlock { (error: NSError?) -> Void in
            
            if let error = error
            {
                // KO
                let errorString = error.userInfo?["error"] as! String
                callback(succeded: false, msgError: errorString)
            }
            else
            {
                // OK
                callback(succeded: true, msgError: "")
            }
            
        }
    }
    //---------------------------------------------------------------------
    //                              username
    //---------------------------------------------------------------------
    public class func username() -> String {
        if let un = PFUser.currentUser()?.username {
            return un
        } else {
            return ""
        }
    }
    
    //---------------------------------------------------------------------
    //                          changePassword
    //---------------------------------------------------------------------
    public class func changePassword(newPassword: String, callback: (succeded: Bool, msgError: String)->Void)
    {
        if let cUser = PFUser.currentUser()
        {
            cUser.password = newPassword
            cUser.saveInBackgroundWithBlock({ (succeded: Bool, error: NSError?) -> Void in
                if let error = error
                {
                    // KO
                    let errorString = error.userInfo?["error"] as! String
                    callback(succeded: false, msgError: errorString)
                }
                else
                {
                    // OK
                    callback(succeded: true, msgError: "")
                }
            })
        }
        else
        {
            callback(succeded: false, msgError: "Current User is NULL")
        }
    }

    
    //---------------------------------------------------------------------
    //                              getPikList
    //---------------------------------------------------------------------
    public class func getPikList(maxPik:Int, callback: (piks : [Pik]?, msgError: String?)->Void ){
        var pikList = [Pik]()
        var query = Pik.query()
        query!.limit = maxPik
        
        query!.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil
            {
                // The find succeeded.
                println("Successfully retrieved \(objects!.count) scores.")
                pikList = objects as! [Pik]
                callback(piks: pikList, msgError: nil)
                
            } else
            {
                // Log details of the failure
                println("Error: \(error!) \(error!.userInfo!)")
                callback(piks: nil, msgError: "Error: \(error!) \(error!.userInfo!)")
            }
        }
    }
    
    
}