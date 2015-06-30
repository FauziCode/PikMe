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
class Cloud
{
    //---------------------------------------------------------------------
    //                              logIn
    //---------------------------------------------------------------------
    class func logIn(username: String, password: String, callback: (succeded: Bool, msgError: String)->Void)
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
                callback(succeded:false, msgError:error?.userInfo?["error"] as String);
            }
        }
    }
    
    //---------------------------------------------------------------------
    //                              signUp
    //---------------------------------------------------------------------
    class func signUp(username: String, password: String, email: String, callback: (succeded: Bool, msgError: String)->Void)
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
                let errorString = error.userInfo?["error"] as String
                callback(succeded: false, msgError: errorString)
            }
            else
            {
                // OK
                callback(succeded: true, msgError: "")
            }
        }
    }
    
}