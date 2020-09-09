//
//  SecoderReaderCallbacks.swift
//  reiner_ccid_via_dk_sample
//
//  Created by Prakti_E on 03.06.15.
//  Copyright (c) 2015 Reiner SCT. All rights reserved.
//

import Foundation


protocol SecoderReaderCallbacks {
    
    
    /// <summary>
    /// called if an apdu was rescieved
    /// </summary>
    /// <param name="answer"></param>
    func didRecieveApdu(_ answer: String)
    
    /// <summary>
    /// called if secoderinfo was recieved
    /// </summary>
    /// <param name="info"></param>
    func didRecieveSecoderInfo(_ info: SecoderInfoData)
    
    /// <summary>
    /// called if an error was rescieved
    /// </summary>
    /// <param name="errorMessage"></param>
    /// <param name="respCode"></param>
    func didRecieveResponseError(_ errorMessage: BluetoothErrors,  block: [byte])
    
    
    /// <summary>
    /// called if readers are found called multiple times if readers get detected
    /// </summary>
    /// <param name="devices"></param>
    func didFindReaders(_ devices: [BluetoothReaderInfo])
    
    
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
    func disconnected()
    
    
    /// <summary>
    /// called when reader is ready to recieve
    /// </summary>
    /// <returns></returns>
    func readyToSend()
    
    
}
