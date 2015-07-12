//
//  PikMe_Tests.swift
//  PikMe Tests
//
//  Created by Giovanni Trovato on 11/07/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import XCTest
import PikMe

class PikMe_Tests: XCTestCase {
    var image: UIImage?
    
    
    override func setUp() {
        super.setUp()
        image = UIImage(named: "pic01.jpg")
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testParseSendAndRetrieve(){
        // creo un oggetto pik da inviate e ed un expectation per il test asincrono
        var pik = Pik(image: image!)
        let expectation = expectationWithDescription("Parse connection")
        
        //provo a salvare su Parse
        pik.saveInBackgroundWithBlock { (ok:Bool, error:NSError?) -> Void in
            if error != nil {
                XCTFail("connessione al server fallita")
            }
            else{
                // se ottengo la lista di pik prendo il primo e controllo se è uguale a quello che ho appena inviato
                var piks : [Pik]?
                Cloud.getPikList(10, callback: { (pikList, msgError) -> Void in
                    piks = pikList
                    if let pik = piks?.last{
                        var img : UIImage?
                        pik.getImage { (image, msgError) -> Void in
                            img = image!
                            if img!.isEqual(self.image){
                                XCTAssert(true, "File caricato e ricevuto correttamente")
                            }
                            else {
                                XCTFail("l'immagine inviata non corrisponde a quella ricevuta")
                            }
                            expectation.fulfill()
                        }
                        
                    }else{
                        XCTFail("non ricevo nulla dal server")
                    }
                    
                    
                    expectation.fulfill()
                })
                
                
                
                
                
            }
            expectation.fulfill()
        }
        
        //se entro 10 secondi non ho concluso il test fallisce
        waitForExpectationsWithTimeout(10.0,handler:nil)
        
    }
    
    
    func testPerformanceExample() {
        self.measureBlock() {
            
        }
    }
    
}
