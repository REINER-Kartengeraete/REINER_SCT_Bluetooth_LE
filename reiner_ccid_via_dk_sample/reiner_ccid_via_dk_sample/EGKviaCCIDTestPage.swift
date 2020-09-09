//
//  EGKviaCCIDTestPage.swift
//  reiner_ccid_via_dk_sample
//
//  Created by Prakti_E on 18.07.16.
//  Copyright © 2016 Reiner SCT. All rights reserved.
//

import Foundation
import UIKit
import Compression



@available(iOS 9.0, *)
class EGKviaCCIDTestPage: UIViewController, BluetoothTestProtocol, CCIDReaderCallbacks
{
    
    
    var _reader:CCIDBluetoothReader?
    
    var saveReaderIdForConnectAfterBond: String = ""
    
    var startwithSelectedreader: Bool = true
    
    var currentCCIDState:CCIDState = CCIDState.powerOff;
    
    
    var ReadStatus = 2
    
    var patientenDatenFile : String = ""
    
    var VersicherungsDatenFile : String = ""
    
    var SLOTINUSE: UInt8 = 0x01;
    
    
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
    
    //BUtton Pressed
    @IBAction func startWithSelectedReader()
    {
         _reader = CCIDBluetoothReader(callbacks: self, type: [BluetoothReaderType.DK_Reader]);        startwithSelectedreader = true
        _reader?.connect(BluetoothReaderSelection.getPreveredReader().getReaderID())
    }
    // BUtton Pressed
    @IBAction func startWithClosestReader()
    {
        _reader = CCIDBluetoothReader(callbacks: self, type: [BluetoothReaderType.DK_Reader]);      startwithSelectedreader = false
        _reader?.scanReaders(TimeInterval(999999999.0))
    }
    
    // Reader Connected and ready to send
    func readyToSend() {
        currentCCIDState = CCIDState.powerOn;
        _reader?.powerCardOn(CCIDProtocoll.CardVoltage.VOLTS_5_CARD_VOLTAGE, slot:SLOTINUSE);
    }
    
    
    func didSendApdu() {
        
    }
    
    // Recieved error
    func didRecieveResponseError(_ errorMessage: BluetoothErrors, respCode: String) {
                  _reader?.disConnect()
    }
    
    
    // Reader found
    func didFindReaders(_ devices: [BluetoothReaderInfo])
    {
        if(devices.count > 0){
            _reader?.stopScaning()
            _reader?.connect(devices[0].getReaderID())
        }
    }
    
    // if device was bonded during the process
    func Bonded(_ info: BluetoothReaderInfo)
    {
        _reader?.connect(saveReaderIdForConnectAfterBond)
    }
    
    
    func onScanningFinished() {
        
    }
    
    func disconnected() {
        
    }
    
    //Shows the atr
    func showCardAnswer(_ answer: String, title: String )
    {
        let alertView:UIAlertView = UIAlertView(title: title, message: answer, delegate: self, cancelButtonTitle: "OK")
        alertView.show()
    }
    
