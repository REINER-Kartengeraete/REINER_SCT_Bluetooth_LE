//
//  HHDTestPage.swift
//  reiner_ccid_via_dk_sample
//
//  Created by Prakti_E on 02.06.15.
//  Copyright (c) 2015 Reiner SCT. All rights reserved.
//

import Foundation
import UIKit


class HHDTestPage: UIViewController, BluetoothTestProtocol, HHDReaderCallbacks, UIAlertViewDelegate {
    
    
    /** The _bluetooth service. */
    private var _reader:HHDBluetoothReader?
    
    /** The startwith selectedreader. */
    private var startwithSelectedreader:Bool = true
    
     var saveReaderIdForConnectAfterBond: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
          _reader = HHDBluetoothReader(callbacks: self, type: [ BluetoothReaderType.DK_Reader, BluetoothReaderType.Secoder_3])
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
    
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int)
    {
        if(alertView.buttonTitle(at: buttonIndex) == "repeat"){
            let iban = "1234567891002345"
            let ammount = "123.45"
            _reader!.sendHHDCommand(HHDGenerator().getHHDCommand("109", bde1: iban, bde2: ammount, bde3: "", control: ""), hasFollowingTrasmittion: true)
        }else
        {
            _reader?.disConnect()
        }
    }

    
    
    private func showTAN( _ info: HHDAnswer)
    {
        let alertView:UIAlertView = UIAlertView(title: "HHD TAN", message:info.getTAN_BCD(), delegate: self, cancelButtonTitle: "cancel",  otherButtonTitles: "repeat")
        alertView.show()


    }
    
    @IBAction func openDeviceSelection()
    {
    
    }
    
    @IBAction func startWithSelectedReader()
    {
        _reader = HHDBluetoothReader(callbacks: self, type: [ BluetoothReaderType.DK_Reader, BluetoothReaderType.Secoder_3])

        startwithSelectedreader = true
           _reader?.connect(BluetoothReaderSelection.getPreveredReader().getReaderID())
    }

    @IBAction func startWithClosestReader()
    {
        _reader = HHDBluetoothReader(callbacks: self, type: [ BluetoothReaderType.DK_Reader, BluetoothReaderType.Secoder_3])
        
        	startwithSelectedreader = false;
            _reader?.scanReaders(TimeInterval(999999999.9))
    }
    

    func didRecieveHHDAnswer(_ answer: HHDAnswer)
    {
        showTAN(answer)
    }

    func didRecieveSecoderInfo( _ info: SecoderInfoData)
    {
        let applications:[SecoderApplications] = info.getSupportedSecoderApplications()
    
        for app in applications
        {
            if(app.getApplicationID() == SecoderApplicationsIDs().CTNApplicationID || app.getApplicationID() == SecoderApplicationsIDs().TANApplicationID)
            {
                let iban = "1234567891002345"
                let ammount = "123.45"
                
                let cmd = HHDGenerator().getHHDCommand("109", bde1: iban, bde2: ammount, bde3: "", control: "")
                _reader?.sendHHDCommand(cmd, hasFollowingTrasmittion: true)
                return
            }
        }
        
        let alertView:UIAlertView = UIAlertView(title: "Leser", message:"This reader soes not support the ChipTan function", delegate: self, cancelButtonTitle: "OK")
        alertView.show();
    }

    func didRecieveResponseError( _ errorMessage: BluetoothErrors, respCode: String)
    {
    
    }

    func didFindReaders(_ devices:[BluetoothReaderInfo])
    {
        if(devices.count > 0){
            _reader?.stopScaning()
            _reader?.connect(devices[0].getReaderID())
        }
    }
    
    func Bonded( _ info: BluetoothReaderInfo)
    {
        _reader?.connect(saveReaderIdForConnectAfterBond)
    }

    func onScanningFinished()
    {
    
    }
    
    func disconnected()
    {
    
    }

    func readyToSend()
    {
        _reader!.requestSecoderInfo()
    }
    

    
}
