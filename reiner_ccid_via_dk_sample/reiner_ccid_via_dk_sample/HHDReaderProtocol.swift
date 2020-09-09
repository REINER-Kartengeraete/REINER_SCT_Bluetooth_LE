//
//  HHDReaderProtocol.swift
//  reiner_ccid_via_dk_sample
//
//  Created by Prakti_E on 08.09.15.
//  Copyright (c) 2015 Reiner SCT. All rights reserved.
//

import Foundation

protocol HHDReader
{
    
    
    /**
    * Connect.
    *
    * @param id the id
    */
    func connect(_ id_ :String)
    
    /**
    * Send hhd command.
    *
    * @param data the data
    * @param hasFollowingTrasmittion the has following trasmittion
    */
    func sendHHDCommand( _ data: String, hasFollowingTrasmittion: Bool)
    
    /**
    * Request secoder info.
    */
    func requestSecoderInfo()
    
    /**
    * Dis connect.
    *
    * @param justDisconnectDevice the just disconnect device
    */
    func disConnect()
    
    /**
    * Scan readers.
    *
    * @param timeout the timeout
    */
    func scanReaders( _ timeout: TimeInterval)
    
    /**
    * Bond reader.
    *
    * @param readerID the reader id
    */
    func bondReader( _ readerID: String)
    
    /**
    * Stop scaning.
    */
    func stopScaning()
    
    /**
    * Le capable.
    *
    * @return true, if successful
    */
    func leCapable() -> Bool
    
    /**
    * Gets the bluetooth connection state.
    *
    * @return the bluetooth connection state
    */
    func getBluetoothConnectionState()-> BluetoothConnectionState
    
}
