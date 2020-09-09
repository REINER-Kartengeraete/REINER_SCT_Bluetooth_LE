//
//  BluetoothReaderInfo.swift
//  reiner_ccid_via_dk_sample
//
//  Created by Prakti_E on 02.06.15.
//  Copyright (c) 2015 Reiner SCT. All rights reserved.
//

import Foundation
import CoreBluetooth

public class BluetoothReaderInfo : NSObject, NSCoding{
    
    /** The Reader id. */
    private var ReaderID: String
    
    /** The Reader name. */
    private var ReaderName: String
    
    /** The Bonded. */
    private var Bonded: Bool = false
    
    
    
    required public init?(coder aDecoder: NSCoder)
    {
        self.ReaderID = aDecoder.decodeObject(forKey: "ReaderID")  as! String
        self.ReaderName = aDecoder.decodeObject(forKey: "ReaderName") as! String
        self.Bonded = aDecoder.decodeBool(forKey: "Bonded")

    }
    
    public func encode(with aCoder: NSCoder) {
        
        aCoder.encode(ReaderID, forKey: "ReaderID")
        aCoder.encode(ReaderName, forKey: "ReaderName")
        aCoder.encode(Bonded, forKey: "Bonded")
    }
    
    
    /**
    * Instantiates a new bluetooth_ reader info.
    */
    public override init() {
        ReaderName = "kein Leser gefunden"
        ReaderID = ""
        Bonded = false;
    }
    
    /// <summary>
    /// constructor
    /// </summary>
    /// <param name="name"></param>
    /// <param name="id"></param>
    /// <param name="bonded"></param>
    /**
    * Instantiates a new bluetooth_ reader info.
    *
    * @param name the name
    * @param id the id
    * @param bonded the bonded
    */
    public init(name: String,id: String ,bonded: Bool)
    {
        ReaderName = name;
        ReaderID = id;
        Bonded = bonded;
    }
    
    /**
    * Instantiates a new bluetooth_ reader info.
    *
    * @param device the device
    */
    public init(device: CBPeripheral)
    {
            ReaderName = device.name!;
            ReaderID = device.identifier.uuidString;
            Bonded = false  ;
    }
    
    /**
    * Gets the reader id.
    *
    * @return the reader id
    */
    func getReaderID()->String {
        return ReaderID;
    }
    
    /**
    * Sets the reader id.
    *
    * @param readerID the new reader id
    */
    func setReaderID(_ readerID: String) {
        ReaderID = readerID;
    }
    
    /**
    * Gets the reader name.
    *
    * @return the reader name
    */
    func getReaderName() -> String {
        return ReaderName;
    }
    
    /**
    * Sets the reader name.
    *
    * @param readerName the new reader name
    */
    func setReaderName(_ readerName: String) {
        ReaderName = readerName;
    }
    
    /**
    * Checks if is bonded.
    *
    * @return true, if is bonded
    */
    func isBonded() -> Bool {
        return Bonded;
    }
    
    /**
    * Sets the bonded.
    *
    * @param bonded the new bonded
    */
    func setBonded(_ bonded: Bool) {
        Bonded = bonded;
    }
    
}
