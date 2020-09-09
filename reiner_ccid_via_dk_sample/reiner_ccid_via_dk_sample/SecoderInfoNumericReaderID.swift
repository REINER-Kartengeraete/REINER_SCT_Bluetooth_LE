//
//  SecoderInfoNumericReaderID.swift
//  reiner_ccid_via_dk_sample
//
//  Created by Prakti_E on 03.06.15.
//  Copyright (c) 2015 Reiner SCT. All rights reserved.
//

import Foundation


public class SecoderInfoNumericReaderID
{
    
    /** the VendorID. */
    private var VendorID: [byte]
    
    /**
    * get thte VendorID.
    *
    * @return the vendor id
    */
    public func getVendorID()->[byte]
    {
    return VendorID;
    }
    
    /**
    * set the VendorID.
    *
    * @param value the new vendor id
    */
    public func setVendorID(_ value: [byte])
    {
        VendorID = value;
    }
    
    /** ProductID. */
    private var ProductID: [byte]
    
    /**
    * get the ProductID.
    *
    * @return the product id
    */
    public func getProductID() ->[byte]
    {
    return ProductID;
    }
    
    /**
    * set the ProductID.
    *
    * @param value the new product id
    */
    public func setProductID(_ value: [byte])
    {
    ProductID = value;
    }
    
    /** SerialNumber. */
    private var SerialNumber:[byte];
    
    /**
    * get the SerialNumber.
    *
    * @return the serial number
    */
    public func getSerialNumber() -> [byte]
    {
        return SerialNumber;
    }
    
    /**
    * set the SerialNumber.
    *
    * @param value the new serial number
    */
    public func setSerialNumber(_ value: [byte])
    {
        SerialNumber = value;
    }
    
    /**
    * constructor for SecoderInfoNumericReaderID.
    *
    * @param readerID the reader id
    */
    init(readerID: [byte])
    {
        if(readerID.count > 0){
            VendorID = SplitArray(readerID , range: (0 ..< 3))
            ProductID = SplitArray(readerID , range: (4 ..< 7))
            SerialNumber = SplitArray(readerID , range: (8 ..< readerID.count))
        }else
        {
            
            VendorID = [0x00]
            ProductID = [0x00]
            SerialNumber = [0x00]

        }
    }
}
