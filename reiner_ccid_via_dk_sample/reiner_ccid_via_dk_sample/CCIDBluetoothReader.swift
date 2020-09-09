//
//  CCIDBluetoothReader.swift
//  reiner_ccid_via_dk_sample
//
//  Created by Prakti_E on 03.09.15.
//  Copyright (c) 2015 Reiner SCT. All rights reserved.
//

import Foundation



class CCIDBluetoothReader : CCIDReader , SecoderReaderCallbacks
{
    
    
    /** The _callbacks. */
    var _callbacks :CCIDReaderCallbacks!
    
    /** The _reader. */
    var _reader: SecoderBluetoothReader!
    
    /** The sequence number */
    var sqn: Int = 0
    
    var type: [BluetoothReaderType]!
    
    
    func increaseSequenceNumber()
    {
        if(sqn >= 256)
        {
            sqn = 0
        }
        sqn += 1
    }

        
            func didRecieveApdu(_ answer: String) {
                let cmd = CCIDProtocoll().parseCCIDResponse(hexStringToByteArray(answer))
                _callbacks.didRecieveCCID_DataBlock(cmd)
            }
            
            func didRecieveResponseError(_ errorMessage: BluetoothErrors, block: [byte]) {
                _callbacks.didRecieveResponseError(errorMessage, respCode: byteArrayToHexString(block))
            }
            
            func didFindReaders( _ devices: [BluetoothReaderInfo]) {
                _callbacks.didFindReaders(devices);
            }
            
            func Bonded( _ info: BluetoothReaderInfo) {
                _callbacks.Bonded(info);
                
            }
            
            func onScanningFinished() {
                _callbacks.onScanningFinished();
            }
            
            func disconnected() {
                _callbacks.disconnected();
            }
            
            func didRecieveSecoderInfo( _ info: SecoderInfoData)
            {
            }
            
            func readyToSend() {
                _callbacks.readyToSend();
            }

    init( callbacks: CCIDReaderCallbacks, type: [BluetoothReaderType])
   {
        self.type = type
        _callbacks = callbacks
   }
    
    func connect(_ id: String)
    {
        if !(_reader != nil)
        {
            _reader = SecoderBluetoothReader(callbacks: self, type: type)
        }
      _reader.connect(id)
    }
        
    
    func  powerCardOn(_ voltage: CCIDProtocoll.CardVoltage, slot: byte)
    {
        increaseSequenceNumber()
        let cmd = CCIDProtocoll().generatePowerOn( sqn, voltage: voltage, slot: slot)
        _reader.sendCommand(cmd, transparrent: true)
    }
    
    
    func  powerCardOff(slot: byte)
    {
            increaseSequenceNumber()
        let cmd = CCIDProtocoll().generatePowerOff(sqn, slot: slot)
            _reader.sendCommand(cmd, transparrent: true)
    }
    
    
    func  getSlotStatus(slot: byte)
    {
        increaseSequenceNumber()
        let cmd = CCIDProtocoll().generateGetSlotStatus(sqn, slot:slot)
        _reader.sendCommand(cmd, transparrent: true);
    }
    
    
    func  secure(_ returntype: CCIDProtocoll.CCIDSecureReturnType ,  operation: CCIDProtocoll.PINOperation, pinVerificationDataStructure: String , slot: byte)
    {
        increaseSequenceNumber();
        let cmd = CCIDProtocoll().generateGetSecure(pinVerificationDataStructure, seq: sqn, returntype: returntype, operation: operation, slot: slot)
        _reader.sendCommand(cmd, transparrent: true)
    }
    
    
    func  sendXfrBlock( _ data: String, slot: byte)
    {
        increaseSequenceNumber()
        let cmd = CCIDProtocoll().generateXferBlock(data, seq: sqn, slot: slot)
        _reader.sendCommand(cmd, transparrent: true);
    }
    
    func  sendESCBlock( _ data: String, slot: byte)
    {
        increaseSequenceNumber()
        let cmd = CCIDProtocoll().generateESCBlock(data, seq: sqn, slot: slot)
        _reader.sendCommand(cmd, transparrent: true);
    }

    
    func  setParameter( _ proto: CCIDProtocoll.TransportProtocol , parser: AtrParser, slot: byte)
    {
        increaseSequenceNumber()
        let cmd = CCIDProtocoll().generateSetParameters(proto, seq: sqn, atr: parser, slot : slot)
        _reader.sendCommand(cmd, transparrent: true);
    
    }
    
    func  disConnect()
    {
        if(_reader != nil ){
            _reader.disConnect()
        }

    }
    
    
    func  scanReaders( _ timeout: TimeInterval )
    {
        if !(_reader != nil)
        {
            _reader = SecoderBluetoothReader(callbacks: self, type: type)
        }
        _reader.scanReaders(timeout)
    }
    
    
    func  bondReader( _ readerID: String )
    {
         _reader.bondReader(readerID)
    }
    
    
    func  stopScaning()
    {
        _reader.stopScaning()
    }
    
    
    func leCapable() -> Bool
    {
        return _reader.leCapable()
    }
    
    
    func getBluetoothConnectionState() -> BluetoothConnectionState
    {
        return _reader.getBluetoothConnectionState()
    }
    
    
    
  
    
}
