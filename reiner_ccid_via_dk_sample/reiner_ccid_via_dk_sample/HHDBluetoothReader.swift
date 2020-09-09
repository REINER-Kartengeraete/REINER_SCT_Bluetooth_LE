//
//  HHDBluetoothReader.swift
//  reiner_ccid_via_dk_sample
//
//  //  Created by Prakti_E on 08.09.15.
//  Copyright (c) 2015 Reiner SCT. All rights reserved.
//

import Foundation

private class Dummy : SecoderReaderCallbacks
{

    func didRecieveApdu(_ answer: String){}

    func didRecieveSecoderInfo(_ info: SecoderInfoData){}

    func didRecieveResponseError(_ errorMessage: BluetoothErrors,  block: [byte]){}

    func didFindReaders(_ devices: [BluetoothReaderInfo]){}

    func Bonded(_ info: BluetoothReaderInfo){}

    func onScanningFinished(){}

    func disconnected(){}

    func readyToSend(){}

}


public class HHDBluetoothReader : HHDReader , SecoderReaderCallbacks {
    
    /** The _callbacks. */
    var _callbacks : HHDReaderCallbacks
    
    /** The _reader. */
    var _reader: SecoderBluetoothReader
    
    var _type: [BluetoothReaderType]
    
    /** The hhd finalize. */
    var hhdFinalize = ""
    
    /**
    * Instantiates a new HHD bluetooth reader.
    *
    * @param callbacks the callbacks
    */
    init(callbacks: HHDReaderCallbacks,type: [BluetoothReaderType])
    {
        _type = type
        _callbacks = callbacks;
        _reader =  SecoderBluetoothReader(callbacks: Dummy(), type: type)
    }
    
    /* 
    * @see HHD.HHDReader#connect(String)
    */
    func connect( _ id: String) {
        _reader = SecoderBluetoothReader( callbacks: self, type: _type)
        _reader.connect(id);
    }
    
    /* 
    * @see HHD.HHDReader#sendHHDCommand(String, boolean)
    */
    func sendHHDCommand( _ data: String ,  hasFollowingTrasmittion: Bool){
        
        hhdFinalize = HHDProtocoll().Generatefinalize(hasFollowingTrasmittion)
        let cmd = HHDProtocoll().generateHHDCommand(data)
        _reader.sendCommand(cmd, transparrent: false)
    }
    
    /* 
    * @see HHD.HHDReader#requestSecoderInfo()
    */
    func requestSecoderInfo() {
        _reader.requestSecoderInfo()
    }
    
    /* 
    * @see HHD.HHDReader#disConnect(boolean)
    */
    func disConnect() {
        _reader.disConnect()
    }
    
    /* 
    * @see HHD.HHDReader#scanReaders(long)
    */
    func scanReaders( _ timeout: TimeInterval) {
        _reader = SecoderBluetoothReader( callbacks: self, type: _type)
        _reader.scanReaders(timeout)
    }
    
    /* 
    * @see HHD.HHDReader#bondReader(String)
    */
    func bondReader( _ readerID: String) {
        _reader.bondReader(readerID)
    }
    
    /* 
    * @see HHD.HHDReader#stopScaning()
    */
   func stopScaning() {
        _reader.stopScaning();
    }
    
    /* 
    * @see HHD.HHDReader#leCapable()
    */
    func leCapable()-> Bool {
        return _reader.leCapable()
    }
    
    /* 
    * @see HHD.HHDReader#getBluetoothConnectionState()
    */

    func getBluetoothConnectionState() -> BluetoothConnectionState{
        return _reader.getBluetoothConnectionState()
    }
    
    
    /* 
    * @see secode3.SecoderReaderCallbacks#didRecieveApdu(String)
    */
  func didRecieveApdu(_ answer: String)
  {
        if(answer == "00 01 ")
        {
            //_reader.disConnect()
            return
    
        }
    
        _reader.sendCommand(hhdFinalize, transparrent: false)
        _callbacks.didRecieveHHDAnswer(HHDAnswer(rsp: answer))
    }
    
    /* 
    * @see secode3.SecoderReaderCallbacks#didRecieveSecoderInfo(secodeInfo.SecoderInfoData)
    */
    func didRecieveSecoderInfo(_ info: SecoderInfoData) {
        _callbacks.didRecieveSecoderInfo(info);
    }
    
    /* 
    * @see secode3.SecoderReaderCallbacks#didRecieveResponseError(bluetooth.BluetoothErrors, String)
    */
     func didRecieveResponseError(_ errorMessage: BluetoothErrors,  block: [byte])
    {
        _callbacks.didRecieveResponseError(errorMessage, respCode: byteArrayToHexString(block))
    }
    
    /* 
    * @see secode3.SecoderReaderCallbacks#didFindReaders(List)
    */
    func didFindReaders(_ devices:[BluetoothReaderInfo]) {
        _callbacks.didFindReaders(devices);
    }
    
    /* 
    * @see secode3.SecoderReaderCallbacks#Bonded(bluetooth.Bluetooth_ReaderInfo)
    */
    func Bonded( _ info: BluetoothReaderInfo) {
        _callbacks.Bonded(info);
    }
    
    /* 
    * @see secode3.SecoderReaderCallbacks#onScanningFinished()
    */
    func onScanningFinished() {
        _callbacks.onScanningFinished();
    }
    
    /* 
    * @see secode3.SecoderReaderCallbacks#disconnected()
    */
    func disconnected() {
        _callbacks.disconnected();
    }
    
    /* 
    * @see secode3.SecoderReaderCallbacks#readyToSend()
    */
    func readyToSend() {
        _callbacks.readyToSend();
    }
}
