
//
//  HHDReaderCallbacks.swift
//  reiner_ccid_via_dk_sample
//
///  Created by Prakti_E on 08.09.15.
//  Copyright (c) 2015 Reiner SCT. All rights reserved.
//

import Foundation


protocol HHDReaderCallbacks {
    
    /// <summary>
    /// called if an apdu was rescieved
    /// </summary>
    /// <param name="answer"></param>
    /**
    * Did recieve hhd answer.
    *
    * @param answer the answer
    */
    func didRecieveHHDAnswer(_ answer: HHDAnswer)
    
    /// <summary>
    /// called if secoderinfo was recieved
    /// </summary>
    /// <param name="info"></param>
    /**
    * Did recieve secoder info.
    *
    * @param info the info
    */
    func didRecieveSecoderInfo( _ info: SecoderInfoData)
    
    /// <summary>
    /// called if an error was rescieved
    /// </summary>
    /// <param name="errorMessage"></param>
    /// <param name="respCode"></param>
    /**
    * Did recieve response error.
    *
    * @param errorMessage the error message
    * @param respCode the resp code
    */
    func didRecieveResponseError( _ errorMessage: BluetoothErrors, respCode: String)
    
    
    /// <summary>
    /// called if readers are found called multiple times if readers get detected
    /// </summary>
    /// <param name="devices"></param>
    /**
    * Did find readers.
    *
    * @param devices the devices
    */
    func didFindReaders(_ devices:[BluetoothReaderInfo])
    
    
    /// <summary>
    /// called after a sucsessfull bond
    /// </summary>
    /**
    * Bonded.
    *
    * @param info the info
    */
    func Bonded( _ info: BluetoothReaderInfo)
    
    /// <summary>
    /// if scaning timed out
    /// </summary>
    /**
    * On scanning finished.
    */
    func onScanningFinished()
    
    /// <summary>
    /// called after the disconnect, if service was killed
    /// </summary>
    /**
    * Disconnected.
    */
    func disconnected()
    
    /// <summary>
    /// called when reader is ready to recieve
    /// </summary>
    /// <returns></returns>
    /**
    * Ready to send.
    */
    func readyToSend();
    
}
