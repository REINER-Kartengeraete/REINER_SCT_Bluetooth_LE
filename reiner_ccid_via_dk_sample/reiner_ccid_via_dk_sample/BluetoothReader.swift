
//  BluetoothReader.swift
//  reiner_ccid_via_dk_sample
//
//  Created by Prakti_E on 02.06.15.
//  Copyright (c) 2015 Reiner SCT. All rights reserved.
//


import Foundation
import CoreLocation
import CoreBluetooth


private class Dummy : BluetoothReaderCallbacks
{

    func readyToSend(){}
    
    func didSend(){}

    func didRecieveBlock(_ block: [CUnsignedChar]){}
    
    func didRecieveError(_ errorMessage: BluetoothErrors, block: [CUnsignedChar]){}

    func disconnected(){}
    
    func onfound_BluetoothReader(_ devices: [BluetoothReaderInfo]){}
    
    func Bonded(_ info: BluetoothReaderInfo){}

    func onScanningFinished(){}

}




class BluetoothReader: NSObject, CBCentralManagerDelegate,  BluetoothReaderProtocol, CBPeripheralDelegate
{
    private var currentConnectionState: BluetoothConnectionState = BluetoothConnectionState.disconnected
    private var supportedTypes: [BluetoothReaderType] = [BluetoothReaderType.DK_Reader]
    private var uuidsToScanFor:[CBUUID] = [CBUUID(string: BluetoothUUIDS.DK_Service_UUID.rawValue)]
    private var txCharacketerisrtic : CBCharacteristic!
    private var rxCharacketerisrtic : CBCharacteristic!
    
    private var selectedServiceUUID: CBUUID = CBUUID(string: BluetoothUUIDS.DK_Service_UUID.rawValue)
    private var txCharacketerisrticUUID: CBUUID = CBUUID(string: BluetoothUUIDS.DK_Tx_Data_Characteristic_Uuid.rawValue)
    private var rxCharacketerisrticUUID: CBUUID = CBUUID(string: BluetoothUUIDS.DK_Rx_Data_Characteristic_Uuid.rawValue)
    
    private var selectedType: BluetoothReaderType = BluetoothReaderType.Secoder_3
    private var callbacks: BluetoothReaderCallbacks
    private var devices =  [BluetoothReaderInfo]()

    private var manager = CBCentralManager()
    private var scanningMode: Bool = false
    private var deviceToConnect = CBUUID()
    

    private var scanTimer = Timer()
    private var connectedPeripherals = [CBPeripheral]()
    private var foundReaders = [CBPeripheral]()
    
    private var isBonding: Bool = false
    private var isFirstWrite: Bool = true
    

    
    init (callback: BluetoothReaderCallbacks, type: [BluetoothReaderType])
    {
        self.callbacks = callback
        self.supportedTypes = type
        super.init()
    }
    
    override init ()
    {
        self.callbacks = Dummy()
        self.supportedTypes = [BluetoothReaderType.DK_Reader]
        super.init()
    }
    
    
    func isNil()->Bool
    {
        return manager.delegate == nil ? true : false
    }
    
    func Connect(_ readerID: String)
    {
        deviceToConnect = CBUUID(string: readerID)
        scanningMode = false
        if(isNil()){
            manager = CBCentralManager(delegate: self, queue: nil)
        }
        else
        {
            currentConnectionState = BluetoothConnectionState.connecting
            manager.stopScan()
            for peripheral in foundReaders
            {
                if(peripheral.identifier.uuidString == readerID)
                {
                    manager.connect(peripheral, options:[CBConnectPeripheralOptionNotifyOnConnectionKey:true])
                    return;
                }
                
            }
        
        }
    }
   
    func DisConnect()
    {
            if(manager.delegate != nil)
            {
                manager.cancelPeripheralConnection(connectedPeripherals[0])
            }
              self.callbacks.disconnected()
    }
    
  
    func SendCommando(_ block: [CUnsignedChar])
    {
        
        NSLog("SendBlock: " + byteArrayToHexString(block))
        if(currentConnectionState == BluetoothConnectionState.connected)
        {
            connectedPeripherals[0].writeValue(Data(bytes: UnsafePointer<UInt8>(block), count: block.count), for: txCharacketerisrtic, type: isFirstWrite == true ? CBCharacteristicWriteType.withResponse : CBCharacteristicWriteType.withoutResponse )
            isFirstWrite = false;
            callbacks.didSend()
        }
        else
        {
            callbacks.didRecieveError(BluetoothErrors.notConnected, block: [CUnsignedChar]())
        }
    }
    
