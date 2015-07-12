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
    
    func testSendAndRetrieveToParse(){
        var pik = Pik(image: image!)
        pik.saveInBackgroundWithBlock { (ok:Bool, error:NSError?) -> Void in
            if error != nil {
                XCTFail("connessione al server fallita")
            }
            else{
                var piks = Cloud.getPikList(1)
                if let pik = piks?.last{
                    XCTAssert(pik.getImage().isEqual(self.image), "File caricato e ricevuto correttamente")
                }
                
                
            }
        }
    }
    
    
    func testPerformanceExample() {
        self.measureBlock() {
            Cloud.getPikList(100)
        }
    }
    
}
