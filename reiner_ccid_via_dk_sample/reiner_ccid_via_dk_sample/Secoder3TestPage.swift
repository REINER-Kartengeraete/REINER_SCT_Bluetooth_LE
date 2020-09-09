//
//  Secoder3TestPage.swift
//  reiner_ccid_via_dk_sample
//
//  Created by Prakti_E on 02.06.15.
//  Copyright (c) 2015 Reiner SCT. All rights reserved.
//

import Foundation
import UIKit

class Secoder3TestPage: UIViewController, BluetoothTestProtocol, SecoderReaderCallbacks {
    
    var _reader: SecoderBluetoothReader?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // disconnect the Reader if the view closes
    override func viewDidDisappear(_ animated: Bool)
    {
        if(_reader != nil ){
            _reader?.disConnect()
        }

    }
    
    @IBAction func openDeviceSelection()
    {
           }
    
    @IBAction func startWithSelectedReader()
    {
        _reader = SecoderBluetoothReader(callbacks: self, type: [ BluetoothReaderType.DK_Reader, BluetoothReaderType.Secoder_3])
       _reader?.connect(BluetoothReaderSelection.getPreveredReader().getReaderID())
    }
    
    @IBAction func startWithClosestReader()
    {
        _reader = SecoderBluetoothReader(callbacks: self, type: [ BluetoothReaderType.DK_Reader, BluetoothReaderType.Secoder_3])
        _reader?.scanReaders(TimeInterval(999999999.9))
    }
 

    func didRecieveApdu(_ answer: String)
    {
        
    }
    
    func didRecieveSecoderInfo(_ info: SecoderInfoData)
    {
        _reader?.disConnect()
        let alert = UIAlertView(title: "Secoder Info", message:info.toString(), delegate: nil, cancelButtonTitle: "OK")
        alert.show()
    }
    
    func didRecieveResponseError(_ errorMessage: BluetoothErrors,  block: [byte])
    {
        
    }
    
    func didFindReaders(_ devices: [BluetoothReaderInfo])
    {
        if(devices.count > 0){
            _reader?.stopScaning()
            _reader?.connect(devices[0].getReaderID())
        }
    }
    
    func Bonded(_ info: BluetoothReaderInfo)
    {
        _reader!.connect(info.getReaderID())
    }
    
    func onScanningFinished()
    {
    
    }
    
    func disconnected()
    {
    
    }
    
    func readyToSend()
    {
        _reader?.requestSecoderInfo()
    }

    
    
}
