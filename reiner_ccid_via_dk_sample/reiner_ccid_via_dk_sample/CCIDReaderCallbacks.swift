//
//  CCIDReaderCallbacks.swift
//  reiner_ccid_via_dk_sample
//
//  Created by Prakti_E on 03.09.15.
//  Copyright (c) 2015 Reiner SCT. All rights reserved.
//

import Foundation

protocol CCIDReaderCallbacks {
    
    /// <summary>
    /// called if connection is stable
    /// </summary>
    func readyToSend()
    
    
    /// <summary>
    /// called if a n apdu was send
    /// </summary>
    func didSendApdu()
    
    /// <summary>
    /// called if an apdu was rescieved
    /// </summary>
    /// <param name="answer"></param>
    func didRecieveCCID_DataBlock(_ ccid_AnswerBlock: CCID_AnswerBlock)
   
    /// <summary>
    /// called if an error was rescieved
    /// </summary>
    /// <param name="errorMessage"></param>
    /// <param name="respCode"></param>
    func didRecieveResponseError( _ errorMessage: BluetoothErrors ,  respCode: String)
    
    
    /// <summary>
    /// called if readers are found called multiple times if readers get detected
    /// </summary>
    /// <param name="devices"></param>
    func didFindReaders(_ devices: [BluetoothReaderInfo] )
    
    
    /// <summary>
    /// called after a sucsessfull bond
    /// </summary>
    func Bonded(_ info: BluetoothReaderInfo)
    
    /// <summary>
    /// if scaning timed out
    /// </summary>
    func onScanningFinished()
    
    /// <summary>
    /// called after the disconnect, if service was killed
    /// </summary>
    func disconnected();
   
    
}