    func ScanReaders(_ timeout: TimeInterval)
    {
        scanTimer = Timer.scheduledTimer(timeInterval: timeout, target:self, selector: #selector(BluetoothReader.StopScaning), userInfo: nil, repeats: false)
        scanningMode = true
        if(isNil()){
            //let serialQueue = DispatchQueue(label: "bluetooth queue")
            manager = CBCentralManager(delegate: self, queue: nil)
        }
    
       
    }
    
    func BondReader(_ readerID: String)
    {
        scanTimer.invalidate()
        manager.stopScan()
        isBonding = true
        Connect(readerID)
    }

    func StopScaning()
    {
        scanTimer.invalidate()
        manager.stopScan()
        callbacks.onScanningFinished()
    }
    
    
    func LeCapable()->Bool
    {
        return CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self);
    }
    
 
    func GetBluetoothConnectionState() -> BluetoothConnectionState
    {
        return currentConnectionState;
    }
    
    
    private func initUUIDS(_ type: BluetoothReaderType)
    {
            if(type == BluetoothReaderType.DK_Reader){
                uuidsToScanFor.append(CBUUID(string: BluetoothUUIDS.DK_Service_UUID.rawValue))
                selectedServiceUUID = CBUUID(string: BluetoothUUIDS.DK_Service_UUID.rawValue)
                txCharacketerisrticUUID = CBUUID(string: BluetoothUUIDS.DK_Tx_Data_Characteristic_Uuid.rawValue)
                rxCharacketerisrticUUID = CBUUID(string: BluetoothUUIDS.DK_Rx_Data_Characteristic_Uuid.rawValue)
                
            }
        
            if(type == BluetoothReaderType.Secoder_3){
                uuidsToScanFor.append(CBUUID(string: BluetoothUUIDS.Secoder_3_UUID.rawValue))
                selectedServiceUUID = CBUUID(string: BluetoothUUIDS.Secoder_3_UUID.rawValue)
                txCharacketerisrticUUID = CBUUID(string: BluetoothUUIDS.Secoder_3_Tx_Data_Characteristic_Uuid.rawValue)
                rxCharacketerisrticUUID = CBUUID(string: BluetoothUUIDS.Secoder_3_Rx_Data_Characteristic_Uuid.rawValue)
            }
    }
    
    @objc func centralManagerDidUpdateState(_ central: CBCentralManager)
    {
        switch central.state
        {
        case .unsupported:
            currentConnectionState = BluetoothConnectionState.disconnected;
            callbacks.didRecieveError(BluetoothErrors.bluetoothLENotSupported, block: [CUnsignedChar]())
            
        case .unauthorized:
            currentConnectionState = BluetoothConnectionState.disconnected;
            callbacks.didRecieveError(BluetoothErrors.noBluetoothPermission, block: [CUnsignedChar]())
            
            
        case .poweredOff:
            currentConnectionState = BluetoothConnectionState.disconnected;
            callbacks.didRecieveError(BluetoothErrors.bluetoothNotEnabled, block: [CUnsignedChar]())
            
        case .poweredOn:
               currentConnectionState = BluetoothConnectionState.scanning;
               central.scanForPeripherals(withServices: uuidsToScanFor, options: [CBCentralManagerScanOptionAllowDuplicatesKey:false] )
            
        case .unknown:
            currentConnectionState = BluetoothConnectionState.disconnected
            
        default:
            currentConnectionState = BluetoothConnectionState.disconnected

        }

    }
    
