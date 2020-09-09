//
//  BluetoothReaderConnectionCallbacks.swift
//  reiner_ccid_via_dk_sample
//
//  Created by Prakti_E on 02.06.15.
//  Copyright (c) 2015 Reiner SCT. All rights reserved.
//

import Foundation


protocol BluetoothReaderConnectionCallbacks
{
    /// <summary>
    /// list of devices foaund while scanning
    /// called if new device is found
    /// </summary>
    /// <param name="devices"></param>
    func onfound_BluetoothReader(_ devices: [BluetoothReaderInfo])
    
    /// <summary>
    /// called if device is bonded
    /// </summary>
    func Bonded(_ info: BluetoothReaderInfo)
    
    /// <summary>
    /// called if scanning timeout runns out
    /// </summary>
    func onScanningFinished()
}


