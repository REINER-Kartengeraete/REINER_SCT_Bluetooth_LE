//
//  SecoderReaderProtocol.swift
//  reiner_ccid_via_dk_sample
//
//  Created by Prakti_E on 03.06.15.
//  Copyright (c) 2015 Reiner SCT. All rights reserved.
//

import Foundation

protocol SecoderReaderProtocol {
    
    
    /**
    * Connect.
    *
    * @param id the id
    */
    func connect(_ id: String)
    
    /**
    * Send apdu.
    *
    * @param data the data
    * @param transparrent the transparrent
    */
    func sendCommand(_ data: String,transparrent: Bool)
    
    /**
    * Request secoder info.
    */
    func requestSecoderInfo()
    
    /**
    * Dis connect.
    */
    func disConnect();
    
    /**
    * Scan readers.
    *
    * @param timeout the timeout
    */
    func scanReaders(_ timeout: TimeInterval)
    
    /**
    * Bond reader.
    *
    * @param readerID the reader id
    */
    func bondReader(_ readerID: String)
    
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
    func getBluetoothConnectionState() -> BluetoothConnectionState
    
}
