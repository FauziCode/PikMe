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

class Pik: PFObject, PFSubclassing {
    
    var image: UIImage!
    
    //@NSManaged Permette di memorizzare le proprietà dell'oggetto come coppia chiave valore Automaticamente
    @NSManaged var imageFile: PFFile
    @NSManaged var user: PFUser
    @NSManaged var like: Int
    
    // i due metodi che seguono servono a conformare la classe al protocollo PFSubclassing
    
    // Setta il nome della classe Come viene visualizzata nel backend di parse
    class func parseClassName() -> String {
        return "Pik"
    }
    
    //permette a Parse di sapere che intendiamo utilizzare questa sottoclasse per tutto gli oggetti di tipo Pik
    //ovviamente questa operazione viene fatta solo alla prima istanza
    override class func initialize() {
        var onceToken: dispatch_once_t = 0
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
    
    //override della funzione query base
    override class func query() -> PFQuery? {
        //creo l'oggetto query
        let query = PFQuery(className: Pik.parseClassName())
        //aggiungo tutti i dettagli dell'utente che ha postato la foto
        query.includeKey("user")
        //ordino per data di creazione
        query.orderByDescending("createdAt")
        return query
    }
    
    //chi mi ha votato?
    func queryWhoLikeMe() -> PFQuery?{
        
        let relation = self.relationForKey("likeUsers")
        let query = relation.query()
        return query
    
    }
    
    //Chiamare questo metodo per incrementare il like relativo ad un Pik
    func like(callback: (succeded: Bool, msgError: String?)->Void)
    {
        //la funzione incrementKey di PFObject incrementa una variabile numerica in modo atomico
        //per questo motivo chiamo anche la saveIn background...
        self.incrementKey("like")
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
    func unlike(callback: (succeded: Bool, msgError: String?)->Void)
    {
        self.incrementKey("like", byAmount: -1)
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
    
    //metodo costruttore
    init(image: UIImage, comment: String?)
    {
        super.init()
        self.user = PFUser.currentUser()!
        self.image = image
        
        //credo che la mia foto piaccia almeno a me stesso
        self.like = 1;
        // o no
        //self.like = 0;
    }
    
    //costruttore vuoto
    override init()
    {
        super.init()
        
    }
    
}
