
//
//  StartTestPage.swift
//  reiner_ccid_via_dk_sample
//
//  Created by Prakti_E on 02.06.15.
//  Copyright (c) 2015 Reiner SCT. All rights reserved.
//

import Foundation
import UIKit

class StartTestPage: UIViewController, BluetoothTestProtocol {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func openDeviceSelection(){}
    
    func startWithSelectedReader(){}
    
    func startWithClosestReader(){}
    
}