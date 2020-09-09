//
//  CCIDBluetoothReaderProtocol.swift
//  reiner_ccid_via_dk_sample
//
//  Created by Prakti_E on 03.09.15.
//  Copyright (c) 2015 Reiner SCT. All rights reserved.
//

import Foundation


protocol CCIDReader {
    
    /**
    * Connect.
    *
    * @param id the id
    */
    func connect(_ id: String)
    
    /**
    * Power card on.
    */
    func  powerCardOn(_ voltage: CCIDProtocoll.CardVoltage, slot: byte)
    
    /**
    * Power card off.
    */
    func  powerCardOff(slot: byte)
    
    /**
    * Gets the slot status.
    *
    * @return the slot status
    */
    func  getSlotStatus(slot: byte)
    
    /**
    * Secure.
    *
    * @param returntype the returntype
    * @param operation the operation
    * @param pinVerificationDataStructure the pin verification data structure
    */
    func  secure(_ returntype: CCIDProtocoll.CCIDSecureReturnType ,  operation: CCIDProtocoll.PINOperation, pinVerificationDataStructure: String , slot: byte)
    
    /**
    * Send xfr block.
    *
    * @param data the data
    */
    func  sendXfrBlock( _ data: String, slot: byte)
    
    
    /**
     * Send esc block.
     *
     * @param data the data
     */
    func  sendESCBlock( _ data: String, slot: byte)

    
    /**
    * Send setParameterblock.
    *
    * @param TransportProtocol the TransportProtocol
    * @param AtrParser the AtrParser
    */
    func  setParameter( _ proto: CCIDProtocoll.TransportProtocol , parser: AtrParser, slot: byte)
    
    
    /**
    * Dis connect.
    *
    * @param justDisconnectDevice the just disconnect device
    */
    func  disConnect()
    
    /**
    * Scan readers.
    *
    * @param timeout the timeout
    */
    func  scanReaders( _ timeout: TimeInterval )
    
    /**
    * Bond reader.
    *
    * @param readerID the reader id
    */
    func  bondReader( _ readerID: String )
    
    /**
    * Stop scaning.
    */
    func  stopScaning()
    
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
