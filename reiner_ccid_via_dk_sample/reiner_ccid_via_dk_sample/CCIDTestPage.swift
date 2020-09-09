//
//  CCIDTestPage.swift
//  reiner_ccid_via_dk_sample
//
//  Created by Prakti_E on 02.06.15.
//  Copyright (c) 2015 Reiner SCT. All rights reserved.
//

import Foundation
import UIKit


class CCIDTestPage: UIViewController, BluetoothTestProtocol, CCIDReaderCallbacks {
    

    
    var _reader:CCIDBluetoothReader?
    
    var saveReaderIdForConnectAfterBond: String = ""
    
    var startwithSelectedreader: Bool = true
    
    var currentCCIDState:CCIDState = CCIDState.powerOff

    let SLOTTOUSE: byte = 0x00
    
    
    
    enum CCIDState{
        /** The Secure. */
        case secure
        /** The Power off. */
        case powerOff
        /** The Power on. */
        case powerOn
        /** The SetParameter*/
        case setParameter
        /** The Connected. */
        case connected
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    // disconnect the Reader if the view closes
    override func viewDidDisappear(_ animated: Bool)
    {
        if(_reader != nil ){
            _reader?.disConnect()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func openDeviceSelection()
    {
    }
    
    @IBAction func startWithSelectedReader()
    {
        _reader = CCIDBluetoothReader(callbacks: self, type: [BluetoothReaderType.DK_Reader])
        startwithSelectedreader = true
        _reader?.connect(BluetoothReaderSelection.getPreveredReader().getReaderID())
    }
    
    @IBAction func startWithClosestReader()
    {
        _reader = CCIDBluetoothReader(callbacks: self, type: [BluetoothReaderType.DK_Reader])
        startwithSelectedreader = false
        _reader?.scanReaders(TimeInterval(999999999.0))
    }
 
        func readyToSend() {
            currentCCIDState = CCIDState.powerOn;
            _reader!.powerCardOn(CCIDProtocoll.CardVoltage.VOLTS_5_CARD_VOLTAGE, slot: SLOTTOUSE);
        }
    

        func didSendApdu() {
    
        }
    

        func didRecieveResponseError(_ errorMessage: BluetoothErrors, respCode: String) {
            
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
            _reader?.connect(saveReaderIdForConnectAfterBond)
        }
    

        func onScanningFinished() {
    
        }
    
        func disconnected() {
    
        }
    

    func showCardAnswer(_ answer: String, title: String )
    {
        let alertView:UIAlertView = UIAlertView(title: title, message: answer, delegate: self, cancelButtonTitle: "OK")
        alertView.show()

    }
  
    
    func didRecieveCCID_DataBlock( _ ccid_AnswerBlock: CCID_AnswerBlock) {
    
    
           // let status : CCIDProtocoll.CCID_SlotStausBlock  = ccid_AnswerBlock.slotStatus
            let answer : CCIDProtocoll.CCID_DataBlock  = ccid_AnswerBlock.dataBlock

        
            if (currentCCIDState == CCIDState.powerOff) {
                _reader?.disConnect()
                return
            }
        
            if (currentCCIDState == CCIDState.powerOn) {
                    let atr = answer.getCommandoData()
                    currentCCIDState = CCIDState.setParameter
                    showCardAnswer(atr, title: "Card ATR")
                    _reader?.setParameter(CCIDProtocoll.TransportProtocol.T_Equals_1, parser: AtrParser(atrstring: answer.getCommandoData()), slot: SLOTTOUSE);
                    return
            }
        
            if (currentCCIDState == CCIDState.setParameter) {
                    currentCCIDState = CCIDState.connected
                    _reader?.sendXfrBlock(CCIDProtocoll().getRootCommand , slot: SLOTTOUSE)
                    return
            }
        
     
            if (currentCCIDState == CCIDState.connected) {
                    //currentCCIDState = CCIDState.powerOff
                    //let masterFile = answer.getCommandoData()
                    //showCardAnswer(masterFile, title: "Master File")
                    _reader?.sendESCBlock("02 00 00 01 02 00 00 00 00 00 1E 86 08 00 08 01 02 01 00 00 00 00 00 00 00 20 00 81 08 00 00 00 00 FF FF FF FF", slot: SLOTTOUSE)
                    //_reader?.powerCardOff( slot: SLOTTOUSE)
                    return;
            }
        
    }
}
