//
//  User.swift
//  PikMe
//
//  Created by Giovanni Trovato on 01/07/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import Parse

//Estendo La classe PFObject e la rendo conforme al protocollo PFSubclassing
//concedetemi di chiamare la foto Pik visto che l'app si chiama PikMe

public class Pik: PFObject, PFSubclassing {
    
    
    
    //@NSManaged Permette di memorizzare le proprietà dell'oggetto come coppia chiave valore Automaticamente
    @NSManaged var imageFile: PFFile
    @NSManaged var user: PFUser
    @NSManaged var like: Int
    
    // i due metodi che seguono servono a conformare la classe al protocollo PFSubclassing
    
    // Setta il nome della classe Come viene visualizzata nel backend di parse
    public class func parseClassName() -> String {
        return "Pik"
    }
    
    //permette a Parse di sapere che intendiamo utilizzare questa sottoclasse per tutto gli oggetti di tipo Pik
    //ovviamente questa operazione viene fatta solo alla prima istanza
    public override class func initialize() {
        var onceToken: dispatch_once_t = 0
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
    
    //override della funzione query base
    public override class func query() -> PFQuery? {
        //creo l'oggetto query
        let query = PFQuery(className: Pik.parseClassName())
        //aggiungo tutti i dettagli dell'utente che ha postato la foto
        query.includeKey("user")
        //ordino per data di creazione
        query.orderByDescending("createdAt")
        return query
    }
    
    //chi mi ha votato?
    //---------------------------------------------------------------------
    //                           queryWhoLikeMe
    //---------------------------------------------------------------------
    public func queryWhoLikeMe() -> PFQuery?{
        
        let relation = self.relationForKey("likeUsers")
        let query = relation.query()
        return query
    
    }
    
    //restituisce l'elenco dei pfuser che mi hanno votato
    //---------------------------------------------------------------------
    //                           whoLikeMe
    //---------------------------------------------------------------------
    public func whoLikeMe(callback: (users: [PFUser]?, msgError: String?)->Void)
    {
        let query = queryWhoLikeMe()
        query?.findObjectsInBackgroundWithBlock({ (users: [AnyObject]?, error: NSError?) in
            if error == nil
            {
                // The find succeeded.
                println("Successfully retrieved \(users!.count)")
                let userlist = users as! [PFUser]
                callback(users: userlist, msgError: nil)
                
            } else
            {
                // Log details of the failure
                println("Error: \(error!) \(error!.userInfo!)")
                callback(users: nil, msgError:  "Error: \(error!) \(error!.userInfo!)")
            }
        })
        return
    }
    
    
    
    //restutuisce vero se ho già flaggato like su questo Pik
    //---------------------------------------------------------------------
    //                           alreadyLike
    //---------------------------------------------------------------------
    public func alreadyLike()->Bool{
        let query = queryWhoLikeMe()
        query?.whereKey("objectId", equalTo: (PFUser.currentUser()?.valueForKey("objectId") as? String)!)
        return query?.countObjects() > 0 ? true : false
    }
    
    //Chiamare questo metodo per incrementare il like relativo ad un Pik
    //---------------------------------------------------------------------
    //                           like
    //---------------------------------------------------------------------
    public func like(callback: (succeded: Bool, msgError: String?)->Void)
    {
        //la funzione incrementKey di PFObject incrementa una variabile numerica in modo atomico
        //per questo motivo chiamo anche la saveIn background...
        self.incrementKey("like")
        let relation = self.relationForKey("likeUsers")
        relation.addObject(PFUser.currentUser()!)
    
        self.saveInBackgroundWithBlock {
            (succceded :Bool, error: NSError?) -> Void in
            if error != nil
            {
                //Incremento non riuscito
                let details = "Error: \(error!) \(error!.userInfo!)"
                callback(succeded: false, msgError: details)
            }
            else
            {
                callback(succeded: true, msgError: nil)
                
            }
        }
    }
    
    //Chiamare questo metodo per decrementare il like relativo ad un Pik
    //---------------------------------------------------------------------
    //                           unlike
    //---------------------------------------------------------------------
    public func unlike(callback: (succeded: Bool, msgError: String?)->Void)
    {
        self.incrementKey("like", byAmount: -1)
        let relation = self.relationForKey("likeUsers")
        relation.removeObject(PFUser.currentUser()!)
        
        self.saveInBackgroundWithBlock {
            (succceded :Bool, error: NSError?) -> Void in
            if error != nil
            {
                //Incremento non riuscito
                let details = "Error: \(error!) \(error!.userInfo!)"
                callback(succeded: false, msgError: details)
            }
            else
            {
                callback(succeded: true, msgError: nil)
                
            }
        }

    }
    
    //Chiamare questo metodo per scaricare la foto relativa ad un pik
    //---------------------------------------------------------------------
    //                           getImage
    //---------------------------------------------------------------------
    public func getImage(callback: (image: UIImage?, msgError: String?)->Void){
        self.imageFile.getDataInBackgroundWithBlock { (dati, error) -> Void in
            if error != nil {
                callback (image: nil , msgError: "impossibile ricevere l'immagine dal server")
            }else if let dati = dati {
                let image = UIImage(data: dati)
                callback (image: image , msgError: nil)
            }
        }
    }
    
    //metodo costruttore
    public init(image: UIImage)
    {
        super.init()
        self.user = PFUser.currentUser()!
        
        let size = CGSizeApplyAffineTransform(image.size, CGAffineTransformMakeScale(0.26, 0.26))
        let hasAlpha = false
        let scale: CGFloat = 0.0
        let compression: CGFloat = 0.5
        
        UIGraphicsBeginImageContextWithOptions(size, hasAlpha, scale)
        image.drawInRect(CGRect(origin: CGPointZero, size: size))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let pictureData = UIImageJPEGRepresentation(image, compression)
        self.imageFile = PFFile(name: "image", data: pictureData)
        
        
        //credo che la mia foto piaccia almeno a me stesso
        //self.like = 1;
        // o no
        self.like = 0;
    }
    
    
    //costruttore vuoto
    public override init()
    {
        super.init()
        
    }
    
}