    func centralManager(_ central: CBCentralManager!, didRetrievePeripherals peripherals: [AnyObject]!)
    {
        
    }
    func centralManager(_ central: CBCentralManager!, didRetrieveConnectedPeripherals peripherals: [AnyObject]!)
    {
         // nothing to do here
    }
    
    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber)
    {
        foundReaders.append(peripheral)
        
        if(scanningMode)
        {
            let info = BluetoothReaderInfo(device: peripheral)
            devices.append(info)
            callbacks.onfound_BluetoothReader(devices)
        }
        else
        {
            if peripheral.identifier.uuidString == deviceToConnect.uuidString
            {
                currentConnectionState = BluetoothConnectionState.connecting
                central.stopScan()
              
                manager.connect(peripheral, options:[CBConnectPeripheralOptionNotifyOnConnectionKey:true])
                    /*[CBConnectPeripheralOptionNotifyOnDisconnectionKey:true])*/
            }
        }
    }

    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral){
        currentConnectionState = BluetoothConnectionState.connected
        connectedPeripherals.append( peripheral )
        connectedPeripherals[0].delegate = self
        peripheral.discoverServices(uuidsToScanFor)
        
    }
    

    public func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?)  {
        currentConnectionState = BluetoothConnectionState.disconnected
        
    }
    

    public func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        currentConnectionState = BluetoothConnectionState.disconnected
        callbacks.disconnected()
    }
    



    
    public func peripheralDidUpdateName(_ peripheral: CBPeripheral){

    }
    
    public func peripheral(_ peripheral: CBPeripheral, didModifyServices invalidatedServices: [CBService]){
        
    }
    
    
    public func peripheralDidUpdateRSSI(_ peripheral: CBPeripheral, error: Error?){
        
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?){
        
    }
    
    
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?){
        
        if error == nil {
            for service:CBService in peripheral.services!  {
                
                for uuidstring in uuidsToScanFor
                {
                    
                    if(service.uuid.uuidString == uuidstring.uuidString)
                    {
                        if(service.uuid.uuidString == BluetoothUUIDS.Secoder_3_UUID.rawValue){
                            initUUIDS(BluetoothReaderType.Secoder_3)
                            peripheral.discoverCharacteristics(nil, for: service )
                        }
                        if(service.uuid.uuidString == BluetoothUUIDS.DK_Service_UUID.rawValue){
                            initUUIDS(BluetoothReaderType.DK_Reader)
                            peripheral.discoverCharacteristics(nil, for: service  )
                        }
                    }
                }
            }
        }
        
    }
    
    
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverIncludedServicesFor service: CBService, error: Error?){
        
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?)
    {
        let serv:CBService = service as CBService
        
        for charackteristic:CBCharacteristic in serv.characteristics!            {
            if(charackteristic.uuid.uuidString == txCharacketerisrticUUID.uuidString)
            {
                txCharacketerisrtic = charackteristic as CBCharacteristic
            }
            if(charackteristic.uuid.uuidString == rxCharacketerisrticUUID.uuidString)
            {
                rxCharacketerisrtic = charackteristic as CBCharacteristic
                peripheral.discoverDescriptors(for: charackteristic as CBCharacteristic )
            }
        }
        
        
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        let count = characteristic.value!.count / MemoryLayout<UInt8>.size
        var array = [CUnsignedChar](repeating: 0, count: characteristic.value!.count)
        (characteristic.value! as NSData).getBytes(&array, length:count * MemoryLayout<UInt8>.size)
        
        if(isBonding != true)
        {
            NSLog("RecievedBlock: " + byteArrayToHexString(array))
            callbacks.didRecieveBlock(array)
        }else
        {
            isBonding = false
            
            
            callbacks.Bonded(BluetoothReaderInfo(device: peripheral))
        }
    }

    
    
    public func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?)
    {
        if(error != nil)
        {
            callbacks.didRecieveError(BluetoothErrors.bluetoothPairingCorrupted, block: [CUnsignedChar]())
            return
        }
        callbacks.didSend()
    }
    
    
    public func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?)      {
        if(!txCharacketerisrtic.uuid.isEqual(nil) && !rxCharacketerisrtic.uuid.isEqual(nil))
        {
            currentConnectionState = BluetoothConnectionState.connected
            if(isBonding == false)
            {
                callbacks.readyToSend()
            }
            else
            {
                let dummyData:[CUnsignedChar] = [0x00,0x01,0x00,0x00,0x00,0x00,0x00,0x00,0x10,0x00,0x00]
                SendCommando(dummyData)
            }
        }
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?){
        peripheral.setNotifyValue(true, for: rxCharacketerisrtic as CBCharacteristic)
    }
    
    
      public func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor descriptor: CBDescriptor, error: Error?)
      {
        
    }
    
      public func peripheral(_ peripheral: CBPeripheral, didWriteValueFor descriptor: CBDescriptor, error: Error?)
      {
        
    }
    
    
}
