//
//  BluetoothReaderProtocol.swift
//  reiner_ccid_via_dk_sample
//
//  Created by Prakti_E on 02.06.15.
//  Copyright (c) 2015 Reiner SCT. All rights reserved.
//

import Foundation


protocol BluetoothReaderProtocol {
    
    
    
    /// <summary>
    /// connect to device with the identifier
    /// </summary>
    /// <param name="readerID"></param>
    func Connect(_ readerID: String)
    
    /// <summary>
    /// disconnect connected device, or the service
    /// </summary>
    func DisConnect()
    
    /// <summary>
    /// send a 20byte long block
    /// </summary>
    /// <param name="block"></param>
    func SendCommando(_ block: [CUnsignedChar])
    
    /// <summary>
    /// scann for readers
    /// </summary>
    /// <param name="timeout"></param>
    func ScanReaders(_ timeout: TimeInterval)
    
    /// <summary>
    /// bond the reader with the identifier
    /// </summary>
    /// <param name="readerID"></param>
    func BondReader(_ readerID: String)
    
    /// <summary>
    /// stop scanning for readers
    /// </summary>
    func StopScaning()
    
    /// <summary>
    /// is the mobile device bluetooth Low Energy 4.0 capable
    /// </summary>
    /// <returns></returns>
    func LeCapable()->Bool
    
    /// <summary>
    /// returns the current GetBluetoothConnectionState()
    /// </summary>
    /// <returns></returns>
    func GetBluetoothConnectionState() -> BluetoothConnectionState

    
    
    
}

