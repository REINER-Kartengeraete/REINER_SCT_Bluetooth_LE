//
//  BluetoothReaderCallbacks.swift
//  reiner_ccid_via_dk_sample
//
//  Created by Prakti_E on 02.06.15.
//  Copyright (c) 2015 Reiner SCT. All rights reserved.
//

import Foundation

protocol BluetoothReaderCallbacks : BluetoothReaderConnectionCallbacks  {
    
    /// <summary>
    /// called when the reader is connected and ready to send
    /// </summary>
    func readyToSend()
    
    /// <summary>
    /// called after a block was send
    /// </summary>
    func didSend()
    
    /// <summary>
    /// called if a block was recieved from the remote device
    /// </summary>
    /// <param name="block"></param>
    func didRecieveBlock(_ block: [CUnsignedChar])

    /// <summary>
    /// called if an error accoured, errorMessage explaines some errors, the block returns a failure byte array for the error description
    /// </summary>
    /// <param name="errorMessage"></param>
    /// <param name="block"></param>
    func didRecieveError(_ errorMessage: BluetoothErrors, block: [CUnsignedChar])
    
    /// <summary>
    /// called after the disconnect
    /// </summary>
    /// <param name="unhingedService"></param>
    func disconnected()
    
    
}