    // Work with the recieved Data
    func didRecieveCCID_DataBlock( _ ccid_AnswerBlock: CCID_AnswerBlock)
    {
        let answer : CCIDProtocoll.CCID_DataBlock  = ccid_AnswerBlock.dataBlock
        let status : CCIDProtocoll.CCID_SlotStausBlock  = ccid_AnswerBlock.slotStatus
        
        if (currentCCIDState == CCIDState.powerOff) {
            _reader?.disConnect()
            return
        }
        if (currentCCIDState == CCIDState.powerOn) {
            
            let atr = answer.getCommandoData()
            if(atr.length == 0 )
            {
                sleep(1)
                _reader?.powerCardOn(CCIDProtocoll.CardVoltage.VOLTS_5_CARD_VOLTAGE ,slot: SLOTINUSE);
                return
            }
            
            currentCCIDState = CCIDState.setParameter
            showCardAnswer(atr, title: "Card ATR")
            _reader?.setParameter(CCIDProtocoll.TransportProtocol.T_Equals_1, parser: AtrParser(atrstring: answer.getCommandoData()), slot: SLOTINUSE);
            return
        }
        if (currentCCIDState == CCIDState.setParameter) {
            currentCCIDState = CCIDState.connected;
            ReadStatus = 0
        }
        if(currentCCIDState == CCIDState.connected && status.getSlotstatus() == 0)
        {
   
            ReadStatus += 1
            
            if (ReadStatus == 1) {
                _reader?.sendXfrBlock("00 A4 04 0C 07 D2 76 00 01 44 80 00",slot: SLOTINUSE)
                return
            }
            
            if (ReadStatus == 2) {
                _reader?.sendXfrBlock("00 A4 04 0C 06 D2 76 00 00 01 02",slot: SLOTINUSE)
                return;
            }
            if (ReadStatus == 3) {
                _reader?.sendXfrBlock("00 B0 81 00 00 00 00",slot: SLOTINUSE)
                return;
            }
            if (ReadStatus == 4) {
                
                patientenDatenFile = answer.getCommandoData()
                _reader?.sendXfrBlock("00 B0 82 00 00 00 00",slot: SLOTINUSE)
                return;
            }
            
            if (ReadStatus == 5)
            {
                
                 _reader?.powerCardOff(slot: SLOTINUSE)
                VersicherungsDatenFile = answer.getCommandoData()
                currentCCIDState = CCIDState.powerOff;
                ShowDaten ()
                return;
            }
        }
    }
    
    
    // Shows the recieved XML files
    func ShowDaten ()
    {
        var versicherungsdatenString : String = ""
        
        let pDataF:EGKFile = EGKFile(data: patientenDatenFile,pd: true)
        let vDataF:EGKFile = EGKFile(data: VersicherungsDatenFile,pd: false)
        
       
        let pArray = hexStringToByteArray(patientenDatenFile) as [UInt8]
        let pData = Data(bytes: pArray)
       
        if(pData.count > 12){
            versicherungsdatenString =  NSDataToXMLString(pData,start: 2, end: pDataF.len)
        }
  
        let vArray = hexStringToByteArray(VersicherungsDatenFile) as [UInt8]
        let vData = Data(bytes: vArray)
        
        if(vData.count > 12){
            versicherungsdatenString = versicherungsdatenString + NSDataToXMLString(vData, start: 8, end: vDataF.len + 8)
        }
        
        if(versicherungsdatenString.length == 0)
        {
            let alertView:UIAlertView = UIAlertView(title: "Versicherungdaten", message: "Keine Versicherungsdaten gefunden, sind sie sicher, dass es sich um eine Gesundheitskarte handelt?", delegate: self, cancelButtonTitle: "OK")
            alertView.show()
            return
            
            
        }
        
        let alertView:UIAlertView = UIAlertView(title: "Versicherungdaten", message: versicherungsdatenString, delegate: self, cancelButtonTitle: "OK")
        alertView.show()
    }
    
    // Inflate the XML data
    func NSDataToXMLString(_ data: Data, start: UInt16, end : UInt16) -> String{
       
        let iso88599 = CFStringConvertEncodingToNSStringEncoding(0x020F)
        
        let exData = data.subdata(in: Int(start)..<Int(end))
      
        let retVal1 = GzipInflater.gzipInflate(exData) as Data
        let part1 = String(data: retVal1, encoding: String.Encoding(rawValue: iso88599))
        return part1!
    }
}

// Helper Class to hold the xml files
class EGKFile
{
    
    
    var data:String = ""
    var dataBytes = [byte]()
    var len:UInt16 = 0
    
    init(data : String,  pd: Bool)
    {
    
        if(data.length > 12){
            self.data = data;
            self.dataBytes = hexStringToByteArray(data);
        
            if(pd == true)
            {
                len = toShort(highByte: dataBytes[0], lowByte: dataBytes[1]) ;
            }else
            {
                len = toShort(highByte: dataBytes[2], lowByte: dataBytes[3]) - toShort(highByte: dataBytes[0], lowByte: dataBytes[1]) ;
            }
        }
    }
    //UInt8's to UInt16
    func toShort(highByte : UInt8, lowByte : UInt8) -> UInt16
    {
        return (UInt16) ((UInt16(highByte) & 0x00FF) << 8 | (UInt16(lowByte) & 0x00FF));
    }
}
