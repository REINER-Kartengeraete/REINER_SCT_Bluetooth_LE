//
//  BluetoothTestProtocol.swift
//  reiner_ccid_via_dk_sample
//
//  Created by Prakti_E on 02.06.15.
//  Copyright (c) 2015 Reiner SCT. All rights reserved.
//

import Foundation
import UIKit

@objc protocol BluetoothTestProtocol
{
    
    /**
    * Open device selection.
    */
    func openDeviceSelection()
    
    /**
    * Start with selected reader.
    */
    func   startWithSelectedReader()
    
    /**
    * Start with closest reader.
    */
    func  startWithClosestReader()
    
}